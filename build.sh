VERSION=v1.0.7

docker build -t paulmeng/homepage:$VERSION .
docker push paulmeng/homepage:$VERSION
