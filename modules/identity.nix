{ config, lib, pkgs, ... }:

let
  shieldosIdentity = pkgs.stdenvNoCC.mkDerivation {
    name = "shieldos-identity-0.3.1";
    dontUnpack = true;
    installPhase = ''
      set -eu

      mkdir -p $out/share/wallpapers/ShieldOS/contents/images
      cp ${../assets/identity/shieldos-wallpaper.svg} $out/share/wallpapers/ShieldOS/contents/images/1920x1080.svg
      cp ${../assets/identity/shieldos-wallpaper.svg} $out/share/wallpapers/ShieldOS/contents/images/2560x1440.svg
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
      cp ${../assets/identity/shieldos-logo.svg} $out/share/icons/hicolor/scalable/apps/shieldos.svg
      cp ${../assets/identity/shieldos-privacy.svg} $out/share/icons/hicolor/scalable/apps/shieldos-privacy.svg
      cp ${../assets/identity/shieldos-store.svg} $out/share/icons/hicolor/scalable/apps/shieldos-store.svg
      cp ${../assets/identity/shieldos-updates.svg} $out/share/icons/hicolor/scalable/apps/shieldos-updates.svg
      cp ${../assets/identity/shieldos-vault.svg} $out/share/icons/hicolor/scalable/apps/shieldos-vault.svg
      cp ${../assets/identity/shieldos-welcome.svg} $out/share/icons/hicolor/scalable/apps/shieldos-welcome.svg
      cp ${../assets/identity/shieldos-browser.svg} $out/share/icons/hicolor/scalable/apps/shieldos-browser.svg

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
      Font=JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0

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
      title = Image.Text("◈  ShieldOS", 0.13, 0.83, 0.93);
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

  # This script is intentionally stronger than the old one. It applies wallpaper,
  # colors, dark theme, icons and a ShieldOS panel layout to the real KDE session.
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
        kwriteconfig6 --file kdeglobals --group General --key fixed JetBrainsMono || true
        kwriteconfig6 --file kdeglobals --group Icons --key Theme Papirus-Dark || true
        kwriteconfig6 --file kdeglobals --group KDE --key SingleClick false || true
        kwriteconfig6 --file plasmarc --group Theme --key name breeze-dark || true
        kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file://$WALLPAPER" || true
      fi

      # Make the session look like ShieldOS instead of stock Plasma.
      # It creates a top status panel, a left launcher rail and a bottom task dock.
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

      if (!String(readConfig("shieldosLayoutApplied", "false")).match(/true/)) {
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

      cat > "$HOME/.local/share/applications/shieldos-session.desktop" <<EOF
      [Desktop Entry]
      Type=Application
      Name=ShieldOS Session Tools
      Comment=Apply ShieldOS identity, wallpaper and visual defaults
      Exec=shield-apply-identity
      Icon=shieldos
      Terminal=false
      Categories=System;
      EOF

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

  environment.etc."shieldos/identity/shieldos-wallpaper.svg".source = ../assets/identity/shieldos-wallpaper.svg;
  environment.etc."shieldos/identity/shieldos-logo.svg".source = ../assets/identity/shieldos-logo.svg;

  boot.plymouth = {
    enable = true;
    theme = "shieldos";
    themePackages = [ shieldosIdentity ];
  };

  environment.sessionVariables = {
    SHIELDOS_BRAND = "ShieldOS";
    SHIELDOS_VERSION = "0.3.1 Real UI Build";
    KDE_COLOR_SCHEME = "ShieldOSDark";
  };

  # Apply after Plasma has started. Absolute path avoids PATH problems in KDE autostart.
  environment.etc."xdg/autostart/shield-apply-identity.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Apply ShieldOS Identity
    Exec=${shieldApplyIdentity}/bin/shield-apply-identity
    X-KDE-autostart-after=panel
    Terminal=false
    Hidden=false
  '';

  # Defaults for newly created homes, including the live user on ISO boot.
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
    ShieldOS 0.3.1 Real UI Build
    Private. Clean. Familiar.
  '';

  environment.etc."motd".text = ''
    ShieldOS 0.3.1 Real UI Build
    Commands: shield-center, shield-privacy, shield-store, shield-updates, shield-vault, shield-welcome, shield-apply-identity
  '';
}
