docker build -t eljefederodeodeljefe/helloworld-nodejs .
docker push eljefederodeodeljefe/helloworld-nodejs

kubectl apply --filename service.yml

if kubectl get configmap config-istio -n knative-serving &> /dev/null; then
    INGRESSGATEWAY=istio-ingressgateway
fi

kubectl get svc $INGRESSGATEWAY --namespace istio-system

export IP_ADDRESS=$(kubectl get svc $INGRESSGATEWAY --namespace istio-system --output 'jsonpath={.status.loadBalancer.ingress[0].ip}')

kubectl get route helloworld-nodejs  --output=custom-columns=NAME:.metadata.name,DOMAIN:.status.domain

export HOST_URL=$(kubectl get route helloworld-nodejs  --output jsonpath='{.status.domain}')

curl -H "Host: ${HOST_URL}" http://${IP_ADDRESS}


