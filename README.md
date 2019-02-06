# Paul’s website
The website is built in docker and managed by kubernetes.


## Deployment
First build a new version
```
./build.sh
```

Then switch to k8s folder and apply kubernetes deployment object.
```
cd k8s/
kubectl apply -f homepage.yml
```
