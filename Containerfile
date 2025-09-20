FROM quay.io/fedora/fedora-bootc:latest

# -- Package installation --
## Enable RPM Fusion repositories
## https://rpmfusion.org/
RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

ENV BASE_PKG="tmux unzip vim htop qemu-guest-agent @container-management @hardware-support zsh rsync"
RUN dnf install -y ${BASE_PKG} && \
    dnf clean all

# -- User setup --
ARG USERNAME
ARG PASSWORD

RUN groupadd -g 1000 ${USERNAME} \
    && useradd -m -u 1000 -g 1000 -G wheel -s /bin/zsh -K MAIL_DIR=/dev/null ${USERNAME} \
    && echo "${USERNAME}:${PASSWORD}" | chpasswd \
    && mkdir -p /home/${USERNAME} \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME} \
    && chmod 700 /home/${USERNAME}

# -- Finalize container setup --
RUN bootc container lint
