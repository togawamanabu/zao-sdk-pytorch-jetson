FROM nvcr.io/nvidia/l4t-pytorch:r32.7.1-pth1.10-py3

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 42D5A192B819C5DA

RUN apt update && apt upgrade -y
#RUN apt install python3-opencv -y
RUN apt install -y libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav 
RUN apt install -y gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio
RUN apt install -y python3-gst-1.0 python3-gi
RUN apt install -y nodejs-dev node-gyp libssl1.0-dev 
RUN apt install -y npm
RUN apt install -y python3-smbus && pip3 install pyzmq

# opencv

COPY jetson-ota-public.asc /etc/apt/trusted.gpg.d/jetson-ota-public.asc
RUN echo "deb https://repo.download.nvidia.com/jetson/common r32.4 main" > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
            libopencv-python \
    && rm /etc/apt/sources.list.d/nvidia-l4t-apt-source.list \
    && rm -rf /var/lib/apt/lists/*

# gstreamer
RUN apt-get update && \
    apt-get install -y \
    libwayland-egl1 \
    gstreamer1.0-plugins-bad \
    libgstreamer-plugins-bad1.0-0 \
    gstreamer1.0-plugins-good \
    python3-gst-1.0

# misc
RUN apt-get update && apt-get install -y supervisor unzip zip
RUN apt install -y python3-smbus && pip3 install pyzmq


RUN npm install -y -g n
RUN n 12

RUN pip3 install --upgrade pip
RUN pip3 install jupyterlab
RUN pip3 install ipywidgets
RUN pip3 install sparkfun-qwiic Adafruit_MotorHat Adafruit-SSD1306
RUN pip3 install pyserial
RUN pip3 install numpy
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN pip3 install pyserial-asyncio

# jupyter clickable image widget
RUN apt-get install -y libssl1.0-dev && \
    git clone https://github.com/jaybdub/jupyter_clickable_image_widget && \
    cd jupyter_clickable_image_widget && \
    git checkout tags/v0.1 && \
    pip3 install -e . && \
    jupyter labextension install js && \
    jupyter lab build

ENV PYTHONPATH="${PYTHONPATH}:/jetbot"

WORKDIR /jetbot

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root"]

# sudo docker build -t zao_sdk_jetbot .