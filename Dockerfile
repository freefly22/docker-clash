FROM debian:10

ARG CLASH_VERSION="v1.8.0"

ADD https://github.com/Dreamacro/clash/releases/download/$CLASH_VERSION/clash-linux-amd64-$CLASH_VERSION.gz /opt/clash-linux-amd64-$CLASH_VERSION.gz
ADD https://cdn.jsdelivr.net/gh/Dreamacro/maxmind-geoip@release/Country.mmdb /root/conf/Country.mmdb
COPY ./run.bash /bin/run
COPY ./dl-clash-conf.bash /bin/dl-clash-conf
COPY ./update-clash-conf.bash /bin/update-clash-conf
COPY sources.list /etc/apt/

# 配置文件地址
ENV CONF_URL http://test.com
# 配置文件更新频率
ENV UPDATE_INTERVAL 86400
# RESTful API 地址, 可为空
ENV EXTERNAL_BIND "127.0.0.1"
ENV EXTERNAL_PORT "9090"
# RESTful API 鉴权
ENV EXTERNAL_SECRET ""

RUN apt update && apt update  \
    && apt install -y wget \
    curl \
    && gzip -d /opt/clash-linux-amd64-$CLASH_VERSION.gz \
    && chmod +x /opt/clash-linux-amd64-$CLASH_VERSION \
    && ln -s /opt/clash-linux-amd64-$CLASH_VERSION /bin/clash \
    && chmod +x /bin/run \
    && chmod +x /bin/update-clash-conf \
    && chmod +x /bin/dl-clash-conf

ENTRYPOINT ["run"]
