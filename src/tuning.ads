--  Alle Zeiten, Ton- und Gecko-Konstanten. Das Laufzeit-Skript liest sie
--  als CFG; CSS-Animationen werden aus denselben Werten erzeugt.
--
--  Splash: eine Lemniskaten-Runde dauert Splash_Hold Sekunden, danach
--  blendet Splash_Fade die Seite ein. 53.2 s ist 30 % schneller als 76 s.
package Tuning is

   Splash_Hold   : constant Float := 53.2;
   Splash_Fade   : constant Float := 2.24;
   Header_Orbit  : constant Float := 50.0;
   Skip_Fade     : constant Float := 1.0;

   Volume        : constant Float := 0.25;
   Crossfade_Ms  : constant Float := 2400.0;
   Fade_In_Ms    : constant Float := 900.0;

   Anim_Hold : constant String := "splash-hold";
   Anim_Fade : constant String := "splash-fade";
   Anim_Away : constant String := "splash-away";
   Anim_Page : constant String := "page-in";

   Id_Splash       : constant String := "splash";
   Id_Skip         : constant String := "skip";
   Id_Sound        : constant String := "sound";
   Id_Splash_Audio : constant String := "audio-splash";
   Id_Page_Audio   : constant String := "audio-seite";
   Id_Gecko        : constant String := "gecko";
   Id_Page         : constant String := "seite";
   Id_About        : constant String := "ueber";
   Id_Offer        : constant String := "angebot";
   Id_Contact      : constant String := "kontakt";

   Cls_On     : constant String := "is-on";
   Cls_Muted  : constant String := "is-muted";
   Cls_Motion : constant String := "motion-dot";
   Cls_Static : constant String := "static-dot";
   Cls_Tail   : constant String := "gecko-tail";
   Cls_Body   : constant String := "gecko-body";
   Cls_Leg    : constant String := "leg";

   Src_Splash : constant String := "audio/splash.mp3";
   Src_Page   : constant String := "audio/seite.mp3";

   Tel_Href    : constant String := "tel:+4987114230600";
   Tel_Display : constant String := "0871 / 14230600";

   --  Klangschale: Grundton je Ziel, gemeinsame Partialtöne und Hüllkurve.
   type Chime is record
      Selector : access constant String;
      Hertz    : Float;
   end record;

   Sel_Nav  : aliased constant String := "a.nav-a";
   Sel_Flag : aliased constant String := "label.flag";
   Sel_Tel  : aliased constant String := "a.tel";
   Sel_Skip : aliased constant String := ".skip";

   Chime_Map : constant array (1 .. 4) of Chime :=
     ((Sel_Nav'Access, 494.0),
      (Sel_Flag'Access, 392.0),
      (Sel_Tel'Access, 330.0),
      (Sel_Skip'Access, 440.0));

   Chime_Partials : constant array (1 .. 3) of Float := (1.0, 2.0, 2.76);
   Chime_Peak     : constant Float := 0.012;
   Chime_Floor    : constant Float := 0.00008;
   Chime_Attack   : constant Float := 0.02;
   Chime_Release  : constant Float := 2.1;
   Chime_Tail     : constant Float := 0.15;

   Rustle_Dur  : constant Float := 0.09;
   Rustle_Freq : constant Float := 1600.0;
   Rustle_Q    : constant Float := 0.7;
   Rustle_Gain : constant Float := 0.012;

   --  Gecko: Wanderung mit sanfter Anziehung, kein direkter Lauf zum Zeiger.
   --  wanderAmp ist die Spitze der Winkelgeschwindigkeit (rad/s).
   --  seekTurn * pull ist die zusätzliche Drehung zum Ziel (rad/s).
   Gecko_Cruise     : constant Float := 42.0;
   Gecko_Dart       : constant Float := 138.0;
   Gecko_Wander_Freq : constant Float := 0.72;
   Gecko_Wander_Amp : constant Float := 0.95;
   Gecko_Seek_Turn  : constant Float := 0.85;
   Gecko_Dart_Turn  : constant Float := 1.15;
   Gecko_Pull_Far   : constant Float := 0.50;
   Gecko_Pull_Near  : constant Float := 0.28;
   Gecko_Pull_Dist  : constant Float := 340.0;
   Gecko_Orbit_Dist : constant Float := 200.0;
   Gecko_Orbit_Flip : constant Float := 0.045;
   Gecko_Pause_Rate : constant Float := 0.042;
   Gecko_Pause_Min  : constant Float := 800.0;
   Gecko_Pause_Max  : constant Float := 2300.0;
   Gecko_Dart_Rate  : constant Float := 0.11;
   Gecko_Dart_Min   : constant Float := 260.0;
   Gecko_Dart_Max   : constant Float := 480.0;
   Gecko_Leg_Amp    : constant Float := 18.0;
   Gecko_Leg_Slow   : constant Float := 8.2;
   Gecko_Leg_Fast   : constant Float := 15.5;
   Gecko_Tail_Amp   : constant Float := 11.0;
   Gecko_Tail_Rest  : constant Float := 2.4;
   Gecko_Tail_Freq  : constant Float := 0.82;
   Gecko_Body_Amp   : constant Float := 2.5;
   Gecko_Body_Rest  : constant Float := 0.7;
   Gecko_Margin     : constant Float := 6.0;
   Gecko_Start_X    : constant Float := 18.0;
   Gecko_From_Bottom : constant Float := 120.0;
   Gecko_Start_Head : constant Float := -0.15;
   Gecko_Max_Dt     : constant Float := 0.05;
   Gecko_Css_W      : constant Float := 132.0;
   Gecko_Css_H      : constant Float := 63.0;
   Gecko_Tap_Hold   : constant Float := 3400.0;
   Gecko_Tap_Dart   : constant Float := 460.0;
   Gecko_Rustle_Gap : constant Float := 2600.0;
   Gecko_Tap_Rustle : constant Float := 700.0;
   Gecko_Avoid_X    : constant Float := 78.0;
   Gecko_Avoid_Y    : constant Float := 32.0;
   Gecko_Avoid_R    : constant Float := 120.0;
   Gecko_Avoid_Turn : constant Float := 2.4;

   Plaster_Freq    : constant Float := 0.72;
   Plaster_Octaves : constant := 4;
   Plaster_Opacity : constant Float := 0.38;

   Infinity_Samples : constant := 120;
   Dot_Splash       : constant Float := 4.6;
   Dot_Header       : constant Float := 3.3;

   Gecko_Orbit_Side : constant Float := 0.5;
   Gecko_Move_Eps   : constant Float := 1.0;

end Tuning;
