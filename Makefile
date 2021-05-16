.PHONE: docker

docker:
	docker build -t mihxil/html2latex:latest .
	docker build -t mihxil/html2latex:i386 i386
