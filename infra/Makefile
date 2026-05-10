init-dev:
	cd environments/dev && terraform init -backend-config=backend.hcl

plan-dev:
	cd environments/dev && terraform plan

apply-dev:
	cd environments/dev && terraform apply

init-prod:
	cd environments/prod && terraform init -backend-config=backend.hcl

plan-prod:
	cd environments/prod && terraform plan

apply-prod:
	cd environments/prod && terraform apply

fmt:
	terraform fmt -recursive

validate-dev:
	cd environments/dev && terraform validate

validate-prod:
	cd environments/prod && terraform validate

deploy-frontend-dev:
	aws s3 sync ../frontend/ s3://sebcel-bottled-vftw-website-bucket-dev --delete

deploy-frontend-prod:
	aws s3 sync ../frontend/ s3://sebcel-bottled-vftw-website-bucket-prod --delete

invalidate-dev:
	aws cloudfront create-invalidation --distribution-id E3EZ67JX4T7V79 --paths "/*"

invalidate-prod:
	aws cloudfront create-invalidation --distribution-id E2R8L4WX98I7GA --paths "/*"