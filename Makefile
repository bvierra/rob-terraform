.PHONY: plan apply destroy planmodule applymodule ansibleinventory

parallel = 2

all: plan

plan:
	tofu validate
	tofu plan -parallelism=$(parallel)

planmodule:
	tofu validate
	tofu plan -parallelism=$(parallel) -target=module.$(module)

apply:
	tofu validate
	tofu apply -auto-approve  -parallelism=$(parallel)

applymodule:
	tofu validate
	tofu apply -auto-approve  -parallelism=$(parallel) -target=module.$(module)

destroy:
	tofu validate
	tofu destroy -auto-approve  -parallelism=$(parallel)

output:
	tofu output

ansibleinventory:
	ansible-inventory -i inventory.yml --graph

ansibleplaybook:
	ansible-playbook -i inventory.yml ../ansible/playbook.yml

ansibleplaybookwithskiptag:
	ansible-playbook -i inventory.yml ../ansible/playbook.yml --skip-tags ${tag}

destroyandapply:
	$(MAKE) destroy
	$(MAKE) apply
