#!/bin/sh

RED="\033[0;31m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color


if [ -f /.dockerenv ]; then
	echo
	echo -e "${GREEN}>> RUNNING INSIDE DOCKER <<${NC}"
	echo

	apk update
	echo -e "${BLUE}-- ${YELLOW}Installing packages${NC}"
	apk add git go musl-dev npm nodejs gcc
	echo -e "${GREEN}Building Wizard${NC}"
	cd /go && PATH="/root/go/bin/:${PATH}" ./wizard.sh -b
	#cd /go && ./wizard.sh -c
	#echo -e "${BLUE}-- ${YELLOW}Getting project${NC}"
	#go get -v github.com/hacdias/filemanager

	#echo -e "${BLUE}-- ${YELLOW}Getting dependencies${NC}"
	#cd $HOME/go/src/github.com/hacdias/filemanager
	#go get -v ./...

	#echo -e "${BLUE}-- ${YELLOW}Compiling${NC}"
	#cd $HOME/go/src/github.com/hacdias/filemanager/cmd/filemanager
	#CGO_ENABLED=0 go build -a -v

	echo -e "${BLUE}-- ${YELLOW}Copying executables${NC}"
	mv * /go/

else
	echo
	echo -e "${BLUE}-- ${YELLOW}Starting compilation inside docker${NC}"
	echo "-- Running command:"
	echo "-- docker run -it -v $PWD:/go:rw i386/alpine /go/build-filemanager.sh"
	echo
	docker run -it -v $PWD:/go:rw alpine /go/build-filemanager.sh

	echo
	echo -e "${GREEN}>> RUNNING OUTSIDE DOCKER <<${NC}"
	echo

	echo -e "${RED}CAUTION: THIS ACTION IS IRREVERSIBLE!!${NC}"
	echo "This will remove all containers and images!"
	#read -r -p "Do you want to clean docker (yes/NO)? " cleanans
	#if [ "$cleanans" == "yes" ]; then
#		echo
#		echo -e "${BLUE}-- ${YELLOW}Removing containers${NC}"
#		for i in $(docker ps -aq); do docker stop $i; docker rm $i; done
#		echo
#		echo -e "${BLUE}-- ${YELLOW}Removing images${NC}"
#		for i in $(docker images -aq); do docker rmi $i; done
#
#		echo
#		echo -e "${BLUE}-- ${YELLOW}Pruning volumes${NC}"
#		docker volume prune
#	fi
fi
