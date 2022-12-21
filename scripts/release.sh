#!/bin/bash

# Change to the directory with our code that we plan to work from
# cd "$GOPATH/src/inthemoment.com"

echo "==== Releasing inthemoment.com ===="
echo "  Deleting the local binary if it exists (so it isn't uploaded)..."
rm inthemoment.com
echo "  Done!"

echo "  Deleting existing code..."
ssh root@caddyv2.inthemoment.com "rm -rf /root/go/src/inthemoment.com"
echo "  Code deleted successfully!"

echo "  Uploading code..."
rsync -avr --exclude '.git/*' --exclude 'tmp/*' --exclude 'images/*' ./ root@caddyv2.inthemoment.com:/root/go/src/inthemoment.com/
echo "  Code uploaded successfully!"

echo "  Building the code on remote server..."
ssh root@caddyv2.inthemoment.com 'export GOPATH=/root/go; cd /root/app; /usr/local/go/bin/go build -o ./server $GOPATH/src/inthemoment.com/*.go'
echo "  Code built successfully!"

echo "  Moving assets..."
ssh root@caddyv2.inthemoment.com "cd /root/app; cp -R /root/go/src/inthemoment.com/assets ."
echo "  Assets moved successfully!"

echo "  Moving views..."
ssh root@caddyv2.inthemoment.com "cd /root/app; cp -R /root/go/src/inthemoment.com/views ."
echo "  Views moved successfully!"

echo "  Moving Caddyfile..."
ssh root@caddyv2.inthemoment.com "cp /root/go/src/inthemoment.com/Caddyfile /etc/caddy/Caddyfile"
echo "  Caddyfile moved successfully!"

echo "  Restarting the server..."
ssh root@caddyv2.inthemoment.com "sudo service inthemoment.com restart"
echo "  Server restarted successfully!"

echo "  Restarting Caddy server..."
ssh root@caddyv2.inthemoment.com "sudo service caddy restart"
echo "  Caddy restarted successfully!"

echo "==== Done releasing inthemoment.com ===="
