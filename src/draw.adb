with Ada.Numerics;
with Ada.Numerics.Elementary_Functions;
with Ada.Strings.Unbounded;

with Output;
with Palette;
with Tuning;

package body Draw is

   use Ada.Numerics;
   use Ada.Numerics.Elementary_Functions;
   use Ada.Strings.Unbounded;
   use Output;
   use Palette;

   Buf : Unbounded_String;

   procedure Clear is
   begin
      Buf := Null_Unbounded_String;
   end Clear;

   procedure Add (S : String) is
   begin
      Append (Buf, S);
   end Add;

   function D return String is (To_String (Buf));

   procedure M (X, Y : Float) is
   begin
      Add ("M" & F (X) & " " & F (Y));
   end M;

   procedure L (X, Y : Float) is
   begin
      Add ("L" & F (X) & " " & F (Y));
   end L;

   procedure Q (X1, Y1, X, Y : Float) is
   begin
      Add ("Q" & F (X1) & " " & F (Y1) & " " & F (X) & " " & F (Y));
   end Q;

   procedure C (X1, Y1, X2, Y2, X, Y : Float) is
   begin
      Add ("C" & F (X1) & " " & F (Y1) & " " & F (X2) & " " & F (Y2) &
           " " & F (X) & " " & F (Y));
   end C;

   procedure Z is
   begin
      Add ("Z");
   end Z;

   procedure Svg_Open
     (Class_Name : String;
      W, H       : Float;
      Element_Id : String := "";
      Hidden     : Boolean := True;
      Xlink      : Boolean := False)
   is
   begin
      Put ("<svg xmlns=""http://www.w3.org/2000/svg""");
      if Xlink then
         Put (" xmlns:xlink=""http://www.w3.org/1999/xlink""");
      end if;
      Put (" class=""" & Class_Name & """");
      if Element_Id /= "" then
         Put (" id=""" & Element_Id & """");
      end if;
      Put (" viewBox=""0 0 " & I (Integer (W)) & " " & I (Integer (H)) & """");
      if Hidden then
         Put (" aria-hidden=""true""");
      end if;
      Put (" focusable=""false"">");
      New_Line;
   end Svg_Open;

   procedure Svg_Close is
   begin
      Put_Line ("</svg>");
   end Svg_Close;

   procedure Circle
     (Cx, Cy, R : Float;
      Fill      : String;
      Stroke    : String := "";
      Sw        : Float := 0.0;
      Class_Name : String := "")
   is
   begin
      Put ("<circle");
      if Class_Name /= "" then
         Put (" class=""" & Class_Name & """");
      end if;
      Put (" cx=""" & F (Cx) & """ cy=""" & F (Cy) & """ r=""" & F (R) & """");
      Put (" fill=""" & Fill & """");
      if Stroke /= "" then
         Put (" stroke=""" & Stroke & """ stroke-width=""" & F (Sw) & """");
      end if;
      Put_Line ("/>");
   end Circle;

   procedure Ellipse
     (Cx, Cy, Rx, Ry, Rot : Float;
      Fill                : String;
      Stroke              : String := "";
      Sw                  : Float := 0.0)
   is
   begin
      Put ("<ellipse cx=""" & F (Cx) & """ cy=""" & F (Cy) &
           """ rx=""" & F (Rx) & """ ry=""" & F (Ry) & """");
      if abs Rot > 0.05 then
         Put (" transform=""rotate(" & F (Rot, 1) & " " & F (Cx) & " " &
              F (Cy) & ")""");
      end if;
      Put (" fill=""" & Fill & """");
      if Stroke /= "" then
         Put (" stroke=""" & Stroke & """ stroke-width=""" & F (Sw) & """");
      end if;
      Put_Line ("/>");
   end Ellipse;

   procedure Emit_Path
     (Fill, Stroke : String;
      Sw            : Float := 0.0;
      Extra         : String := "")
   is
   begin
      Put ("<path d=""" & D & """");
      if Fill /= "" then
         Put (" fill=""" & Fill & """");
      else
         Put (" fill=""none""");
      end if;
      if Stroke /= "" then
         Put (" stroke=""" & Stroke & """ stroke-width=""" & F (Sw) & """");
         Put (" stroke-linecap=""round"" stroke-linejoin=""round""");
      end if;
      if Extra /= "" then
         Put (" " & Extra);
      end if;
      Put_Line ("/>");
      Clear;
   end Emit_Path;

   procedure Stroke (Color : String; Sw : Float; Extra : String := "") is
   begin
      Emit_Path ("", Color, Sw, Extra);
   end Stroke;

   procedure Fill_Path (Color : String) is
   begin
      Emit_Path (Color, "");
   end Fill_Path;

   procedure Plaster is
   begin
      Svg_Open ("plaster", 100.0, 100.0);
      Put_Line ("<filter id=""plaster"" x=""0"" y=""0"" width=""100%"" height=""100%"">");
      Put_Line ("<feTurbulence type=""fractalNoise"" baseFrequency=""" &
                F (Tuning.Plaster_Freq) & """ numOctaves=""" &
                I (Tuning.Plaster_Octaves) &
                """ stitchTiles=""stitch"" result=""n""/>");
      Put_Line ("<feColorMatrix in=""n"" type=""saturate"" values=""0""/>");
      Put_Line ("</filter>");
      Put_Line ("<rect width=""100%"" height=""100%"" filter=""url(#plaster)""/>");
      Svg_Close;
   end Plaster;

   procedure Flag_DE is
   begin
      Svg_Open ("flag-svg", 5.0, 3.0);
      Put_Line ("<rect width=""5"" height=""1"" fill=""#000""/>");
      Put_Line ("<rect y=""1"" width=""5"" height=""1"" fill=""" & Flag_Red & """/>");
      Put_Line ("<rect y=""2"" width=""5"" height=""1"" fill=""" & Flag_Gold & """/>");
      Svg_Close;
   end Flag_DE;

   procedure Flag_EN is
   begin
      Svg_Open ("flag-svg", 60.0, 30.0);
      Put_Line ("<defs><clipPath id=""union-clip""><rect width=""60"" height=""30""/></clipPath></defs>");
      Put_Line ("<g clip-path=""url(#union-clip)"">");
      Put_Line ("<rect width=""60"" height=""30"" fill=""" & Union_Blue & """/>");
      Put_Line ("<path d=""M0 0L60 30M60 0L0 30"" stroke=""" & Glaze &
                """ stroke-width=""10""/>");
      Put_Line ("<path d=""M0 0L60 30"" stroke=""" & Union_Red &
                """ stroke-width=""4""/>");
      Put_Line ("<path d=""M60 0L0 30"" stroke=""" & Union_Red &
                """ stroke-width=""4""/>");
      Put_Line ("<path d=""M30 0V30M0 15H60"" stroke=""" & Glaze &
                """ stroke-width=""16""/>");
      Put_Line ("<path d=""M30 0V30M0 15H60"" stroke=""" & Union_Red &
                """ stroke-width=""9""/>");
      Put_Line ("</g>");
      Svg_Close;
   end Flag_EN;

   procedure Flag_Fallback (Lang_Code : String) is
   begin
      Svg_Open ("flag-svg", 60.0, 36.0);
      Put_Line ("<rect width=""60"" height=""36"" rx=""4"" fill=""" & Cobalt & """/>");
      Put ("<text x=""30"" y=""24"" text-anchor=""middle"" fill=""" & Cream &
           """ font-size=""16"" font-family=""Palatino, Georgia, serif"">");
      Put (Lang_Code);
      Put_Line ("</text>");
      Svg_Close;
   end Flag_Fallback;

   procedure Flag (Lang_Code : String) is
   begin
      if Lang_Code = "de" then
         Flag_DE;
      elsif Lang_Code = "en" then
         Flag_EN;
      else
         Flag_Fallback (Lang_Code);
      end if;
   end Flag;

   --  Lemniskate von Bernoulli, eine geschlossene Acht.
   procedure Infinity
     (Prefix       : String;
      Duration     : Float;
      Repeat_Count : String;
      Dot_R        : Float)
   is
      Cx : constant Float := 120.0;
      Cy : constant Float := 60.0;
      Ax : constant Float := 104.0;
      Ay : constant Float := 98.0;
   begin
      Svg_Open ("infty " & Prefix, 240.0, 120.0, Xlink => True);
      Put_Line ("<defs>");
      Put_Line ("<filter id=""" & Prefix & "-glow"" x=""-40%"" y=""-40%"" width=""180%"" height=""180%"">");
      Put_Line ("<feGaussianBlur stdDeviation=""1.2"" result=""b""/>");
      Put_Line ("<feMerge><feMergeNode in=""b""/><feMergeNode in=""SourceGraphic""/></feMerge>");
      Put_Line ("</filter>");
      Put_Line ("</defs>");

      Clear;
      for Step in 0 .. Tuning.Infinity_Samples loop
         declare
            T   : constant Float :=
              Pi / 2.0 +
              (Float (Step) / Float (Tuning.Infinity_Samples)) * 2.0 * Pi;
            S   : constant Float := Sin (T);
            Co  : constant Float := Cos (T);
            Den : constant Float := 1.0 + S * S;
            X   : constant Float := Cx + Ax * Co / Den;
            Y   : constant Float := Cy + Ay * S * Co / Den;
         begin
            if Step = 0 then
               M (X, Y);
            else
               L (X, Y);
            end if;
         end;
      end loop;
      Put ("<path id=""" & Prefix & "-path"" d=""" & D & """ fill=""none""");
      Clear;
      Put (" stroke=""" & Bordeaux & """ stroke-width=""3.6""");
      Put_Line (" stroke-linecap=""round"" stroke-linejoin=""round""/>");

      Put ("<circle class=""" & Tuning.Cls_Motion & """ r=""" & F (Dot_R) &
           """ cx=""0"" cy=""0"" fill=""" & Gold & """ stroke=""" & Gold_Edge &
           """ stroke-width=""0.7"" filter=""url(#" & Prefix & "-glow)"">");
      New_Line;
      Put ("<animateMotion dur=""" & F (Duration) & "s"" repeatCount=""" &
           Repeat_Count & """ calcMode=""linear"" rotate=""0"">");
      New_Line;
      Put_Line ("<mpath href=""#" & Prefix & "-path"" xlink:href=""#" &
                Prefix & "-path""/>");
      Put_Line ("</animateMotion>");
      Put_Line ("</circle>");
      Circle (Cx, Cy, Dot_R, Gold, Gold_Edge, 0.7, Tuning.Cls_Static);
      Svg_Close;
   end Infinity;

   type Folio is record
      X, Y, Rx, Ry, Rot : Float;
   end record;

   Canopy : constant array (Positive range <>) of Folio :=
     ((102.0, 48.0, 18.0, 7.5, -18.0),
      (76.0, 58.0, 16.0, 6.5, 32.0),
      (128.0, 56.0, 17.0, 7.0, -36.0),
      (54.0, 78.0, 15.0, 6.0, 18.0),
      (148.0, 76.0, 16.0, 6.5, -28.0),
      (92.0, 74.0, 14.0, 5.5, 58.0),
      (116.0, 86.0, 15.0, 6.0, -8.0),
      (38.0, 104.0, 14.0, 5.5, 40.0),
      (164.0, 102.0, 15.0, 6.0, -48.0),
      (68.0, 108.0, 16.0, 6.5, -16.0),
      (132.0, 112.0, 14.0, 5.5, 24.0),
      (100.0, 108.0, 12.0, 5.0, 70.0),
      (46.0, 132.0, 14.0, 5.5, 12.0),
      (156.0, 134.0, 15.0, 6.0, -32.0),
      (84.0, 136.0, 13.0, 5.0, 46.0),
      (120.0, 146.0, 13.0, 5.0, -22.0),
      (60.0, 158.0, 14.0, 5.5, 8.0),
      (146.0, 162.0, 13.0, 5.0, -38.0),
      (104.0, 166.0, 12.0, 5.0, 52.0),
      (32.0, 176.0, 12.0, 5.0, 28.0),
      (172.0, 150.0, 12.0, 5.0, -14.0),
      (74.0, 188.0, 13.0, 5.0, -42.0),
      (136.0, 196.0, 12.0, 5.0, 18.0),
      (96.0, 196.0, 11.0, 4.5, 24.0),
      (118.0, 208.0, 12.0, 5.0, -30.0),
      (52.0, 206.0, 11.0, 4.5, 16.0));

   type Fruit is record
      X, Y, R : Float;
   end record;

   Lemons : constant array (Positive range <>) of Fruit :=
     ((72.0, 72.0, 11.0),
      (130.0, 70.0, 12.0),
      (98.0, 96.0, 10.0),
      (50.0, 118.0, 11.0),
      (158.0, 118.0, 12.0),
      (112.0, 132.0, 10.5),
      (78.0, 176.0, 10.0),
      (148.0, 178.0, 11.0),
      (104.0, 214.0, 9.5));

   procedure Lemon_Fruit (Item : Fruit) is
   begin
      Circle (Item.X, Item.Y, Item.R, Lemon, Lemon_Deep, 0.8);
      Circle (Item.X - Item.R * 0.28, Item.Y - Item.R * 0.32,
              Item.R * 0.28, Sheen);
      Ellipse (Item.X, Item.Y - Item.R - 1.2, 3.2, 1.6, -20.0, Leaf_Mid);
   end Lemon_Fruit;

   procedure Draw_Dove (X, Y, Scale, Flip : Float) is
   begin
      Put ("<g transform=""translate(" & F (X) & " " & F (Y) &
           ") scale(" & F (Flip * Scale, 2) & " " & F (Scale, 2) & ")"">");
      New_Line;
      Clear;
      M (-18.0, 2.0);
      Q (-28.0, -2.0, -34.0, 4.0);
      Q (-26.0, 6.0, -16.0, 6.0);
      Z;
      Fill_Path (Dove);
      Ellipse (0.0, 0.0, 16.0, 7.2, 0.0, Dove, Dove_Line, 1.5);
      Circle (14.0, -5.0, 6.2, Dove, Dove_Line, 1.5);
      Clear;
      M (2.0, -1.0);
      Q (-6.0, -16.0, 10.0, -5.0);
      Q (4.0, -8.0, 2.0, -1.0);
      Z;
      Emit_Path (Cobalt_Wash, Dove_Line, 1.2);
      Circle (16.2, -6.2, 1.15, Ink);
      Clear;
      M (19.0, -4.0);
      L (25.0, -2.6);
      L (19.2, -1.4);
      Z;
      Fill_Path (Beak);
      Put_Line ("</g>");
   end Draw_Dove;

   procedure Lemon_Tree is
   begin
      Svg_Open ("tile lemon", 200.0, 400.0);
      Clear;
      M (16.0, 384.0);
      L (16.0, 150.0);
      Add ("A82 82 0 0 1 184 150");
      L (184.0, 384.0);
      Z;
      Emit_Path (Glaze, Mustard, 7.0);
      Clear;
      M (24.0, 384.0);
      L (24.0, 154.0);
      Add ("A74 74 0 0 1 176 154");
      L (176.0, 384.0);
      Stroke (Cobalt, 2.2);

      Clear;
      M (100.0, 372.0);
      C (96.0, 300.0, 108.0, 240.0, 100.0, 168.0);
      Stroke (Bark, 13.0);
      Clear;
      M (100.0, 250.0);
      C (70.0, 236.0, 46.0, 210.0, 34.0, 176.0);
      Stroke (Bark, 5.5);
      Clear;
      M (98.0, 210.0);
      C (72.0, 188.0, 50.0, 156.0, 36.0, 122.0);
      Stroke (Bark, 6.0);
      Clear;
      M (104.0, 196.0);
      C (138.0, 176.0, 162.0, 146.0, 176.0, 104.0);
      Stroke (Bark, 6.0);
      Clear;
      M (102.0, 230.0);
      C (140.0, 220.0, 164.0, 200.0, 176.0, 168.0);
      Stroke (Bark, 5.0);
      Clear;
      M (100.0, 168.0);
      C (88.0, 130.0, 112.0, 96.0, 100.0, 62.0);
      Stroke (Bark_Deep, 5.0);
      Clear;
      M (100.0, 150.0);
      C (78.0, 120.0, 70.0, 90.0, 86.0, 58.0);
      Stroke (Bark, 3.5);
      Clear;
      M (104.0, 142.0);
      C (130.0, 118.0, 150.0, 96.0, 142.0, 64.0);
      Stroke (Bark, 3.5);

      for Item of Canopy loop
         Ellipse (Item.X, Item.Y, Item.Rx, Item.Ry, Item.Rot, Leaf_Mid);
         Ellipse (Item.X, Item.Y, Item.Rx * 0.55, Item.Ry * 0.45,
                  Item.Rot, Leaf_Lite);
      end loop;

      for Item of Lemons loop
         Lemon_Fruit (Item);
      end loop;

      Clear;
      M (70.0, 236.0);
      Q (96.0, 228.0, 118.0, 240.0);
      Stroke (Bark, 3.2);
      Clear;
      M (112.0, 276.0);
      Q (140.0, 268.0, 162.0, 286.0);
      Stroke (Bark, 3.0);
      Draw_Dove (76.0, 228.0, 1.15, 1.0);
      Draw_Dove (132.0, 270.0, 1.08, -1.0);

      Ellipse (100.0, 368.0, 72.0, 9.0, 0.0, Leaf);
      Ellipse (46.0, 360.0, 8.0, 3.2, -30.0, Leaf_Mid);
      Ellipse (54.0, 364.0, 7.0, 2.8, 20.0, Leaf_Lite);
      Ellipse (150.0, 362.0, 8.0, 3.0, 24.0, Leaf_Mid);
      Ellipse (158.0, 366.0, 6.5, 2.6, -18.0, Leaf_Lite);

      Put_Line ("<g stroke=""" & Grout & """ stroke-width=""2"" opacity=""0.55"">");
      Put_Line ("<path d=""M16 120H184M16 210H184M16 300H184M100 20V384""/>");
      Put_Line ("</g>");
      Svg_Close;
   end Lemon_Tree;

   procedure Bloom
     (Cx, Cy, Radius : Float;
      Petals         : Positive;
      Petal          : String;
      Center         : String)
   is
   begin
      for K in 0 .. Petals - 1 loop
         declare
            Ang : constant Float :=
              (Float (K) / Float (Petals)) * 2.0 * Pi - Pi / 2.0;
            Px  : constant Float := Cx + Cos (Ang) * Radius * 0.62;
            Py  : constant Float := Cy + Sin (Ang) * Radius * 0.62;
         begin
            Circle (Px, Py, Radius * 0.48, Petal);
         end;
      end loop;
      Circle (Cx, Cy, Radius * 0.38, Center, Bark_Deep, 0.4);
   end Bloom;

   procedure Vase is
   begin
      Svg_Open ("tile vase", 200.0, 250.0);
      Put_Line ("<rect x=""4"" y=""4"" width=""192"" height=""242"" fill=""" &
                Glaze & """ stroke=""" & Cobalt & """ stroke-width=""6""/>");
      Put_Line ("<rect x=""12"" y=""12"" width=""176"" height=""226"" fill=""none"" stroke=""" &
                Cobalt & """ stroke-width=""1.4""/>");

      Clear;
      M (100.0, 128.0);
      C (78.0, 118.0, 60.0, 132.0, 48.0, 108.0);
      Stroke (Leaf, 2.2);
      Ellipse (46.0, 100.0, 12.0, 5.0, -40.0, Leaf_Mid);
      Ellipse (62.0, 118.0, 11.0, 4.5, 30.0, Leaf);
      Ellipse (150.0, 96.0, 14.0, 5.5, 36.0, Leaf_Mid);
      Ellipse (132.0, 112.0, 10.0, 4.2, -24.0, Leaf_Lite);
      Ellipse (108.0, 124.0, 12.0, 4.8, 10.0, Leaf);

      Bloom (64.0, 78.0, 16.0, 6, Flower_Orange, Flower_Center);
      Bloom (108.0, 52.0, 18.0, 7, Flower_Red, Flower_Center);
      Bloom (148.0, 74.0, 15.0, 6, Flower_Blue, Glaze);
      Bloom (86.0, 108.0, 11.0, 5, Flower_Purple, Flower_Center);
      Bloom (138.0, 112.0, 12.0, 6, Flower_Orange, Flower_Center);

      Clear;
      M (70.0, 148.0);
      C (40.0, 148.0, 32.0, 168.0, 38.0, 176.0);
      C (46.0, 186.0, 58.0, 178.0, 64.0, 170.0);
      L (70.0, 206.0);
      C (72.0, 224.0, 128.0, 224.0, 130.0, 206.0);
      L (136.0, 170.0);
      C (142.0, 178.0, 154.0, 186.0, 162.0, 176.0);
      C (168.0, 168.0, 160.0, 148.0, 130.0, 148.0);
      L (124.0, 136.0);
      L (76.0, 136.0);
      Z;
      Emit_Path (Cobalt, Cobalt_Deep, 1.2);

      Clear;
      M (78.0, 154.0);
      Q (100.0, 164.0, 122.0, 154.0);
      Stroke (Glaze, 2.4);
      Clear;
      M (84.0, 168.0);
      Q (100.0, 176.0, 116.0, 168.0);
      Stroke (Cobalt_Wash, 2.0);
      Clear;
      M (76.0, 222.0);
      L (68.0, 234.0);
      L (132.0, 234.0);
      L (124.0, 222.0);
      Z;
      Fill_Path (Cobalt_Deep);
      Clear;
      M (90.0, 228.0);
      Q (100.0, 222.0, 110.0, 228.0);
      Stroke (Gold, 1.2);

      Put_Line ("<g fill=""" & Cobalt & """ opacity=""0.9"">");
      Put_Line ("<path d=""M18 28c8 6 8 14 0 18c-6-8 0-14 0-18z""/>");
      Put_Line ("<path d=""M182 28c-8 6-8 14 0 18c6-8 0-14 0-18z""/>");
      Put_Line ("<path d=""M18 214c8-6 8-14 0-18c-6 8 0 14 0 18z""/>");
      Put_Line ("<path d=""M182 214c-8-6-8-14 0-18c6 8 0 14 0 18z""/>");
      Put_Line ("</g>");
      Svg_Close;
   end Vase;

   procedure Bird
     (X, Y, Scale, Flip : Float;
      Breast            : String)
   is
   begin
      Put ("<g transform=""translate(" & F (X) & " " & F (Y) &
           ") scale(" & F (Flip * Scale, 2) & " " & F (Scale, 2) & ")"">");
      New_Line;
      Ellipse (0.0, 0.0, 18.0, 8.0, 0.0, Dove_Line);
      Ellipse (-2.0, 1.0, 10.0, 5.5, 0.0, Breast);
      Circle (16.0, -4.0, 6.4, Ink);
      Circle (18.0, -5.2, 1.1, Glaze);
      Clear;
      M (20.0, -3.0);
      L (27.0, -1.2);
      L (20.0, 0.4);
      Z;
      Fill_Path (Beak);
      Clear;
      M (-4.0, -2.0);
      Q (-16.0, -16.0, -2.0, -6.0);
      Stroke (Ink, 2.4);
      Clear;
      M (-16.0, 2.0);
      Q (-30.0, -4.0, -36.0, 4.0);
      Stroke (Ink, 2.2);
      Ellipse (-6.0, 8.0, 3.2, 1.4, 0.0, Beak);
      Put_Line ("</g>");
   end Bird;

   procedure Birds is
   begin
      Svg_Open ("tile birds", 320.0, 150.0);
      Ellipse (160.0, 75.0, 150.0, 64.0, 0.0, Glaze, Cobalt, 8.0);
      Ellipse (160.0, 75.0, 138.0, 52.0, 0.0, "none", Cobalt, 1.5);

      Clear;
      M (36.0, 96.0);
      C (80.0, 70.0, 120.0, 88.0, 156.0, 64.0);
      Stroke (Cobalt, 5.0);
      Clear;
      M (150.0, 70.0);
      C (190.0, 46.0, 230.0, 58.0, 286.0, 40.0);
      Stroke (Cobalt, 4.5);
      Clear;
      M (70.0, 108.0);
      C (110.0, 120.0, 150.0, 100.0, 196.0, 112.0);
      Stroke (Cobalt_Deep, 3.5);

      for N in 1 .. 5 loop
         declare
            Bx : constant Float := 48.0 + Float (N) * 28.0;
            By : constant Float := 58.0 + Sin (Float (N)) * 16.0;
         begin
            Circle (Bx, By, 3.2, Lemon, Lemon_Deep, 0.4);
            Circle (Bx + 6.0, By + 4.0, 2.6, Lemon);
         end;
      end loop;

      Ellipse (54.0, 70.0, 10.0, 4.5, 30.0, Leaf_Mid);
      Ellipse (92.0, 84.0, 11.0, 4.5, -20.0, Leaf);
      Ellipse (210.0, 48.0, 10.0, 4.2, 24.0, Leaf_Lite);
      Ellipse (250.0, 56.0, 12.0, 5.0, -30.0, Leaf_Mid);
      Ellipse (180.0, 100.0, 9.0, 4.0, 16.0, Leaf);

      Bird (108.0, 78.0, 0.85, 1.0, Lemon);
      Bird (214.0, 62.0, 0.8, -1.0, Gold);
      Svg_Close;
   end Birds;

   procedure Sun is
      Rays   : constant := 18;
      Center : constant Float := 100.0;
   begin
      Svg_Open ("sun", 200.0, 200.0);
      for K in 0 .. Rays - 1 loop
         declare
            Ang  : constant Float :=
              (Float (K) / Float (Rays)) * 2.0 * Pi - Pi / 2.0;
            Long : constant Boolean := K mod 2 = 0;
            Len  : constant Float := (if Long then 90.0 else 68.0);
            Curl : constant Boolean := K mod 3 = 0;
            Inner : constant Float := 30.0;
            X1 : constant Float := Center + Cos (Ang) * Inner;
            Y1 : constant Float := Center + Sin (Ang) * Inner;
            X2 : constant Float := Center + Cos (Ang) * Len;
            Y2 : constant Float := Center + Sin (Ang) * Len;
            Wobble : constant Float :=
              Sin (Float (K) * 1.7) * (if Long then 14.0 else 8.0);
            Mx : constant Float :=
              (X1 + X2) / 2.0 + (-Sin (Ang)) * Wobble;
            My : constant Float :=
              (Y1 + Y2) / 2.0 + Cos (Ang) * Wobble;
            Tone : constant String :=
              (if K mod 5 = 0 then Rust else Iron);
         begin
            Clear;
            M (X1, Y1);
            Q (Mx, My, X2, Y2);
            Stroke (Tone, (if Long then 3.4 else 2.4));
            if Curl then
               Circle (X2, Y2, 5.5, "none", Iron_Dark, 1.6);
            end if;
         end;
      end loop;

      Circle (Center, Center, 26.0, Iron, Iron_Dark, 2.0);
      Circle (Center, Center, 20.0, Iron_Dark);
      Ellipse (91.0, 96.0, 3.2, 4.0, 0.0, Glaze);
      Ellipse (109.0, 96.0, 3.2, 4.0, 0.0, Glaze);
      Circle (91.0, 97.0, 1.3, Ink);
      Circle (109.0, 97.0, 1.3, Ink);
      Clear;
      M (94.0, 108.0);
      Q (100.0, 114.0, 106.0, 108.0);
      Stroke (Glaze, 1.4);
      Svg_Close;
   end Sun;

   type Leg is record
      Hx, Hy, Kx, Ky, Fx, Fy : Float;
   end record;

   Legs : constant array (1 .. 4) of Leg :=
     ((118.0, 50.0, 106.0, 70.0, 94.0, 84.0),
      (128.0, 60.0, 114.0, 82.0, 100.0, 94.0),
      (158.0, 50.0, 170.0, 70.0, 184.0, 82.0),
      (168.0, 60.0, 182.0, 80.0, 198.0, 90.0));

   procedure Toes (From_X, From_Y, Foot_X, Foot_Y : Float) is
      Dx  : Float := Foot_X - From_X;
      Dy  : Float := Foot_Y - From_Y;
      Len : Float;
   begin
      Len := Sqrt (Dx * Dx + Dy * Dy);
      if Len < 0.01 then
         return;
      end if;
      Dx := Dx / Len;
      Dy := Dy / Len;
      for K in -1 .. 1 loop
         declare
            Side : constant Float := Float (K);
            Px   : constant Float :=
              Foot_X + Dx * 6.5 + (-Dy) * Side * 4.6;
            Py   : constant Float :=
              Foot_Y + Dy * 6.5 + Dx * Side * 4.6;
         begin
            Circle (Px, Py, 3.5, Bronze_Hi, Bronze_Line, 0.6);
         end;
      end loop;
   end Toes;

   procedure Gecko is
      Body_X : constant Float := 140.0;
      Body_Y : constant Float := 54.0;
      Tail_X : constant Float := 96.0;
      Tail_Y : constant Float := 54.0;
   begin
      Svg_Open ("gecko", 230.0, 110.0, Tuning.Id_Gecko);
      Put_Line ("<defs>");
      Put_Line ("<linearGradient id=""gecko-bronze"" x1=""0"" y1=""0"" x2=""0"" y2=""1"">");
      Put_Line ("<stop offset=""0"" stop-color=""" & Bronze_Hi & """/>");
      Put_Line ("<stop offset=""0.45"" stop-color=""" & Bronze_Mid & """/>");
      Put_Line ("<stop offset=""1"" stop-color=""" & Bronze_Lo & """/>");
      Put_Line ("</linearGradient>");
      Put ("<clipPath id=""gecko-clip""><ellipse cx=""" & F (Body_X) &
           """ cy=""" & F (Body_Y) & """ rx=""36"" ry=""13""/></clipPath>");
      New_Line;
      Put_Line ("</defs>");

      Put ("<g class=""" & Tuning.Cls_Tail & """ data-px=""" & F (Tail_X) &
           """ data-py=""" & F (Tail_Y) & """>");
      New_Line;
      Clear;
      M (Tail_X, Tail_Y - 8.0);
      C (68.0, 40.0, 36.0, 62.0, 16.0, 80.0);
      C (8.0, 88.0, 12.0, 98.0, 26.0, 90.0);
      C (48.0, 76.0, 70.0, 64.0, Tail_X, Tail_Y + 8.0);
      Z;
      Fill_Path ("url(#gecko-bronze)");
      Put_Line ("</g>");

      Put ("<g class=""" & Tuning.Cls_Body & """ data-px=""" & F (Body_X) &
           """ data-py=""" & F (Body_Y) & """>");
      New_Line;
      Ellipse (Body_X, Body_Y, 40.0, 16.0, 0.0, "url(#gecko-bronze)",
               Bronze_Line, 0.8);

      Put_Line ("<g clip-path=""url(#gecko-clip)"">");
      Clear;
      M (112.0, 54.0);
      Q (140.0, 46.0, 170.0, 56.0);
      Stroke (Leaf, 1.3);
      for N in 1 .. 8 loop
         declare
            T   : constant Float := Float (N) / 9.0;
            Lx  : constant Float := 112.0 + T * 56.0;
            Ly  : constant Float := Body_Y + Sin (T * 10.0) * 5.5;
            Rot : constant Float := Sin (T * 6.0) * 55.0;
         begin
            Ellipse (Lx, Ly, 7.5, 3.2, Rot,
                     (if N mod 2 = 0 then Leaf_Lite else Leaf_Mid));
         end;
      end loop;
      Put_Line ("</g>");

      Ellipse (186.0, 50.0, 22.0, 14.0, 0.0, "url(#gecko-bronze)",
               Bronze_Line, 0.8);
      Ellipse (204.0, 52.0, 8.0, 5.5, 8.0, Bronze_Mid, Bronze_Line, 0.5);
      Circle (190.0, 46.0, 4.4, Bronze_Line);
      Circle (178.0, 44.5, 2.8, Bronze_Line);
      Circle (191.4, 44.6, 1.15, Glaze);
      Circle (178.8, 43.6, 0.7, Glaze);

      for Item of Legs loop
         Put ("<g class=""" & Tuning.Cls_Leg & """ data-x=""" & F (Item.Hx) &
              """ data-y=""" & F (Item.Hy) & """>");
         New_Line;
         Clear;
         M (Item.Hx, Item.Hy);
         Q (Item.Kx, Item.Ky, Item.Fx, Item.Fy);
         Stroke (Bronze_Lo, 3.3);
         Toes (Item.Kx, Item.Ky, Item.Fx, Item.Fy);
         Put_Line ("</g>");
      end loop;
      Put_Line ("</g>");
      Svg_Close;
   end Gecko;

   procedure Mini_Scene (X : Float; Kind : Positive) is
      Y : constant Float := 14.0;
   begin
      Put ("<g transform=""translate(" & F (X) & " " & F (Y) & ")"">");
      New_Line;
      if Kind = 1 then
         Put_Line ("<rect width=""70"" height=""40"" fill=""" & Cobalt & """/>");
         Circle (54.0, 12.0, 6.0, Gold);
         Clear;
         M (8.0, 30.0);
         L (28.0, 22.0);
         L (46.0, 30.0);
         Z;
         Fill_Path (Glaze);
      elsif Kind = 2 then
         Put_Line ("<rect width=""70"" height=""40"" fill=""" & Wall & """/>");
         Clear;
         M (18.0, 32.0);
         L (18.0, 18.0);
         L (34.0, 10.0);
         L (50.0, 18.0);
         L (50.0, 32.0);
         Z;
         Fill_Path (Flower_Red);
         Put_Line ("<rect x=""30"" y=""22"" width=""8"" height=""10"" fill=""" &
                   Cream & """/>");
      else
         Put_Line ("<rect width=""70"" height=""40"" fill=""" & Flower_Orange & """/>");
         Circle (14.0, 12.0, 5.0, Gold);
         Clear;
         M (28.0, 32.0);
         L (36.0, 16.0);
         L (44.0, 32.0);
         Z;
         Fill_Path (Leaf_Mid);
         Put_Line ("<rect x=""48"" y=""20"" width=""12"" height=""12"" fill=""" &
                   Glaze & """/>");
      end if;
      Put_Line ("</g>");
   end Mini_Scene;

   procedure Casa is
   begin
      Svg_Open ("casa", 260.0, 176.0);
      Put_Line ("<rect width=""260"" height=""176"" rx=""6"" fill=""" & Pebble & """/>");
      for N in 1 .. 48 loop
         declare
            Px : constant Float :=
              Float ((N * 37) mod 240) + 8.0;
            Py : constant Float :=
              Float ((N * 19) mod 150) + 10.0;
            Pr : constant Float := 3.0 + Float (N mod 4);
            Tone : constant String :=
              (if N mod 3 = 0 then Pebble_Dark else Cream);
         begin
            Circle (Px, Py, Pr, Tone);
         end;
      end loop;

      Mini_Scene (22.0, 1);
      Mini_Scene (96.0, 2);
      Mini_Scene (170.0, 3);

      for Row in 1 .. 3 loop
         declare
            Y : constant Float := 62.0 + Float (Row - 1) * 34.0;
         begin
            Put_Line ("<rect x=""48"" y=""" & F (Y) &
                      """ width=""164"" height=""28"" rx=""2"" fill=""" &
                      Glaze & """ stroke=""" & Ink & """ stroke-width=""1.4""/>");
         end;
      end loop;

      Put ("<text x=""130"" y=""82"" text-anchor=""middle"" fill=""" & Ink &
           """ font-size=""16"" font-family=""Palatino, Georgia, serif"" letter-spacing=""3"">");
      Put_W ("CASA");
      Put_Line ("</text>");
      Put ("<text x=""130"" y=""116"" text-anchor=""middle"" fill=""" & Ink &
           """ font-size=""16"" font-family=""Palatino, Georgia, serif"" letter-spacing=""2"">");
      Put_W ("DOBOS");
      Put_Line ("</text>");
      Put ("<text x=""130"" y=""150"" text-anchor=""middle"" fill=""" & Ink &
           """ font-size=""16"" font-family=""Palatino, Georgia, serif"" letter-spacing=""1"">");
      Put_W ("Nº10");
      Put_Line ("</text>");
      Svg_Close;
   end Casa;

   procedure Rule is
   begin
      Svg_Open ("azulejo-rule", 360.0, 26.0);
      for K in 0 .. 8 loop
         declare
            X : constant Float := 14.0 + Float (K) * 40.0;
         begin
            Clear;
            M (X, 13.0);
            L (X + 8.0, 4.0);
            L (X + 16.0, 13.0);
            L (X + 8.0, 22.0);
            Z;
            Emit_Path ("none", Cobalt, 1.15);
            if K mod 2 = 0 then
               Circle (X + 8.0, 13.0, 1.7, Bordeaux);
            else
               Circle (X + 8.0, 13.0, 1.5, Leaf_Mid);
            end if;
         end;
      end loop;
      Svg_Close;
   end Rule;

   procedure Speaker is
   begin
      Svg_Open ("speaker", 24.0, 24.0);
      Clear;
      M (4.0, 9.0);
      L (8.0, 9.0);
      L (13.0, 5.0);
      L (13.0, 19.0);
      L (8.0, 15.0);
      L (4.0, 15.0);
      Z;
      Fill_Path ("currentColor");
      Clear;
      M (16.0, 8.5);
      Q (20.0, 12.0, 16.0, 15.5);
      Stroke ("currentColor", 1.6);
      Svg_Close;
   end Speaker;

end Draw;
