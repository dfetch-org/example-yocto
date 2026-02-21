# Internal Makefile for maintaining and testing the project.

SHELL=bash

DFETCH=dfetch

.PHONY: add
add:
	mkdir -p sources
	cd sources && $(DFETCH) add https://git.yoctoproject.org/poky -r refs/heads/scarthgap
	cd sources && $(DFETCH) add https://git.openembedded.org/meta-openembedded -r refs/heads/scarthgap
	cd sources && $(DFETCH) add https://git.yoctoproject.org/meta-raspberrypi -r refs/heads/scarthgap
	git commit -m "add layers"


.PHONY: create
create:
	. sources/poky/oe-init-build-env ; \
		bitbake-layers create-layer ../sources/meta-mylayer && \
		bitbake-layers add-layer ../sources/meta-mylayer && \
		git add ../sources/meta-mylayer && \
		git commit -m "add own layer"

.PHONY: save
save:
	. sources/poky/oe-init-build-env ; \
		bitbake-layers save-build-conf ../sources/meta-mylayer/ myconf && \
		git add ../sources/meta-mylayer/conf/templates/myconf/ && \
		git commit -m "add my template"

.PHONY: add-layers
add-layers:
	. sources/poky/oe-init-build-env ; \
		bitbake-layers add-layer ../sources/meta-openembedded/meta-oe && \
		bitbake-layers add-layer ../sources/meta-openembedded/meta-python && \
		bitbake-layers add-layer ../sources/meta-raspberrypi

.PHONY: build
build:
	. sources/poky/oe-init-build-env ; \
		bitbake my-image

.PHONY: update
update:
	$(DFETCH) update sources/poky
	$(DFETCH) update sources/meta-openembedded
	$(DFETCH) update sources/meta-raspberrypi


.PHONY: upgrade
upgrade:
	$(DFETCH) update -f sources/poky
	$(DFETCH) update -f sources/meta-openembedded
	$(DFETCH) update -f sources/meta-raspberrypi
