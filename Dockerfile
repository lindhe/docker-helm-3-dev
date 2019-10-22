FROM golang AS builder
# Clone and build Helm 3
RUN git clone --branch master --depth 1 https://github.com/helm/helm.git /go/src/helm.sh/helm
WORKDIR /go/src/helm.sh/helm/
RUN make
# When make is done, the path to the binary is /go/src/helm.sh/helm/bin/helm

FROM alpine
RUN apk update && apk add libc6-compat
COPY --from=builder /go/src/helm.sh/helm/bin/helm /usr/local/bin/
USER nobody

