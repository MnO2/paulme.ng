VERSION=v1.0.5

docker build -t paulmeng/homepage:$VERSION .
docker push paulmeng/homepage:$VERSION
