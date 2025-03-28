.PHONY: tf-apply tf-destroy tf-plan

tf-apply:
	@echo "Applying Terraform Changes"
	@cd terraform && terraform apply -auto-approve

tf-destroy:
	@echo "Destroying Terraform Changes"
	@cd terraform && terraform destroy -auto-approve

tf-plan:
	@echo "Planning Terraform Changes"
	@cd terraform && terraform plan