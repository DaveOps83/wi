Sublime plugin for Terraform
https://github.com/alexlouden/Terraform.tmLanguage

On your dev:
brew install terraform

clone repository

Create an AWS User Terraform (with admin access)

Make sure Terraform has credentials you created by setting the variables below.
#User Terraform
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""

Create AWS User Terraform (with admin access) , add credentials to credentials.sh
Create an S3 bucket , weareweekday.com-terraform-state-files , set Properties->Grantee to Any Auth..., tick List and Upload/Delete

cd weekday-infrastructure/terraform

make wrapper.sh executable
chmod +x wrapper.sh

download and update modules
./wrapper.sh get weareweekday.com staging

generate terraform execution plan
./wrapper.sh plan weareweekday.com staging

apply terraform execution plan
./wrapper.sh apply weareweekday.com staging


What will be created:

...

On your dev:

configure ssh forwarding (only once)
ssh-add -K ~/Downloads/weekday.pem

ssh into public bastion instance
ssh -A ec2-user@ec2-52-211-238-228.eu-west-1.compute.amazonaws.com

ssh into private instance via bastion
ssh ec2-user@10.0.0.22

Configure private instance for CI:

	1.Install node
	https://github.com/SIB-Colombia/dataportal-explorer/wiki/How-to-install-node-and-mongodb-on-Amazon-EC2

	2.Install gulp
	sudo npm install --global gulp

	3.Install Jenkins

		When installing plugins, following error may occur:
			Problem accessing /pluginManager/install. Reason:
	    	No valid crumb was included in the request

	    There seems to be quite a simple solution to revert the Jenkins 2.0 startup behaviour
	    ( and avoid above error ) so that it mimics Jenkins
	 	1.642.4 to an extent, by setting an environmental variable of:

	 	JAVA_OPTS=-Djenkins.install.runSetupWizard=false

		right before installing.

		(https://github.com/vfarcic/ms-lifecycle/issues/3)


	sudo yum -y update

	Add the Jenkins repository to available packages:

	sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
	sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
	JAVA_OPTS=-Djenkins.install.runSetupWizard=false
	sudo yum install jenkins

	Start Jenkins up and make sure it starts every time we reboot:

	sudo service jenkins start
	sudo chkconfig --add jenkins

	OK. Jenkins is actually up and running at this point. We can verify this by accessing localhost on port 8080 with wget.

	wget http://localhost:8080

	4.Configure route 53 record for Jenkins , so that it is accessible via browser
	ci.weareweekday.com

	At ci.weareweekday.com

	5.Install S3 plugin via Jenkins web interface
	https://wiki.jenkins-ci.org/display/JENKINS/S3+Plugin

	6.Configure build job like the following
