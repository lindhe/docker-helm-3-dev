FROM golang AS builder
# Install Git and Glide
RUN apt-get update && apt-get install -y git golang-glide
# Install dep
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
# Clone and build Helm 3
RUN git clone https://github.com/helm/helm.git /go/src/helm.sh/helm
WORKDIR /go/src/helm.sh/helm/
RUN git checkout dev-v3
RUN make
# When make is done, the path to the binary is /go/src/helm.sh/helm/bin/helm

FROM alpine
RUN apk update && apk add libc6-compat
COPY --from=builder /go/src/helm.sh/helm/bin/helm /usr/local/bin/
USER nobody
ENTRYPOINT ["/usr/local/bin/helm"]

