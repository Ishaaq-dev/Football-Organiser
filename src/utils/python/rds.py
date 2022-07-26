import json
import boto3 as aws
import secrets_manager
import mysql.connector

rds = aws.client('rds')
rds_credentials = json.loads(secrets_manager.get_secret("rds_credentials"))

def insert_row(table_name, columns, values):

    print('rds_credentials: {}'.format(rds_credentials))
    sql = "INSERT INTO {} {} VALUES (%s, %s, %s)".format(table_name, columns)
    print('sql: {}'.format(sql))
    mydb = mysql.connector.connect( 
        host='football-organiser-db.cslgggmecyu8.eu-west-1.rds.amazonaws.com',
        user='root',
        password=rds_credentials.get('password'),
        database='football_organiser'
    )
    mycursor = mydb.cursor()
    mycursor.execute(sql, values)
    mydb.commit()

    print(mycursor.rowcount, "record inserted.")
