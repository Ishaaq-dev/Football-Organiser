import json
import sqlalchemy as db
import boto3 as aws
import secrets_manager
import mysql.connector

rds = aws.client('rds')
rds_credentials = json.loads(secrets_manager.get_secret("rds_credentials"))

INSERT_QUERY = 'insert'
SELECT_QUERY = 'select'
DB_URL = 'mysql+pymysql//{}:{}@{}:{}/{}'.format(
    rds_credentials.get('username'),
    rds_credentials.get('password'),
    rds_credentials.get('host'),
    rds_credentials.get('port'),
    rds_credentials.get('dbname')
)

engine = db.create_engine(DB_URL)

def _execute_query(type, sql_query, values=None):
    mydb = mysql.connector.connect( 
        host=rds_credentials.get('host'),
        user=rds_credentials.get('username'),
        password=rds_credentials.get('password'),
        database=rds_credentials.get('dbname')
    )
    mycursor = mydb.cursor()

    response = None
    if type is INSERT_QUERY:
        mycursor.executemany(sql_query, values)
        response = "{} record inserted.".format(mycursor.rowcount)
    if type is SELECT_QUERY:
        if values:
            mycursor.execute(sql_query, values)
            mydb.commit()
        else:
            mycursor.execute(sql_query)
        response = mycursor.fetchall()

    return response

def select_rows(table_name, columns='*', condition_attribute=None, condition_value=None):
    if condition_attribute and condition_value:
        condition_query = True
    else:
        condition_query = False
    
    columns = str.join(',', columns)
    sql_query = "SELECT {} FROM {}"
    if condition_query:
        sql_query += ' WHERE {} = %s'.format(condition_attribute)
    
    sql_response = _execute_query(SELECT_QUERY, sql_query, condition_value)
    print('sql_response: {}'.format(sql_response))
    return sql_response


def insert_rows(table_name, columns, values):

    if isinstance(values, tuple):
        values = [values]
    if not isinstance(values, list):
        print('"values" parameter must be a tuple or an array of tuples')
        return None

    sql_query = "INSERT INTO {} (".format(table_name) + str.join(',', columns) + ") VALUES (%s, %s, %s)"

    print('sql_query: {}'.format(sql_query))
    query_result = _execute_query(INSERT_QUERY, sql_query, values)
    print(query_result)
