with Ada.Text_IO, GNAT.Semaphores;
use Ada.Text_IO, GNAT.Semaphores;

with Ada.Containers.Indefinite_Doubly_Linked_Lists;
use Ada.Containers;

procedure Main is
   package String_Lists is new Indefinite_Doubly_Linked_Lists (String);
   use String_Lists;

   procedure Starter (Storage_Size : in Integer; Item_Numbers : in Integer; Consumers_Numbers : in Integer; Producers_Numbers : in Integer) is
      Storage : List;

      Access_Storage : Counting_Semaphore (1, Default_Ceiling);
      Full_Storage   : Counting_Semaphore (Storage_Size, Default_Ceiling);
      Empty_Storage  : Counting_Semaphore (0, Default_Ceiling);


       Item_Numbers_For_One:Integer;
       Item_counter:Integer:=1;

      task type Consumer is
         entry Start(Item_Numbers : in Integer);
      end Consumer;

      task type Producer is
         entry Start(Item_Numbers : in Integer);
      end Producer;

      task body Producer is
           Item_Numbers : Integer;
      begin
           accept Start (Item_Numbers : in Integer) do
              Producer.Item_Numbers := Item_Numbers;
           end Start;

         for i in 1 .. Item_Numbers loop
            Full_Storage.Seize;
            Access_Storage.Seize;

            Storage.Append ("item " & Item_counter'Img);
            Put_Line ("Added item " & Item_counter'Img);
Item_counter:=Item_counter+1;

            Access_Storage.Release;
            Empty_Storage.Release;
            delay 1.5;
         end loop;

      end Producer;

      task body Consumer is
         Item_Numbers : Integer;
      begin
         accept Start (Item_Numbers : in Integer) do
            Consumer.Item_Numbers := Item_Numbers;
         end Start;

         for i in 1 .. Item_Numbers loop
            Empty_Storage.Seize;
            Access_Storage.Seize;

            declare
               item : String := First_Element (Storage);
            begin
               Put_Line ("Took " & item);
            end;

            Storage.Delete_First;

            Access_Storage.Release;
            Full_Storage.Release;

            delay 2.0;
         end loop;

      end Consumer;

      producers: array(1..Producers_Numbers) of Producer;
      consumers: array(1..Consumers_Numbers) of Consumer;
   begin
      -- null;
      for i in 1 .. Consumers_Numbers loop
      if i=Consumers_Numbers then
      Item_Numbers_For_One:=Item_Numbers/Consumers_Numbers;
   else
     Item_Numbers_For_One:=Item_Numbers-(i*Consumers_Numbers);
   end if;
        consumers(i).Start(Item_Numbers_For_One);
      end loop;

      for i in 1 .. Producers_Numbers loop
      if i=Producers_Numbers then
      Item_Numbers_For_One:=Item_Numbers/Producers_Numbers;
   else
     Item_Numbers_For_One:=Item_Numbers-(i*Producers_Numbers);
   end if;
        producers(i).Start(Item_Numbers_For_One);
      end loop;
   end Starter;

begin
   Starter (3,18,3,6);

end Main;
