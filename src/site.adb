with Ada.Command_Line;
with Output;
with Page;

procedure Site is

   procedure Run (Path : String) is
   begin
      Output.Open (Path);
      Page.Emit;
      Output.Close;
   end Run;

begin
   if Ada.Command_Line.Argument_Count >= 2
     and then Ada.Command_Line.Argument (1) = "-o"
   then
      Run (Ada.Command_Line.Argument (2));
   else
      Run ("index.html");
   end if;
end Site;
