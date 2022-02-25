FROM quay.io/armosec/kubescape

RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sh

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
