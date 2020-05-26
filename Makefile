plan:
	ansible-playbook -i ./ansible/hosts ./ansible/main.yml

deploy:
	ansible-playbook -i ./ansible/hosts ./ansible/main.yml --extra-vars '{"tearraform_plan":"no"}'

destroy:
	ansible-playbook -i ./ansible/hosts ./ansible/main.yml --extra-vars '{"tearraform_plan":"no","tearraform_state":"absent"}'

docker-build:
	docker build -t website-deploy:latest -f docker/dockerfile .

docker-plan:
	docker run -it --rm -v $(shell pwd):/home/deployment website-deploy:latest /bin/bash -c "make plan"

docker-deploy:
	docker run -it --rm -v $(shell pwd):/home/deployment website-deploy:latest /bin/bash -c "make deploy"

docker-destroy:
	docker run -it --rm -v $(shell pwd):/home/deployment website-deploy:latest /bin/bash -c "make destroy"
