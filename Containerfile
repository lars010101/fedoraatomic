#ARG FEDORA_MAJOR_VERSION=43

ARG IMAGE_NAME="${IMAGE_NAME:-sway-atomic}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-43}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} 

COPY etc /etc

COPY ublue-firstboot /usr/bin

#add install for gnome-tweaks and gnome-clocks if running silverblue

RUN rpm-ostree override remove firefox firefox-langpacks &&  \
    rpm-ostree install wireguard-tools fail2ban rclone smartmontools iotop distrobox && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    ostree container commit
