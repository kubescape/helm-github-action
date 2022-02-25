FROM alpine/helm as helm

FROM quay.io/armosec/kubescape

COPY --from=helm /usr/bin/helm /usr/bin/helm

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
