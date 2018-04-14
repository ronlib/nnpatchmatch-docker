# Use an official Ubuntu runtime as a parent image
FROM kaixhin/torch

# Don't forget to run "xhost local:root" on the host machine

RUN rm -rf /var/lib/apt/lists/* ; \
		apt-get update ; \
		apt-get install libwxbase3.0-dev libwxgtk3.0-dev libwxgtk-media3.0-dev libopencv-dev --no-install-recommends -y ; \
		rm -rf /var/lib/apt/lists/*

RUN luarocks install dpnn ; \
		cd /root ; \
		git clone https://github.com/ronlib/torch-image-completion.git ; \
		git clone https://github.com/ronlib/PatchMatch.git ; \
		git clone https://github.com/pkulchenko/wxlua.git ; \
		cd /root/PatchMatch ; cmake . ; make ; \
		ln -s /root/PatchMatch/libluainpaint.so /root/torch/install/lib/luainpaint.so ; \
		ln -s /root/PatchMatch/libpatchmatch2.so /root/torch/install/lib/libpatchmatch2.so ; \
		ln -s /root/PatchMatch/patch2vec.lua /root/torch-image-completion/patch2vec.lua ; \
		cd /root/wxlua/wxLua ; cmake . -DCMAKE_BUILD_TYPE=Release ; make ; \
		ln -s /root/wxlua/wxLua/lib/Release/libwx.so /root/torch/install/lib/wx.so ; \
		find  /root/ -iname CMakeFiles | xargs rm -rf ; \
		# A fix from the Internet (https://stackoverflow.com/questions/12689304/ctypes-error-libdc1394-error-failed-to-initialize-libdc1394) for an error I encountered
		ln /dev/null /dev/raw1394

WORKDIR /root/torch-image-completion