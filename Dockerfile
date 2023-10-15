FROM accetto/ubuntu-vnc-xfce-chromium-g3

USER root

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y apt-utils apt-transport-https software-properties-common gnupg curl iputils-ping vim libnss3-tools ssh git unzip && \
    apt-get update


# Set the timezone non-interactively
ENV TZ=Your_Timezone_Here
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Get Onyxia init script
RUN wget https://raw.githubusercontent.com/InseeFrLab/images-datascience/main/scripts/onyxia-init.sh -O /opt/onyxia-init.sh && \
    chmod +x /opt/onyxia-init.sh

##### Extension JsonViewer pour chromium
RUN touch /etc/chromium-browser/policies/managed/test_policy.json && \
    echo "{\"ExtensionInstallForcelist\": [\"aimiinbnnkboelefkjlenlgimcabobli;https://clients2.google.com/service/update2/crx\"]}" > /etc/chromium-browser/policies/managed/test_policy.json

# Installing mc

RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc


# Installing vault

RUN cd /usr/bin && \
    wget https://releases.hashicorp.com/vault/1.8.2/vault_1.8.2_linux_amd64.zip && \
    unzip vault_1.8.2_linux_amd64.zip && \
    rm vault_1.8.2_linux_amd64.zip
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

# Installing DBeaver
RUN add-apt-repository ppa:serge-rider/dbeaver-ce && \
    apt-get update  && \
    apt-get install dbeaver-ce

# Installing QGIS
RUN mkdir -m755 -p /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg && \
    apt-get update && \
    apt-get install -y qgis qgis-plugin-grass
    
# Clean
RUN apt-get clean && \
    apt -y autoremove && \
    rm -rf /var/lib/apt/lists/*    

## Allow sudo without password
RUN echo "headless     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

## Remove desktop shortcut 
RUN rm /home/headless/Desktop/versionsticker.desktop

## Full size by default
RUN sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'remote');/g" /usr/libexec/noVNCdim/app/ui.js

# Keep the connection alive to prevent timeouts
ENV NOVNC_HEARTBEAT=30

USER headless

RUN mkdir /home/headless/work
WORKDIR /home/headless/work
