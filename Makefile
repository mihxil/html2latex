.PHONY: docker

docker:
	(echo FROM debian:bullseye ; cat Dockerfile.debian) | docker build -t mihxil/html2latex:latest -
	(echo FROM i386/debian:bullseye ; cat Dockerfile.debian) | docker build -t mihxil/html2latex:i386 -
