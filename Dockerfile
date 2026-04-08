FROM mysql:8.0

RUN microdnf install -y oracle-epel-release-el9 && \
    microdnf install -y rlwrap && \
    microdnf clean all && \
    echo "set editing-mode vi" > /root/.inputrc
