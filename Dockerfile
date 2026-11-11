# Dockerfile
# Only the plain (no agent) flavor is built for now; the target name matches
# the other services so the shared workflow can build it with --target plain.

FROM ruby:3.0.2 AS plain

WORKDIR /world-ruby
COPY src /world-ruby
RUN bundle install

EXPOSE 5003

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "5003"]