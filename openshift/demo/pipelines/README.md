```bash
# Set up Dev Project
oc new-project xyz-tasks-dev --display-name "Tasks Development"
oc policy add-role-to-user edit system:serviceaccount:xyz-jenkins:jenkins -n xyz-tasks-dev

# Set up Dev Application
oc new-build --binary=true --name="tasks" jboss-eap70-openshift:1.6 -n xyz-tasks-dev
oc new-app xyz-tasks-dev/tasks:0.0-0 --name=tasks --allow-missing-imagestream-tags=true -n xyz-tasks-dev
oc set triggers dc/tasks --remove-all -n xyz-tasks-dev
oc expose dc tasks --port 8080 -n xyz-tasks-dev
oc expose svc tasks -n xyz-tasks-dev
oc create configmap tasks-config --from-literal="application-users.properties=Placeholder" --from-literal="application-roles.properties=Placeholder" -n xyz-tasks-dev
oc set volume dc/tasks --add --name=jboss-config --mount-path=/opt/eap/standalone/configuration/application-users.properties --sub-path=application-users.properties --configmap-name=tasks-config -n xyz-tasks-dev
oc set volume dc/tasks --add --name=jboss-config1 --mount-path=/opt/eap/standalone/configuration/application-roles.properties --sub-path=application-roles.properties --configmap-name=tasks-config -n xyz-tasks-dev
```


oc new-project xyz-tasks-dev --display-name "Tasks Development"
oc policy add-role-to-user edit system:serviceaccount:public-services:jenkins -n xyz-tasks-dev


oc new-build --binary=true --name="tasks" jboss-eap70-openshift:latest -n xyz-tasks-dev
oc new-app xyz-tasks-dev/tasks:0.0-0 --name=tasks --allow-missing-imagestream-tags=true -n xyz-tasks-dev
oc set triggers dc/tasks --remove-all -n xyz-tasks-dev
oc expose dc tasks --port 8080 -n xyz-tasks-dev
oc expose svc tasks -n xyz-tasks-dev
oc create configmap tasks-config --from-literal="application-users.properties=Placeholder" --from-literal="application-roles.properties=Placeholder" -n xyz-tasks-dev
oc set volume dc/tasks --add --name=jboss-config --mount-path=/opt/eap/standalone/configuration/application-users.properties --sub-path=application-users.properties --configmap-name=tasks-config -n xyz-tasks-dev
oc set volume dc/tasks --add --name=jboss-config1 --mount-path=/opt/eap/standalone/configuration/application-roles.properties --sub-path=application-roles.properties --configmap-name=tasks-config -n xyz-tasks-dev




##############################################################################

```bash
# Set up Production Project
oc new-project xyz-tasks-prod --display-name "Tasks Production"
oc policy add-role-to-group system:image-puller system:serviceaccounts:xyz-tasks-prod -n xyz-tasks-dev
oc policy add-role-to-user edit system:serviceaccount:public-services:jenkins -n xyz-tasks-prod

# Create Blue Application
oc new-app xyz-tasks-dev/tasks:0.0 --name=tasks-blue --allow-missing-imagestream-tags=true -n xyz-tasks-prod
oc set triggers dc/tasks-blue --remove-all -n xyz-tasks-prod
oc expose dc tasks-blue --port 8080 -n xyz-tasks-prod
oc create configmap tasks-blue-config --from-literal="application-users.properties=Placeholder" --from-literal="application-roles.properties=Placeholder" -n xyz-tasks-prod
oc set volume dc/tasks-blue --add --name=jboss-config --mount-path=/opt/eap/standalone/configuration/application-users.properties --sub-path=application-users.properties --configmap-name=tasks-blue-config -n xyz-tasks-prod
oc set volume dc/tasks-blue --add --name=jboss-config1 --mount-path=/opt/eap/standalone/configuration/application-roles.properties --sub-path=application-roles.properties --configmap-name=tasks-blue-config -n xyz-tasks-prod

# Create Green Application
oc new-app xyz-tasks-dev/tasks:0.0 --name=tasks-green --allow-missing-imagestream-tags=true -n xyz-tasks-prod
oc set triggers dc/tasks-green --remove-all -n xyz-tasks-prod
oc expose dc tasks-green --port 8080 -n xyz-tasks-prod
oc create configmap tasks-green-config --from-literal="application-users.properties=Placeholder" --from-literal="application-roles.properties=Placeholder" -n xyz-tasks-prod
oc set volume dc/tasks-green --add --name=jboss-config --mount-path=/opt/eap/standalone/configuration/application-users.properties --sub-path=application-users.properties --configmap-name=tasks-green-config -n xyz-tasks-prod
oc set volume dc/tasks-green --add --name=jboss-config1 --mount-path=/opt/eap/standalone/configuration/application-roles.properties --sub-path=application-roles.properties --configmap-name=tasks-green-config -n xyz-tasks-prod

# Expose Blue service as route to make blue application active
oc expose svc/tasks-blue --name tasks -n xyz-tasks-prod

```

```yaml
apiVersion: v1
data:
  password: b25jZWFz
  username: amlob25ncnVp
kind: Secret
metadata:
  name: gogs-secret
type: Opaque
```
317bf993-9557-11e8-b7dc-005056a2342a






```groovy
#!groovy

// Run this pipeline on the custom Maven Slave ('maven-appdev')
// Maven Slaves have JDK and Maven already installed
// 'maven-appdev' has skopeo installed as well.
node('maven-appdev') {
  // Define Maven Command. Make sure it points to the correct
  // settings for our Nexus installation (use the service to
  // bypass the router). The file nexus_openshift_settings.xml
  // needs to be in the Source Code repository.
  def mvnCmd = "mvn -s ./nexus_openshift_settings.xml"

    // Checkout Source Code.
    stage('Checkout Source') {
    // Replace xyz-gogs with the name of your Gogs project
    // Replace the credentials with your credentials.
    git credentialsId: '317bf993-9557-11e8-b7dc-005056a2342a', url: 'http://gogs.public-services.svc.cluster.local:3000/CICDLabs/openshift-tasks.git'
    }


  // The following variables need to be defined at the top level
  // and not inside the scope of a stage - otherwise they would not
  // be accessible from other stages.
  // Extract version and other properties from the pom.xml
  def groupId    = getGroupIdFromPom("pom.xml")
  def artifactId = getArtifactIdFromPom("pom.xml")
  def version    = getVersionFromPom("pom.xml")

  // Set the tag for the development image: version + build number
  // def devTag  = "0.0-0"
  // Set the tag for the production image: version
  // def prodTag = "0.0"

    // Set the tag for the development image: version + build number
    def devTag  = "${version}-${BUILD_NUMBER}"
    // Set the tag for the production image: version
    def prodTag = "${version}"


// Using Maven build the war file
// Do not run tests in this step
stage('Build war') {
  echo "Building version ${devTag}"

  sh "${mvnCmd} clean package -DskipTests"
}


// Using Maven run the unit tests
stage('Unit Tests') {
  echo "Running Unit Tests"

  sh "${mvnCmd} test"
}

stage('Code Analysis') {
  echo "Running Code Analysis"

  // Replace xyz-sonarqube with the name of your Sonarqube project
  sh "${mvnCmd} sonar:sonar -Dsonar.host.url=http://sonarqube-public-services.apps.example.com/ -Dsonar.projectName=${JOB_BASE_NAME}-${devTag}"
}

  // Publish the built war file to Nexus
stage('Publish to Nexus') {
  echo "Publish to Nexus"

  // Replace xyz-nexus with the name of your Nexus project
  sh "${mvnCmd} deploy -DskipTests=true -DaltDeploymentRepository=nexus::default::http://nexus3.public-services.svc.cluster.local:8081/repository/releases"
}

  // Build the OpenShift Image in OpenShift and tag it.
// Build the OpenShift Image in OpenShift and tag it.
stage('Build and Tag OpenShift Image') {
  echo "Building OpenShift container image tasks:${devTag}"

  // Start Binary Build in OpenShift using the file we just published
  // The filename is openshift-tasks.war in the 'target' directory of your current
  // Jenkins workspace
  // Replace xyz-tasks-dev with the name of your dev project
  sh "oc start-build tasks --follow --from-file=./target/openshift-tasks.war -n xyz-tasks-dev"

  // OR use the file you just published into Nexus:
  // sh "oc start-build tasks --follow --from-file=http://nexus3.xyz-nexus.svc.cluster.local:8081/repository/releases/org/jboss/quickstarts/eap/tasks/${version}/tasks-${version}.war -n xyz-tasks-dev"

  // Tag the image using the devTag
  openshiftTag alias: 'false', destStream: 'tasks', destTag: devTag, destinationNamespace: 'xyz-tasks-dev', namespace: 'xyz-tasks-dev', srcStream: 'tasks', srcTag: 'latest', verbose: 'false'
}



////////////////////////////////////////////////////
  // Deploy the built image to the Development Environment.
// Deploy the built image to the Development Environment.
stage('Deploy to Dev') {
  echo "Deploying container image to Development Project"

  // Update the Image on the Development Deployment Config
  sh "oc set image dc/tasks tasks=docker-registry.default.svc:5000/xyz-tasks-dev/tasks:${devTag} -n xyz-tasks-dev"

  // Update the Config Map which contains the users for the Tasks application
  sh "oc delete configmap tasks-config -n xyz-tasks-dev --ignore-not-found=true"
  sh "oc create configmap tasks-config --from-file=./configuration/application-users.properties --from-file=./configuration/application-roles.properties -n xyz-tasks-dev"

  // Deploy the development application.
  // Replace xyz-tasks-dev with the name of your production project
  openshiftDeploy depCfg: 'tasks', namespace: 'xyz-tasks-dev', verbose: 'false', waitTime: '', waitUnit: 'sec'
  openshiftVerifyDeployment depCfg: 'tasks', namespace: 'xyz-tasks-dev', replicaCount: '1', verbose: 'false', verifyReplicaCount: 'false', waitTime: '', waitUnit: 'sec'
  openshiftVerifyService namespace: 'xyz-tasks-dev', svcName: 'tasks', verbose: 'false'
}

  // Run Integration Tests in the Development Environment.
stage('Integration Tests') {
  echo "Running Integration Tests"
  sleep 15

  // Create a new task called "integration_test_1"
  echo "Creating task"
  sh "curl -i -u 'tasks:redhat1' -H 'Content-Length: 0' -X POST http://tasks.xyz-tasks-dev.svc.cluster.local:8080/ws/tasks/integration_test_1"

  // Retrieve task with id "1"
  echo "Retrieving tasks"
  sh "curl -i -u 'tasks:redhat1' -H 'Content-Length: 0' -X GET http://tasks.xyz-tasks-dev.svc.cluster.local:8080/ws/tasks/1"

  // Delete task with id "1"
  echo "Deleting tasks"
  sh "curl -i -u 'tasks:redhat1' -H 'Content-Length: 0' -X DELETE http://tasks.xyz-tasks-dev.svc.cluster.local:8080/ws/tasks/1"
}

  // Copy Image to Nexus Docker Registry
// Copy Image to Nexus Docker Registry
stage('Copy Image to Nexus Docker Registry') {
  echo "Copy image to Nexus Docker Registry"

  sh "skopeo copy --src-tls-verify=false --dest-tls-verify=false --src-creds openshift:\$(oc whoami -t) --dest-creds admin:admin123 docker://docker-registry.default.svc.cluster.local:5000/xyz-tasks-dev/tasks:${devTag} docker://nexus-registry.public-services.svc.cluster.local:5000/tasks:${devTag}"

  // Tag the built image with the production tag.
  // Replace xyz-tasks-dev with the name of your dev project
  openshiftTag alias: 'false', destStream: 'tasks', destTag: prodTag, destinationNamespace: 'xyz-tasks-dev', namespace: 'xyz-tasks-dev', srcStream: 'tasks', srcTag: devTag, verbose: 'false'
}

// Blue/Green Deployment into Production
// -------------------------------------
// Do not activate the new version yet.
def destApp   = "tasks-green"
def activeApp = ""

stage('Blue/Green Production Deployment') {
  // Replace xyz-tasks-dev and xyz-tasks-prod with
  // your project names
  activeApp = sh(returnStdout: true, script: "oc get route tasks -n xyz-tasks-prod -o jsonpath='{ .spec.to.name }'").trim()
  if (activeApp == "tasks-green") {
    destApp = "tasks-blue"
  }
  echo "Active Application:      " + activeApp
  echo "Destination Application: " + destApp

  // Update the Image on the Production Deployment Config
  sh "oc set image dc/${destApp} ${destApp}=docker-registry.default.svc:5000/xyz-tasks-dev/tasks:${prodTag} -n xyz-tasks-prod"

  // Update the Config Map which contains the users for the Tasks application
  sh "oc delete configmap ${destApp}-config -n xyz-tasks-prod --ignore-not-found=true"
  sh "oc create configmap ${destApp}-config --from-file=./configuration/application-users.properties --from-file=./configuration/application-roles.properties -n xyz-tasks-prod"

  // Deploy the inactive application.
  // Replace xyz-tasks-prod with the name of your production project
  openshiftDeploy depCfg: destApp, namespace: 'xyz-tasks-prod', verbose: 'false', waitTime: '', waitUnit: 'sec'
  openshiftVerifyDeployment depCfg: destApp, namespace: 'xyz-tasks-prod', replicaCount: '1', verbose: 'false', verifyReplicaCount: 'true', waitTime: '', waitUnit: 'sec'
  openshiftVerifyService namespace: 'xyz-tasks-prod', svcName: destApp, verbose: 'false'
}

stage('Switch over to new Version') {
  input "Switch Production?"

  echo "Switching Production application to ${destApp}."
  // Replace xyz-tasks-prod with the name of your production project
  sh 'oc patch route tasks -n xyz-tasks-prod -p \'{"spec":{"to":{"name":"' + destApp + '"}}}\''
}


}

// Convenience Functions to read variables from the pom.xml
// Do not change anything below this line.
// --------------------------------------------------------
def getVersionFromPom(pom) {
  def matcher = readFile(pom) =~ '<version>(.+)</version>'
  matcher ? matcher[0][1] : null
}
def getGroupIdFromPom(pom) {
  def matcher = readFile(pom) =~ '<groupId>(.+)</groupId>'
  matcher ? matcher[0][1] : null
}
def getArtifactIdFromPom(pom) {
  def matcher = readFile(pom) =~ '<artifactId>(.+)</artifactId>'
  matcher ? matcher[0][1] : null
}
```


```bash
echo "apiVersion: v1
items:
- kind: "BuildConfig"
  apiVersion: "v1"
  metadata:
    name: "tasks-pipeline"
  spec:
    source:
      type: "Git"
      git:
        uri: "http://gogs.public-services.svc.cluster.local:3000/CICDLabs/openshift-tasks"
    strategy:
      type: "JenkinsPipeline"
      jenkinsPipelineStrategy:
        jenkinsfilePath: Jenkinsfile
kind: List
metadata: []" | oc create -f - -n public-services



# oc secrets new-basicauth gogs-secret --username=<user_name> --password=<password> -n xyz-jenkins

oc set build-secret --source bc/tasks-pipeline gogs-secret -n public-services
