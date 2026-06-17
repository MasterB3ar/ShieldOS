# GitHub drop-and-build guide

## Upload

1. Go to GitHub.
2. Create a new empty repository called `ShieldOS`.
3. Do not add a README, license, or `.gitignore` on GitHub. This project already contains them.
4. Open the new repository.
5. Click **uploading an existing file**.
6. Drag everything inside the extracted ShieldOS folder into GitHub.
7. Confirm `.github/workflows/build-iso.yml` is at the repository root.
8. Commit the upload.

## Run the workflow

1. Open the **Actions** tab.
2. Select **Build ShieldOS VM ISO**.
3. Click **Run workflow**.
4. Select the `main` branch.
5. Click **Run workflow** again.

The workflow uses `workflow_dispatch`, so it can be started manually from the Actions tab.

## Download the ISO

After the workflow finishes:

1. Open the completed workflow run.
2. Scroll to **Artifacts**.
3. Download `ShieldOS-VM-ISO`.
4. Extract the downloaded artifact zip.
5. Boot the `.iso` file in your VM.

## Troubleshooting

### The Actions tab does not show the workflow

Check that this file exists exactly here:

```text
.github/workflows/build-iso.yml
```

If it is here instead, it is wrong:

```text
ShieldOS/.github/workflows/build-iso.yml
```

Move all project files to the repository root.

### The workflow fails during package evaluation

Open the failed workflow run, expand the red step, and copy the error. Usually this means a package name changed in NixOS. Remove or replace that package in the relevant module.

### The ISO artifact is missing

The workflow is configured with `if-no-files-found: error`, so if there is no ISO file, the workflow should fail instead of silently uploading nothing.
