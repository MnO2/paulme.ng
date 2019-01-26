VERSION=v1.0.2

docker build -t paulmeng/homepage:$VERSION .
docker push paulmeng/homepage:$VERSION
