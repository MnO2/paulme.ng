VERSION=v1.0.3

docker build -t paulmeng/homepage:$VERSION .
docker push paulmeng/homepage:$VERSION
