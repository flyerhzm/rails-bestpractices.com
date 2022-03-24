FROM ruby:3.1-alpine AS jekyll-builder
RUN apk update && apk add build-base
WORKDIR /app
COPY Gemfile* /app/
RUN bundle install
COPY . /app
RUN jekyll build

FROM nginx:alpine
COPY --from=jekyll-builder /app/_site /usr/share/nginx/html
