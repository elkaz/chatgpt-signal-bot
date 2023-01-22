FROM ubuntu:20.04
ENV VERSION=0.11.6

RUN apt-get update \
    && apt-get install -y --no-install-recommends openjdk-17-jre zip curl wget haveged python3 pip \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/AsamK/signal-cli/releases/download/v"${VERSION}"/signal-cli-"${VERSION}"-Linux.tar.gz \
    && wget https://github.com/exquo/signal-libs-build/releases/download/libsignal-client_v0.21.1/libsignal_jni.so-v0.21.1-x86_64-unknown-linux-gnu.tar.gz

RUN tar xf signal-cli-"${VERSION}"-Linux.tar.gz -C /opt \
    && ln -sf /opt/signal-cli-"${VERSION}"/bin/signal-cli /usr/local/bin/ \
    && tar xf libsignal_jni.so-v0.21.1-x86_64-unknown-linux-gnu.tar.gz \
    && mv libsignal_jni.so /opt/signal-cli-"${VERSION}"/lib \
    && zip -d /opt/signal-cli-"${VERSION}"/lib/libsignal-client-*.jar libsignal_jni.so \
    && tar xf libsignal_jni.so-v0.21.1-x86_64-unknown-linux-gnu.tar.gz \
    && zip /opt/signal-cli-"${VERSION}"/lib/libsignal-client-*.jar libsignal_jni.so

RUN pip install openai

ARG ACCOUNT=
ENV ACCOUNT="${ACCOUNT}"
ARG RECIPIENT=
ENV RECIPIENT="${RECIPIENT}"
ARG OPENAI_API_KEY=
ENV OPENAI_API_KEY="${OPENAI_API_KEY}"

COPY verify.sh .
COPY main.py .
CMD ["sh", "verify.sh"]