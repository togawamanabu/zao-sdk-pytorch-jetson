sudo docker run -it --rm \
--runtime nvidia \
--network host \
--privileged \
-v /home/jetson/jetbot:/jetbot \
--volume /dev/bus/usb:/dev/bus/usb \
--volume /tmp/argus_socket:/tmp/argus_socket \
--volume /run/zao/ttyZAOV1:/run/zao/ttyZAOV1 \
--device=/dev/i2c-1 \
--device=/dev/video* \
--device=/run/zao/ttyZAOV1 \
zao_sdk_jetbot