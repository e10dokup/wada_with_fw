FROM ruby:2.3.0

RUN apt-get update && apt-get -y install git build-essential
RUN gem install bundler --no-document

RUN cd ~ && git clone https://github.com/e10dokup/wada_pb_without.git
RUN cd ~/wada_pb_without 
COPY start.sh /start.sh

CMD ./start.sh
