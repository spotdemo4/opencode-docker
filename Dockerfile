ARG ARCH=amd64
FROM ${ARCH}/debian:stable-slim
COPY ./opencode /opencode
ENTRYPOINT ["/opencode"]
CMD ["serve", "--print-logs", "--port", "4096", "--hostname", "0.0.0.0"]
