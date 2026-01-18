#ARG FEDORA_MAJOR_VERSION=43

ARG IMAGE_NAME="${IMAGE_NAME:-sway-atomic}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-43}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} 

COPY etc /etc

COPY ublue-firstboot /usr/bin

#add install for gnome-tweaks and gnome-clocks if running silverblue

RUN rpm-ostree override remove firefox firefox-langpacks &&  \
    rpm-ostree install wireguard-tools fail2ban rclone smartmontools iotop qutebrowser gh && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer 

# Sway: Auto-unlock GNOME Keyring (no prompts for Edge, Chrome, VPN, etc.)
RUN printf '%s\n' \
    'auth       optional      pam_gnome_keyring.so' \
    'session    optional      pam_gnome_keyring.so auto_start' \
    'password   optional      pam_gnome_keyring.so' >> /etc/pam.d/login && \
    mkdir -p /etc/skel/.local/share/keyrings && \
    echo -n "" > /etc/skel/.local/share/keyrings/default && \
    ostree container commit

# Sway: Add low battery check notification pop-up since waybar is hidden
# RUN systemctl enable low-battery-check.timer
