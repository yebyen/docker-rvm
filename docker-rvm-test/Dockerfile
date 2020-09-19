# syntax = docker/dockerfile:experimental
ARG RVM_RUBY_VERSIONS="2.7.1"
FROM kingdonb/docker-rvm-support:20200918-oci8 as test-base
LABEL maintainer="Kingdon Barrett <kingdon.b@nd.edu>"
ENV APPDIR="/home/${RVM_USER}/app"

USER root
# install manpages and a little vim because I might need them
RUN --mount=type=cache,uid=0,gid=0,target=/var/cache/apt/archives/ \
    --mount=type=cache,uid=0,gid=0,target=/var/lib/apt/lists/ \
  apt-get update && apt-get install -y --no-install-recommends \
  manpages vim-tiny runit python3 \
  build-essential nodejs \
  tzdata libpq-dev \
  && apt-get upgrade -y --no-install-recommends \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && bash --login -c 'curl -o- -L https://yarnpkg.com/install.sh | bash'

USER ${RVM_USER}
ENV RUBY=2.7.1
RUN  echo 'gem: --no-document' > /home/${RVM_USER}/.gemrc && rvm ${RUBY} do gem update --system
# USER root
# ENTRYPOINT ["/sbin/my_init", "--"]

# # Example downstream Dockerfile:
FROM test-base as test
#
# # include the ruby-version and Gemfile for bundle install
COPY --chown=rvm Gemfile Gemfile.lock .ruby-version ${APPDIR}/
ENV LD_LIBRARY_PATH /opt/oracle/instantclient_19_8

RUN mkdir -p /home/${RVM_USER}/app/.cache/bundle
RUN bundle config app_config .bundle
RUN bundle config path .cache/bundle
RUN --mount=type=cache,uid=999,gid=1000,target=/home/rvm/app/.cache/bundle \
    rvm ${RUBY} do bundle install && \
      mkdir -p vendor && \
      cp -ar .cache/bundle vendor/bundle
RUN bundle config path vendor/bundle

#
# # include the app source code
# ADD ./ ${APPDIR}
# USER root
# # TODO: lock down permissions (somehow better than this for production)
# RUN chown -R ${RVM_USER} ${APPDIR}
# USER ${RVM_USER}
#
# # If your app uses a different startup routine or entrypoint, set it up here
# CMD  bash --login -c 'bundle exec rails server -b 0.0.0.0'
# EXPOSE 3000

