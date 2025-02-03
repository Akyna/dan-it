FROM fluent/fluentd:v1.17.1-1.0

USER root

RUN apk add --no-cache --update --virtual .build-deps  \
    sudo build-base ruby-dev \
    && gem uninstall -I elasticsearch \
    && gem install elasticsearch -v 7.17.0 \
    && sudo gem install fluent-plugin-elasticsearch  \
    && sudo gem sources --clear-all \
    && apk del .build-deps \
    && rm -rf /home/fluent/.gem/ruby/2.5.0/cache/*.gem

COPY ./fluent.conf /fluentd/etc/

COPY entrypoint.sh /bin/

RUN chmod +x /bin/entrypoint.sh

USER fluent
