--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

--  This package is preelaborated, thus it can't depend from `ESPIDF.Timer`. Necessary
--  functions from `ESPIDF.Timer` are imported directly here, as well as C code it
--  used to help initialize the timer.

pragma Ada_2022;

with System;

with A0B.Timer.Internals;
with A0B.Types;

with ESPIDF.Ada_ESP_Check_Error;

package body A0B.ESPIDF_Timer_Clock_Timer is

   type esp_timer is null record with Convention => C;

   type esp_timer_handle_t is access all esp_timer with Convention => C;

   type esp_timer_cb_t is access procedure (Arg : System.Address)
   with Convention => C;

   function esp_timer_get_time return ESPIDF.int64_t
   with Import, Convention => C, External_Name => "esp_timer_get_time";

   function esp_timer_start_once
     (Timer : esp_timer_handle_t; Timeout_us : ESPIDF.uint64_t)
      return ESPIDF.esp_err_t
   with Import, Convention => C, External_Name => "esp_timer_start_once";

   function esp_timer_restart
     (Timer : esp_timer_handle_t; Timeout_us : ESPIDF.uint64_t)
      return ESPIDF.esp_err_t
   with Import, Convention => C, External_Name => "esp_timer_restart";

   function Initialize_Timer
     (Callback : esp_timer_cb_t; Out_Handle : out esp_timer_handle_t)
      return ESPIDF.esp_err_t
   with Import, Convention => C, External_Name => "__a0b_espidf_timer_INIT";

   Timer_Handle : esp_timer_handle_t;

   procedure Restart (Timeout_us : ESPIDF.uint64_t);
   --  Restart the timer with the given timeout in microseconds, or start it
   --  if it is not already running.

   procedure Timer_Callback (Arg : System.Address)
   with Convention => C;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      A0B.Timer.Internals.Initialize;
      ESPIDF.Ada_ESP_Check_Error
        (Initialize_Timer (Timer_Callback'Access, Timer_Handle));
   end Initialize;

   --------------------
   -- Internal_Clock --
   --------------------

   function Internal_Clock return A0B.Time.Monotonic_Time is
      use type ESPIDF.int64_t;

   begin
      return
        A0B.Time.To_Monotonic_Time
          (A0B.Types.Unsigned_64 (esp_timer_get_time * 1_000));
   end Internal_Clock;

   ---------------------------
   -- Internal_Request_Tick --
   ---------------------------

   procedure Internal_Request_Tick is
   begin
      Restart (1);
   end Internal_Request_Tick;

   -----------------------
   -- Internal_Set_Next --
   -----------------------

   procedure Internal_Set_Next
     (Span : A0B.Time.Time_Span; Success : out Boolean)
   is
      use type ESPIDF.int64_t;

   begin
      --  A callback can enqueue a timeout and arm the timer via Request_Tick
      --  before On_Tick calls Set_Next again.

      Restart (ESPIDF.uint64_t (A0B.Time.To_Nanoseconds (Span) / 1_000));
      Success := True;
   end Internal_Set_Next;

   -------------
   -- Restart --
   -------------

   procedure Restart (Timeout_us : ESPIDF.uint64_t) is
      use type ESPIDF.esp_err_t;

      Error : ESPIDF.esp_err_t;

   begin
      Error := esp_timer_restart (Timer_Handle, Timeout_us);

      if Error = ESPIDF.ESP_ERR_INVALID_STATE then
         Error := esp_timer_start_once (Timer_Handle, Timeout_us);
      end if;

      ESPIDF.Ada_ESP_Check_Error (Error);
   end Restart;

   --------------------
   -- Timer_Callback --
   --------------------

   procedure Timer_Callback (Arg : System.Address with Unreferenced) is
   begin
      A0B.Timer.Internals.On_Tick;
   end Timer_Callback;

end A0B.ESPIDF_Timer_Clock_Timer;
