with Ada.Streams.Stream_IO;
with Ada.Strings.UTF_Encoding.Wide_Wide_Strings;
with Ada.Strings.Wide_Wide_Unbounded;
with Ada.Text_IO;

package body Output is

   package WWU renames Ada.Strings.Wide_Wide_Unbounded;
   package UTF renames Ada.Strings.UTF_Encoding.Wide_Wide_Strings;
   package SIO renames Ada.Streams.Stream_IO;

   use Ada.Streams;

   File : SIO.File_Type;

   package Fio is new Ada.Text_IO.Float_IO (Float);

   function Trim (S : String) return String is
      A : Natural := S'First;
      B : Natural := S'Last;
   begin
      while A <= B and then S (A) = ' ' loop
         A := A + 1;
      end loop;
      while B >= A and then (S (B) = ' ' or else S (B) = ASCII.NUL) loop
         B := B - 1;
      end loop;
      if A > B then
         return "";
      end if;
      return S (A .. B);
   end Trim;

   function F (X : Float; Aft : Natural := 2) return String is
      Buf : String (1 .. 48) := (others => ' ');
   begin
      Fio.Put (Buf, X, Aft => Aft, Exp => 0);
      return Trim (Buf);
   end F;

   function I (N : Integer) return String is
   begin
      return Trim (Integer'Image (N));
   end I;

   procedure Write_Bytes (S : String) is
      Buf : Stream_Element_Array (1 .. Stream_Element_Offset (S'Length));
   begin
      for J in S'Range loop
         Buf (Stream_Element_Offset (J - S'First + 1)) :=
           Stream_Element (Character'Pos (S (J)));
      end loop;
      SIO.Write (File, Buf);
   end Write_Bytes;

   procedure Open (Path : String) is
   begin
      SIO.Create (File, SIO.Out_File, Path);
   end Open;

   procedure Close is
   begin
      SIO.Close (File);
   end Close;

   procedure Put (S : String) is
   begin
      if S'Length > 0 then
         Write_Bytes (S);
      end if;
   end Put;

   procedure Put_Line (S : String) is
   begin
      Put (S);
      New_Line;
   end Put_Line;

   procedure New_Line is
   begin
      Write_Bytes ((1 => ASCII.LF));
   end New_Line;

   procedure Put_W (S : Wide_Wide_String) is
   begin
      Put (UTF.Encode (S));
   end Put_W;

   function Escape (S : Wide_Wide_String) return Wide_Wide_String is
      R : WWU.Unbounded_Wide_Wide_String;
   begin
      for C of S loop
         case C is
            when '&' =>
               WWU.Append (R, "&amp;");
            when '<' =>
               WWU.Append (R, "&lt;");
            when '>' =>
               WWU.Append (R, "&gt;");
            when '"' =>
               WWU.Append (R, "&quot;");
            when others =>
               WWU.Append (R, (1 => C));
         end case;
      end loop;
      return WWU.To_Wide_Wide_String (R);
   end Escape;

   procedure Put_E (S : Wide_Wide_String) is
   begin
      Put_W (Escape (S));
   end Put_E;

end Output;
