#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
manifest="${script_dir}/manifest.txt"

find_alias_target() {
    local shell_file
    local target

    for shell_file in \
        "${HOME:-}/.bashrc" \
        "${HOME:-}/.bash_profile" \
        "${HOME:-}/.profile" \
        "${HOME:-}/.zshrc"; do
        [[ -n "${shell_file}" && -r "${shell_file}" ]] || continue

        target="$(
            sed -n -E "s/^[[:space:]]*alias[[:space:]]+sima-cli=['\"]?([^'\"]+)['\"]?.*$/\1/p" "${shell_file}" \
                | sed -n '1p'
        )"
        [[ -n "${target}" && -x "${target}" ]] || continue

        printf '%s\n' "${target}"
        return 0
    done

    return 1
}

resolve_sima_cli() {
    local candidate

    if [[ -n "${SIMA_CLI:-}" ]]; then
        if [[ -x "${SIMA_CLI}" ]]; then
            printf '%s\n' "${SIMA_CLI}"
            return 0
        fi
        if command -v "${SIMA_CLI}" >/dev/null 2>&1; then
            command -v "${SIMA_CLI}"
            return 0
        fi

        echo "SIMA_CLI is set but is not executable or on PATH: ${SIMA_CLI}" >&2
        return 1
    fi

    if command -v sima-cli >/dev/null 2>&1; then
        command -v sima-cli
        return 0
    fi

    if candidate="$(find_alias_target)"; then
        printf '%s\n' "${candidate}"
        return 0
    fi

    candidate="${HOME:-}/.sima-cli/.venv/bin/sima-cli"
    if [[ -x "${candidate}" ]]; then
        printf '%s\n' "${candidate}"
        return 0
    fi

    if [[ -n "${HOME:-}" && -d "${HOME}/.sima-cli" ]]; then
        while IFS= read -r candidate; do
            [[ -x "${candidate}" ]] || continue
            printf '%s\n' "${candidate}"
            return 0
        done < <(find "${HOME}/.sima-cli" -maxdepth 5 -type f -name sima-cli 2>/dev/null)
    fi

    echo "Unable to find sima-cli. Set SIMA_CLI=/path/to/sima-cli and retry." >&2
    return 1
}

if [[ ! -f "${manifest}" ]]; then
    echo "manifest.txt not found: ${manifest}" >&2
    exit 1
fi

sima_cli="$(resolve_sima_cli)"
echo "Using sima-cli: ${sima_cli}"

while IFS= read -r raw_name || [[ -n "${raw_name}" ]]; do
    name="$(printf '%s' "${raw_name}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [[ -z "${name}" ]] && continue

    "${sima_cli}" playbooks install "${name}" --force
done < "${manifest}"
