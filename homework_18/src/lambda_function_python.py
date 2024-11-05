import boto3

ec2list = []


def lambda_handler(event, context):
    # Get list of regions
    ec2 = boto3.client('ec2')
    regions = ec2.describe_regions().get('Regions', [])
    # Iterate over regions
    for region in regions:
        client = boto3.client('ec2', region_name=region['RegionName'])

        # Special filter for selection by tag key, and it's value
        # custom_filter = [{
        #     'Name': 'tag:UUID',
        #     'Values': ['some_value']
        # }]

        # Or by wildcard value
        # custom_filter = [{
        #     'Name': 'tag:UUID',
        #     'Values': ['*']
        # }]

        # Or filter by tag key
        custom_filter = [{'Name': 'tag-key', 'Values': ['UUID']}]
        response = client.describe_instances(Filters=custom_filter)
        for reservation in response["Reservations"]:
            for instance in reservation["Instances"]:
                # Add to list
                ec2list.append(instance['InstanceId'])
                # Stop the instance
                client.stop_instances(InstanceIds=[instance['InstanceId']])
                # Як для мене то це треба - але тоді, ми не можемо гарантувати Timeout
                # бо інстанси можуть стопатись довго
                # waiter = client.get_waiter('instance_stopped')
                # waiter.wait(InstanceIds=[instance['InstanceId']])

    return {
        "statusCode": 200,
        "body": {
            "Stopped instances list": ec2list
        }
    }
