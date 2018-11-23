FROM python:3.6

MAINTAINER wenchma <mars914@126.com>

# Add a normal user
RUN useradd --user-group --create-home --shell /bin/bash work

# Configure environment
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    HOME=/home/work

RUN apt-get update -y

# Install some dependencies
# http://airbnb.io/superset/installation.html#os-dependencies
RUN apt-get update -y && apt-get install -y build-essential libssl-dev \
    libffi-dev python3-dev libsasl2-dev libldap2-dev libxi-dev

RUN apt-get install -y vim less postgresql-client redis-tools

# Install nodejs for custom build
# https://github.com/apache/incubator-superset/blob/master/docs/installation.rst#making-your-own-build
# https://nodejs.org/en/download/package-manager/
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list; \
    apt-get update; \
    apt-get install -y yarn

RUN curl https://codeload.github.com/wenchma/Flask-CAS/tar.gz/internal -o $HOME/Flask-CAS.tar.gz
RUN tar -zxvf $HOME/Flask-CAS.tar.gz -C $HOME
RUN cd $HOME/Flask-CAS-internal && python setup.py install

RUN mkdir $HOME/incubator-superset
