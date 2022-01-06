#!/bin/zsh

#for i in $(find . -maxdepth 2 -type d -name .git); echo $(basename $(dirname $i))

function main() {

	pushd $HOME

	pushd .config
	for i in $(find . -maxdepth 2 -type d -name .git); do
		if [[ -n "$(git -C $(dirname $i) status --porcelain)" ]]; then
			printf "#[fg=brightred]%s#[default] " "$(basename $(dirname $i))"
		fi
	done
	popd # .config

	for i in $(find . -maxdepth 2 -type d -name .git); do
		if [[ -n "$(git -C $(dirname $i) status --porcelain)" ]]; then
			printf "#[fg=brightyellow]%s#[default] " "$(basename $(dirname $i))"
		fi
	done

	popd # $HOME

	printf "#[fg=brightcyan]C:%s#[default] " "$(docker ps --quiet | wc -l)"
	printf "#[fg=brightblack]%s %s#[default]" "$(hostname)" "$(date +'%l:%M%P')"

}

main
