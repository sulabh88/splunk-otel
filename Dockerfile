# Use a slimmer base image for runtime
FROM redhat/ubi9/ubi-minimal AS final

# Define build arguments for tool versions
ARG OC_CLI_VERSION=4.12.0
ARG HELM_VERSION=3.10.0

# Set environment variables
ENV HOME=/home/appuser \
    ANSIBLE_LOCAL_TEMP=/home/appuser/.ansible/tmp \
    ANSIBLE_GALAXY_CACHE=/home/appuser/.ansible/galaxy_cache \
    PIP_CACHE_DIR=/home/appuser/.cache/pip

# Install dependencies and tools in a single layer to reduce size
RUN microdnf install -y --nodocs python3.11 python3.11-pip git tar shadow-utils && \
    ln -sf /usr/bin/python3.11 /usr/bin/python3 && \
    ln -sf /usr/bin/pip3.11 /usr/bin/pip3 && \
    # Install Helm with version check
    curl -fsSL -o /usr/local/bin/helm "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" | tar -xz --strip-components=1 linux-amd64/helm && \
    chmod +x /usr/local/bin/helm && \
    # Install OC CLI with version check
    curl -fsSL -o /tmp/oc.tar.gz "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_CLI_VERSION}/openshift-client-linux.tar.gz" && \
    tar -xzf /tmp/oc.tar.gz -C /usr/local/bin oc && \
    chmod +x /usr/local/bin/oc && \
    # Create non-root user and set up directories
    useradd -u 1001 -r -g 0 -m -d ${HOME} -s /sbin/nologin -c "Default app user" appuser && \
    mkdir -p ${ANSIBLE_LOCAL_TEMP} ${ANSIBLE_GALAXY_CACHE} ${PIP_CACHE_DIR} && \
    chown -R 1001:0 ${HOME} && \
    chmod -R g=u ${HOME} && \
    # Clean up to reduce image size
    microdnf clean all && \
    rm -rf /tmp/* /var/cache/* /var/log/*

# Copy requirements files
COPY python-req.txt galaxy-req.txt /tmp/

# Install Python and Ansible dependencies
RUN pip3 install --no-cache-dir -r /tmp/python-req.txt && \
    ansible-galaxy collection install -r /tmp/galaxy-req.txt --collections-path ${ANSIBLE_GALAXY_CACHE} && \
    rm -f /tmp/python-req.txt /tmp/galaxy-req.txt

# Switch to non-root user for security
USER 1001

# Set working directory
WORKDIR ${HOME}

# Default command (optional, adjust as needed)
CMD ["/bin/bash"]
