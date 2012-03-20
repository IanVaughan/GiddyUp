#!/bin/bash

export WLD_SITE_ID=1000

base_path='/Users/ivaughan/Projects'
#projects="cas wld-api-router wld-service-site portal portal-sites  "
projects="cas wld-api-router wld-service-site portal portal-sites wld-service-communication wld-service-member wld-service-search mobile"

run() {
  cd ${base_path}/$1
  echo -e "--| $1 - on" `cat .foreman`
  mkdir -p log
  rbenv shell `cat .rbenv-version`
  nohup foreman start > log/foreman.log 2>&1 &
  #(nohup foreman start > $1.log && sleep 1000000000) &
}

pid() {
  `ps -ef | grep $1 | awk '{ print $2 }'`
}

kill() {
  `kill $1`
}

if [ $1 ]; then
  projects=$1
  kill pid $1
  exit
else
  killall ruby
  #sleep 1
fi

#need to find a what to kill only the required processes

#vm start
#sleep 1

. ~/.profile

for p in $projects; do
  run $p
done

# could sleep here, otherwise open is too quick for service!
open http://0.0.0.0:3000/status

# could open all started services

