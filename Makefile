default: deploy

ping:
	ansible all -m ping -i inventory -vvvv

deploy:
	ansible-playbook -i inventory main.yml
