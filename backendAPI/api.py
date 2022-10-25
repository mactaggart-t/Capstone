from flask import Flask, request
from flask_restful import Resource, Api, reqparse
import pymysql
import json


conn = pymysql.connect(
        host= 'capstone.cmkbscvpp696.us-east-1.rds.amazonaws.com',
        port = 3306,
        user = 'admin',
        password = 'ChuckGroup3!',
        db = 'default_app',
        )

# insert query into users table
def insert_users(email, pwd, join_date, max_capacity, firstname, lastname):
    cur=conn.cursor()
    cur.execute("INSERT INTO users (email, pwd, join_date, max_capacity, firstname, lastname) VALUES (%s, %s, %s, %s, %s, %s)", (email, pwd, join_date, max_capacity, firstname, lastname))
    conn.commit()

# read the data from users table
def get_users():
    cur=conn.cursor()
    cur.execute("SELECT * FROM users")
    users = cur.fetchall()
    return users

# delete row from users table based on email
def delete_from_users(email):
    cur = conn.cursor()
    cur.execute("DELETE FROM users WHERE email=%s", (email))
    conn.commit()
    
### Current/Temperature/Voltage ###
# insert query into a table
def insert_data(table, time, data, user_id):
    cur=conn.cursor()
    cur.execute("INSERT INTO " + table + " (time, " + table + ", user_id) VALUES (%s, %s, %s)", (time, data, user_id))
    conn.commit()

# read the data from a table
def get_data(table):
    cur=conn.cursor()
    cur.execute("SELECT * FROM " + table)
    data = cur.fetchall()
    return data

# delete row from a table based on user id
def delete_data(table, user_id):
    cur = conn.cursor()
    cur.execute("DELETE FROM " + table + " WHERE user_id=%s", (user_id))
    conn.commit()

### TESTING ###
# inserts data into users
print("Insert User Data into Table")
insert_users('johndoe@capstone.com', 'fall', '2985-9-1', '1000', 'John', 'Doe')
print(get_users())
# delete a row from users
print("Delete User Data from Table")
delete_from_users('johndoe@capstone.com')
print(get_users())

# inserts data into current
print("Insert Current Data into Table")
insert_data('current', '10', '80', '7')
print(get_data('current'))
# delete a row froms current
print("Delete Current Data from Table")
delete_data('current', '7')
print(get_data('current'))


## inserts data into temperature
print("Insert Temperature Data into Table")
insert_data('temperature', '120', '20', '6')
print(get_data('temperature'))
# delete a row froms temperature
print("Delete Temperature Data from Table")
delete_data('temperature', '6')
print(get_data('temperature'))

# inserts data into voltage
print("Insert Voltage Data into Table")
insert_data('voltage', '5', '12', '7')
print(get_data('voltage'))
# delete a row froms voltage
print("Delete Voltage Data from Table")
delete_data('voltage', '7')
print(get_data('voltage'))

app = Flask(__name__)
api = Api(app)

parser = reqparse.RequestParser()


class Voltage(Resource):
    def post(self):
        args = parser.parse_args()
        return 200


class Current(Resource):
    def post(self):
        args = parser.parse_args()
        return 200


class Temperature(Resource):
    def post(self):
        args = parser.parse_args()
        return 200



class LoadRawData(Resource):
    def post(self):
        data = request.form.to_dict()
        flipped_data = dict([(value, key) for key, value in data.items()])
        data_string = flipped_data.get('')
        data_dict = json.loads(data_string)
        total_voltage = data_dict.get('totalVoltage')
        temperature = data_dict.get('temperature')
        voltage_one = data_dict.get('voltageOne')
        voltage_two = data_dict.get('voltageTwo')
        current = data_dict.get('current')
        

api.add_resource(Voltage, '/voltage')
api.add_resource(Current, '/current')
api.add_resource(Temperature, '/temperature')
api.add_resource(LoadRawData, '/loadRawData')

if __name__ == '__main__':
    app.run(debug=True, port=5001)
