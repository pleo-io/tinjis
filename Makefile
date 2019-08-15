# Expects kubectl, terraform, and curl commands in PATH

.PHONY: build-all build-antaeus build-payme deploy-all deploy-antaeus deploy-payme \
	connect2svc check-pending test-payment


# Build
build-all: build-antaeus build-payme

build-antaeus:
	docker build -t antaeus:0.0.1 .
# Golang with Docker gets weird with CWD
build-payme:
	pushd payme_app; docker build -t payme:0.0.1 .; popd

# Deploy
deploy-all: deploy-antaeus deploy-payme

deploy-antaeus:
	pushd k8s; terraform plan -out run && terraform apply run; popd

deploy-payme:
	pushd payme_app/k8s; terraform plan -out run && terraform apply run; popd

# Testing
connect2svc:
	kubectl port-forward svc/antaeus-svc -n antaeus 8000:8000 

check-pending:
	curl -s localhost:8000/rest/v1/invoices | jq '.[] | select(.status != "PENDING")'

test-payment:
	curl -s -X POST localhost:8000/rest/v1/invoices/pay | jq '.'

# Cleanup 
clean-all: clean-antaeus clean-payme

clean-antaeus:
	pushd k8s; terraform destroy -auto-approve; popd
clean-payme:
	pushd payme_app/k8s; terraform destroy -auto-approve; popd
