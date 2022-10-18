from flask import Flask, request
from flask_restful import Resource, Api, reqparse
import json

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
