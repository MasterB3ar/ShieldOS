{ config, lib, pkgs, ... }:

let
  # ShieldOS 0.3.3 identity package.
  # Important: this file intentionally generates its own SVG assets inline.
  # That prevents Nix flakes from failing when assets are uploaded but not tracked
  # by git, which caused: Path 'assets/identity/shieldos-wallpaper.svg' does not exist.
  shieldosIdentity = pkgs.stdenvNoCC.mkDerivation {
    name = "shieldos-identity-0.3.3";
    dontUnpack = true;
    installPhase = ''
      set -eu

      mkdir -p $out/share/wallpapers/ShieldOS/contents/images
      cat > $out/share/wallpapers/ShieldOS/contents/images/1920x1080.svg <<'EOF'
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1920 1080">
        <defs>
          <linearGradient id="sky" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0" stop-color="#020611"/>
            <stop offset="0.44" stop-color="#061a36"/>
            <stop offset="1" stop-color="#02030a"/>
          </linearGradient>
          <radialGradient id="glow" cx="50%" cy="35%" r="45%">
            <stop offset="0" stop-color="#22d3ee" stop-opacity="0.42"/>
            <stop offset="0.45" stop-color="#1e3a8a" stop-opacity="0.16"/>
            <stop offset="1" stop-color="#000000" stop-opacity="0"/>
          </radialGradient>
          <linearGradient id="aurora" x1="0" y1="0" x2="1" y2="0">
            <stop offset="0" stop-color="#22d3ee" stop-opacity="0"/>
            <stop offset="0.25" stop-color="#22d3ee" stop-opacity="0.58"/>
            <stop offset="0.55" stop-color="#38bdf8" stop-opacity="0.35"/>
            <stop offset="1" stop-color="#22d3ee" stop-opacity="0"/>
          </linearGradient>
          <linearGradient id="shield" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0" stop-color="#22d3ee"/>
            <stop offset="1" stop-color="#1e3a8a"/>
          </linearGradient>
          <filter id="blur"><feGaussianBlur stdDeviation="18"/></filter>
        </defs>
        <rect width="1920" height="1080" fill="url(#sky)"/>
        <rect width="1920" height="1080" fill="url(#glow)"/>
        <path d="M350 250 C700 90 850 360 1120 170 C1320 30 1500 180 1650 70" stroke="url(#aurora)" stroke-width="80" fill="none" opacity="0.58" filter="url(#blur)"/>
        <path d="M460 380 C720 160 950 430 1270 230 C1480 100 1600 250 1780 145" stroke="#22d3ee" stroke-width="18" fill="none" opacity="0.26" filter="url(#blur)"/>
        <path d="M0 760 L260 520 L470 710 L710 450 L930 750 L1120 540 L1370 780 L1600 560 L1920 760 L1920 1080 L0 1080 Z" fill="#06101f" opacity="0.94"/>
        <path d="M0 820 L310 650 L570 820 L820 660 L1100 840 L1370 690 L1630 830 L1920 700 L1920 1080 L0 1080 Z" fill="#020611" opacity="0.86"/>
        <rect y="770" width="1920" height="310" fill="#020611" opacity="0.46"/>
        <path d="M0 900 C300 850 470 920 690 880 C940 835 1130 905 1370 860 C1600 820 1740 870 1920 845 L1920 1080 L0 1080 Z" fill="#0b2a4c" opacity="0.35"/>
        <g transform="translate(810 260) scale(1.5)" opacity="0.13">
          <path d="M100 0 L205 38 L190 185 C181 270 129 324 100 342 C71 324 19 270 10 185 L-5 38 Z" fill="none" stroke="url(#shield)" stroke-width="20"/>
          <path d="M100 40 L160 62 L149 180 C143 234 117 270 100 286 C83 270 57 234 51 180 L40 62 Z" fill="url(#shield)" opacity="0.55"/>
        </g>
        <g opacity="0.25">
          <circle cx="220" cy="180" r="2" fill="#e6edf3"/><circle cx="600" cy="110" r="1.5" fill="#e6edf3"/>
          <circle cx="900" cy="160" r="2" fill="#e6edf3"/><circle cx="1230" cy="100" r="1.5" fill="#e6edf3"/>
          <circle cx="1480" cy="210" r="2" fill="#e6edf3"/><circle cx="1720" cy="130" r="1.6" fill="#e6edf3"/>
        </g>
      </svg>
      EOF
      cp $out/share/wallpapers/ShieldOS/contents/images/1920x1080.svg $out/share/wallpapers/ShieldOS/contents/images/2560x1440.svg
      cat > $out/share/wallpapers/ShieldOS/metadata.json <<'EOF'
      {
        "KPlugin": {
          "Id": "ShieldOS",
          "Name": "ShieldOS Aurora",
          "Description": "ShieldOS dark aurora identity wallpaper"
        }
      }
      EOF

      mkdir -p $out/share/icons/hicolor/scalable/apps
      make_icon() {
        name="$1"; accent="$2"; glyph="$3"
        cat > "$out/share/icons/hicolor/scalable/apps/$name.svg" <<EOF
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
        <defs>
          <linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0" stop-color="#22d3ee"/>
            <stop offset="1" stop-color="$accent"/>
          </linearGradient>
          <filter id="s"><feDropShadow dx="0" dy="8" stdDeviation="8" flood-color="#000" flood-opacity="0.35"/></filter>
        </defs>
        <rect x="16" y="16" width="96" height="96" rx="24" fill="#0b0f14" stroke="#1f3346" stroke-width="2" filter="url(#s)"/>
        <path d="M64 25 L98 38 L93 82 C90 103 74 116 64 121 C54 116 38 103 35 82 L30 38 Z" fill="url(#g)" opacity="0.95"/>
        <path d="M64 39 L84 46 L81 78 C79 90 71 99 64 104 C57 99 49 90 47 78 L44 46 Z" fill="#07111d" opacity="0.72"/>
        <text x="64" y="76" text-anchor="middle" font-family="Inter, Noto Sans, sans-serif" font-size="28" font-weight="700" fill="#e6edf3">$glyph</text>
      </svg>
      EOF
      }
      make_icon shieldos "#1e3a8a" "S"
      make_icon shieldos-logo "#1e3a8a" "S"
      make_icon shieldos-privacy "#0f766e" "P"
      make_icon shieldos-store "#2563eb" "A"
      make_icon shieldos-updates "#059669" "↻"
      make_icon shieldos-vault "#d97706" "V"
      make_icon shieldos-welcome "#7c3aed" "✓"
      make_icon shieldos-browser "#0284c7" "B"

      mkdir -p $out/share/color-schemes
      cat > $out/share/color-schemes/ShieldOSDark.colors <<'EOF'
      [ColorEffects:Disabled]
      Color=56,64,76
      ColorAmount=0
      ColorEffect=0
      ContrastAmount=0.65
      ContrastEffect=1
      IntensityAmount=0.1
      IntensityEffect=2

      [Colors:Button]
      BackgroundAlternate=20,26,34
      BackgroundNormal=20,26,34
      DecorationFocus=34,211,238
      DecorationHover=14,165,233
      ForegroundActive=34,211,238
      ForegroundInactive=148,163,184
      ForegroundLink=56,189,248
      ForegroundNegative=248,113,113
      ForegroundNeutral=250,204,21
      ForegroundNormal=230,237,243
      ForegroundPositive=74,222,128
      ForegroundVisited=147,197,253

      [Colors:Selection]
      BackgroundAlternate=30,58,138
      BackgroundNormal=14,165,233
      DecorationFocus=34,211,238
      DecorationHover=34,211,238
      ForegroundActive=255,255,255
      ForegroundInactive=230,237,243
      ForegroundLink=255,255,255
      ForegroundNegative=255,255,255
      ForegroundNeutral=255,255,255
      ForegroundNormal=255,255,255
      ForegroundPositive=255,255,255
      ForegroundVisited=255,255,255

      [Colors:View]
      BackgroundAlternate=11,15,20
      BackgroundNormal=8,12,18
      DecorationFocus=34,211,238
      DecorationHover=14,165,233
      ForegroundActive=34,211,238
      ForegroundInactive=148,163,184
      ForegroundLink=56,189,248
      ForegroundNegative=248,113,113
      ForegroundNeutral=250,204,21
      ForegroundNormal=230,237,243
      ForegroundPositive=74,222,128
      ForegroundVisited=147,197,253

      [Colors:Window]
      BackgroundAlternate=20,26,34
      BackgroundNormal=11,15,20
      DecorationFocus=34,211,238
      DecorationHover=14,165,233
      ForegroundActive=34,211,238
      ForegroundInactive=148,163,184
      ForegroundLink=56,189,248
      ForegroundNegative=248,113,113
      ForegroundNeutral=250,204,21
      ForegroundNormal=230,237,243
      ForegroundPositive=74,222,128
      ForegroundVisited=147,197,253

      [General]
      ColorScheme=ShieldOSDark
      Name=ShieldOS Dark
      shadeSortColumn=true

      [KDE]
      contrast=4

      [WM]
      activeBackground=11,15,20
      activeBlend=11,15,20
      activeForeground=230,237,243
      inactiveBackground=20,26,34
      inactiveBlend=20,26,34
      inactiveForeground=148,163,184
      EOF

      mkdir -p $out/share/konsole
      cat > $out/share/konsole/ShieldOS.profile <<'EOF'
      [Appearance]
      ColorScheme=Breeze
      Font=JetBrains Mono,11,-1,5,50,0,0,0,0,0

      [General]
      Name=ShieldOS
      Parent=FALLBACK/
      StartInCurrentSessionDir=true
      EOF

      mkdir -p $out/share/plymouth/themes/shieldos
      cat > $out/share/plymouth/themes/shieldos/shieldos.plymouth <<'EOF'
      [Plymouth Theme]
      Name=ShieldOS
      Description=ShieldOS boot splash
      ModuleName=script

      [script]
      ImageDir=/share/plymouth/themes/shieldos
      ScriptFile=/share/plymouth/themes/shieldos/shieldos.script
      EOF
      cat > $out/share/plymouth/themes/shieldos/shieldos.script <<'EOF'
      Window.SetBackgroundTopColor(0.02, 0.04, 0.07);
      Window.SetBackgroundBottomColor(0.00, 0.01, 0.02);
      title = Image.Text("ShieldOS", 0.13, 0.83, 0.93);
      title_sprite = Sprite(title);
      title_sprite.SetX(Window.GetWidth() / 2 - title.GetWidth() / 2);
      title_sprite.SetY(Window.GetHeight() / 2 - 80);
      tagline = Image.Text("Private. Clean. Familiar.", 0.78, 0.84, 0.90);
      tagline_sprite = Sprite(tagline);
      tagline_sprite.SetX(Window.GetWidth() / 2 - tagline.GetWidth() / 2);
      tagline_sprite.SetY(Window.GetHeight() / 2 - 30);
      fun progress_callback(duration, progress) {
        bar = Image.Text("━━━━━━", 0.13, 0.83, 0.93);
        progress_sprite = Sprite(bar);
        progress_sprite.SetX(Window.GetWidth() / 2 - bar.GetWidth() / 2);
        progress_sprite.SetY(Window.GetHeight() / 2 + 38);
      }
      Plymouth.SetBootProgressFunction(progress_callback);
      EOF
    '';
  };

  # Applies wallpaper, colors, dark theme, icons and a ShieldOS panel layout to KDE.
  shieldApplyIdentity = pkgs.writeShellApplication {
    name = "shield-apply-identity";
    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
      gnused
      procps
      xdg-utils
      kdePackages.plasma-workspace
      kdePackages.kconfig
      kdePackages.qttools
    ];
    text = ''
      set -euo pipefail
      WALLPAPER_SRC="/etc/shieldos/identity/shieldos-wallpaper.svg"
      WALLPAPER_DIR="$HOME/Pictures/ShieldOS"
      WALLPAPER="$WALLPAPER_DIR/shieldos-wallpaper.svg"
      STATE_DIR="$HOME/.local/state/shieldos"
      mkdir -p "$WALLPAPER_DIR" "$STATE_DIR" "$HOME/.config" "$HOME/.local/share/applications"
      cp -f "$WALLPAPER_SRC" "$WALLPAPER"

      if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
        plasma-apply-colorscheme ShieldOSDark >/dev/null 2>&1 || plasma-apply-colorscheme BreezeDark >/dev/null 2>&1 || true
      fi
      if command -v plasma-apply-wallpaperimage >/dev/null 2>&1; then
        plasma-apply-wallpaperimage "$WALLPAPER" >/dev/null 2>&1 || true
      fi

      if command -v kwriteconfig6 >/dev/null 2>&1; then
        kwriteconfig6 --file kdeglobals --group General --key ColorScheme ShieldOSDark || true
        kwriteconfig6 --file kdeglobals --group General --key Name ShieldOSDark || true
        kwriteconfig6 --file kdeglobals --group General --key TerminalApplication konsole || true
        kwriteconfig6 --file kdeglobals --group Icons --key Theme Papirus-Dark || true
        kwriteconfig6 --file kdeglobals --group KDE --key SingleClick false || true
        kwriteconfig6 --file plasmarc --group Theme --key name breeze-dark || true
        kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file://$WALLPAPER" || true
      fi

      PLASMA_JS="$STATE_DIR/plasma-layout.js"
      cat > "$PLASMA_JS" <<'EOF'
      var wallpaper = "file:///home/shield/Pictures/ShieldOS/shieldos-wallpaper.svg";
      var ds = desktops();
      for (var i = 0; i < ds.length; i++) {
        ds[i].wallpaperPlugin = "org.kde.image";
        ds[i].currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
        ds[i].writeConfig("Image", wallpaper);
        ds[i].writeConfig("FillMode", 2);
      }

      var already = String(readConfig("shieldosLayoutApplied", "false"));
      if (!already.match(/true/)) {
        var ps = panels();
        for (var p = 0; p < ps.length; p++) { ps[p].remove(); }

        var top = new Panel;
        top.location = "top";
        top.height = 34;
        top.addWidget("org.kde.plasma.kickoff");
        top.addWidget("org.kde.plasma.panelspacer");
        top.addWidget("org.kde.plasma.digitalclock");
        top.addWidget("org.kde.plasma.panelspacer");
        top.addWidget("org.kde.plasma.systemtray");

        var left = new Panel;
        left.location = "left";
        left.height = 72;
        left.lengthMode = "fit";
        left.addWidget("org.kde.plasma.kickoff");
        left.addWidget("org.kde.plasma.icon");
        left.addWidget("org.kde.plasma.icon");
        left.addWidget("org.kde.plasma.showdesktop");

        var bottom = new Panel;
        bottom.location = "bottom";
        bottom.height = 68;
        bottom.lengthMode = "fit";
        bottom.addWidget("org.kde.plasma.icontasks");
        bottom.addWidget("org.kde.plasma.trash");

        writeConfig("shieldosLayoutApplied", "true");
      }
      EOF

      if command -v qdbus6 >/dev/null 2>&1; then
        qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat "$PLASMA_JS")" >/dev/null 2>&1 || true
      elif command -v qdbus >/dev/null 2>&1; then
        qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat "$PLASMA_JS")" >/dev/null 2>&1 || true
      fi

      touch "$STATE_DIR/identity-applied"
      echo "ShieldOS identity applied. Log out and back in if panels did not update immediately."
    '';
  };

in {
  environment.systemPackages = [ shieldosIdentity shieldApplyIdentity ];

  environment.pathsToLink = [
    "/share/wallpapers"
    "/share/icons"
    "/share/color-schemes"
    "/share/konsole"
  ];

  environment.etc."shieldos/identity/shieldos-wallpaper.svg".source = "${shieldosIdentity}/share/wallpapers/ShieldOS/contents/images/1920x1080.svg";
  environment.etc."shieldos/identity/shieldos-logo.svg".source = "${shieldosIdentity}/share/icons/hicolor/scalable/apps/shieldos-logo.svg";

  boot.plymouth = {
    enable = true;
    theme = "shieldos";
    themePackages = [ shieldosIdentity ];
  };

  environment.sessionVariables = {
    SHIELDOS_BRAND = "ShieldOS";
    SHIELDOS_VERSION = "0.3.3 Real UI Build";
    KDE_COLOR_SCHEME = "ShieldOSDark";
  };

  environment.etc."xdg/autostart/shield-apply-identity.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Apply ShieldOS Identity
    Exec=${shieldApplyIdentity}/bin/shield-apply-identity
    X-KDE-autostart-after=panel
    Terminal=false
    Hidden=false
  '';

  environment.etc."skel/.config/kdeglobals".text = ''
    [General]
    ColorScheme=ShieldOSDark
    Name=ShieldOSDark
    TerminalApplication=konsole

    [Icons]
    Theme=Papirus-Dark

    [KDE]
    SingleClick=false
  '';

  environment.etc."skel/.config/plasmarc".text = ''
    [Theme]
    name=breeze-dark
  '';

  environment.etc."issue".text = ''
    ShieldOS 0.3.3 Real UI Build
    Private. Clean. Familiar.
  '';

  environment.etc."motd".text = ''
    ShieldOS 0.3.3 Real UI Build
    Commands: shield-center, shield-privacy, shield-store, shield-updates, shield-vault, shield-welcome, shield-apply-identity, shield-steam
  '';
}
