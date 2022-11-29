from flask import Flask, request
from flask_restful import Resource, Api, reqparse
import numpy as np
import pymysql
import json
from database_interactions import *
import time


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
        temp_dict = {**current_temp, **max_ride_temp, **min_ride_temp}
        return temp_dict


class BatteryPercentage(Resource):
    def get(self):
        args = request.args
        args_dict = args.to_dict()
        session_id = int(args_dict.get("sessionID"))
        all_voltages = get_total_voltages(session_id)
        ten_spaced_elems_idx = np.round(np.linspace(0, len(all_voltages)-1, min(10, len(all_voltages)))).astype(int)
        ten_spaced_elems = [all_voltages[idx] for idx in ten_spaced_elems_idx]
        battery_percentages = []
        for voltage_time_pair in ten_spaced_elems:
            voltage, timestamp = voltage_time_pair
            battery_percentages.append((get_battery_percentage(voltage),
             timestamp.seconds/60))
        return battery_percentages



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
            cur_capacity = 28
            battery_id = get_battery_id(user_id)
            if not battery_id:
                battery_id = insert_battery(user_id, cur_capacity)
            session_id = create_new_session(battery_id, cur_capacity)
        add_raw_data_to(session_id, total_voltage, temperature_one, temperature_two, voltage_one, voltage_two, current)
        return int(session_id)

class GeneralBatteryData(Resource):
    def __smoothed_data(self, slice_size, input_arr):
        smoothed_value = 0
        for elem in input_arr[-slice_size:]:
            elem_val, _ = elem
            smoothed_value += elem_val
        return smoothed_value/slice_size if slice_size != 0 else 0

    def __get_battery_life_remaining(self, current, current_percentage):
        return (current_percentage / 100) * (20 / current) * 60 if current != 0 else 0

    def get(self):
        args = request.args
        args_dict = args.to_dict()
        session_id = int(args_dict.get("sessionID"))
        all_voltages = get_total_voltages(session_id)
        all_currents = get_currents(session_id)
        smoothed_voltage = self.__smoothed_data(min(10, len(all_voltages)), all_voltages)
        smoothed_current = self.__smoothed_data(min(10, len(all_currents)), all_currents)
        power = smoothed_voltage * smoothed_current
        battery_percentage = get_battery_percentage(smoothed_voltage)
        battery_life_remaining = self.__get_battery_life_remaining(smoothed_current, battery_percentage)
        return {
         "current_percentage": battery_percentage,
         "total_voltage": smoothed_voltage,
         "current": smoothed_current,
         "battery_life": battery_life_remaining,
         "power": power,
         }

class AccountData(Resource):
    def get(self):
        args = request.args
        args_dict = args.to_dict()
        user_id = int(args_dict.get("userID"))
        user_info = get_user_by_id(user_id)
        _, email, _, _, first_name, last_name = user_info
        return {
        "first_name": first_name,
        "last_name": last_name,
        "email": email
        }


api.add_resource(Temperature, '/temperature')
api.add_resource(LoadRawData, '/loadRawData')
api.add_resource(Login, '/login')
api.add_resource(CreateAccount, '/createAccount')
api.add_resource(BatteryPercentage, '/batteryPercentages')
api.add_resource(GeneralBatteryData, '/mostRecentData')
api.add_resource(AccountData, '/userData')
