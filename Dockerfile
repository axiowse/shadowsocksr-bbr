FROM debian:latest
LABEL maintainer="axiowse@gmail.com"

ENV PORT="443" \
    PASSWORD="shadowsocksr-bbr" \
    METHOD="none" \
    PROTOCOL="auth_chain_a" \
    OBFS="tls1.2_ticket_auth"

RUN apt-get update \
    && apt-get install -y libsodium-dev python git ca-certificates iptables --no-install-recommends

RUN git clone -b akkariiin/master https://github.com/axiowse/shadowsocksr.git \
    && cd shadowsocksr \
    && bash initcfg.sh \
    && sed -i 's/sspanelv2/mudbjson/' userapiconfig.py \
    && python mujson_mgr.py -a -u Shadowsocksr -p ${PORT} -k ${PASSWORD} -m ${METHOD} -O ${PROTOCOL} -o ${OBFS} -G "#"

COPY bbr /shadowsocksr/bbr
COPY entrypoint.sh /shadowsocksr
RUN chmod a+x /shadowsocksr/entrypoint.sh \
    /shadowsocksr/bbr/rinetd_bbr \
    /shadowsocksr/bbr/rinetd_bbr_powered \
    /shadowsocksr/bbr/rinetd_pcc

WORKDIR /shadowsocksr

EXPOSE ${PORT}

ENTRYPOINT ["/shadowsocksr/entrypoint.sh"]
CMD /shadowsocksr/entrypoint.sh
