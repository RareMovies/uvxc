FROM aicampbell/vnc-ubuntu18-xfce

USER root

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y apt-utils apt-transport-https software-properties-common curl iputils-ping vim leafpad libnss3-tools && \
    apt-get update

##### Extension JsonViewer pour chromium
RUN touch /etc/chromium-browser/policies/managed/test_policy.json && \
    echo "{\"ExtensionInstallForcelist\": [\"aimiinbnnkboelefkjlenlgimcabobli;https://clients2.google.com/service/update2/crx\"]}" > /etc/chromium-browser/policies/managed/test_policy.json

# Installing mc

RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc


# Installing vault

RUN apt-get install -y unzip
RUN cd /usr/bin && \
    wget https://releases.hashicorp.com/vault/1.3.4/vault_1.3.4_linux_amd64.zip && \
    unzip vault_1.3.4_linux_amd64.zip && \
    rm vault_1.3.4_linux_amd64.zip
RUN vault -autocomplete-install

# Installing kubectl

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl
RUN apt-get install bash-completion

# Installing helm

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh
    
##### Clean
RUN apt-get clean && \
    apt -y autoremove && \
    rm -rf /var/lib/apt/lists/*

##### Changer fond d'écran

ADD wallpaper.png /headless/.config/bg_sakuli.png
