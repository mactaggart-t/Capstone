from flask import Flask, request
from flask_restful import Resource, Api, reqparse
import pymysql
import json
from database_interactions import create_new_session_and_add_data, add_raw_data_to


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

app = Flask(__name__)
api = Api(app)

parser = reqparse.RequestParser()


class Temperature(Resource):
    def get(self):
#        current_temp = get_current_temp()
#        max_ride_temp = get_max_ride_temp()
#        min_ride_temp = get_min_ride_temp()
        return 200



class LoadRawData(Resource):
    def post(self):
        data = request.form.to_dict()
        flipped_data = dict([(value, key) for key, value in data.items()])
        data_string = flipped_data.get('')
        data_dict = json.loads(data_string)
        print(data_dict)
        total_voltage = data_dict.get('totalVoltage')
        temperature = data_dict.get('temperature')
        voltage_one = data_dict.get('voltageOne')
        voltage_two = data_dict.get('voltageTwo')
        current = data_dict.get('current')
        session_id = data_dict.get('sessionID')
        if session_id:
            add_raw_data_to(session_id, total_voltage, temperature, voltage_one, voltage_two, current)
            return int(session_id)
        else:
            return create_new_session_and_add_data(total_voltage, temperature,
            voltage_one, voltage_two, current)

api.add_resource(Temperature, '/temperature')
api.add_resource(LoadRawData, '/loadRawData')

if __name__ == '__main__':
    app.run(debug=True, port=5001)