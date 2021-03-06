FROM buildpack-deps:jessie

# Install FANN v2.2.0
RUN apt-get update
RUN apt-get install -y cmake pkg-config libglib2.0-dev wget make gcc g++ git python tree libssl-dev lsof
RUN wget http://78rc4m.com1.z0.glb.clouddn.com/fann1.tar.gz
RUN tar xvzf fann1.tar.gz
RUN cd FANN-2.2.0-Source && cmake .
RUN make -C FANN-2.2.0-Source/ install
RUN ln -s /usr/local/lib/libfann.so.2 /usr/lib/libfann.so.2

# Install alinode v1.1.0 (node 4.2.2)
ENV HOME /root
ENV ALINODE_VERSION 1.1.0
ENV TNVM_DIR /root/.tnvm
RUN mkdir /tmp/node_log

RUN wget -qO- https://raw.githubusercontent.com/aliyun-node/tnvm/master/install.sh | bash

COPY docker-entrypoint.sh /
RUN bash /docker-entrypoint.sh

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN source ~/.bashrc && \
    tnvm install "alinode-v$ALINODE_VERSION" && \
    tnvm use "alinode-v$ALINODE_VERSION" && \
    npm install -g agentx
RUN git clone https://github.com/aliyun-node/commands.git /usr/local/src/alinode_commands

RUN apt-get remove -y cmake pkg-config libglib2.0-dev make gcc g++ && \
    apt-get autoremove -y && \
    apt-get autoclean -y
