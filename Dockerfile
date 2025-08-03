ARG ARCH=amd64
FROM ${ARCH}/debian:stable-slim
COPY ./opencode /opencode
ENTRYPOINT ["/opencode"]
CMD ["serve"]
