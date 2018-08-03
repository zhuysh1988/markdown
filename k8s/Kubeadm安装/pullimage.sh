#!/bin/bash
images=(
kube-proxy-amd64:v1.10.0 
kube-scheduler-amd64:v1.10.0 
kube-controller-manager-amd64:v1.10.0 
kube-apiserver-amd64:v1.10.0
etcd-amd64:3.1.12 
pause-amd64:3.1 
kubernetes-dashboard-amd64:v1.8.3 
k8s-dns-sidecar-amd64:1.14.8 
k8s-dns-kube-dns-amd64:1.14.8
k8s-dns-dnsmasq-nanny-amd64:1.14.8
heapster-grafana-amd64:v4.4.3
heapster-influxdb-amd64:v1.3.3
heapster-amd64:v1.4.2
)

for imageName in ${images[@]} ; do
  #image=registry.example.com:5000/$imageName
  image=registry.cn-hangzhou.aliyuncs.com/jhr-k8s/$imageName
  docker pull $image
  docker tag $image k8s.gcr.io/$imageName
#  docker rmi $image
done

NET_images=(
registry.cn-hangzhou.aliyuncs.com/jhr-calico/node:v3.1.1
registry.cn-hangzhou.aliyuncs.com/jhr-calico/cni:v3.1.1
registry.cn-hangzhou.aliyuncs.com/jhr-calico/kube-controllers:v3.1.1
registry.cn-hangzhou.aliyuncs.com/jhr-flannel/flannel:v0.9.0-amd64
)

for img in ${NET_images[@]};do
  docker pull $img 
done