.PHONY: docker

NAME=mihxil/html2latex

docker: docker-amd64 docker-i386 docker-manifest

docker-amd64:
	docker build -t $(NAME):amd64-latest --build-arg ARCH=amd64/ .
	docker push $(NAME):amd64-latest

docker-i386:
	docker build -t $(NAME):i386-latest --build-arg ARCH=i386/ .
	docker push $(NAME):i386-latest

docker-manifest:
	docker manifest create $(NAME):latest --amend $(NAME):amd64-latest --amend  $(NAME):i386-latest
	docker manifest annotate $(NAME):latest  $(NAME):i386-latest --os linux --arch 386
	docker manifest push $(NAME):latest
