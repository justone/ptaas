from ubuntu:12.10

maintainer Nate Jones <nate@endot.org>

run apt-get update
run DEBIAN_FRONTEND=noninteractive apt-get install curl cmake build-essential libxslt-dev libxml2-dev -y
run mkdir /hiawatha

run curl http://www.hiawatha-webserver.org/files/hiawatha-9.2.tar.gz > /hiawatha/hiawatha-9.2.tar.gz
run bash -c "cd /hiawatha; tar -xzvf hiawatha-9.2.tar.gz; mkdir /hiawatha/hiawatha-9.2/build"
run bash -c "cd /hiawatha/hiawatha-9.2/build; cmake ..; make install/strip"

add hiawatha.conf /usr/local/etc/hiawatha/hiawatha.conf
add tidy.pl /usr/local/var/www/hiawatha/tidy.pl
run chmod +x /usr/local/var/www/hiawatha/tidy.pl

expose 80
cmd ["/usr/local/sbin/hiawatha", "-d"]
