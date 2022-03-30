FROM alpine/helm as helm

FROM quay.io/armosec/kubescape

USER root

COPY --from=helm /usr/bin/helm /usr/bin/helm

ENTRYPOINT ["/entrypoint.sh"]
