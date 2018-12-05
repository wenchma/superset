FROM wenchma/superset:base

MAINTAINER wenchma <mars914@126.com>

# Configure environment
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    HOME=/home/work

WORKDIR $HOME/incubator-superset

COPY ./superset ./superset

USER 0
RUN chown -R work:work $HOME

USER work

RUN cd superset/assets && npm run build

HEALTHCHECK CMD ["curl", "-f", "http://localhost:8088/health"]

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8088
