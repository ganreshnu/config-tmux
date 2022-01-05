#!/bin/zsh

function main() {


	pushd $HOME
	if [[ -n "$(git -C .gnupg status --porcelain)" ]]; then
		printf "#[fg=red]%s#[default] " "gnupg"
	fi
	if [[ -n "$(git -C .ssh status --porcelain)" ]]; then
		printf "#[fg=red]%s#[default] " "openssh"
	fi

	pushd .config
	for i in $(ls); do
		if [[ -n "$(git -C $i status --porcelain)" ]]; then
			printf "#[fg=red]%s#[default] " $i
		fi
	done
	popd # .config
	popd # $HOME

	printf "#[fg=yellow]%s#[default]%s" "$(hostname)" "$(date +'%l:%M%P')"

}

main
