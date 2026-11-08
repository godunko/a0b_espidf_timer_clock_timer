--
--  Copyright (C) 2024-2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with A0B.ESPIDF_Timer_Clock_Timer.Internals;

separate (A0B.Timer)
package body Platform is

   ----------------------------
   -- Enter_Critical_Section --
   ----------------------------

   procedure Enter_Critical_Section is
      procedure Imported
      with
        Import,
        Convention    => C,
        External_Name => "__a0b_espidf_timer_ENTER_CRITICAL";

   begin
      Imported;
   end Enter_Critical_Section;

   ----------------------------
   -- Leave_Critical_Section --
   ----------------------------

   procedure Leave_Critical_Section is
      procedure Imported
      with
        Import,
        Convention    => C,
        External_Name => "__a0b_espidf_timer_EXIT_CRITICAL";

   begin
      Imported;
   end Leave_Critical_Section;

   ------------------
   -- Request_Tick --
   ------------------

   procedure Request_Tick is
   begin
      A0B.ESPIDF_Timer_Clock_Timer.Internals.Request_Tick;
   end Request_Tick;

   --------------
   -- Set_Next --
   --------------

   procedure Set_Next
     (Span    : A0B.Time.Time_Span;
      Success : out Boolean) is
   begin
      A0B.ESPIDF_Timer_Clock_Timer.Internals.Set_Next (Span, Success);
   end Set_Next;

end Platform;
