FROM inseefrlab/ubuntu-vnc
USER root
# Install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io
RUN mkdir -p /etc/docker && echo "{ \"storage-driver\": \"vfs\"}" > /etc/docker/daemon.json
USER headless
RUN curl -o dind https://raw.githubusercontent.com/moby/moby/master/hack/dind && chmod +x dind