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
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

# Cleaning
WORKDIR /etc/nginx
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Docker settings
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/conf.d", "/var/log/nginx"]
EXPOSE 80 443
CMD ["nginx"]

