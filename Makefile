all:

prepare:
	docker pull debian:buster

build:
	docker build --file Dockerfile -t dolibarr:1.1 .

debug:
	docker run -it dolibarr:1.1 /bin/bash

run:
	docker run -it -p 80:80 dolibarr:1.1

deployment:
	kubectl apply -f db-deployment.yaml
	kubectl apply -f db-service.yaml
	kubectl apply -f app-deployment.yaml
	kubectl apply -f app-service.yaml
	kubectl apply -f dolibarr-db-persistentvolumeclaim.yaml
	kubectl apply -f dolibarr-conf-persistentvolumeclaim.yaml
	kubectl apply -f dolibarr-docs-persistentvolumeclaim.yaml	
