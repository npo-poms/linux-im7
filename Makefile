

docker:
	docker build --no-cache  -t npo-tomcat-im:dev .


im:
	docker build --no-cache --target im_build -t npo-tomcat-im-build:dev .
