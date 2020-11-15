FROM python:3-alpine AS mosquitto-tls
LABEL maintainer frippe75 https://github.com/frippe75

# Set environment variables.
ENV TERM=xterm-color
ENV SHELL=/bin/bash

RUN \
	mkdir /mosquitto && \
	mkdir /mosquitto/log && \
	mkdir /mosquitto/conf && \
	cat /etc/resolv.conf && \
	nslookup mirrors.ustc.edu.cn && \
	sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
	apk update && \
	apk upgrade && \
	apk add \
		build-base \
		python3-dev \
		libffi-dev \
                libressl-dev \
		bash \
		coreutils \
		nano \
        	py3-crypto \
		ca-certificates \
        	certbot \
		mosquitto \
		mosquitto-clients && \
	rm -f /var/cache/apk/* && \
	pip install --upgrade pip && \
	pip install pyRFC3339 configobj ConfigArgParse cloudflare 
RUN \
	pip3 install certbot-dns-cloudflare

COPY run.sh /run.sh
COPY certbot.sh /certbot.sh
COPY restart.sh /restart.sh
COPY croncert.sh /etc/periodic/monthly/croncert.sh
RUN \
	chmod +x /run.sh && \
	chmod +x /certbot.sh && \
	chmod +x /restart.sh && \
	chmod +x /etc/periodic/monthly/croncert.sh

EXPOSE 1883
EXPOSE 8883

# This will run any scripts found in /scripts/*.sh
# then start Apache
CMD ["/bin/bash","-c","/run.sh"]
