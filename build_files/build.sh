#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

dnf5 -y install dnf5-plugins
dnf5 -y install zstd

dnf5 -y config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf5 -y install tailscale

# this installs a package from fedora repos

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl disable docker.socket

sed -i '/^PRETTY_NAME/s/"$/-resna2 (Resna2 Core)"/' /usr/lib/os-release
sed -i '/^VERSION/s/ (CoreOS)"$/-resna2 (Resna2 Core)"/' /usr/lib/os-release
sed -i 's|^VARIANT_ID=.*|VARIANT_ID=damillora-resna2|' /usr/lib/os-release
sed -i 's|^VARIANT=.*|VARIANT="Resna2 Core"|' /usr/lib/os-release
sed -i "/^OSTREE_VERSION/s/'$/-resna2'/" /usr/lib/os-release
