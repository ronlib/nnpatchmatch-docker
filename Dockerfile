# Use an official Ubuntu runtime as a parent image
FROM kaixhin/torch

# Don't forget to run "xhost local:root" on the host machine

RUN luarocks install dpnn
RUN apt update
RUN apt-get install libwxbase3.0-dev libwxgtk3.0-dev libwxgtk-media3.0-dev libopencv-dev -y

WORKDIR /root

RUN git clone https://github.com/ronlib/torch-image-completion.git

RUN git clone https://github.com/ronlib/PatchMatch.git
WORKDIR /root/PatchMatch
RUN cmake .
RUN make
RUN ln -s /root/PatchMatch/libluainpaint.so /root/torch/install/lib/luainpaint.so
RUN ln -s /root/PatchMatch/patch2vec.lua /root/torch-image-completion/patch2vec.lua
WORKDIR /root

RUN git clone https://github.com/pkulchenko/wxlua.git
WORKDIR /root/wxlua/wxLua
RUN cmake .
RUN make
RUN ln -s /root/wxlua/wxLua/lib/Debug/libwx.so /root/torch/install/lib/wx.so
WORKDIR /root

# A fix from the Internet (https://stackoverflow.com/questions/12689304/ctypes-error-libdc1394-error-failed-to-initialize-libdc1394) for an error I encountered
ln /dev/null /dev/raw1394
