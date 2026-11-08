--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

private with A0B.Time;

package A0B.ESPIDF_Timer_Clock_Timer with Preelaborate is

   procedure Initialize;

private

   function Internal_Clock return A0B.Time.Monotonic_Time;

   procedure Internal_Request_Tick;

   procedure Internal_Set_Next
     (Span    : A0B.Time.Time_Span;
      Success : out Boolean);

end A0B.ESPIDF_Timer_Clock_Timer;
