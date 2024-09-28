FROM jenkins/inbound-agent:latest

USER root

RUN apt-get update && apt-get install -y lsb-release

# WORKAROUND FOR MACOS
#RUN apt-get update && \
#    apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
#    install -m 0755 -d /etc/apt/keyrings && \
#    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
#    chmod a+r /etc/apt/keyrings/docker.asc && \
#    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#      jammy stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
#    apt-get update
#
#RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# WORKAROUND FOR MACOS

RUN usermod -u 1001 jenkins && groupmod -g 1001 jenkins

RUN groupadd -g 986 docker && usermod -aG docker jenkins

USER jenkins
