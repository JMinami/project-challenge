.PHONY: tffmt docker-build

tffmt:
	@echo "Run tf fmt"
	@terraform fmt -recursive

tf-init-prod:
	@echo "Run terraform init prod"
	@cd ./terraform/envs/production && terraform init

tf-apply-prod:
	@echo "Run terraform apply prod"
	@cd ./terraform/envs/production && terraform apply

IMAGE_NAME := frontend-server
IMAGE_TAG := latest

frontend-build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) \
	-f ./frontend/Dockerfile.dev \
	./frontend	