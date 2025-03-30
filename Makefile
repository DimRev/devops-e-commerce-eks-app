.PHONY: tf-apply tf-destroy tf-plan dev fs-build fs-push fs-local-run fs-local-delete

tf-plan:
	@echo "Planning Terraform Changes"
	@cd terraform && terraform plan

tf-apply:
	@echo "Applying Terraform Changes"
	@cd terraform && terraform apply -auto-approve

tf-destroy:
	@echo "Destroying Terraform Changes"
	@cd terraform && terraform destroy -auto-approve

dev:
	@echo "Starting Dev Environment"
	@./scripts/dev.sh

fs-build:
	@./scripts/fullstack-docker-build.sh

fs-push:
	@./scripts/fullstack-docker-push.sh

fs-local-run:
	@./scripts/fullstack-docker-run.sh

fs-local-delete:
	@./scripts/fullstack-docker-delete.sh