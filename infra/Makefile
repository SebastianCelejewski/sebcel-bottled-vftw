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
	export ANALYTICS_ENDPOINT=$$(terraform -chdir=environments/dev output -raw analytics_endpoint) && \
	export MAPBOX_ACCESS_TOKEN=$$(terraform -chdir=environments/dev output -raw mapbox_access_token) && \
	export WEBSITE_BUCKET=$$(terraform -chdir=environments/dev output -raw website_bucket_name) && \
	envsubst < ../templates/config.template.js > ../frontend/js/config.js && \
	aws s3 sync ../frontend/ s3://$$WEBSITE_BUCKET --delete

deploy-frontend-prod:
	export ANALYTICS_ENDPOINT=$$(terraform -chdir=environments/prod output -raw analytics_endpoint) && \
	export MAPBOX_ACCESS_TOKEN=$$(terraform -chdir=environments/prod output -raw mapbox_access_token) && \
	export WEBSITE_BUCKET=$$(terraform -chdir=environments/prod output -raw website_bucket_name) && \
	envsubst < ../templates/config.template.js > ../frontend/js/config.js && \
	aws s3 sync ../frontend/ s3://$$WEBSITE_BUCKET --delete

invalidate-dev:
	aws cloudfront create-invalidation --distribution-id E3EZ67JX4T7V79 --paths "/*"

invalidate-prod:
	aws cloudfront create-invalidation --distribution-id E2R8L4WX98I7GA --paths "/*"

athena-repair-dev:
	aws athena start-query-execution \
		--work-group $$(terraform -chdir=environments/dev output -raw athena_workgroup_name) \
		--query-string "MSCK REPAIR TABLE analytics_events;" \
		--query-execution-context Database=$$(terraform -chdir=environments/dev output -raw athena_database_name)

athena-repair-prod:
	aws athena start-query-execution \
		--work-group $$(terraform -chdir=environments/prod output -raw athena_workgroup_name) \
		--query-string "MSCK REPAIR TABLE analytics_events;" \
		--query-execution-context Database=$$(terraform -chdir=environments/prod output -raw athena_database_name)