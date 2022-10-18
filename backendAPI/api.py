from flask import Flask
from flask_restful import Resource, Api, reqparse
import pymysql

# Establish connection with the database
conn = pymysql.connect(
        host= 'capstone.cmkbscvpp696.us-east-1.rds.amazonaws.com',
        port = 3306,
        user = 'admin',
        password = 'ChuckGroup3!',
        db = 'default_app',
        )

# insert query into users table
def insert_users(users_id, email, pwd, join_date, max_capacity, firstname, lastname):
    cur=conn.cursor()
    cur.execute("INSERT INTO users VALUES (%s, %s, %s, %s, %s, %s, %s)", (users_id, email, pwd, join_date, max_capacity, firstname, lastname))
    conn.commit()

# read the data in users table
def get_users():
    cur=conn.cursor()
    cur.execute("SELECT * FROM users")
    users = cur.fetchall()
    return users

# delete row from users table based on id
def delete_from_users(id):
    cur = conn.cursor()
    cur.execute("DELETE FROM users WHERE users_id=%s", (id))
    conn.commit()

##--- HANDLING CURRENT / TEMPERATURE / VOLTAGE DATA ---##
# insert data into a specified table
def insert_data(table, session_id, time, value, users_id):
    cur=conn.cursor()
    cur.execute("INSERT INTO " + table + " VALUES (%s, %s, %s, %s)", (session_id, time, value, users_id))
    conn.commit()
    
# read the data in a table
def get_data(table):
    cur=conn.cursor()
    cur.execute("SELECT * FROM " + table)
    data = cur.fetchall()
    return data
    
# delete row from a data table based on session id
def delete_from_data(table, session_id):
    cur = conn.cursor()
    cur.execute("DELETE FROM " + table + " WHERE session_id=%s", (session_id))
    conn.commit()

##--- TESTING ---##
print("###### TEST RESULTS ######")

## USERS ##
# inserts data into users
insert_users('5', 'johndoe@capstone.com', 'fall', '2985-9-1', '1000', 'John', 'Doe')
# prints all of users table
print("After adding a new user...")
print(get_users())
# delete a row
delete_from_users('5')
print("After deleting a user...")
print(get_users())

### CURRENT ##
## inserts data into current table
insert_data('current', '1', '10', '20', '6')
## prints current table
print("After inserting into current...")
print(get_data('current'))
## delete the row
delete_from_data('current', '1')
print("After deleting from current...")
print(get_data('current'))

## TEMPERATURE ##
# inserts data into temperature table
insert_data('temperature', '2', '50', '100', '7')
# prints temperature table
print("After inserting into temperature...")
print(get_data('temperature'))
# delete the row
delete_from_data('temperature', '2')
print("After deleting from temperature...")
print(get_data('temperature'))

## VOLTAGE ##
# inserts data into voltage table
insert_data('voltage', '100', '200', '70', '7')
# prints voltage table
print("After inserting into voltage...")
print(get_data('voltage'))
# delete the row
delete_from_data('voltage', '100')
print("After deleting from voltage...")
print(get_data('voltage'))

#app = Flask(__name__)
#api = Api(app)
#
#parser = reqparse.RequestParser()
#
#
#class Voltage(Resource):
#    def post(self):
#        args = parser.parse_args()
#        return 200
#
#
#class Current(Resource):
#    def post(self):
#        args = parser.parse_args()
#        return 200
#
#
#class Temperature(Resource):
#    def post(self):
#        args = parser.parse_args()
#        return 200
#
#
#api.add_resource(Voltage, '/voltage')
#api.add_resource(Current, '/current')
#api.add_resource(Temperature, '/temperature')
#
#if __name__ == '__main__':
#    app.run(debug=True)
#
#
