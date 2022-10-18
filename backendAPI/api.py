from flask import Flask
from flask_restful import Resource, Api, reqparse
import pymysql

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

# read the data from users table
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
    
### Current/Temperature/Voltage ###
# insert query into a table
def insert_data(table, session_id, time, data, users_id):
    cur=conn.cursor()
    cur.execute("INSERT INTO " + table + " VALUES (%s, %s, %s, %s)", (session_id, time, data, users_id))
    conn.commit()

# read the data from a table
def get_data(table):
    cur=conn.cursor()
    cur.execute("SELECT * FROM " + table)
    data = cur.fetchall()
    return data

# delete row from a table based on session id
def delete_data(table, session_id):
    cur = conn.cursor()
    cur.execute("DELETE FROM " + table + " WHERE users_id=%s", (session_id))
    conn.commit()

### TESTING ###
# inserts data into users
print("Insert User Data into Table")
insert_users('5', 'johndoe@capstone.com', 'fall', '2985-9-1', '1000', 'John', 'Doe')
print(get_users())
# delete a row from users
print("Delete User Data from Table")
delete_from_users('5')
print(get_users())

# inserts data into current
print("Insert Current Data into Table")
insert_data('current', '1', '10', '80', '7')
print(get_data('current'))
# delete a row froms current
print("Delete Current Data from Table")
delete_data('current', '1')
print(get_data('current'))

# inserts data into temperature
print("Insert Temperature Data into Table")
insert_data('temperature', '10', '120', '20', '6')
print(get_data('temperature'))
# delete a row froms temperature
print("Delete Temperature Data from Table")
delete_data('temperature', '10')
print(get_data('temperature'))

# inserts data into voltage
print("Insert Voltage Data into Table")
insert_data('voltage', '100', '5', '12', '7')
print(get_data('voltage'))
# delete a row froms voltage
print("Delete Voltage Data from Table")
delete_data('voltage', '100')
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
