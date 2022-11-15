from flask import Flask, request
from flask_restful import Resource, Api, reqparse
import pymysql
import json
from database_interactions import *


app = Flask(__name__)
api = Api(app)

parser = reqparse.RequestParser()


class Login(Resource):
    def post(self):
        data = request.form.to_dict()
        flipped_data = dict([(value, key) for key, value in data.items()])
        data_string = flipped_data.get('')
        data_dict = json.loads(data_string)
        password = data_dict.get('password')
        username = data_dict.get('username')
        return login(username, password)


class CreateAccount(Resource):
    def post(self):
        data = request.form.to_dict()
        flipped_data = dict([(value, key) for key, value in data.items()])
        data_string = flipped_data.get('')
        data_dict = json.loads(data_string)
        password = data_dict.get('password')
        username = data_dict.get('username')
        first_name = data_dict.get('first_name')
        last_name = data_dict.get('last_name')
        return insert_user(username, password, first_name, last_name)


class Temperature(Resource):
    def get(self):
        args = request.args
        args_dict = args.to_dict()
        session_id = int(args_dict.get("sessionID"))
        current_temp = get_current_temp(session_id)
        max_ride_temp = get_max_ride_temp(session_id)
        min_ride_temp = get_min_ride_temp(session_id)
        return {"current_temp": current_temp,
                "max_ride_temp": max_ride_temp,
                "min_ride_temp": min_ride_temp}



class LoadRawData(Resource):
    def post(self):
        data = request.form.to_dict()
        flipped_data = dict([(value, key) for key, value in data.items()])
        data_string = flipped_data.get('')
        data_dict = json.loads(data_string)
        total_voltage = data_dict.get('totalVoltage')
        temperature_one = data_dict.get('temperatureOne')
        temperature_two = data_dict.get('temperatureTwo')
        voltage_one = data_dict.get('voltageOne')
        voltage_two = data_dict.get('voltageTwo')
        current = data_dict.get('current')
        session_id = data_dict.get('sessionID')
        user_id = data_dict.get('userID')
        if not session_id:
            battery_id = get_batteries(user_id)
            if not battery_id:
                battery_capacity = 48
                battery_id = insert_battery(user_id, battery_capacity)
            battery_id = get_batteries(user_id)[0]['battery_id']
            cur_capacity = 48
            session_id = create_new_session(battery_id, cur_capacity)
        add_raw_data_to(session_id, total_voltage, temperature_one, temperature_two,
         voltage_one, voltage_two, current)
        return int(session_id)

api.add_resource(Temperature, '/temperature')
api.add_resource(LoadRawData, '/loadRawData')
api.add_resource(Login, '/login')
api.add_resource(CreateAccount, '/createAccount')

def get_battery_percentage(v):
    battery_percentage = 1.58*(v**4) + -79.51*(v**3) + 1502.63*(v**2) + -12619.21*(v) + 39735.81
    return battery_percentage
