# Neat Coding Agent Skills and Rules

This repository is the index of Neat coding agent skills and rules playbooks. It does not carry the playbook payloads directly; `manifest.txt` points `sima-cli` at the playbook locations to install.

## Contents

- `manifest.txt` lists the playbook install targets, one per line. These entries can point to different locations supported by `sima-cli playbooks install`.
- `install.sh` finds `sima-cli`, reads `manifest.txt`, and runs `sima-cli playbooks install <name>` for each non-empty entry.
- `metadata.json` describes this index package for Palette SDK installation.

## Updating the Manifest

Add one playbook install target per line in `manifest.txt`:

```text
gh:sima-neat/insight
gh:sima-neat/model-sdk
```

Then run:

```bash
bash ./install.sh
```

If `sima-cli` is not on `PATH`, the installer checks the SDK alias target in common shell startup files and the default `~/.sima-cli/.venv/bin/sima-cli` location. You can also set it explicitly:

```bash
SIMA_CLI=/home/jim/.sima-cli/.venv/bin/sima-cli bash ./install.sh
```

## Package Metadata

The package is Palette SDK-only and includes the index resources:

- `manifest.txt`
- `install.sh`

There are no selectable resources.

## Install using sima-cli

```bash
sima-cli install gh:sima-neat/playbooks
```
