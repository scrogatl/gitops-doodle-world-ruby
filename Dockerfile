# One Dockerfile, three images. Pick the flavor with --target:
#   plain     no agent
#   newrelic  New Relic Ruby agent (newrelic_rpm)
#   otel      OpenTelemetry SDK + instrumentation
FROM ruby:3.2.2 AS base
WORKDIR /world-ruby
COPY src/Gemfile /world-ruby/Gemfile
EXPOSE 5003
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "5003"]

FROM base AS plain
ENV APM_FLAVOR=plain \
    BUNDLE_WITHOUT="newrelic:otel"
RUN bundle install
COPY src /world-ruby

FROM base AS newrelic
ENV APM_FLAVOR=newrelic \
    BUNDLE_WITHOUT="otel" \
    NEW_RELIC_DISTRIBUTED_TRACING_ENABLED=true
RUN bundle install
COPY src /world-ruby

FROM base AS otel
ENV APM_FLAVOR=otel \
    BUNDLE_WITHOUT="newrelic"
RUN bundle install
COPY src /world-ruby
