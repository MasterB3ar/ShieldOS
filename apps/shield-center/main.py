#!/usr/bin/env python3
"""
Shield Center
A small first-party control panel for the ShieldOS Daily Driver VM.
It is intentionally simple: no cloud account, no telemetry, no hidden network calls.
"""

from __future__ import annotations

import os
import subprocess
import tkinter as tk
from tkinter import ttk, messagebox
from pathlib import Path

APP_NAME = "Shield Center"
STATE_DIR = Path.home() / ".local" / "state" / "shieldos"
PRIVATE_MODE_FILE = STATE_DIR / "private-mode-on"


def run_command(command: list[str]) -> str:
    try:
        result = subprocess.run(
            command,
            check=False,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=8,
        )
        return result.stdout.strip() or "Done."
    except Exception as exc:  # noqa: BLE001 - this is a user-facing control app
        return f"Could not run command: {exc}"


def service_status(name: str) -> str:
    result = run_command(["systemctl", "is-active", name])
    return "active" if result.strip() == "active" else result.strip()


class ShieldCenter(tk.Tk):
    def __init__(self) -> None:
        super().__init__()
        self.title(APP_NAME)
        self.geometry("980x640")
        self.minsize(860, 560)
        self.configure(bg="#111827")

        style = ttk.Style(self)
        style.theme_use("clam")
        style.configure("TFrame", background="#111827")
        style.configure("Card.TFrame", background="#1f2937", relief="flat")
        style.configure("TLabel", background="#111827", foreground="#e5e7eb", font=("Inter", 11))
        style.configure("Card.TLabel", background="#1f2937", foreground="#e5e7eb", font=("Inter", 11))
        style.configure("Title.TLabel", background="#111827", foreground="#ffffff", font=("Inter", 24, "bold"))
        style.configure("Subtitle.TLabel", background="#111827", foreground="#9ca3af", font=("Inter", 12))
        style.configure("CardTitle.TLabel", background="#1f2937", foreground="#ffffff", font=("Inter", 15, "bold"))
        style.configure("Good.TLabel", background="#1f2937", foreground="#86efac", font=("Inter", 11, "bold"))
        style.configure("Warn.TLabel", background="#1f2937", foreground="#facc15", font=("Inter", 11, "bold"))
        style.configure("Danger.TLabel", background="#1f2937", foreground="#fca5a5", font=("Inter", 11, "bold"))
        style.configure("TButton", font=("Inter", 10, "bold"), padding=10)

        self._build_layout()
        self.refresh_status()

    def _build_layout(self) -> None:
        outer = ttk.Frame(self, padding=24)
        outer.pack(fill="both", expand=True)

        title = ttk.Label(outer, text="ShieldOS", style="Title.TLabel")
        title.pack(anchor="w")
        subtitle = ttk.Label(
            outer,
            text="Easy desktop controls for privacy, security, gaming and development.",
            style="Subtitle.TLabel",
        )
        subtitle.pack(anchor="w", pady=(0, 18))

        content = ttk.Frame(outer)
        content.pack(fill="both", expand=True)
        content.columnconfigure(0, weight=1)
        content.columnconfigure(1, weight=1)
        content.rowconfigure(0, weight=1)
        content.rowconfigure(1, weight=1)

        self.privacy_card = self._card(content, "Privacy", 0, 0)
        self.security_card = self._card(content, "Security", 0, 1)
        self.gaming_card = self._card(content, "Gaming", 1, 0)
        self.dev_card = self._card(content, "Developer", 1, 1)

        self.private_status = ttk.Label(self.privacy_card, text="Private Mode: checking…", style="Card.TLabel")
        self.private_status.pack(anchor="w", pady=(4, 10))
        ttk.Button(self.privacy_card, text="Enable Private Mode", command=lambda: self.toggle_private(True)).pack(anchor="w", pady=3)
        ttk.Button(self.privacy_card, text="Disable Private Mode", command=lambda: self.toggle_private(False)).pack(anchor="w", pady=3)
        ttk.Button(self.privacy_card, text="Open Privacy Report", command=self.open_privacy_report).pack(anchor="w", pady=3)

        self.firewall_status = ttk.Label(self.security_card, text="Firewall: checking…", style="Card.TLabel")
        self.firewall_status.pack(anchor="w", pady=(4, 10))
        self.apparmor_status = ttk.Label(self.security_card, text="AppArmor: checking…", style="Card.TLabel")
        self.apparmor_status.pack(anchor="w", pady=(0, 10))
        ttk.Label(
            self.security_card,
            text="Default: firewall on, SSH off, app sandbox support enabled.",
            style="Card.TLabel",
            wraplength=360,
        ).pack(anchor="w", pady=3)

        ttk.Label(
            self.gaming_card,
            text="Steam, GameMode, MangoHud, Heroic, Lutris and Prism Launcher are included.",
            style="Card.TLabel",
            wraplength=360,
        ).pack(anchor="w", pady=(4, 10))
        ttk.Button(self.gaming_card, text="Show GPU/Vulkan Info", command=self.show_vulkan_hint).pack(anchor="w", pady=3)

        ttk.Label(
            self.dev_card,
            text="VSCodium, Node.js, Python, GitHub CLI, Rust, Go and Podman are included.",
            style="Card.TLabel",
            wraplength=360,
        ).pack(anchor="w", pady=(4, 10))
        ttk.Button(self.dev_card, text="Show Developer Commands", command=self.show_dev_commands).pack(anchor="w", pady=3)
        ttk.Button(self.dev_card, text="Refresh Status", command=self.refresh_status).pack(anchor="w", pady=3)

    def _card(self, parent: ttk.Frame, heading: str, row: int, column: int) -> ttk.Frame:
        card = ttk.Frame(parent, style="Card.TFrame", padding=18)
        card.grid(row=row, column=column, sticky="nsew", padx=8, pady=8)
        ttk.Label(card, text=heading, style="CardTitle.TLabel").pack(anchor="w")
        return card

    def refresh_status(self) -> None:
        private = "ON" if PRIVATE_MODE_FILE.exists() else "OFF"
        self.private_status.configure(text=f"Private Mode: {private}")
        self.firewall_status.configure(text=f"Firewall: {service_status('firewall.service')}")
        self.apparmor_status.configure(text=f"AppArmor: {service_status('apparmor.service')}")

    def toggle_private(self, enabled: bool) -> None:
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        output = run_command(["shield-private-mode", "on" if enabled else "off"])
        self.refresh_status()
        messagebox.showinfo("Private Mode", output)

    def open_privacy_report(self) -> None:
        output = run_command(["shield-privacy-report"])
        ReportWindow(self, "Privacy Report", output)

    def show_vulkan_hint(self) -> None:
        output = run_command(["sh", "-lc", "vulkaninfo --summary 2>/dev/null || echo 'Vulkan info is not available in this session.'"])
        ReportWindow(self, "Gaming / Vulkan", output)

    def show_dev_commands(self) -> None:
        text = """Useful ShieldOS developer commands:

node --version
python3 --version
git --version
gh auth login
podman --version
podman run hello-world
nix flake show
nixfmt <file>.nix

Project folders recommended:
~/Projects/Web
~/Projects/Games
~/Projects/Security
"""
        ReportWindow(self, "Developer Commands", text)


class ReportWindow(tk.Toplevel):
    def __init__(self, parent: tk.Tk, title: str, text: str) -> None:
        super().__init__(parent)
        self.title(title)
        self.geometry("820x520")
        self.configure(bg="#111827")
        box = tk.Text(self, bg="#0b1220", fg="#e5e7eb", insertbackground="#ffffff", wrap="word")
        box.pack(fill="both", expand=True, padx=14, pady=14)
        box.insert("1.0", text)
        box.configure(state="disabled")


if __name__ == "__main__":
    app = ShieldCenter()
    app.mainloop()
