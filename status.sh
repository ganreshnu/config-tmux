#!/bin/bash

gitStatusWrap() {
	local dir="$1"; shift
	local status="$(git -C "$dir" status --porcelain)"
	if [[ -z "$status" ]]; then
		status="$(git -C "$dir" status |grep -q 'branch is ahead')"

		git -C "$dir" status |grep -q 'branch is ahead' \
			|| return 0
	fi

	local name="$(basename "$dir")"
	local color="lightcyan"
	printf "#[fg=$color]%s#[default]" " $name"
}

# untracked files
# unstaged changes
# uncommitted changes 
# unpushed commits
function main() {

	pushd "$HOME" > /dev/null || return

	while read -r d; do
		gitStatusWrap "$d"
	done < .local/state/user_config_dirs

	popd > /dev/null || return
}
main "$@"
