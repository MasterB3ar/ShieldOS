#!/usr/bin/env python3
from __future__ import annotations

import tkinter as tk
from tkinter import ttk


class Welcome(tk.Tk):
    def __init__(self) -> None:
        super().__init__()
        self.title("Welcome to ShieldOS")
        self.geometry("760x480")
        self.configure(bg="#111827")
        self.resizable(False, False)

        style = ttk.Style(self)
        style.theme_use("clam")
        style.configure("TFrame", background="#111827")
        style.configure("TLabel", background="#111827", foreground="#e5e7eb", font=("Inter", 12))
        style.configure("Title.TLabel", background="#111827", foreground="#ffffff", font=("Inter", 26, "bold"))
        style.configure("Accent.TLabel", background="#111827", foreground="#93c5fd", font=("Inter", 13, "bold"))
        style.configure("TButton", font=("Inter", 10, "bold"), padding=10)

        root = ttk.Frame(self, padding=32)
        root.pack(fill="both", expand=True)
        ttk.Label(root, text="Welcome to ShieldOS", style="Title.TLabel").pack(anchor="w")
        ttk.Label(root, text="Daily Driver VM 0.2", style="Accent.TLabel").pack(anchor="w", pady=(4, 22))
        ttk.Label(
            root,
            text=(
                "ShieldOS is a clean, private desktop system. It uses local accounts by default, "
                "keeps the firewall enabled, supports Flatpak/Flathub, Steam, Wine and developer tools, "
                "and gives you one simple Shield Center for privacy, gaming and developer controls."
            ),
            wraplength=660,
        ).pack(anchor="w", pady=(0, 20))
        ttk.Label(root, text="Live user: shield  |  Live password: shield").pack(anchor="w", pady=3)
        ttk.Label(root, text="Install to an empty VM disk: sudo shield-install-vm /dev/vda").pack(anchor="w", pady=3)
        ttk.Label(root, text="Open Discover for apps, or run: shield-install-common-apps").pack(anchor="w", pady=3)
        ttk.Button(root, text="Close", command=self.destroy).pack(anchor="e", pady=(40, 0))


if __name__ == "__main__":
    Welcome().mainloop()
