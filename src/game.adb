
with MicroBit.Display;
with MicroBit.IOs;
with HAL;
use HAL;

package body Game is

   GridSize : constant Integer := 4;
   subtype Coord is Natural range 0 .. GridSize;
   
   --Snake is implemented as a linked list;
   type Node;
   type NodePtr is access Node;
   type Direction is (North, East, South, West);
   type Node is
      record
         Next : NodePtr := null;
         Prev : NodePtr := null;
         XCoord : Coord;
         YCoord : Coord;
      end record;
   type Snake_struct is
      record
         Front : NodePtr;
         Back : NodePtr;
         Dir : Direction := North;
      end record;
   
   type Coord_Vector is array (0 .. 1) of Coord;
   Food : Coord_Vector := (1, 1);
   Snake : Snake_Struct;

   procedure ChangeDir(i : Integer) is
   begin
      Snake.Dir := Direction'Val((Direction'Pos(Snake.Dir) + i) mod Direction'pos(Direction'Last));
   end ChangeDir;
     
   
   procedure Display is
      N : NodePtr := Snake.Front;
   begin
      MicroBit.Display.Clear;
      while N/= null loop
         MicroBit.Display.Set(N.XCoord, N.YCoord);
         N := N.Next;
      end loop;
      MicroBit.Display.Set(Food(0), Food(1));
   end Display;
   
   function MoveSnake return Integer is
      N : NodePtr := Snake.Back;
      newNode : NodePtr;
      tempFront : Coord_Vector := (Snake.Front.XCoord, Snake.Front.YCoord);
      JustCaughtFood : Boolean := false;
   begin
      
      
      --Check if Food is in head:
      if Snake.Front.XCoord = Food(0) and Snake.Front.YCoord = Food(1) then
         GenerateNewFood;
         JustCaughtFood := true;
      end if;
         
      case Snake.Dir is
         when North =>
            if Snake.Front.YCoord = Coord'First then
               Snake.Front.YCoord := Coord'Last;
            else
               Snake.Front.YCoord := Snake.Front.YCoord -1;
            end if;
            
         when East =>
            if Snake.Front.XCoord = Coord'Last then
               Snake.Front.XCoord := Coord'First;
            else               
               Snake.Front.XCoord := Snake.Front.XCoord + 1;
            end if;
         when South =>
            if Snake.Front.YCoord = Coord'Last then
               Snake.Front.YCoord := Coord'First;
            else               
               Snake.Front.YCoord := Snake.Front.YCoord + 1;
            end if;
         when West =>
            if Snake.Front.XCoord = Coord'First then
               Snake.Front.XCoord := Coord'Last;
            else              
               Snake.Front.XCoord := Snake.Front.XCoord - 1;
            end if;
      end case;
      --Remember to check for collision with Snake
      if JustCaughtFood then
         newNode := new Node;
         Snake.Front.Next.Prev := newNode;
         newNode.Next := Snake.Front.Next;
         Snake.Front.Next := newNode;
         newNode.Prev := Snake.Front;
         newNode.XCoord := tempFront(0);
         newNode.YCoord := tempFront(1);
         JustCaughtFood := false;
      else
         
         while N.Prev /= Snake.Front loop
            N.XCoord := N.Prev.XCoord;
            N.YCoord := N.Prev.YCoord;
            N := N.Prev;
         end loop;
         N.XCoord := tempFront(0);
         N.YCoord := tempFront(1);
      end if;
      
      
      return 0;
      
      
end MoveSnake;
   
   procedure GenerateNewFood is

      --Value : MicroBit.IOs.Analog_Value;

      
   begin
      Food(0) := Integer(MicroBit.IOs.Analog (1)) mod 4;
      Food(1) := Integer(MicroBit.IOs.Analog (2)) mod 4;
      
   end GenerateNewFood;
   
   
   
begin
   Snake.Front := new Node;
   Snake.Front.XCoord := 3;
   Snake.Front.YCoord := 2;
   Snake.Front.Next := new Node;
   
   Snake.Front.Next.XCoord := 3;
   Snake.Front.Next.YCoord := 3;
   Snake.Back := Snake.Front.Next;
   Snake.Back.Prev := Snake.Front;
         
   

   
end Game;
