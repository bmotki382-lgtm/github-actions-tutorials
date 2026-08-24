import json
import os
import pymysql

connection = pymysql.connect(
    host=os.environ["DB_HOST"],
    user=os.environ["DB_USER"],
    password=os.environ["DB_PASSWORD"],
    database=os.environ["DB_NAME"]
)

def lambda_handler(event, context):
    cursor = connection.cursor()

    for record in event["Records"]:
        body = json.loads(record["body"])
        message = json.loads(body["Message"]) if "Message" in body else body

        bucket = message["Records"][0]["s3"]["bucket"]["name"]
        key = message["Records"][0]["s3"]["object"]["key"]

        cursor.execute(
            "INSERT INTO files (bucket_name, file_name) VALUES (%s, %s)",
            (bucket, key)
        )

    connection.commit()
    cursor.close()

    return {
        "statusCode": 200,
        "body": "Success"
    }
    