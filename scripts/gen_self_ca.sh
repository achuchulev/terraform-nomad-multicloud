#!/usr/bin/env bash

# Check if nginx is installed
# Install nginx if not installed
which cfssl cfssljson &>/dev/null || {
  cd /tmp/
  for bin in cfssl cfssl-certinfo cfssljson
  do
    echo "Installing $bin..."
    curl -sSL https://pkg.cfssl.org/R1.2/${bin}_linux-amd64 > /tmp/${bin}
    install /tmp/${bin} /usr/local/bin/${bin}
  done
}

# Generate the CA's private key and certificate
cfssl print-defaults csr | cfssl gencert -initca - | cfssljson -bare $1/nomad-ca

# Copy certificates to each nomad location
cp -R $1/ $2/