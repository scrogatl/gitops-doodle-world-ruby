# One Dockerfile, three images. Pick the flavor with --target:
#   plain     no agent
#   newrelic  New Relic Ruby agent (newrelic_rpm)
#   otel      OpenTelemetry SDK + instrumentation
FROM ruby:3.2.2 AS base
# Optional: trust an extra CA (for local builds behind TLS inspection). Pass it with
#   docker build --secret id=extra_ca,src=ca.pem ...
# Does nothing when the secret is absent, so CI builds are unaffected.
RUN --mount=type=secret,id=extra_ca \
    if [ -s /run/secrets/extra_ca ]; then \
      cp /run/secrets/extra_ca /usr/local/share/ca-certificates/extra-ca.crt && update-ca-certificates; \
    fi
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
