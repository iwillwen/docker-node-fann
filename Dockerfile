FROM node:onbuild

RUN apt-get update
RUN apt-get install -y cmake pkg-config libglib2.0-dev make gcc g++
RUN wget http://78rc4m.com1.z0.glb.clouddn.com/fann1.tar.gz
RUN tar xvzf fann1.tar.gz
RUN cd FANN-2.2.0-Source && cmake .
RUN make -C FANN-2.2.0-Source/ install
RUN ln -s /usr/local/lib/libfann.so.2 /usr/lib/libfann.so.2
RUN cd bin && chmod +x predict