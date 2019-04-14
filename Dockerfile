FROM debian:latest
LABEL maintainer="axiowse@gmail.com"
RUN apt-get update \
    && apt-get install -y libsodium-dev python git ca-certificates iptables --no-install-recommends

RUN git clone -b akkariiin/master https://github.com/axiowse/shadowsocksr.git \
    && cd shadowsocksr \
    && bash initcfg.sh \
    && sed -i 's/sspanelv2/mudbjson/' userapiconfig.py

COPY bbr /shadowsocksr/bbr
COPY entrypoint.sh /shadowsocksr
RUN chmod a+x /shadowsocksr/entrypoint.sh \
    /shadowsocksr/bbr/rinetd_bbr \
    /shadowsocksr/bbr/rinetd_bbr_powered \
    /shadowsocksr/bbr/rinetd_pcc
WORKDIR /shadowsocksr
ENTRYPOINT ["/shadowsocksr/entrypoint.sh"]
CMD /shadowsocksr/entrypoint.sh