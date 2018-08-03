# nodejs-mongo

## Create ImageStream

registry.example.com:5000/openshift3/mongodb-32-rhel7:latest

oc import-image mongodb:3.2 \
--from=registry.example.com:5000/rhscl/mongodb-32-rhel7:latest \
--insecure=true \
--confirm

registry.example.com:5000/rhscl/nodejs-6-rhel7:latest

oc import-image nodejs:6 \
--from=registry.example.com:5000/rhscl/nodejs-6-rhel7:latest \
--insecure=true \
--confirm

## Create Application 
oc new-app \
--template=nodejs-mongo-persistent \
--param=NAME=nodejs \
--param=NAMESPACE=test \
--param=SOURCE_REPOSITORY_URL=http://gogs-public-services.apps.example.com/sclorg/nodejs-ex.git
