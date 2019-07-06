VERSION=v1.0.4

docker build -t paulmeng/homepage:$VERSION .
docker push paulmeng/homepage:$VERSION
