from flask import Flask, request
from flask_restful import Resource, Api, reqparse
import json
from database_interactions import *

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
