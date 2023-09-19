

docker:
	docker build --no-cache  -t vpro/debian-im7 .


test:
	docker run -it vpro/debian-im7
