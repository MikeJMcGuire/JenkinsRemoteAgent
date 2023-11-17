FROM jenkins/ssh-agent:latest-debian-jdk11

RUN apt-get update && apt-get install -y gnupg2

RUN groupadd -g 998 docker && usermod -aG docker jenkins

COPY *.crt /usr/local/share/ca-certificates

RUN update-ca-certificates

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN apt-key adv --fetch-keys https://download.docker.com/linux/debian/gpg && \
  echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(grep "VERSION_CODENAME=" /etc/os-release | awk -F= {' print $2'} | sed s/\"//g) stable" >> /etc/apt/sources.list && \
  apt-get update && apt-get -y upgrade && apt-get install -y docker-ce-cli wget && \
  rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["setup-sshd"]
