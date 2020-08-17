# syntax = docker/dockerfile:experimental
ARG RVM_RUBY_VERSIONS="2.7.1"
FROM kingdonb/docker-rvm:20200815 as test-base
LABEL maintainer="Kingdon Barrett <kingdon.b@nd.edu>"
ENV APPDIR="/home/${RVM_USER}/app"

# install manpages and a little vim because I might need them
RUN apt-get update && apt-get install -y --no-install-recommends \
  manpages vim-tiny runit python3 && apt-get clean && rm -rf /var/lib/apt/lists/*
# make sure the base is upgraded, so downstream images don't have to do it
RUN apt-get update && apt-get upgrade -y --no-install-recommends \
  && apt-get clean && rm -rf /var/lib/apt/lists/*
# gem update to ensure railties binstubs are correct for Rails 6
RUN echo 'gem: --no-document' > /root/.gemrc && bash --login -c 'gem update'

# set the time zone
ENV DEBIAN_FRONTEND=noninteractive
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential nodejs \
  tzdata libpq-dev && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN echo "America/New_York" > /etc/timezone
RUN unlink /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

# put an app dir in place and ensure the user can manage it without escalation
RUN mkdir ${APPDIR}
WORKDIR ${APPDIR}

RUN chown ${RVM_USER} ${APPDIR}
# ADD my_init /sbin/my_init
# RUN mkdir -p /etc/my_init.d \
#   mkdir -p /etc/my_init.pre_shutdown.d ; \
#   mkdir -p /etc/my_init.post_shutdown.d ; \
#   mkdir -p /etc/container_environment ; \
#   touch /etc/container_environment.sh ; \
#   touch /etc/container_environment.json ; \
#   chmod 700 /etc/container_environment ; \
#     groupadd -g 8377 docker_env ; \
#     chown :docker_env /etc/container_environment.sh /etc/container_environment.json ; \
#     chmod 640 /etc/container_environment.sh /etc/container_environment.json ; \
#     ln -s /etc/container_environment.sh /etc/profile.d/
USER ${RVM_USER}
RUN  bash --login -c 'curl -o- -L https://yarnpkg.com/install.sh | bash'
# USER root
# ENTRYPOINT ["/sbin/my_init", "--"]

# # Example downstream Dockerfile:
FROM test-base as test
ENV RUBY=2.7.1
#
# # include the ruby-version and Gemfile for bundle install
COPY --chown=rvm Gemfile Gemfile.lock .ruby-version ${APPDIR}/

RUN mkdir -p /home/${RVM_USER}/app/.cache/bundle
RUN bundle config set app_config .bundle
RUN bundle config set path .cache/bundle
RUN --mount=type=cache,uid=999,gid=1000,target=/home/rvm/app/.cache/bundle \
    rvm ${RUBY} do bundle install && \
      mkdir -p vendor && \
      cp -ar .cache/bundle vendor/bundle
RUN bundle config set path vendor/bundle

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

