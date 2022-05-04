#!/bin/bash

hammer -t /root/creds.json cf-login
cf create-org prisma-ci
cf csp -o prisma-ci staging
cf target -o prisma-ci -s staging

#obtain app names from manifest.yml
if [ -f manifest.yml ]; then
    apps=`yq -r  '.applications[] | .name'  < manifest.yml`
else 
    echo "There is no manifest.yml in your current dir"
    exit 1
fi
cf push --no-start
#need app selection here
for app in ${apps[@]}; do 
        dropletguid=$(cf stage $app | tee /dev/tty | awk '/droplet\ guid/ {print $3}')
        #cf set-droplet $app $dropletguid
        cf download-droplet $app --droplet $dropletguid --path ./droplet.tgz
    done 


cf delete-org -f prisma-ci