FROM ruby:3.2.1 AS supnet-development

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends nodejs yarn vim

# Default directory
ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH

# Install gems
WORKDIR $INSTALL_PATH
COPY supnet/ .

RUN rm -rf node_modules vendor
RUN gem install rails bundler
RUN bundle install
RUN yarn install

EXPOSE 3000

# Start server
CMD bundle exec puma -C config/puma.rb
