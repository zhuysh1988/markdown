
## development project 


oc new-project jhr-tasks-dev
oc policy add-role-to-user edit system:serviceaccount:public-services:jenkins -n jhr-tasks-dev
oc new-build --binary=true --name="tasks" jboss-eap70-openshift:latest

oc new-app jhr-tasks-dev/tasks:0.0-0 --name=tasks --allow-missing-imagestream-tags=true 
oc set triggers dc/tasks --remove-all
oc expose dc tasks --port 8080
oc expose svc tasks
oc create configmap tasks-config --from-literal="application-users.properties=Placeholder" --from-literal="application-roles.properties=Placeholder"
oc set volume dc/tasks --add --name=jboss-config --mount-path=/opt/eap/standalone/configuration/application-users.properties --sub-path=application-users.properties --configmap-name=tasks-config
oc set volume dc/tasks --add --name=jboss-config1 --mount-path=/opt/eap/standalone/configuration/application-roles.properties --sub-path=application-roles.properties --configmap-name=tasks-config



# Test project 
oc new-project jhr-tasks-test
oc policy add-role-to-group system:image-puller system:serviceaccounts:jhr-tasks-test -n jhr-tasks-dev
oc policy add-role-to-user edit system:serviceaccount:public-services:jenkins -n jhr-tasks-test


oc new-app jhr-tasks-dev/tasks:0.0 --name="tasks" --allow-missing-imagestream-tags=true
oc set triggers dc/tasks --remove-all
oc expose dc tasks --port 8080
oc expose svc tasks
oc create configmap tasks-config --from-literal="application-users.properties=Placeholder" --from-literal="application-roles.properties=Placeholder"
oc set volume dc/tasks --add --name=jboss-config --mount-path=/opt/eap/standalone/configuration/application-users.properties --sub-path=application-users.properties --configmap-name=tasks-config
oc set volume dc/tasks --add --name=jboss-config1 --mount-path=/opt/eap/standalone/configuration/application-roles.properties --sub-path=application-roles.properties --configmap-name=tasks-config



# production
oc new-project jhr-tasks-prod
oc policy add-role-to-group system:image-puller system:serviceaccounts:jhr-tasks-prod -n jhr-tasks-test
oc policy add-role-to-user edit system:serviceaccount:public-services:jenkins -n jhr-tasks-prod



# production
oc new-project jhr-tasks-prod
oc policy add-role-to-group system:image-puller system:serviceaccounts:jhr-tasks-prod -n jhr-tasks-dev
oc policy add-role-to-user edit system:serviceaccount:public-services:jenkins -n jhr-tasks-prod


oc new-app jhr-tasks-dev/tasks:0.0 --name=tasks-blue --allow-missing-imagestream-tags=true
oc set triggers dc/tasks-blue --remove-all 
oc expose dc tasks-blue --port 8080
oc create configmap tasks-blue-config --from-literal="application-users.properties=Placeholder" --from-literal="application-roles.properties=Placeholder" 
oc set volume dc/tasks-blue --add --name=jboss-config --mount-path=/opt/eap/standalone/configuration/application-users.properties --sub-path=application-users.properties --configmap-name=tasks-blue-config
oc set volume dc/tasks-blue --add --name=jboss-config1 --mount-path=/opt/eap/standalone/configuration/application-roles.properties --sub-path=application-roles.properties --configmap-name=tasks-blue-config

oc new-app jhr-tasks-dev/tasks:0.0 --name=tasks-green --allow-missing-imagestream-tags=true
oc set triggers dc/tasks-green --remove-all
oc expose dc tasks-green --port 8080
oc create configmap tasks-green-config --from-literal="application-users.properties=Placeholder" --from-literal="application-roles.properties=Placeholder"
oc set volume dc/tasks-green --add --name=jboss-config --mount-path=/opt/eap/standalone/configuration/application-users.properties --sub-path=application-users.properties --configmap-name=tasks-green-config
oc set volume dc/tasks-green --add --name=jboss-config1 --mount-path=/opt/eap/standalone/configuration/application-roles.properties --sub-path=application-roles.properties --configmap-name=tasks-green-config

oc expose svc/tasks-blue --name tasks

oc set route-backends tasks tasks-blue=100 tasks-green=0



