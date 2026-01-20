# Simple helpers for this Terraform project

TF ?= terraform
TF_TEST_DIR ?= tests
TFLINT ?= tflint

.PHONY: init validate plan apply destroy test fmt lint

init:
	$(TF) init

validate:
	$(TF) validate

plan:
	$(TF) plan

apply:
	$(TF) apply -input=false -auto-approve

destroy:
	$(TF) destroy -input=false -auto-approve

fmt:
	$(TF) fmt -recursive

test:
	$(TF) test -test-directory=$(TF_TEST_DIR)

lint:
	@command -v $(TFLINT) >/dev/null 2>&1 || { echo "tflint not found. Install with: brew install tflint"; exit 1; }
	$(TFLINT) --no-color --recursive
