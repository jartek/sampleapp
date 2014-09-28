# Ubuntu version
FROM  ubuntu:14.04

# Install dependencies
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y software-properties-common build-essential
RUN apt-get install -y wget links curl rsync bc git git-core apt-transport-https libxml2 libxml2-dev
RUN apt-get install -y libcurl4-openssl-dev openssl gawk libreadline6-dev libyaml-dev autoconf libgdbm-dev
RUN apt-get install -y git libncurses5-dev automake libtool bison libffi-dev

# Supervisord
RUN apt-get install -y openssh-server apache2 supervisor

# Nginx
RUN apt-get install -y nginx

# Node
RUN apt-get install -y nodejs npm

RUN apt-get clean

# Install rvm, ruby, bundler
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.1.0"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN /bin/bash -l -c "rvm info"
RUN /bin/bash -l -c "bundle -v"

# Install supervisord
COPY ./config/docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

# Install nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD ./config/docker/nginx.conf /etc/nginx/sites-enabled/default

# Publish port 80
EXPOSE 80

# Add rails project to project directory
ONBUILD ADD Gemfile /home/app/Gemfile
ONBUILD ADD Gemfile.lock /home/app/Gemfile.lock
ONBUILD RUN bundle install --without development test

ADD ./ /home/app

# set WORKDIR
WORKDIR /home/app

ENV RAILS_ENV production
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Start supervisord when container starts
ENTRYPOINT /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
