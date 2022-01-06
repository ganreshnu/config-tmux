#!/bin/zsh

function check-git-status() {
	local branch="$(git -C $1 branch --show-current)"
	local style=""

	if ! git -C $1 diff-files --quiet --ignore-submodules; then
		# unstaged changes
		style="fg=yellow,italics"
	elif ! git -C $1 diff-index --cached --quiet --ignore-submodules HEAD 2>/dev/null; then
		# uncommitted changes
		style="fg=yellow"
	elif ! git -C $1 diff --quiet origin 2>/dev/null; then
		# unpushed commits
		style="fg=brightred,italics"
	fi

	if [[ -n $style ]]; then
		local name=$(basename $1)
		printf "#[${style}]%s#[default] " "$(basename $1)"
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
