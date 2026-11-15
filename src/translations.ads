--  Sprachen.
--
--  Eine Sprache hinzufügen heißt: in translations.adb eine Funktion
--  Text_XX mit vollständiger case-Anweisung schreiben und genau eine
--  Zeile in Catalog ergänzen. Radios, CSS und Texte entstehen daraus.
--  Deutsch ist die erste Zeile und damit die Voreinstellung.
package Translations is

   type Phrase is
     (About_Body,
      About_Title,
      Aria_Birds,
      Aria_Casa,
      Aria_Lemon,
      Aria_Sun,
      Aria_Vase,
      Attach_Body,
      Attach_Title,
      Contact_Body,
      Contact_Title,
      Doc_Title,
      Healing_Body,
      Healing_Title,
      Meta_Description,
      Name,
      Nav_About,
      Nav_Contact,
      Nav_Label,
      Nav_Offer,
      Placeholder_Mark,
      Practice,
      Services_Intro,
      Services_Line,
      Services_Title,
      Skip_Label,
      Sound_Idle,
      Sound_Mute,
      Sound_Unmute,
      Tel_Label,
      Tel_Note);

   function Lang_Count return Positive;
   function Code (Index : Positive) return String;
   function Endonym (Index : Positive) return Wide_Wide_String;
   function Phrase_Text
     (Index : Positive; Id : Phrase) return Wide_Wide_String;

   Default_Index : constant Positive := 1;

end Translations;
