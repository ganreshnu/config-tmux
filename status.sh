#!/bin/bash

function check-git-status() {
	# local branch
	# branch="$(git -C "$1" branch --show-current)"
	local style

	if ! git -C "$1" diff-files --quiet --ignore-submodules; then
		# unstaged changes
		style="fg=yellow,italics"
	elif ! git -C "$1" diff-index --cached --quiet --ignore-submodules HEAD 2>/dev/null; then
		# uncommitted changes
		style="fg=yellow"
	elif ! git -C "$1" diff --quiet "@{u}" 2>/dev/null; then
		# unpushed commits
		style="fg=brightred,italics"
	fi

	if [[ -n $style ]]; then
		printf "#[${style}]%s#[default] " "$(basename "$1")"
	fi
}

function main() {

	pushd "$HOME" > /dev/null || return

	while read -r d; do
		check-git-status "$d"
	done < .local/state/user_config_dirs

	popd > /dev/null || return
}
main "$@"
