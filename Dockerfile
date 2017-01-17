FROM ruby:2.3.0

RUN apt-get update && apt-get -y install git build-essential
RUN cd /usr/local && \
    git clone git://github.com/creationix/nvm.git nvm && \
    . /usr/local/nvm/nvm.sh && \
    nvm install 6.0.0 && nvm alias default 6.0.0
RUN gem install bundler --no-document

RUN cd ~ && git clone https://github.com/rutan/zoint2.git
RUN cd ~/zoint2 && \
    . /usr/local/nvm/nvm.sh && npm install --unsafe-perm && \
    bundle install -j4
COPY start.sh /start.sh

CMD ./start.sh