.PHONY: docker

NAME=mihxil/html2latex

docker: docker-amd64 docker-i386 docker-manifest

docker-amd64:
	docker build -t $(NAME):manifest-amd64 --build-arg ARCH=amd64/ .
	docker push $(NAME):manifest-amd64

docker-i386:
	docker build -t $(NAME):manifest-i386 --build-arg ARCH=i386/ .
	docker push $(NAME):manifest-i386

docker-manifest:
	docker manifest create $(NAME):manifest-latest --amend $(NAME):manifest-amd64 --amend $(NAME):manifest-i386
	docker manifest push $(NAME):manifest-latest
