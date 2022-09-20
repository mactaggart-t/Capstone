from flask import Flask
from flask_restful import Resource, Api, reqparse

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


api.add_resource(Voltage, '/voltage')
api.add_resource(Current, '/current')
api.add_resource(Temperature, '/temperature')

if __name__ == '__main__':
    app.run(debug=True)
