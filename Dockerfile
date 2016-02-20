FROM buildpack-deps:wily-scm

RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ wily main restricted universe multiverse'            > /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ wily-security main restricted universe multiverse'  >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ wily-updates main restricted universe multiverse'   >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ wily-proposed main restricted universe multiverse'  >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ wily-backports main restricted universe multiverse' >> /etc/apt/sources.list

# gcc for cgo
RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
        gcc \
        libc6-dev \
        make \
    && rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.6
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 5470eac05d273c74ff8bac7bef5bad0b5abbd1c4052efbdbc8db45332e836b0b

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/
