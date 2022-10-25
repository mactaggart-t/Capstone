from flask import Flask, request
from flask_restful import Resource, Api, reqparse
import pymysql
import json

from api import *


conn = pymysql.connect(
        host= 'capstone.cmkbscvpp696.us-east-1.rds.amazonaws.com',
        port = 3306,
        user = 'admin',
        password = 'ChuckGroup3!',
        db = 'default_app',
        )

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