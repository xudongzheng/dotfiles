alias dim="docker images"
alias din="docker inspect"
alias dpsa="docker ps -a"

function dexb {
	docker exec -it $1 su -
}

function dsrm {
	docker stop "$@" && docker rm -v "$@"
	if [[ -f "about/$@" ]]; then
		rm "about/$@"
	fi
}
