NAME =                  kubernetes
VERSION =               latest
VERSION_ALIASES =       1.2.3 1.2 1
TITLE =                 Ubuntu Xenial Kubernetes
DESCRIPTION =           Ubuntu Xenial Kubernetes
DOC_URL =
SOURCE_URL =
VENDOR_URL =
DEFAULT_IMAGE_ARCH =    x86_64


IMAGE_VOLUME_SIZE =     50G
IMAGE_BOOTSCRIPT =      stable
IMAGE_NAME =            kubernetes

## Image tools  (https://github.com/scaleway/image-tools)
all:    docker-rules.mk
docker-rules.mk:
        wget -qO - https://j.mp/scw-builder | bash
-include docker-rules.mk
