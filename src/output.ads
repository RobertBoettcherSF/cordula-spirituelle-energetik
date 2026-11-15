package Output is

   procedure Open (Path : String);
   procedure Close;

   procedure Put (S : String);
   procedure Put_Line (S : String);
   procedure New_Line;

   --  UTF-8, ohne Escaping.
   procedure Put_W (S : Wide_Wide_String);

   --  UTF-8, HTML-Text escaped (& < > ").
   procedure Put_E (S : Wide_Wide_String);

   function F (X : Float; Aft : Natural := 2) return String;
   function I (N : Integer) return String;

end Output;
