FROM  jartek/sample
WORKDIR /home/app
ONBUILD ADD Gemfile /home/app/Gemfile
