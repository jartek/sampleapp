FROM  ubuntu
WORKDIR /home/app
ONBUILD ADD Gemfile /home/app/Gemfile
