FROM scaleway/ubuntu:amd64-xenial
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/ubuntu:armhf-xenial       # arch=armv7l
#FROM scaleway/ubuntu:arm64-xenial       # arch=arm64
#FROM scaleway/ubuntu:i386-xenial        # arch=i386
#FROM scaleway/ubuntu:mips-xenial        # arch=mips

# Prepare rootfs
RUN /usr/local/sbin/scw-builder-enter

# Add your commands here (before scw-builder-leave and after scw-builder-enter)
RUN apt-get update && apt-get install -y -qq apt-transport-https
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update && apt-get install -y -qq docker-engine kubectl kubelet
RUN apt-get download kubeadm
RUN dpkg --unpack kubeadm*.deb
RUN rm /var/lib/dpkg/info/kubeadm.postinst -f
RUN dpkg --configure kubeadm
RUN apt-get install -yf

# Clean rootfs
RUN /usr/local/sbin/scw-builder-leave
