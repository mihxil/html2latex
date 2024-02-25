.PHONY: docker-manifest docker2-manifest

NAME=mihxil/html2latex
NAME2=mihxil/latex2html

docker: docker-amd64-push docker-i386-push docker-manifest

docker-amd64:
	docker buildx build --platform linux/amd64 -t $(NAME):amd64-latest  .

docker-amd64-push: docker-amd64
	docker push $(NAME):amd64-latest

docker-386-push:
	docker buildx --platform linux/386 -t $(NAME):i386-latest .
	docker push $(NAME):i386-latest

docker-arm64-push:
	docker buildx --platform linux/arm64 -t $(NAME):arm64-latest .
	docker push $(NAME):arm64-latest


docker2-amd64:
	docker build -t $(NAME2):amd64-latest  latex2html


docker2-amd64-push: docker2-amd64
	docker push $(NAME2):amd64-latest --build-arch ARCH=amd64/


docker2-i386-push:
	docker build -t $(NAME2):i386-latest --build-arg TAG=i386-latest latex2html
	docker push $(NAME2):i386-latest

docker-manifest:
	-docker manifest rm $(NAME):latest
	docker manifest create $(NAME):latest --amend $(NAME):amd64-latest --amend  $(NAME):i386-latest
	docker manifest annotate $(NAME):latest  $(NAME):i386-latest --os linux --arch 386
	docker manifest annotate $(NAME):latest  $(NAME):arm64-latest --os linux --arch arm64
	docker manifest push $(NAME):latest

docker2-manifest:
	-docker manifest rm $(NAME2):latest
	docker manifest create $(NAME2):latest --amend $(NAME2):amd64-latest --amend  $(NAME2):i386-latest
	docker manifest annotate $(NAME2):latest $(NAME2):i386-latest --os linux --arch 386
	docker manifest push $(NAME2):latest
