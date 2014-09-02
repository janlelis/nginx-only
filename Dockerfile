# # #
# nginx Dockerfile
# # #

FROM ubuntu:trusty
ENV DEBIAN_FRONTEND noninteractive

# Ensure locale
RUN apt-get -y update
RUN dpkg-reconfigure locales && \
  locale-gen en_US.UTF-8 && \
  /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Essential packages
RUN apt-get -y update
RUN apt-get -y install wget build-essential git

# Install and adjust nginx
RUN \
  apt-get -y install software-properties-common && \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get -y update && \
  apt-get -y install nginx && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

# Make overwriting main config easier
RUN mkdir /etc/nginx/from-docker
RUN mv /etc/nginx/nginx.conf /etc/nginx/from-docker/nginx.conf

# Cleaning
WORKDIR /etc/nginx
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Docker settings
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/from-docker", "/var/log/nginx"]
EXPOSE 80 443
CMD ["nginx", "-c", "/etc/nginx/from-docker/nginx.conf"]

