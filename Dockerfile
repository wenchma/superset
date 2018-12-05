FROM python:3.6

RUN useradd --user-group --create-home --no-log-init --shell /bin/bash work

# Configure environment
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Install superset dependencies
# https://superset.incubator.apache.org/installation.html#os-dependencies
RUN apt-get update -y && apt-get install -y build-essential libssl-dev \
    libffi-dev python3-dev libsasl2-dev libldap2-dev libxi-dev \
    vim less postgresql-client redis-tools

# Install nodejs for custom build
# https://superset.incubator.apache.org/installation.html#making-your-own-build
# https://nodejs.org/en/download/package-manager/
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs

# https://yarnpkg.com/lang/en/docs/install/#debian-stable
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn

WORKDIR /home/work

COPY ./ ./

RUN pip install --upgrade setuptools pip \
    && pip install -e . && pip install -r requirements-dev.txt \
    && rm -rf /root/.cache/pip

USER 0
RUN curl https://codeload.github.com/wenchma/Flask-CAS/tar.gz/internal -o /home/work/Flask-CAS.tar.gz \
    && tar -zxvf /home/work/Flask-CAS.tar.gz -C /home/work \
    && cd /home/work/Flask-CAS-internal \
    && python setup.py install \
    && cd /home/work \
    && rm -rf Flask-CAS*

USER work

COPY --chown=work:work superset superset

ENV PATH=/home/work/superset/bin:$PATH \
    PYTHONPATH=/home/work/superset/:$PYTHONPATH

RUN cd superset/assets \
    && yarn \
    && yarn run build \
    && yarn cache clean

COPY docker-init.sh .
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

HEALTHCHECK CMD ["curl", "-f", "http://localhost:8088/health"]

EXPOSE 8088