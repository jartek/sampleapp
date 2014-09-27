# Ubuntu version
FROM  ubuntu:14.04

# Install dependencies
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y software-properties-common
RUN apt-get install -y make curl gcc wget openjdk-6-jre
RUN apt-get install -y git
RUN apt-get clean

# Install rvm, ruby, bundler
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.1.0"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

# Publish port 80
EXPOSE 80
