alias dpsa="docker ps -a"
alias di="docker inspect"

function dexb {
	docker exec -it $1 su -
}

function dsrm {
	docker stop "$@" && docker rm -v "$@"
	if [ -f "about/$@" ]; then
		rm "about/$@"
	fi
}
