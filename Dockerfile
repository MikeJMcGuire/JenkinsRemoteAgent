FROM jenkins/ssh-agent:latest-debian-jdk25

RUN apt-get update && apt-get install -y gnupg2 curl ca-certificates wget

RUN groupadd -g 900 docker && usermod -aG docker jenkins

COPY *.crt /usr/local/share/ca-certificates

RUN update-ca-certificates

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN install -m 0755 -d /etc/apt/keyrings && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
  chmod a+r /etc/apt/keyrings/docker.asc

RUN tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

RUN apt-get update && apt install docker-ce-cli && \
  rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["setup-sshd"]
