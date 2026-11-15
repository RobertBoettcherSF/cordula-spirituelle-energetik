with Ada.Numerics;
with Ada.Strings.Wide_Wide_Unbounded;

with Output;
with Palette;
with Tuning;
with Translations;

package body Style is

   use Output;
   use Palette;
   use Tuning;
   use Translations;

   procedure Css (S : String) is
   begin
      Put_Line (S);
   end Css;

   procedure Placeholder_Css is
      package WWU renames Ada.Strings.Wide_Wide_Unbounded;

      function Esc (S : Wide_Wide_String) return Wide_Wide_String is
         R : WWU.Unbounded_Wide_Wide_String;
      begin
         for C of S loop
            if C = '"' or else C = '\' then
               WWU.Append (R, (1 => '\'));
            end if;
            WWU.Append (R, (1 => C));
         end loop;
         return WWU.To_Wide_Wide_String (R);
      end Esc;

      procedure Content (Index : Positive) is
      begin
         Put (" content: """);
         Put_W (" · " & Esc (Phrase_Text (Index, Placeholder_Mark)));
         Put ("""");
      end Content;
   begin
      Put ("  .ph::after {");
      Content (Default_Index);
      Css (" ; font-size: .72em; letter-spacing: .04em; color: " &
           Placeholder & "; }");
      for Index in 1 .. Lang_Count loop
         if Index /= Default_Index then
            Put ("  body:has(#lang-" & Code (Index) &
                 ":checked) .ph::after {");
            Content (Index);
            Css ("; }");
         end if;
      end loop;
   end Placeholder_Css;

   procedure Language_Css is
   begin
      Css ("  .t { display: none; }");
      Css ("  .t-" & Code (Default_Index) & " { display: inline; }");
      for Index in 1 .. Lang_Count loop
         if Index /= Default_Index then
            Css ("  body:has(#lang-" & Code (Index) &
                 ":checked) .t { display: none; }");
            Css ("  body:has(#lang-" & Code (Index) &
                 ":checked) .t-" & Code (Index) & " { display: inline; }");
         end if;
      end loop;
   end Language_Css;

   procedure Emit is
      Hold : constant String := F (Splash_Hold) & "s";
      Fade : constant String := F (Splash_Fade) & "s";
      Skip : constant String := F (Skip_Fade) & "s";
      Deg  : constant String :=
        F (Gecko_Start_Head * 180.0 / Ada.Numerics.Pi, 1);
   begin
      Css ("<style>");
      Css ("*, *::before, *::after { box-sizing: border-box; }");
      Css ("html { scroll-behavior: smooth; }");
      Css ("body {");
      Css ("  margin: 0; min-height: 100vh; color: " & Ink & ";");
      Css ("  background-color: " & Wall & ";");
      Css ("  background-image:");
      Css ("    radial-gradient(ellipse at 15% 0%, " & Wall_Lite & ", transparent 48%),");
      Css ("    radial-gradient(ellipse at 100% 85%, " & Wall_Deep & ", transparent 40%);");
      Css ("  font-family: ""Iowan Old Style"", Palatino, ""Palatino Linotype"", ""Book Antiqua"", Georgia, ""Times New Roman"", serif;");
      Css ("  font-size: 1.0625rem; line-height: 1.6;");
      Css ("}");
      Css ("img, svg { max-width: 100%; }");
      Css ("a { color: " & Cobalt & "; }");
      Css ("a:hover { color: " & Bordeaux_Deep & "; }");
      Css ("::selection { background: " & Mustard & "; color: " & Navy & "; }");
      Css ("audio { display: none; }");
      Language_Css;
      Placeholder_Css;

      Css ("  .visually-hidden {");
      Css ("    position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px;");
      Css ("    overflow: hidden; clip: rect(0 0 0 0); clip-path: inset(50%);");
      Css ("    white-space: nowrap; border: 0;");
      Css ("  }");
      Css ("  .skip-input {");
      Css ("    position: absolute; width: 1px; height: 1px; margin: -1px; padding: 0;");
      Css ("    overflow: hidden; clip: rect(0 0 0 0); clip-path: inset(50%); border: 0;");
      Css ("  }");

      Css ("  .plaster {");
      Css ("    position: fixed; inset: 0; width: 100%; height: 100%;");
      Css ("    pointer-events: none; z-index: 0; mix-blend-mode: multiply;");
      Css ("    opacity: " & F (Plaster_Opacity) & ";");
      Css ("  }");

      Css ("  .tools {");
      Css ("    position: fixed; z-index: 60; top: .6rem; right: .6rem;");
      Css ("    display: flex; align-items: center; gap: .3rem;");
      Css ("    padding: .2rem .35rem .2rem .4rem;");
      Css ("    background: " & Cream & ";");
      Css ("    border: 1px solid " & Navy & "; border-radius: 999px;");
      Css ("    box-shadow: 0 6px 16px rgba(60, 30, 10, .14);");
      Css ("  }");
      Css ("  .flag { position: relative; display: inline-flex; padding: 2px; border-radius: 3px; cursor: pointer; line-height: 0; }");
      Css ("  .flag input { position: absolute; inset: 0; opacity: 0; margin: 0; cursor: pointer; }");
      Css ("  .flag-svg { width: 28px; height: 18px; display: block; border-radius: 2px; box-shadow: 0 0 0 1px rgba(22,35,63,.25); }");
      Css ("  .flag:has(input:checked) { box-shadow: 0 0 0 2px " & Navy & "; }");
      Css ("  .flag:focus-within { outline: 2px solid " & Navy & "; outline-offset: 2px; }");
      Css ("  .sound {");
      Css ("    border: 0; background: transparent; color: " & Navy & ";");
      Css ("    display: inline-flex; align-items: center; gap: .28rem;");
      Css ("    min-height: 44px; padding: .3rem .55rem; cursor: pointer;");
      Css ("    font: inherit; letter-spacing: .04em;");
      Css ("  }");
      Css ("  .sound:focus-visible { outline: 2px solid " & Navy & "; outline-offset: 2px; }");
      Css ("  .speaker { width: 18px; height: 18px; display: block; }");
      Css ("  .sound .when-on, .sound .when-off { display: none; }");
      Css ("  .sound." & Cls_On & " .when-idle { display: none; }");
      Css ("  .sound." & Cls_On & " .when-on { display: inline; }");
      Css ("  .sound." & Cls_Muted & " .when-idle,");
      Css ("  .sound." & Cls_Muted & " .when-on { display: none; }");
      Css ("  .sound." & Cls_Muted & " .when-off { display: inline; }");

      Css ("  .splash {");
      Css ("    position: fixed; inset: 0; z-index: 40;");
      Css ("    display: flex; flex-direction: column; align-items: center; justify-content: center;");
      Css ("    text-align: center; color: " & Navy & ";");
      Css ("    padding: 4.6rem 1.15rem 5.6rem;");
      Css ("    background:");
      Css ("      radial-gradient(120% 72% at 50% 0%, " & Sheen & ", transparent 54%),");
      Css ("      linear-gradient(165deg, " & Mustard_Lite & " 0%, " & Mustard & " 46%, " & Mustard_Deep & " 100%);");
      Css ("    animation: " & Anim_Hold & " " & Hold & " linear forwards, " &
           Anim_Fade & " " & Fade & " ease " & Hold & " forwards;");
      Css ("  }");
      Css ("  .splash::before, .splash::after {");
      Css ("    content: """"; position: absolute; pointer-events: none; border: 1px solid " & Navy & ";");
      Css ("  }");
      Css ("  .splash::before { inset: .7rem; opacity: .5; }");
      Css ("  .splash::after { inset: .98rem; opacity: .32; }");
      Css ("  .splash h1 {");
      Css ("    font-weight: 500; line-height: 1.05; letter-spacing: .015em;");
      Css ("    font-size: clamp(2.15rem, 6vw, 3.55rem); margin: .15rem 0 .1rem;");
      Css ("  }");
      Css ("  .splash .practice { margin: 0; letter-spacing: .09em; font-size: clamp(1.12rem, 2.6vw, 1.5rem); }");
      Css ("  .splash .services-line { margin: .85rem 0 .2rem; letter-spacing: .04em; }");
      Css ("  .splash .tel-line { margin: .15rem 0 0; }");
      Css ("  .splash a { color: inherit; }");
      Css ("  .hairline { width: 4.5rem; height: 1px; margin: .75rem auto; border: 0; background: " & Navy & "; opacity: .4; }");
      Css ("  .infty.mark { width: min(78vw, 300px); height: auto; }");
      Css ("  .infty.head { width: min(64vw, 220px); max-width: 100%; height: auto; }");
      Css ("  ." & Cls_Static & " { display: none; }");
      Css ("  .skip {");
      Css ("    position: absolute; left: 50%; bottom: max(1rem, env(safe-area-inset-bottom));");
      Css ("    transform: translateX(-50%);");
      Css ("    color: " & Navy & "; background: " & Sheen & ";");
      Css ("    border: 1px solid " & Navy & ";");
      Css ("    padding: .55rem 1.1rem; min-height: 44px;");
      Css ("    display: inline-flex; align-items: center; justify-content: center;");
      Css ("    letter-spacing: .08em; cursor: pointer; font: inherit;");
      Css ("  }");
      Css ("  .skip-input:focus-visible ~ .splash .skip { outline: 2px solid " & Navy & "; outline-offset: 4px; }");

      Css ("  .page {");
      Css ("    position: relative; z-index: 1; opacity: 0; visibility: hidden;");
      Css ("    animation: " & Anim_Page & " " & Fade & " ease " & Hold & " forwards;");
      Css ("  }");
      Css ("  #" & Id_Skip & ":checked ~ .splash {");
      Css ("    animation: " & Anim_Away & " " & Skip & " ease forwards;");
      Css ("  }");
      Css ("  #" & Id_Skip & ":checked ~ .page {");
      Css ("    visibility: visible;");
      Css ("    animation: " & Anim_Page & " " & Skip & " ease forwards;");
      Css ("  }");
      Css ("  @keyframes " & Anim_Hold & " {");
      Css ("    from { opacity: 1; visibility: visible; }");
      Css ("    to { opacity: 1; visibility: visible; }");
      Css ("  }");
      Css ("  @keyframes " & Anim_Fade & " {");
      Css ("    from { opacity: 1; visibility: visible; }");
      Css ("    to { opacity: 0; visibility: hidden; pointer-events: none; }");
      Css ("  }");
      Css ("  @keyframes " & Anim_Away & " {");
      Css ("    from { opacity: 1; visibility: visible; }");
      Css ("    to { opacity: 0; visibility: hidden; pointer-events: none; }");
      Css ("  }");
      Css ("  @keyframes " & Anim_Page & " {");
      Css ("    from { opacity: 0; visibility: visible; }");
      Css ("    to { opacity: 1; visibility: visible; }");
      Css ("  }");

      Css ("  .sun {");
      Css ("    position: fixed; top: .75rem; left: .75rem; z-index: 5;");
      Css ("    width: clamp(88px, 15vw, 156px); height: auto;");
      Css ("    pointer-events: none; opacity: .94;");
      Css ("  }");
      Css ("  .gecko {");
      Css ("    position: fixed; left: 0; top: 0; z-index: 6; pointer-events: none;");
      Css ("    width: " & I (Integer (Gecko_Css_W)) & "px; height: auto; overflow: visible;");
      Css ("    transform-origin: 50% 50%;");
      Css ("    transform: translate(" & I (Integer (Gecko_Start_X)) & "px, calc(100vh - " &
           I (Integer (Gecko_From_Bottom)) & "px)) rotate(" & Deg & "deg);");
      Css ("    filter: drop-shadow(0 2px 1px rgba(58, 40, 16, .3));");
      Css ("  }");

      Css ("  .panel {");
      Css ("    position: relative; z-index: 3; overflow: hidden;");
      Css ("    max-width: 42rem; margin: 4.7rem auto 2.2rem;");
      Css ("    padding: 1.55rem 1.2rem 1.3rem;");
      Css ("    background: " & Cream & ";");
      Css ("    border: 3px solid " & Mustard & ";");
      Css ("    border-radius: 190px 190px 12px 12px;");
      Css ("    box-shadow: 0 0 0 7px " & Cream & ", 0 0 0 10px " & Cobalt &
           ", 0 18px 36px rgba(80, 40, 20, .16);");
      Css ("  }");
      Css ("  .plaque {");
      Css ("    text-align: center; color: " & Navy & ";");
      Css ("    width: min(24rem, calc(100% - 5.5rem));");
      Css ("    margin: 1.75rem auto .35rem;");
      Css ("    padding: .85rem .8rem 1rem;");
      Css ("    background:");
      Css ("      radial-gradient(120% 80% at 50% 0%, " & Sheen & ", transparent 56%),");
      Css ("      linear-gradient(165deg, " & Mustard_Lite & ", " & Mustard & " 58%, " & Mustard_Deep & ");");
      Css ("    border: 1px solid " & Mustard_Deep & ";");
      Css ("    box-shadow: inset 0 1px 0 rgba(255, 255, 255, .55), 0 10px 18px rgba(80, 40, 10, .1);");
      Css ("  }");
      Css ("  .plaque h1 {");
      Css ("    font-weight: 500; line-height: 1.08; margin: .05rem 0;");
      Css ("    font-size: clamp(2rem, 5vw, 2.85rem);");
      Css ("  }");
      Css ("  .plaque .practice { margin: 0; letter-spacing: .08em; font-size: 1.12rem; }");
      Css ("  .plaque .services-line { margin: .55rem 0 .15rem; }");
      Css ("  .plaque a, .splash a { color: inherit; text-underline-offset: .15em; }");

      Css ("  nav { display: flex; flex-wrap: wrap; justify-content: center; gap: .35rem 1.15rem; margin: 1rem 0 .2rem; }");
      Css ("  .nav-a {");
      Css ("    color: " & Navy & "; text-decoration: none; letter-spacing: .06em;");
      Css ("    padding: .4rem .15rem; border-bottom: 1px solid transparent; min-height: 44px;");
      Css ("    display: inline-flex; align-items: center;");
      Css ("  }");
      Css ("  .nav-a:hover { color: " & Bordeaux & "; border-bottom-color: " & Bordeaux & "; }");
      Css ("  .panel:has(#" & Id_About & ":target) a[href=""#" & Id_About & """],");
      Css ("  .panel:has(#" & Id_Offer & ":target) a[href=""#" & Id_Offer & """],");
      Css ("  .panel:has(#" & Id_Contact & ":target) a[href=""#" & Id_Contact & """] {");
      Css ("    color: " & Bordeaux & "; border-bottom-color: " & Bordeaux & ";");
      Css ("  }");
      Css ("  .azulejo-rule { width: 100%; height: 26px; display: block; margin: .15rem 0 .35rem; }");

      Css ("  main { padding: 0 .15rem; }");
      Css ("  section { scroll-margin-top: 4.5rem; padding: .55rem 0 .2rem; }");
      Css ("  h2 { font-weight: 500; font-size: 1.55rem; letter-spacing: .03em; margin: .15rem 0 .4rem; color: " & Navy & "; }");
      Css ("  h3 { font-weight: 500; letter-spacing: .04em; margin: 0 0 .35rem; color: " & Bordeaux & "; }");
      Css ("  p { margin: .35rem 0 .55rem; }");

      Css ("  .about-grid, .contact-grid { display: grid; gap: 1rem; align-items: center; }");
      Css ("  .tile { width: 100%; height: auto; display: block; }");
      Css ("  .cards { display: grid; gap: .75rem; }");
      Css ("  .card {");
      Css ("    border: 2px solid " & Cobalt & "; background: " & Cream & ";");
      Css ("    padding: .8rem .85rem .95rem;");
      Css ("    box-shadow: inset 0 0 0 4px " & Cream & ", inset 0 0 0 6px " & Cobalt_Wash & ";");
      Css ("  }");
      Css ("  .call { font-size: clamp(1.35rem, 2.6vw, 1.75rem); margin: .35rem 0 .2rem; }");
      Css ("  .call a, a.tel { color: " & Cobalt & "; white-space: nowrap; }");
      Css ("  .plaque a.tel, .splash a.tel { color: inherit; }");
      Css ("  footer { text-align: center; padding: .2rem 0 .4rem; }");
      Css ("  .casa { width: min(100%, 280px); height: auto; margin: 0 auto; display: block; }");
      Css ("  figcaption.visually-hidden { position: absolute; }");

      Css ("  @media (min-width: 760px) {");
      Css ("    .about-grid { grid-template-columns: .78fr 1.22fr; }");
      Css ("    .contact-grid { grid-template-columns: 1.15fr .85fr; }");
      Css ("    .cards { grid-template-columns: 1fr 1fr; }");
      Css ("    .panel { padding: 1.8rem 1.7rem 1.5rem; }");
      Css ("  }");
      Css ("  @media (max-width: 640px) {");
      Css ("    .panel { margin: 4.3rem .45rem 1.2rem; border-radius: 120px 120px 10px 10px; padding: 1.15rem .75rem 1rem; }");
      Css ("    .plaque { width: min(24rem, calc(100% - 3.2rem)); margin-top: 1.35rem; }");
      Css ("    .gecko { width: 104px; }");
      Css ("    .tools { top: .4rem; right: .4rem; }");
      Css ("  }");

      Css ("  @media (prefers-reduced-motion: reduce) {");
      Css ("    html { scroll-behavior: auto; }");
      Css ("    .splash, #" & Id_Skip & ":checked ~ .splash { display: none; }");
      Css ("    .page, #" & Id_Skip & ":checked ~ .page {");
      Css ("      opacity: 1; visibility: visible; animation: none;");
      Css ("    }");
      Css ("    ." & Cls_Motion & " { display: none; }");
      Css ("    ." & Cls_Static & " { display: block; }");
      Css ("    .gecko { display: none; }");
      Css ("    .flag:hover { transform: none; }");
      Css ("  }");
      Css ("</style>");
   end Emit;

end Style;
