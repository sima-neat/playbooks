# Neat Coding Agent Skills and Rules

This repository packages Neat coding agent skills and rules as installable playbooks.

## Contents

- `manifest.txt` lists the playbook names to install, one per line.
- `install.sh` finds `sima-cli`, reads `manifest.txt`, and runs `sima-cli playbooks install <name>` for each non-empty entry.
- `metadata.json` describes the package for Palette SDK installation.

## Updating the Manifest

Add one playbook name per line in `manifest.txt`:

```text
example-playbook-name
another-playbook-name
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

The package is Palette SDK-only and includes two resources:

- `manifest.txt`
- `install.sh`

There are no selectable resources.

## Install using sima-cli

```bash
sima-cli install gh:sima-neat/playbooks
```