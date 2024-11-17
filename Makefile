

docker:
	docker build --no-cache  --progress plain -t npo-poms/linux-im7 .


test:
	docker run -it npo-poms/linux-im7
