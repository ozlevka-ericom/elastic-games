FROM java:8-jre-alpine

ENV ES_NAME=elasticsearch \
	ELASTICSEARCH_VERSION=5.6.3
ENV ELASTICSEARCH_URL=https://artifacts.elastic.co/downloads/$ES_NAME/$ES_NAME-$ELASTICSEARCH_VERSION.tar.gz

ENV KIBANA_VERSION=5.6.3 \
	KIBANA_NAME=kibana
ENV KIBANA_URL=https://artifacts.elastic.co/downloads/$KIBANA_NAME/$KIBANA_NAME-$KIBANA_VERSION-linux-x86_64.tar.gz


ENV LOGSTASH_NAME=logstash \
	LOGSTASH_VERSION=5.6.3

ENV LOGSTASH_URL https://artifacts.elastic.co/downloads/$LOGSTASH_NAME/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz

ENV CONTAINERPILOT_VERSION=3.5.1
ENV CONTAINERPILOT_URL=https://github.com/joyent/containerpilot/releases/download/$CONTAINERPILOT_VERSION/containerpilot-$CONTAINERPILOT_VERSION.tar.gz

RUN apk add --update openssl nodejs bash curl jq wget \
    && mkdir -p /opt/config \
    && echo '[i] Start create elasticsearch' \
    && wget -T 15 -O /tmp/$ES_NAME-$ELASTICSEARCH_VERSION.tar.gz $ELASTICSEARCH_URL \
    && tar -xzf /tmp/$ES_NAME-$ELASTICSEARCH_VERSION.tar.gz -C /opt/ \
    && ln -s /opt/$ES_NAME-$ELASTICSEARCH_VERSION /opt/$ES_NAME \
    && adduser -D -S elastic \
    && mkdir -p /var/lib/elasticsearch /opt/$ES_NAME/plugins /opt/$ES_NAME/config/scripts \
    && chown -R elastic /opt/$ES_NAME-$ELASTICSEARCH_VERSION/ \
    && echo "[i] Start install kibana" \
    && wget -T 15 -O /tmp/$KIBANA_NAME-$KIBANA_VERSION-linux-x86_64.tar.gz $KIBANA_URL \
    && tar -xzf /tmp/$KIBANA_NAME-$KIBANA_VERSION-linux-x86_64.tar.gz -C /opt/ \
    && ln -s /opt/$KIBANA_NAME-$KIBANA_VERSION-linux-x86_64 /opt/$KIBANA_NAME \
    && rm -rf /opt/$KIBANA_NAME/node/ \
    && mkdir -p /opt/$KIBANA_NAME/node/bin/ \
    && ln -s $(which node) /opt/$KIBANA_NAME/node/bin/node \
    && echo "[i] Start install logstash" \
    && wget -T 15 -O /tmp/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz $LOGSTASH_URL \
    && tar xzf /tmp/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz -C /opt/ \
    && ln -s /opt/$LOGSTASH_NAME-$LOGSTASH_VERSION /opt/$LOGSTASH_NAME \
    && ln -s /opt/$LOGSTASH_NAME/bin/$LOGSTASH_NAME /usr/local/bin/$LOGSTASH_NAME \
    && echo "[i] Start install containerpilot" \
    && wget -T 15 -O containerpilot-$CONTAINERPILOT_VERSION.tar.gz $CONTAINERPILOT_URL \
    && tar -xzf containerpilot-$CONTAINERPILOT_VERSION.tar.gz -C /usr/bin \
    && rm containerpilot-$CONTAINERPILOT_VERSION.tar.gz \
    && echo '[i] Finishing' \
    && mkdir -p /scripts

COPY elasticsearch/elasticsearch.sh /scripts/
COPY kibana/kibana.yml  /opt/kibana/config
COPY container-pilot.json5 /scripts/
COPY logstash/jvm.options /opt/$LOGSTASH_NAME-$LOGSTASH_VERSION/config/jvm.options
COPY logstash/log4j2.properties /opt/$LOGSTASH_NAME-$LOGSTASH_VERSION/config/log4j2.properties
COPY logstash/logstash.json /etc/$LOGSTASH_NAME/$LOGSTASH_NAME.json
COPY logstash/logstash.sh /scripts/
COPY operations/init.sh /scripts/
COPY operations/config/templates.json /opt/config/templates.json
COPY operations/config/kibana-config.json /opt/config/kibana-config.json
COPY operations/config/pipelines.json /opt/config/pipelines.json
COPY operations/create-indexes.js /opt/kibana/create-indexes.js
COPY operations/elk-utils.js  /opt/kibana/elk-utils.js

RUN  /opt/$LOGSTASH_NAME/bin/logstash-plugin install logstash-output-syslog

ENV PATH=/opt/elasticsearch/bin:/opt/kibana/bin:$PATH

CMD [ "containerpilot", "-config", "/scripts/container-pilot.json5" ]