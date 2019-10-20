# HA Nginx deployment
## Prerequisites
- Docker installed

## 1- Create a AWS credentials file (.aws/credentials) under the root repository directory. Its spected that you have sufficient permissions on that AWS account to create EC2 instances, ALBs, Security Groups and lots of cool stuff.

sre-task/.aws/credentials
```ini
[default]
aws_access_key_id=XXXXX
aws_secret_access_key=XXXXXX
```
## 2- Build Docker Image where we will have the exact Terraform and Ansible for the deployment
```shell
cd sre-task/

# With make
make docker-build

# or without make
docker build -t website-deploy:latest -f deploy_image/dockerfile .
```

## 2- To run Terraform plan within the container run:
```shell
# With make
make docker-plan

# or without make
docker run -it --rm -v $(pwd):/home/deployment website-deploy:latest /bin/bash -c "make plan"
```

## 3- Deploy the webserver and all their AWS resources:
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

## 4- Destroy the webserver reosurces from AWS:
```shell
# With make
make docker-destroy

# or without make
docker run -it --rm -v $(pwd):/home/deployment website-deploy:latest /bin/bash -c "make destroy"
```