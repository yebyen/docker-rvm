ARG RVM_RUBY_VERSIONS="2.6.5 2.7.0 2.5.7 2.4.9"
FROM kingdonb/docker-rvm:20200220
LABEL maintainer="Kingdon Barrett <kingdon.b@nd.edu>"
ENV APPDIR="/home/${RVM_USER}/app"

# install manpages and a little vim because I might need them
RUN apt-get update && apt-get install -y --no-install-recommends \
  manpages vim-tiny && apt-get clean && rm -rf /var/lib/apt/lists/*
# make sure the base is upgraded, so downstream images don't have to do it
RUN apt-get update && apt-get upgrade -y --no-install-recommends \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# set the time zone
ENV DEBIAN_FRONTEND=noninteractive
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
USER ${RVM_USER}
RUN  bash --login -c 'curl -o- -L https://yarnpkg.com/install.sh | bash'

# # Example downstream Dockerfile:
# FROM kingdonb/docker-rvm-support:latest
# ENV RUBY=2.7.0
#
# # include the ruby-version and Gemfile for bundle install
# ADD Gemfile Gemfile.lock .ruby-version ${APPDIR}/
# RUN  bash --login -c 'bundle install'
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

