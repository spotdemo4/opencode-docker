LABEL org.opencontainers.image.source="https://github.com/spotdemo4/opencode-docker"
ARG ARCH=amd64
FROM ${ARCH}/debian:stable-slim
COPY ./opencode /opencode
ENTRYPOINT ["/opencode"]
CMD ["serve"]
