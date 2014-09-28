# Ubuntu version
FROM  ubuntu:14.04

# Install dependencies
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y software-properties-common
RUN apt-get install -y make curl gcc wget
RUN apt-get install -y git
RUN apt-get clean

# Install rvm, ruby, bundler
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.1.0"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

# Install Supervisord
RUN apt-get install -y openssh-server apache2 supervisor
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor
COPY ./config/docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install nginx
RUN apt-get install -y nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD ./config/docker/nginx.conf /etc/nginx/sites-enabled/default

# Publish port 80
EXPOSE 80

# Start supervisord when container starts
# ENTRYPOINT /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
ENTRYPOINT /usr/sbin/nginx

# Add rails project to project directory
ONBUILD ADD Gemfile /home/app/Gemfile
ONBUILD ADD Gemfile.lock /home/app/Gemfile.lock
ONBUILD RUN bundle install --without development test

ADD ./ /home/app

# set WORKDIR
WORKDIR /home/app

ENV RAILS_ENV production

# Compile assets and start unicorn
CMD bundle exec unicorn -p 4000 -c ./config/unicorn.rb
