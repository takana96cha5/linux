FROM ubuntu:latest

ARG USERNAME
ARG USER_PASSWORD
ARG SUDO_WITHOUT_PASSWORD

RUN apt update && apt install -y openssh-server sudo && \
    apt clean && rm -rf /var/lib/apt/lists/* && \
    if id "${USERNAME}" &>/dev/null; then \
        usermod -aG sudo ${USERNAME}; \
    else \
        useradd -rm -d /home/${USERNAME} -s /bin/bash -g root -G sudo -u 1000 ${USERNAME}; \
    fi && \
    echo "${USERNAME}:${USER_PASSWORD}" | chpasswd && \
    if [ "${SUDO_WITHOUT_PASSWORD}" = "true" ]; then \
        echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers; \
    fi && \
    mkdir -p /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

CMD ["/usr/sbin/sshd", "-D"]