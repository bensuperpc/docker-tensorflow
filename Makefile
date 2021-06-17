#//////////////////////////////////////////////////////////////
#//   ____                                                   //
#//  | __ )  ___ _ __  ___ _   _ _ __   ___ _ __ _ __   ___  //
#//  |  _ \ / _ \ '_ \/ __| | | | '_ \ / _ \ '__| '_ \ / __| //
#//  | |_) |  __/ | | \__ \ |_| | |_) |  __/ |  | |_) | (__  //
#//  |____/ \___|_| |_|___/\__,_| .__/ \___|_|  | .__/ \___| //
#//                             |_|             |_|          //
#//////////////////////////////////////////////////////////////
#//                                                          //
#//  Script, 2021                                            //
#//  Created: 17, June, 2021                                 //
#//  Modified: 17, June, 2021                                //
#//  file: -                                                 //
#//  -                                                       //
#//  Source:                                                 //
#//															 //
#//  OS: ALL                                                 //
#//  CPU: ALL                                                //
#//                                                          //
#//////////////////////////////////////////////////////////////
BASE_IMAGE := tensorflow/tensorflow
IMAGE_NAME := bensuperpc/tensorflow
DOCKERFILE := Dockerfile

DOCKER := docker

TAG := $(shell date '+%Y%m%d')-$(shell git rev-parse --short HEAD)
DATE_FULL := $(shell date -u "+%Y-%m-%dT%H:%M:%SZ")
UUID := $(shell cat /proc/sys/kernel/random/uuid)
VERSION := 1.0.0

VERSION_LIST := latest latest-devel latest-jupyter devel latest-gpu latest-devel-gpu latest-gpu-jupyter devel-gpu \
	2.5.0 2.5.0-jupyter 2.5.0-gpu 2.5.0-gpu-jupyter 1.15.5 1.15.5-jupyter 1.15.5-gpu 1.15.5-gpu-jupyter

$(VERSION_LIST): $(DOCKERFILE)
	$(DOCKER) build . -f $(DOCKERFILE) -t $(IMAGE_NAME):$@ \
	--build-arg BUILD_DATE=$(DATE_FULL) --build-arg DOCKER_IMAGE=$(BASE_IMAGE):$@ \
	--build-arg VERSION=$(VERSION)

all: $(VERSION_LIST)

push:
	$(DOCKER) push $(IMAGE_NAME) --all-tags

clean:
	$(DOCKER) images --filter='reference=$(IMAGE_NAME)' --format='{{.Repository}}:{{.Tag}}' | xargs -r $(DOCKER) rmi -f

.PHONY: build push clean qemu $(ARCH_LIST)
