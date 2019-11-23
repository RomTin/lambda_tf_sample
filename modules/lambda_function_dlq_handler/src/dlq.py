#!/usr/bin/env python3
import json
import boto3
from datetime import datetime as dt

s3 = boto3.resource("s3")

BUCKET_NAME = "${bucket_name}"

def handle(event, context):
    sqs_message_id = event["Records"][0]["messageId"]
    sqs_source = event["Records"][0]["eventSourceARN"].split(":")[-1]
    s3_object_name = (f"SQS/{sqs_source}/{sqs_message_id}.json")

    try:
        s3_bucket = s3.Bucket(BUCKET_NAME)
        s3_object = s3.Object(BUCKET_NAME, s3_object_name)
        s3_object.put(Body=json.dumps(event, indent=2).encode())
    except Exception as e:
        raise(e)
    else:
        return True

if __name__ == "__main__":
    pass
