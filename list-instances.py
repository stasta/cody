#!/usr/local/bin/python3
import boto3
from termcolor import colored

AWS_REGION_NAME='us-east-1'
AWS_PROFILE_NAME='cody'

boto3.setup_default_session(profile_name=AWS_PROFILE_NAME, region_name=AWS_REGION_NAME)
ec2 = boto3.resource('ec2')

def list_instances():
    instances = ec2.instances.filter(
        Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
    return instances

def print_instances(instances):
    for instance in instances:
        print(instance.id, instance.instance_type)

print_instances(list_instances())