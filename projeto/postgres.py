import psycopg2
import os

def lambda_metodo(event, context):

    # establishing the connection
    conn = psycopg2.connect(
        database="postgres", user=os.getenv("DB_USER"), password=os.getenv("DB_PASS"), host=os.getenv("DB_URL"), port=os.getenv("DB_PORT")
    )
    # Creating a cursor object using the cursor() method
    cursor = conn.cursor()

    # Executing an MYSQL function using the execute() method
    cursor.execute("select version()")

    # Fetch a single row using fetchone() method.
    data = cursor.fetchone()
    print("Connection established to: ", data)

    # Closing the connection
    conn.close()
