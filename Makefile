

AWS_REGION=us-east-1
AWS_DEFAULT_REGION=$(AWS_REGION)
CDK_DEFAULT_REGION=$(AWS_REGION)

region:
	env | grep REGION

build-petclinic:
	cd petclinic && docker run -ti -v $(PWD)/petclinic:/usr/src/mymaven -w /usr/src/mymaven maven mvn package -Dmaven.test.skip=true 
	cd petclinic && docker build -t petclinic .


test:
	docker run -it --rm -p 8080:80 --name petclinic petclinic

mysql-password:
ifndef MYSQL_PASSWORD
	$(error MYSQL_PASSWORD is undefined)
endif

ssm: mysql-password
	aws ssm put-parameter --name /database/password --value $(MYSQL_PASSWORD) --type SecureString

init:
	cd terraform && terraform init

apply:
	cd terraform && terraform apply -auto-approve -var 'tf_branch=$(shell git rev-parse --abbrev-ref HEAD)'


destroy:
	#cd terraform && terraform destroy -auto-approve -var 'tf_branch=$(shell git rev-parse --abbrev-ref HEAD)' -target=aws_apprunner_service.service
	cd terraform && terraform destroy -auto-approve -var 'tf_branch=$(shell git rev-parse --abbrev-ref HEAD)'
