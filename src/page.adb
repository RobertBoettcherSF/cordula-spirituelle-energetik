with Output;
with Palette;
with Tuning;
with Translations;
with Draw;
with Style;
with Runtime;

package body Page is

   use Output;
   use Tuning;
   use Translations;

   procedure T (Id : Phrase) is
   begin
      for Index in 1 .. Lang_Count loop
         Put ("<span class=""t t-" & Code (Index) & """ lang=""" &
              Code (Index) & """>");
         Put_E (Phrase_Text (Index, Id));
         Put ("</span>");
      end loop;
   end T;

   procedure Placeholder (Id : Phrase) is
   begin
      Put_Line ("<!-- PLACEHOLDER: Von Cordula zu ersetzen. -->");
      Put ("<p class=""ph"">");
      T (Id);
      Put_Line ("</p>");
   end Placeholder;

   procedure Tel_Line (Extra_Class : String := "") is
   begin
      Put ("<p class=""tel-line" & Extra_Class & """>");
      T (Tel_Label);
      Put ("<a class=""tel"" href=""" & Tel_Href & """>" & Tel_Display & "</a>");
      T (Tel_Note);
      Put_Line ("</p>");
   end Tel_Line;

   procedure Figure
     (Draw_It : access procedure;
      Caption : Phrase)
   is
   begin
      Put_Line ("<figure>");
      Draw_It.all;
      Put ("<figcaption class=""visually-hidden"">");
      T (Caption);
      Put_Line ("</figcaption></figure>");
   end Figure;

   procedure Emit is
   begin
      Put_Line ("<!DOCTYPE html>");
      Put_Line ("<html lang=""" & Code (Default_Index) & """>");
      Put_Line ("<head>");
      Put_Line ("<meta charset=""utf-8"">");
      Put_Line ("<meta name=""viewport"" content=""width=device-width, initial-scale=1"">");
      Put ("<title>");
      Put_E (Phrase_Text (Default_Index, Doc_Title));
      Put_Line ("</title>");
      Put ("<meta name=""description"" content=""");
      Put_E (Phrase_Text (Default_Index, Meta_Description));
      Put_Line (""">");
      Put_Line ("<meta name=""color-scheme"" content=""light"">");
      Put_Line ("<meta name=""theme-color"" content=""" & Palette.Mustard & """>");
      Put_Line ("<!-- Erzeugt durch bin/site. Nicht von Hand ändern.");
      Put_Line ("     Texte: src/translations.adb");
      Put_Line ("     Farben: src/palette.ads");
      Put_Line ("     Zeiten, Ton, Gecko: src/tuning.ads -->");
      Style.Emit;
      Put_Line ("</head>");
      Put_Line ("<body>");
      Put_Line ("<input class=""skip-input"" type=""checkbox"" id=""" &
                Id_Skip & """>");
      Draw.Plaster;

      Put_Line ("<div class=""tools"">");
      for Index in 1 .. Lang_Count loop
         Put ("<label class=""flag"">");
         Put ("<input type=""radio"" name=""lang"" id=""lang-" & Code (Index) &
              """");
         if Index = Default_Index then
            Put (" checked");
         end if;
         Put_Line (">");
         Put ("<span class=""visually-hidden"">");
         Put_E (Endonym (Index));
         Put_Line ("</span>");
         Draw.Flag (Code (Index));
         Put_Line ("</label>");
      end loop;
      Put ("<button type=""button"" class=""sound"" id=""" & Id_Sound &
           """ aria-pressed=""false"">");
      Draw.Speaker;
      Put ("<span class=""when-idle"">");
      T (Sound_Idle);
      Put ("</span><span class=""when-on"">");
      T (Sound_Mute);
      Put ("</span><span class=""when-off"">");
      T (Sound_Unmute);
      Put_Line ("</span></button>");
      Put_Line ("</div>");

      Put_Line ("<div class=""splash"" id=""" & Id_Splash & """>");
      Draw.Infinity ("mark", Splash_Hold, "1", Dot_Splash);
      Put ("<h1>");
      T (Name);
      Put_Line ("</h1>");
      Put ("<p class=""practice"">");
      T (Practice);
      Put_Line ("</p>");
      Put_Line ("<hr class=""hairline"">");
      Put ("<p class=""services-line"">");
      T (Services_Line);
      Put_Line ("</p>");
      Tel_Line;
      Put ("<label class=""skip"" for=""" & Id_Skip & """>");
      T (Skip_Label);
      Put_Line ("</label>");
      Put_Line ("</div>");

      Put_Line ("<div class=""page"" id=""" & Id_Page & """>");
      Draw.Sun;
      Draw.Gecko;
      Put_Line ("<div class=""panel"">");
      Put_Line ("<header class=""plaque"">");
      Draw.Infinity ("head", Header_Orbit, "indefinite", Dot_Header);
      Put ("<h1>");
      T (Name);
      Put_Line ("</h1>");
      Put ("<p class=""practice"">");
      T (Practice);
      Put_Line ("</p>");
      Put ("<p class=""services-line"">");
      T (Services_Line);
      Put_Line ("</p>");
      Tel_Line;
      Put_Line ("</header>");

      Put_Line ("<nav>");
      Put ("<span class=""visually-hidden"">");
      T (Nav_Label);
      Put_Line ("</span>");
      Put ("<a class=""nav-a"" href=""#" & Id_About & """>");
      T (Nav_About);
      Put_Line ("</a>");
      Put ("<a class=""nav-a"" href=""#" & Id_Offer & """>");
      T (Nav_Offer);
      Put_Line ("</a>");
      Put ("<a class=""nav-a"" href=""#" & Id_Contact & """>");
      T (Nav_Contact);
      Put_Line ("</a>");
      Put_Line ("</nav>");
      Draw.Rule;

      Put_Line ("<main>");
      Put_Line ("<section id=""" & Id_About & """>");
      Put ("<h2>");
      T (About_Title);
      Put_Line ("</h2>");
      Put_Line ("<div class=""about-grid"">");
      Figure (Draw.Lemon_Tree'Access, Aria_Lemon);
      Put_Line ("<div>");
      Placeholder (About_Body);
      Put_Line ("</div></div></section>");

      Put_Line ("<section id=""" & Id_Offer & """>");
      Put ("<h2>");
      T (Services_Title);
      Put_Line ("</h2>");
      Placeholder (Services_Intro);
      Put_Line ("<div class=""cards"">");
      Put_Line ("<article class=""card"">");
      Put ("<h3>");
      T (Healing_Title);
      Put_Line ("</h3>");
      Placeholder (Healing_Body);
      Put_Line ("</article>");
      Put_Line ("<article class=""card"">");
      Put ("<h3>");
      T (Attach_Title);
      Put_Line ("</h3>");
      Placeholder (Attach_Body);
      Put_Line ("</article></div>");
      Figure (Draw.Birds'Access, Aria_Birds);
      Put_Line ("</section>");

      Put_Line ("<section id=""" & Id_Contact & """>");
      Put ("<h2>");
      T (Contact_Title);
      Put_Line ("</h2>");
      Put_Line ("<div class=""contact-grid"">");
      Put_Line ("<div>");
      Placeholder (Contact_Body);
      Tel_Line (" call");
      Put_Line ("</div>");
      Figure (Draw.Vase'Access, Aria_Vase);
      Put_Line ("</div></section>");
      Put_Line ("</main>");

      Put_Line ("<footer>");
      Draw.Rule;
      Figure (Draw.Casa'Access, Aria_Casa);
      Put_Line ("</footer>");
      Put_Line ("</div></div>");

      Put_Line ("<audio id=""" & Id_Splash_Audio &
                """ loop preload=""none"" src=""" & Src_Splash &
                """ aria-hidden=""true""></audio>");
      Put_Line ("<audio id=""" & Id_Page_Audio &
                """ loop preload=""none"" src=""" & Src_Page &
                """ aria-hidden=""true""></audio>");
      Runtime.Emit;
      Put_Line ("</body>");
      Put_Line ("</html>");
   end Emit;

end Page;
