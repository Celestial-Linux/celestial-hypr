## 1. BUILD ARGS
# See list here: https://github.com/orgs/ublue-os/packages?repo_name=main
ARG SOURCE_IMAGE="base"

## SOURCE_SUFFIX arg should include a hyphen and the appropriate suffix name
# These examples all work for silverblue/kinoite/sericea/onyx/lazurite/vauxite/base
# - "-main"
# - "-nvidia"
# - "-asus"
# - "-asus-nvidia"
# - "-surface"
# - "-surface-nvidia"
ARG SOURCE_SUFFIX="-main"

## SOURCE_TAG arg must be a version built for the specific image: eg, 39, 40, gts, latest
ARG SOURCE_TAG="latest"


### 2. SOURCE IMAGE
## this is a standard Containerfile FROM using the build ARGs above to select the right upstream image
FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG}


### 3. MODIFICATIONS
COPY scripts/build.sh /tmp/build.sh
COPY scripts/remove_unprofessional_wallpapers.sh /tmp/remove_unprofessional_wallpapers.sh

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    /tmp/remove_unprofessional_wallpapers.sh && \
    ostree container commit
## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit
