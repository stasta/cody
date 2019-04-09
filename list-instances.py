#!/usr/local/bin/python3
import boto3
import datetime

AWS_REGION_NAME='us-east-1'
AWS_PROFILE_NAME='cody'

boto3.setup_default_session(profile_name=AWS_PROFILE_NAME, region_name=AWS_REGION_NAME)
ec2 = boto3.client('ec2')

def list_instances():
    instances = ec2.describe_instances(
        Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
    return instances

def print_instances(instances):
    for instance in instances['Reservations'][0]['Instances']:
        print(instance['InstanceId'])

def create_image(instance_id):
    now = datetime.datetime.now()
    nowdate = datetime.datetime.now().strftime('%Y%m%d')
    nowtime = datetime.datetime.now().strftime('%H%M')
    image_name = ('wordpress-%s-%s-PST' % (nowdate, nowtime))
    print (image_name)
    ec2.create_image(InstanceId=instance_id,
        Name=image_name, 
        Description='WP Snapshot', 
        NoReboot=True, 
        DryRun=False)

instances = list_instances()
print_instances(instances)

if len(list(instances['Reservations'][0]['Instances'])) == 1:
    create_image(instances['Reservations'][0]['Instances'][0]['InstanceId'])

