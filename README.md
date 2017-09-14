# image-kubernetes
A Scaleway Image config for a Ubuntu Xenial Kubernetes Image

export ARCH=amd64  # can be 'i386', 'amd64' or 'armhf'  
wget "https://github.com/scaleway/scaleway-cli/releases/download/v1.13/scw_1.13_${ARCH}.deb" -O /tmp/scw.deb  
sudo dpkg -i /tmp/scw.deb && rm -f /tmp/scw.deb  

sudo scw login  
sudo scw run --name="kubernetes" image-builder  

# build this image

# create server with this image

# kubeadm init

# setup cluster

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"  
kubectl taint nodes --all node-role.kubernetes.io/master-  

# kube-lego

KUBE_LEGO_REPO=https://raw.githubusercontent.com/jetstack/kube-lego/0.1.5/examples/nginx  

kubectl apply -f $KUBE_LEGO_REPO/lego/00-namespace.yaml  
kubectl apply -f $KUBE_LEGO_REPO/nginx/00-namespace.yaml  

curl -s $KUBE_LEGO_REPO/nginx/default-deployment.yaml | sed "s/containers:/nodeSelector:\n        node-role.kubernetes.io\/master: \"\"\n      containers:/" | kubectl apply -f -  
kubectl apply -f $KUBE_LEGO_REPO/nginx/default-service.yaml  

kubectl apply -f $KUBE_LEGO_REPO/nginx/configmap.yaml  
kubectl apply -f $KUBE_LEGO_REPO/nginx/service.yaml  
curl -s $KUBE_LEGO_REPO/nginx/deployment.yaml | sed "s/containers:/hostNetwork: true\n      nodeSelector:\n        node-role.kubernetes.io\/master: \"\"\n      containers:/" | sed -r "s/containerPort: (.*)/containerPort: \1\n          hostPort: \1/" | kubectl apply -f -  

curl -s $KUBE_LEGO_REPO/lego/configmap.yaml | sed s/example.com/eneticum.de/ | kubectl apply -f -  
curl -s $KUBE_LEGO_REPO/lego/deployment.yaml | sed "s/containers:/nodeSelector:\n        node-role.kubernetes.io\/master: \"\"\n      containers:/" | kubectl apply -f -  

# cluster roles

EDITOR=nano kubectl edit clusterrolebindings cluster-admin  

- kind: ServiceAccount  
  name: default  
  namespace: kube-lego  
- kind: ServiceAccount  
  name: default  
  namespace: nginx-ingress  
  
# heapster

HEAPSTER_REPO=https://raw.githubusercontent.com/kubernetes/heapster/v1.4.2/deploy/kube-config  
kubectl apply -f $HEAPSTER_REPO/influxdb/grafana.yaml  
kubectl apply -f $HEAPSTER_REPO/influxdb/heapster.yaml  
kubectl apply -f $HEAPSTER_REPO/influxdb/influxdb.yaml  
kubectl apply -f $HEAPSTER_REPO/rbac/heapster-rbac.yaml  

# kubeadm join
