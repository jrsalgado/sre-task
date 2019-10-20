# HA Nginx deployment

This is container based tool to deploy a Nginx High Availability web server.

This tool uses some infrastructure as code applications like **terraform** and **ansible** from a **Docker** container for the deployment of several resources on AWS cloud, using a container will help us to have the specific versions of terraform and ansible accross multiple team (currently only supported for mac).

## Prerequisites
- AWS credentials
- Docker installed

### 1- Create a AWS credentials file (.aws/credentials) under the root repository directory. Its spected that you have sufficient permissions on that AWS account to create EC2 instances, ALBs, Security Groups and lots of cool stuff.

sre-task/.aws/credentials
```ini
[default]
aws_access_key_id=XXXXX
aws_secret_access_key=XXXXXX
```
![Example](./common/tutorial/setup_access_keys.svg)

---

### 2- Build Docker Image where we will have the exact Terraform and Ansible for the deployment
```shell
cd sre-task/

# With make
make docker-build

# or without make
docker build -t website-deploy:latest -f deploy_image/dockerfile .
```
![Example](./common/tutorial/build_docker_image.svg)

---

### 3- To run Terraform plan within the container run:
```shell
# With make
make docker-plan

# or without make
docker run -it --rm -v $(pwd):/home/deployment website-deploy:latest /bin/bash -c "make plan"
```
![Example](./common/tutorial/terraform_plan.svg)

---

### 4- Deploy the webserver and all their AWS resources:
 Note: ALB some times takes longer than spected to finish provisioning and breaks the apply execution.
 Run the comand again to complete the deployment

```shell

# With make
make docker-deploy

# or without make
docker run -it --rm -v $(pwd):/home/deployment website-deploy:latest /bin/bash -c "make deploy"

# After the deployment you will find the dns name on the bottom og the logs like:
# "website_dns": {
#     "sensitive": false,
#     "type": "string",
#     "value": "http://develop-nginx-ha-alb-1761420719.us-east-1.elb.amazonaws.com"
# }
```
![Example](./common/tutorial/terraform_deploy.svg)

---

### 5- Test Nginx Server load balanced between 2 EC2 nodes
```shell
curl -s http://develop-nginx-ha-alb-362709296.us-east-1.elb.amazonaws.com | grep instanceId
```
![Example](./common/tutorial/test_dns_webserver.svg)

---

### 6- Time for destruction!!! of the webserver reosurces from AWS
```shell
# With make
make docker-destroy

# or without make
docker run -it --rm -v $(pwd):/home/deployment website-deploy:latest /bin/bash -c "make destroy"
```
![Example](./common/tutorial/terraform_destroy_all.svg)

---