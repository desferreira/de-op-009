import psycopg2

def lambda_metodo(event, context):

    # establishing the connection
    conn = psycopg2.connect(
        database="postgres", user='username', password='password', host='terraform-20230419063231030400000001.cxpvmuydcarm.us-east-1.rds.amazonaws.com', port='5432'
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
