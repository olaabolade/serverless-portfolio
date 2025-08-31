import json
import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Print the entire event to CloudWatch logs for debugging
    print("Full event received from CodePipeline:")
    print(json.dumps(event, indent=2))
    
    # For now, just return a success message
    # We'll add the actual file processing logic in the next step
    return {
        'statusCode': 200,
        'body': json.dumps('Portfolio update processed successfully!')
    }
