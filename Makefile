plan:
	ansible-playbook -i ./hosts website_deploy.yml

deploy:
	ansible-playbook -i ./hosts website_deploy.yml --extra-vars '{"tearraform_plan":"no"}'

destroy:
	ansible-playbook -i ./hosts website_deploy.yml --extra-vars '{"tearraform_plan":"no","tearraform_state":"absent"}'

docker-build:
	docker build -t website-deploy:latest -f deploy_image/dockerfile .

docker-plan:
	docker run -it --rm -v $(shell pwd):/home/deployment website-deploy:latest /bin/bash -c "make plan"

docker-deploy:
	docker run -it --rm -v $(shell pwd):/home/deployment website-deploy:latest /bin/bash -c "make deploy"

docker-destroy:
	docker run -it --rm -v $(shell pwd):/home/deployment website-deploy:latest /bin/bash -c "make destroy"