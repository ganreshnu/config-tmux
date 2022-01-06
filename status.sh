#!/bin/zsh

function check-git-status() {
	local branch="$(git -C $1 branch --show-current)"
	local color=""

	if  ! git -C $1 diff-files --quiet --ignore-submodules || ! git -C $1 diff-index --cached --quiet --ignore-submodules HEAD --; then
		# uncommitted changes
		color="yellow"
	elif ! git -C $1 diff --quiet origin/${branch}..${branch}; then
		# unpushed commits
		color="brightred"
	fi

	if [[ -n $color ]]; then
		printf "#[fg=${color}]%s#[default] " "$(basename $1)"
	fi
}

function main() {

	pushd $HOME

	pushd .config
	for i in $(find . -maxdepth 2 -type d -name .git)
		check-git-status $(dirname $i)
	popd # .config

	for i in $(find . -maxdepth 2 -type d -name .git)
		check-git-status $(dirname $i)

	popd # $HOME

	printf "#[fg=brightcyan]C:%s#[default] " "$(docker ps --quiet | wc -l)"
	printf "#[fg=brightblack]%s %s#[default]" "$(hostname)" "$(date +'%l:%M%P')"

}

main
