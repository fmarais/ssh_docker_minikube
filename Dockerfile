#FROM alpine:3.5
FROM nginx:stable-alpine

MAINTAINER Francois Marais <fm.marais@gmail.com>

### start copy
RUN apk --update add --no-cache openssh bash \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:root" | chpasswd \
  && rm -rf /var/cache/apk/*

RUN sed -ie 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
RUN sed -ri 's/#HostKey \/etc\/ssh\/ssh_host_key/HostKey \/etc\/ssh\/ssh_host_key/g' /etc/ssh/sshd_config
RUN sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/etc\/ssh\/ssh_host_rsa_key/g' /etc/ssh/sshd_config
RUN sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_dsa_key/HostKey \/etc\/ssh\/ssh_host_dsa_key/g' /etc/ssh/sshd_config
RUN sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g' /etc/ssh/sshd_config
RUN sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/etc\/ssh\/ssh_host_ed25519_key/g' /etc/ssh/sshd_config

RUN /usr/bin/ssh-keygen -A
RUN ssh-keygen -t rsa -b 4096 -f  /etc/ssh/ssh_host_key

EXPOSE 22 
### end copy

# remember you need to start the ssh server if manually you did not copy this
# start ssh server on minikube using
# > kubectl exec my-pod-name-here-123ff2123-1123 /usr/sbin/sshd -D
CMD ["/usr/sbin/sshd","-D"]

# Installation info
# navigate to Dockerfile
# > docker build -t ssh_test1 .
# > docker images (view newly created)
# > docker run -d -p 2222:22 ssh_test1
# > docker ps -a (view started container process)
# connect to docker image
# > ssh root@localhost -p 2222
# possibly remove the line [localhost]:2222 from ~/.ssh/known_hosts if required, and retry connecting
# password: root
