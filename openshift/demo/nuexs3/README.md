## Use Image 
* registry.example.com:5000/nexus3:latest

## deployer nexus3 
```bash
# create imagestorm
oc create is nexus3 
# import image to imagestorm nexus3 
oc import-image nexus3:latest --from=registry.example.com:5000/nexus3:latest --insecure=true
# deploy nexus3 
oc new-app nexus3
# create route nexus3 from svc nexus3
oc expose svc nexus3
# pause dc nexus3 
oc rollout pause dc nexus3
# Config DC 
oc patch dc nexus3 --patch='{ "spec": { "strategy": { "type": "Recreate" }}}'
# Set resources 
oc set resources dc nexus3 --limits=memory=2Gi --requests=memory=1Gi
# create pvc 
echo "apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nexus-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi" | oc create -f -
# Set volume 
oc set volume dc/nexus3 --add --overwrite --name=nexus3-volume-1 --mount-path=/nexus-data/ --type persistentVolumeClaim --claim-name=nexus-pvc
# Set probe 
oc set probe dc/nexus3 --liveness --failure-threshold 3 --initial-delay-seconds 60 -- echo ok
oc set probe dc/nexus3 --readiness --failure-threshold 3 --initial-delay-seconds 60 --get-url=http://:8081/repository/maven-public/
# Config OK , resume DC 
oc rollout resume dc nexus3
```