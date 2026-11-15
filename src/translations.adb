package body Translations is

   type Translator is
     access function (Id : Phrase) return Wide_Wide_String;

   type Name_Ptr is access constant Wide_Wide_String;

   type Language is record
      Code : String (1 .. 2);
      Name : Name_Ptr;
      Text : Translator;
   end record;

   DE_Name : aliased constant Wide_Wide_String := "Deutsch";
   EN_Name : aliased constant Wide_Wide_String := "English";

   --  Schildtexte auf Deutsch stehen hier wortgetreu.
   --  PLACEHOLDER-Zeilen ersetzt Cordula durch eigene Formulierungen.
   function Text_DE (Id : Phrase) return Wide_Wide_String is
   begin
      case Id is
         when About_Body =>
            --  PLACEHOLDER
            return "Cordula Dobos bietet spirituelle Energetik in ruhiger, " &
              "achtsamer Atmosphäre. Diese Sätze sind ein Platzhalter und " &
              "werden von ihr selbst ersetzt.";
         when About_Title =>
            return "Über mich";
         when Aria_Birds =>
            return "Vögel auf blauen Zweigen, wie auf den Hauskacheln";
         when Aria_Casa =>
            return "Hausschild CASA DOBOS Nº10";
         when Aria_Lemon =>
            return "Zitronenbaum mit weißen Tauben, wie auf den Hauskacheln";
         when Aria_Sun =>
            return "Schmiedeeiserne Sonne";
         when Aria_Vase =>
            return "Blumenvase im Talavera-Stil";
         when Attach_Body =>
            --  PLACEHOLDER
            return "Behutsame Begleitung, wenn sich etwas belastend oder " &
              "fremd anfühlt. Die eigenen Worte von Cordula folgen hier.";
         when Attach_Title =>
            return "Besetzungen";
         when Contact_Body =>
            --  PLACEHOLDER
            return "Für eine Terminvereinbarung genügt ein Anruf. Weitere " &
              "Hinweise trägt Cordula hier ein.";
         when Contact_Title =>
            return "Kontakt";
         when Doc_Title =>
            return "Cordula Dobos · Spirituelle Energetik";
         when Healing_Body =>
            --  PLACEHOLDER
            return "Ein stiller Raum für energetische Heilbegleitung. " &
              "Cordula beschreibt hier selbst, was Menschen erwartet.";
         when Healing_Title =>
            return "Heilungen";
         when Meta_Description =>
            return "Cordula Dobos, Spirituelle Energetik. Heilungen und " &
              "Besetzungen. Tel. Vereinbarung: 0871 / 14230600.";
         when Name =>
            return "Cordula Dobos";
         when Nav_About =>
            return "Über mich";
         when Nav_Contact =>
            return "Kontakt";
         when Nav_Label =>
            return "Seitenabschnitte";
         when Nav_Offer =>
            return "Angebot";
         when Placeholder_Mark =>
            return "Entwurf";
         when Practice =>
            return "Spirituelle Energetik";
         when Services_Intro =>
            --  PLACEHOLDER
            return "Zwei Wege, wie Cordula begleitet. Die Beschreibungen " &
              "sind ein Platzhalter.";
         when Services_Line =>
            return "· Heilungen · Besetzungen";
         when Services_Title =>
            return "Angebot";
         when Skip_Label =>
            return "Überspringen / Skip";
         when Sound_Idle =>
            return "Klang";
         when Sound_Mute =>
            return "Ton aus";
         when Sound_Unmute =>
            return "Ton an";
         when Tel_Label =>
            return "Tel. Vereinbarung: ";
         when Tel_Note =>
            return " (AB)";
      end case;
   end Text_DE;

   function Text_EN (Id : Phrase) return Wide_Wide_String is
   begin
      case Id is
         when About_Body =>
            --  PLACEHOLDER
            return "Cordula Dobos offers spiritual energetics in a quiet, " &
              "attentive atmosphere. These sentences are a placeholder and " &
              "will be replaced by her own words.";
         when About_Title =>
            return "About";
         when Aria_Birds =>
            return "Birds on blue branches, like the tiles on the house";
         when Aria_Casa =>
            return "House sign CASA DOBOS Nº10";
         when Aria_Lemon =>
            return "Lemon tree with white doves, like the tiles on the house";
         when Aria_Sun =>
            return "Wrought-iron sun";
         when Aria_Vase =>
            return "Flower vase in the Talavera style";
         when Attach_Body =>
            --  PLACEHOLDER
            return "Gentle company when something feels heavy or unfamiliar. " &
              "Cordula's own words will follow here.";
         when Attach_Title =>
            return "Attachments";
         when Contact_Body =>
            --  PLACEHOLDER
            return "A phone call is enough to arrange a time. Cordula will " &
              "add any further notes here.";
         when Contact_Title =>
            return "Contact";
         when Doc_Title =>
            return "Cordula Dobos · Spiritual Energetics";
         when Healing_Body =>
            --  PLACEHOLDER
            return "A quiet space for energetic support. Cordula will " &
              "describe in her own words what to expect.";
         when Healing_Title =>
            return "Healings";
         when Meta_Description =>
            return "Cordula Dobos, spiritual energetics. Healings and " &
              "attachments. Telephone by appointment: 0871 / 14230600.";
         when Name =>
            return "Cordula Dobos";
         when Nav_About =>
            return "About";
         when Nav_Contact =>
            return "Contact";
         when Nav_Label =>
            return "Sections";
         when Nav_Offer =>
            return "Offerings";
         when Placeholder_Mark =>
            return "draft";
         when Practice =>
            return "Spiritual Energetics";
         when Services_Intro =>
            --  PLACEHOLDER
            return "Two ways Cordula accompanies people. The descriptions " &
              "are placeholders.";
         when Services_Line =>
            return "· Healings · Attachments";
         when Services_Title =>
            return "Offerings";
         when Skip_Label =>
            return "Überspringen / Skip";
         when Sound_Idle =>
            return "Sound";
         when Sound_Mute =>
            return "Mute";
         when Sound_Unmute =>
            return "Unmute";
         when Tel_Label =>
            return "Tel. by appointment: ";
         when Tel_Note =>
            return " (voicemail)";
      end case;
   end Text_EN;

   Catalog : constant array (1 .. 2) of Language :=
     (1 => (Code => "de", Name => DE_Name'Access, Text => Text_DE'Access),
      2 => (Code => "en", Name => EN_Name'Access, Text => Text_EN'Access));

   function Lang_Count return Positive is (Catalog'Length);

   function Code (Index : Positive) return String is
     (Catalog (Index).Code);

   function Endonym (Index : Positive) return Wide_Wide_String is
     (Catalog (Index).Name.all);

   function Phrase_Text
     (Index : Positive; Id : Phrase) return Wide_Wide_String is
     (Catalog (Index).Text.all (Id));

end Translations;
