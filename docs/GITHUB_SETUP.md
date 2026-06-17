# Put ShieldOS on GitHub

## Option A: Upload with GitHub Desktop

1. Create a new GitHub repository named `ShieldOS`.
2. Keep it public if you want people to see it, or private while testing.
3. Unzip this project.
4. Open GitHub Desktop.
5. Choose **File → Add Local Repository**.
6. Select the `ShieldOS` folder.
7. Publish the repository.

## Option B: Upload with terminal

From inside the `ShieldOS` folder:

```bash
git init
git branch -M main
git add .
git commit -m "Initial ShieldOS developer preview"
git remote add origin https://github.com/YOUR_USERNAME/ShieldOS.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

## Build ISO on GitHub

This project includes a GitHub Actions workflow:

```text
.github/workflows/build-iso.yml
```

After pushing to GitHub:

1. Open the repository on GitHub.
2. Go to **Actions**.
3. Choose **Build ShieldOS ISO**.
4. Press **Run workflow**.
5. When it finishes, download the ISO artifact.

The ISO build can be heavy. If GitHub Actions runs out of time or disk space, build locally instead:

```bash
./scripts/build-iso.sh
```

## Recommended repository settings

Use this description:

```text
A privacy-first, easy-to-use NixOS-based desktop OS prototype.
```

Recommended topics:

```text
nixos linux privacy desktop-os kde-plasma wayland gaming developer-tools security
```

Do not upload generated `.iso` files directly to Git. Use GitHub Releases or Actions artifacts instead.
