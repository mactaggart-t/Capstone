from flask import Flask, request
from flask_restful import Resource, Api, reqparse
import pymysql
import json
from database_interactions import *


app = Flask(__name__)
api = Api(app)

parser = reqparse.RequestParser()


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
        temperature = data_dict.get('temperature')
        voltage_one = data_dict.get('voltageOne')
        voltage_two = data_dict.get('voltageTwo')
        current = data_dict.get('current')
        session_id = data_dict.get('sessionID')
        if not session_id:
            session_id = create_new_session()
        add_raw_data_to(session_id, total_voltage, temperature, voltage_one, voltage_two, current)
        return int(session_id)

api.add_resource(Temperature, '/temperature')
api.add_resource(LoadRawData, '/loadRawData')
