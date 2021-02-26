#/bin/bash

fqdn=$1
key_size=4096
key_duration=365

# Generate config file
echo "[ req ]
distinguished_name = server_distinguished_name
req_extensions     = server_req_extensions
string_mask        = utf8only
prompt             = no

[ server_distinguished_name ]
commonName         = ${fqdn}

[ server_req_extensions ]
subjectAltName     = @alternate_names

[ alternate_names ]
DNS.1  = ${fqdn}
IP.1   = 127.0.0.1
" > config.cfg

# Generate key
openssl genrsa -out  ${fqdn}.key ${key_size}

# Generate a Certificate Signing Request
openssl req -new -sha256 -out ${fqdn}.csr -key ${fqdn}.key -config config.cfg

# Generate the certificate
openssl x509 -req -sha256 -days ${key_duration} -in ${fqdn}.csr -signkey ${fqdn}.key -out ${fqdn}.crt -extensions server_req_extensions -extfile config.cfg