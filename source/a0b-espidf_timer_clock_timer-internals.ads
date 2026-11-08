--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with A0B.Time;

package A0B.ESPIDF_Timer_Clock_Timer.Internals
  with Preelaborate
is

   function Clock return A0B.Time.Monotonic_Time;

   procedure Request_Tick;

   procedure Set_Next (Span : A0B.Time.Time_Span; Success : out Boolean);

private

   function Clock return A0B.Time.Monotonic_Time renames Internal_Clock;

   procedure Request_Tick renames Internal_Request_Tick;

   procedure Set_Next (Span : A0B.Time.Time_Span; Success : out Boolean)
   renames Internal_Set_Next;

end A0B.ESPIDF_Timer_Clock_Timer.Internals;
