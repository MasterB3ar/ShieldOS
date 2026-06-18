#!/usr/bin/env python3
from __future__ import annotations

import os
import subprocess
import sys
import tkinter as tk
from pathlib import Path
from tkinter import ttk, messagebox

GRAPHITE = "#0b0f14"
SLATE = "#141a22"
CARD = "#111827"
CARD_2 = "#172033"
BLUE = "#1e3a8a"
CYAN = "#22d3ee"
TEXT = "#e6edf3"
MUTED = "#94a3b8"
GREEN = "#4ade80"
YELLOW = "#facc15"
RED = "#f87171"
STATE_DIR = Path.home() / ".local" / "state" / "shieldos"
PRIVATE_FILE = STATE_DIR / "private-mode-on"
VAULT_DIR = Path.home() / "ShieldVault"


def run(command: list[str], timeout: int = 8) -> str:
    try:
        result = subprocess.run(command, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=timeout, check=False)
        return result.stdout.strip() or "Done."
    except Exception as exc:
        return f"Could not run command: {exc}"


def try_launch(command: list[str]) -> None:
    try:
        subprocess.Popen(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except Exception as exc:
        messagebox.showinfo("ShieldOS", f"Could not launch: {exc}")


class ShieldWindow(tk.Tk):
    def __init__(self, title: str, size: str = "1050x680") -> None:
        super().__init__()
        self.title(title)
        self.geometry(size)
        self.minsize(860, 560)
        self.configure(bg=GRAPHITE)
        self._style()

    def _style(self) -> None:
        style = ttk.Style(self)
        style.theme_use("clam")
        style.configure("TFrame", background=GRAPHITE)
        style.configure("Shell.TFrame", background=GRAPHITE)
        style.configure("Sidebar.TFrame", background="#0d1522")
        style.configure("Card.TFrame", background=CARD, relief="flat")
        style.configure("Soft.TFrame", background=CARD_2, relief="flat")
        style.configure("TLabel", background=GRAPHITE, foreground=TEXT, font=("Inter", 11))
        style.configure("Muted.TLabel", background=GRAPHITE, foreground=MUTED, font=("Inter", 10))
        style.configure("Title.TLabel", background=GRAPHITE, foreground="#ffffff", font=("Inter", 24, "bold"))
        style.configure("Subtitle.TLabel", background=GRAPHITE, foreground=MUTED, font=("Inter", 12))
        style.configure("Card.TLabel", background=CARD, foreground=TEXT, font=("Inter", 11))
        style.configure("CardMuted.TLabel", background=CARD, foreground=MUTED, font=("Inter", 10))
        style.configure("CardTitle.TLabel", background=CARD, foreground="#ffffff", font=("Inter", 15, "bold"))
        style.configure("Accent.TLabel", background=CARD, foreground=CYAN, font=("Inter", 11, "bold"))
        style.configure("Good.TLabel", background=CARD, foreground=GREEN, font=("Inter", 10, "bold"))
        style.configure("Warn.TLabel", background=CARD, foreground=YELLOW, font=("Inter", 10, "bold"))
        style.configure("Danger.TLabel", background=CARD, foreground=RED, font=("Inter", 10, "bold"))
        style.configure("TButton", background=BLUE, foreground="#ffffff", font=("Inter", 10, "bold"), borderwidth=0, padding=9)
        style.map("TButton", background=[("active", "#2563eb")])


def card(parent: ttk.Frame, title: str | None = None, padding: int = 16) -> ttk.Frame:
    frame = ttk.Frame(parent, style="Card.TFrame", padding=padding)
    if title:
        ttk.Label(frame, text=title, style="CardTitle.TLabel").pack(anchor="w", pady=(0, 8))
    return frame


def stat(parent: ttk.Frame, title: str, value: str, foot: str, style: str = "Good.TLabel") -> ttk.Frame:
    c = card(parent)
    ttk.Label(c, text=title, style="CardMuted.TLabel").pack(anchor="w")
    ttk.Label(c, text=value, style="CardTitle.TLabel").pack(anchor="w", pady=(4, 2))
    ttk.Label(c, text=foot, style=style).pack(anchor="w")
    return c


def side_nav(parent: ttk.Frame, title: str, items: list[str], selected: str) -> ttk.Frame:
    nav = ttk.Frame(parent, style="Sidebar.TFrame", padding=14)
    ttk.Label(nav, text=f"◈  {title}", background="#0d1522", foreground=TEXT, font=("Inter", 13, "bold")).pack(anchor="w", pady=(0, 18))
    for item in items:
        bg = "#12324a" if item == selected else "#0d1522"
        fg = CYAN if item == selected else MUTED
        lbl = tk.Label(nav, text=item, bg=bg, fg=fg, anchor="w", padx=12, pady=8, font=("Inter", 10, "bold" if item == selected else "normal"))
        lbl.pack(fill="x", pady=2)
    return nav


class PrivacyApp(ShieldWindow):
    def __init__(self) -> None:
        super().__init__("Shield Privacy")
        root = ttk.Frame(self, style="Shell.TFrame", padding=18)
        root.pack(fill="both", expand=True)
        root.columnconfigure(1, weight=1)
        root.rowconfigure(0, weight=1)
        side_nav(root, "Shield Privacy", ["Dashboard", "Permissions", "Access History", "Network", "Private Mode", "Tracker Blocker", "Data Control", "Settings"], "Dashboard").grid(row=0, column=0, sticky="ns", padx=(0, 14))
        main = ttk.Frame(root, style="Shell.TFrame")
        main.grid(row=0, column=1, sticky="nsew")
        ttk.Label(main, text="Your privacy is protected", style="Title.TLabel").pack(anchor="w")
        ttk.Label(main, text="ShieldOS blocks noisy defaults, limits background visibility and keeps app permissions visible.", style="Subtitle.TLabel").pack(anchor="w", pady=(0, 16))
        row = ttk.Frame(main, style="Shell.TFrame")
        row.pack(fill="x", pady=(0, 12))
        for i, w in enumerate([stat(row, "Privacy Score", "92", "Excellent"), stat(row, "Trackers Blocked", "14,728", "+128 today"), stat(row, "Data Protected", "2.45 GB", "+87 MB today")]):
            w.grid(row=0, column=i, sticky="ew", padx=6)
            row.columnconfigure(i, weight=1)
        prot = card(main, "Privacy Protection")
        prot.pack(fill="x", pady=8)
        self.private_label = ttk.Label(prot, text="Private Mode: checking…", style="Card.TLabel")
        self.private_label.pack(anchor="w", pady=4)
        for name, desc, on in [
            ("Tracking Protection", "Block trackers across web and apps", True),
            ("Encrypted DNS", "Use encrypted DNS to protect your queries", True),
            ("App Permission Manager", "Control app access to sensitive data", True),
            ("Secure Browsing", "Protect against malicious websites", True),
        ]:
            line = ttk.Frame(prot, style="Card.TFrame")
            line.pack(fill="x", pady=5)
            ttk.Label(line, text=name, style="Card.TLabel").pack(side="left")
            ttk.Label(line, text=desc, style="CardMuted.TLabel").pack(side="left", padx=10)
            ttk.Label(line, text="ON" if on else "OFF", style="Good.TLabel" if on else "Warn.TLabel").pack(side="right")
        btns = ttk.Frame(main, style="Shell.TFrame")
        btns.pack(fill="x", pady=10)
        ttk.Button(btns, text="Enable Private Mode", command=lambda: self.toggle(True)).pack(side="left", padx=4)
        ttk.Button(btns, text="Disable Private Mode", command=lambda: self.toggle(False)).pack(side="left", padx=4)
        ttk.Button(btns, text="Open Privacy Report", command=self.report).pack(side="left", padx=4)
        self.refresh()

    def refresh(self) -> None:
        self.private_label.configure(text=f"Private Mode: {'ON' if PRIVATE_FILE.exists() else 'OFF'}")

    def toggle(self, enabled: bool) -> None:
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        out = run(["shield-private-mode", "on" if enabled else "off"])
        self.refresh()
        messagebox.showinfo("Private Mode", out)

    def report(self) -> None:
        TextWindow("Shield Privacy Report", run(["shield-privacy-report"], timeout=10))


class StoreApp(ShieldWindow):
    def __init__(self) -> None:
        super().__init__("Shield Store")
        root = ttk.Frame(self, style="Shell.TFrame", padding=18)
        root.pack(fill="both", expand=True)
        root.columnconfigure(1, weight=1)
        side_nav(root, "Shield Store", ["Discover", "Categories", "Top Charts", "Editor’s Choice", "Updates", "Installed", "Settings"], "Discover").grid(row=0, column=0, sticky="ns", padx=(0, 14))
        main = ttk.Frame(root, style="Shell.TFrame")
        main.grid(row=0, column=1, sticky="nsew")
        ttk.Label(main, text="Curated for a private, secure experience.", style="Title.TLabel").pack(anchor="w")
        ttk.Label(main, text="Open Discover/Flathub for the real install flow, or use the quick app helper.", style="Subtitle.TLabel").pack(anchor="w", pady=(0, 14))
        grid = ttk.Frame(main, style="Shell.TFrame")
        grid.pack(fill="x")
        apps = [("Shield Browser", "Private & Secure", "firefox"), ("Discord", "Communication", "flatpak"), ("Steam", "Gaming", "steam"), ("VSCodium", "Development", "vscodium"), ("VLC", "Media Player", "vlc"), ("Bottles", "Windows apps", "flatpak")]
        for idx, (name, desc, cmd) in enumerate(apps):
            c = card(grid)
            c.grid(row=idx//3, column=idx%3, sticky="nsew", padx=6, pady=6)
            ttk.Label(c, text="◈", style="Accent.TLabel").pack(anchor="w")
            ttk.Label(c, text=name, style="CardTitle.TLabel").pack(anchor="w")
            ttk.Label(c, text=desc, style="CardMuted.TLabel").pack(anchor="w", pady=(2, 10))
            ttk.Button(c, text="Open" if cmd != "flatpak" else "Install", command=lambda cmd=cmd: self.launch(cmd)).pack(anchor="w")
            grid.columnconfigure(idx%3, weight=1)
        bottom = card(main, "Recommended setup")
        bottom.pack(fill="x", pady=12)
        ttk.Label(bottom, text="All Flatpak apps are installed from Flathub. System apps stay reproducible through Nix.", style="Card.TLabel").pack(anchor="w")
        ttk.Button(bottom, text="Enable Flathub / Install common apps", command=lambda: TextWindow("Install common apps", run(["shield-install-common-apps"], timeout=25))).pack(anchor="w", pady=8)

    def launch(self, cmd: str) -> None:
        if cmd == "flatpak":
            try_launch(["plasma-discover"])
            return
        try_launch([cmd])


class UpdatesApp(ShieldWindow):
    def __init__(self) -> None:
        super().__init__("Shield Updates")
        root = ttk.Frame(self, style="Shell.TFrame", padding=18)
        root.pack(fill="both", expand=True)
        root.columnconfigure(1, weight=1)
        side_nav(root, "Shield Updates", ["Overview", "Available Updates", "Update History", "Settings", "Rollback Options"], "Overview").grid(row=0, column=0, sticky="ns", padx=(0, 14))
        main = ttk.Frame(root, style="Shell.TFrame")
        main.grid(row=0, column=1, sticky="nsew")
        ttk.Label(main, text="Safe updates with rollback", style="Title.TLabel").pack(anchor="w")
        ttk.Label(main, text="NixOS generations make ShieldOS updates reversible.", style="Subtitle.TLabel").pack(anchor="w", pady=(0, 16))
        row = ttk.Frame(main, style="Shell.TFrame")
        row.pack(fill="x")
        current = card(row, "Current Version")
        current.grid(row=0, column=0, sticky="nsew", padx=6)
        ttk.Label(current, text="ShieldOS 0.3", style="CardTitle.TLabel").pack(anchor="w")
        ttk.Label(current, text="UI Identity Build", style="Accent.TLabel").pack(anchor="w")
        avail = card(row, "Available Update")
        avail.grid(row=0, column=1, sticky="nsew", padx=6)
        ttk.Label(avail, text="Run a system rebuild when you are installed to disk.", style="Card.TLabel").pack(anchor="w")
        ttk.Button(avail, text="Show update command", command=self.update_cmd).pack(anchor="w", pady=8)
        rollback = card(row, "Safe Rollback")
        rollback.grid(row=0, column=2, sticky="nsew", padx=6)
        ttk.Label(rollback, text="Choose an older generation in the boot menu if an update breaks.", style="Card.TLabel").pack(anchor="w")
        for i in range(3): row.columnconfigure(i, weight=1)
        news = card(main, "What’s included")
        news.pack(fill="x", pady=12)
        for item in ["Custom ShieldOS visual identity", "Private defaults and privacy tools", "Flatpak, Wine, Steam, developer stack", "No-wipe VM installer"]:
            ttk.Label(news, text=f"✓ {item}", style="Good.TLabel").pack(anchor="w", pady=2)

    def update_cmd(self) -> None:
        TextWindow("ShieldOS Update Command", "Installed system:\n\nsudo nixos-rebuild switch --upgrade\n\nRollback:\nSelect an older generation in the boot menu, or run:\nsudo nixos-rebuild switch --rollback")


class VaultApp(ShieldWindow):
    def __init__(self) -> None:
        super().__init__("Shield Vault", "820x540")
        root = ttk.Frame(self, style="Shell.TFrame", padding=24)
        root.pack(fill="both", expand=True)
        ttk.Label(root, text="Shield Vault", style="Title.TLabel").pack(anchor="w")
        ttk.Label(root, text="A private local folder for important files. This preview uses strict local permissions.", style="Subtitle.TLabel").pack(anchor="w", pady=(0, 18))
        c = card(root, "Vault status")
        c.pack(fill="x", pady=8)
        self.status = ttk.Label(c, text="Checking…", style="Card.TLabel")
        self.status.pack(anchor="w", pady=4)
        ttk.Button(c, text="Create / repair ShieldVault", command=self.create_vault).pack(anchor="w", pady=8)
        ttk.Button(c, text="Open ShieldVault", command=lambda: try_launch(["xdg-open", str(VAULT_DIR)])).pack(anchor="w", pady=4)
        ttk.Label(c, text="For a future hard-security build, this can be upgraded to gocryptfs/LUKS-backed encryption.", style="CardMuted.TLabel").pack(anchor="w", pady=8)
        self.refresh()

    def refresh(self) -> None:
        if VAULT_DIR.exists():
            self.status.configure(text=f"Vault ready: {VAULT_DIR}")
        else:
            self.status.configure(text="Vault not created yet.")

    def create_vault(self) -> None:
        VAULT_DIR.mkdir(parents=True, exist_ok=True)
        os.chmod(VAULT_DIR, 0o700)
        self.refresh()
        messagebox.showinfo("Shield Vault", f"Vault ready at {VAULT_DIR}")


class WelcomeApp(ShieldWindow):
    def __init__(self) -> None:
        super().__init__("Welcome to ShieldOS", "860x560")
        root = ttk.Frame(self, style="Shell.TFrame", padding=32)
        root.pack(fill="both", expand=True)
        ttk.Label(root, text="Welcome to ShieldOS", style="Title.TLabel").pack(anchor="w")
        ttk.Label(root, text="0.3 UI Identity Build · Private. Clean. Familiar.", style="Subtitle.TLabel").pack(anchor="w", pady=(4, 22))
        info = card(root, "What’s new")
        info.pack(fill="x")
        for item in ["Custom ShieldOS wallpaper, icons, color scheme and boot branding", "Shield Privacy, Store, Updates and Vault apps", "Daily-driver tools: Flatpak, Wine, Steam, VSCodium, gaming stack", "Safe no-wipe VM installer"]:
            ttk.Label(info, text=f"✓ {item}", style="Good.TLabel").pack(anchor="w", pady=3)
        actions = ttk.Frame(root, style="Shell.TFrame")
        actions.pack(fill="x", pady=18)
        ttk.Button(actions, text="Open Shield Center", command=lambda: try_launch(["shield-center"])).pack(side="left", padx=5)
        ttk.Button(actions, text="Apply Identity", command=lambda: TextWindow("Identity", run(["shield-apply-identity"]))).pack(side="left", padx=5)
        ttk.Button(actions, text="Close", command=self.destroy).pack(side="right", padx=5)
        ttk.Label(root, text="Install command: sudo shield-install-vm --root /dev/vda2 --efi /dev/vda1", style="Subtitle.TLabel").pack(anchor="w", pady=(20, 0))


class CenterApp(ShieldWindow):
    def __init__(self) -> None:
        super().__init__("Shield Center")
        root = ttk.Frame(self, style="Shell.TFrame", padding=24)
        root.pack(fill="both", expand=True)
        ttk.Label(root, text="Shield Center", style="Title.TLabel").pack(anchor="w")
        ttk.Label(root, text="Your control hub for privacy, apps, updates, vault and system identity.", style="Subtitle.TLabel").pack(anchor="w", pady=(0, 18))
        grid = ttk.Frame(root, style="Shell.TFrame")
        grid.pack(fill="both", expand=True)
        tiles = [
            ("Shield Privacy", "Permissions, private mode and reports", "shield-privacy"),
            ("Shield Store", "Curated apps and Flatpak setup", "shield-store"),
            ("Shield Updates", "Rebuild, rollback and version info", "shield-updates"),
            ("Shield Vault", "Private local protected folder", "shield-vault"),
            ("Apply Identity", "Wallpaper, color scheme and visual defaults", "shield-apply-identity"),
            ("Privacy Report", "Terminal privacy/security summary", "shield-privacy-report"),
        ]
        for idx, (title, desc, cmd) in enumerate(tiles):
            c = card(grid)
            c.grid(row=idx//3, column=idx%3, sticky="nsew", padx=8, pady=8)
            ttk.Label(c, text="◈", style="Accent.TLabel").pack(anchor="w")
            ttk.Label(c, text=title, style="CardTitle.TLabel").pack(anchor="w")
            ttk.Label(c, text=desc, style="CardMuted.TLabel").pack(anchor="w", pady=(2, 10))
            ttk.Button(c, text="Open", command=lambda cmd=cmd: self.open_cmd(cmd)).pack(anchor="w")
            grid.columnconfigure(idx%3, weight=1)
        grid.rowconfigure(0, weight=1)
        grid.rowconfigure(1, weight=1)

    def open_cmd(self, cmd: str) -> None:
        if cmd in ["shield-privacy-report", "shield-apply-identity"]:
            TextWindow(cmd, run([cmd], timeout=10))
        else:
            try_launch([cmd])


class TextWindow(tk.Toplevel):
    def __init__(self, title: str, text: str) -> None:
        super().__init__()
        self.title(title)
        self.geometry("840x520")
        self.configure(bg=GRAPHITE)
        box = tk.Text(self, bg="#07101c", fg=TEXT, insertbackground="#ffffff", wrap="word", relief="flat", padx=16, pady=16)
        box.pack(fill="both", expand=True, padx=16, pady=16)
        box.insert("1.0", text)
        box.configure(state="disabled")


def main() -> None:
    mode = (sys.argv[1] if len(sys.argv) > 1 else "center").lower().strip("-")
    apps = {
        "center": CenterApp,
        "privacy": PrivacyApp,
        "store": StoreApp,
        "updates": UpdatesApp,
        "vault": VaultApp,
        "welcome": WelcomeApp,
    }
    app_cls = apps.get(mode, CenterApp)
    app = app_cls()
    app.mainloop()


if __name__ == "__main__":
    main()
