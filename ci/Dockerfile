FROM ruby:2.6

COPY ../the-mashmake-blog/* .

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash && \
export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
nvm install 10.23.3 && nvm alias default 10.23.3 && nvm use 10.23.3 && npm install -g yarn && \
gem install rails -v 5.2 && gem install rails -v 6.0 && bundle install && rails db:migrate

EXPOSE 3030