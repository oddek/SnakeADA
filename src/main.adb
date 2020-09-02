with Game;
with MicroBit.Time;
with MicroBit.Display;
with MicroBit.Buttons;
use MicroBit.Buttons;
with HAL; use HAL;

procedure Main is
   GameState : Integer := 0;
   DirectionChange : Integer := 0;
   LastMove : MicroBit.Time.Time_Ms := MicroBit.Time.Clock;
   MoveCycle : constant MicroBit.Time.Time_Ms := 1000;
   ButtonCycle : constant MicroBit.Time.Time_Ms := 100;
begin
   loop
      if MicroBit.Buttons.State (Button_A) = Pressed then
         DirectionChange := -1;

      end if;
      if MicroBit.Buttons.State (Button_B) = Pressed then
         DirectionChange := 1;
      end if;

      if MicroBit.Time.Clock - LastMove > MoveCycle then
         Game.ChangeDir(DirectionChange);
         DirectionChange := 0;
         GameState := Game.MoveSnake;
         LastMove := MicroBit.Time.Clock;
      end if;
      exit when( GameState = -1);

      MicroBit.Time.Delay_Ms(ButtonCycle);
      Game.Display;
   end loop;

   loop
      MicroBit.Display.Clear;
      MicroBit.Display.Display("Game Over!");
   end loop;
end Main;
