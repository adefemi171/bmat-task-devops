# Weblink
# https://docs.celeryproject.org/en/stable/getting-started/first-steps-with-celery.html#redis
# https://docs.celeryproject.org/en/stable/getting-started/brokers/redis.html#broker-redis
# https://www.bogotobogo.com/DevOps/DevOps-Terraform.php
# https://dzone.com/articles/awsterraform-workshop-2-ec2-networking-autoscaling
# https://testable.io/create-an-aws-auto-scaling-group-with-terraform/
# https://geekdudes.wordpress.com/2018/01/10/amazon-autosclaing-using-terraform/
#!/bin/bash
sudo apt-get update && sudo apt-get upgrade -y

echo "Update Successfully"
sleep 3

# installed unzip, download AWS Cloudwatch metric monitoring scripts
# Unzip the script and removed
sudo apt-get install unzip
wget https://s3.amazonaws.com/testable-scripts/AwsScriptsMon-0.0.1.zip
unzip AwsScriptsMon-0.0.1.zip
rm AwsScriptsMon-0.0.1.zip

echo "Script Uzipped and removed"
sleep 3

# Installing Python3-pip
sudo apt-get install python3-pip python3-dev

echo "Python3 installed Successfully"
sleep 3
# Installing Celery

sudo pip3 install -U "celery[redis]"
