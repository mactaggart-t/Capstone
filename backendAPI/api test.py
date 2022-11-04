from flask import Flask, request
from flask_restful import Resource, Api, reqparse
import pymysql
import json

from api import *
from database_interactions import *


conn = pymysql.connect(
        host= 'capstone.cmkbscvpp696.us-east-1.rds.amazonaws.com',
        port = 3306,
        user = 'admin',
        password = 'ChuckGroup3!',
        db = 'default_app',
        )

#TODO List
# fix old functions
# delete_data






### TESTING ###
# def insert_user(email, pwd, firstname=None, lastname=None):
# def get_user(email=None):
# def delete_user(email):
# inserts data into users
print("Insert User Data into Table")
insert_user('johndoe@capstone.com', 'johnnyBoy1!')
print(get_user())
# delete a row from users
print("Delete User Data from Table")
delete_user('johndoe@capstone.com')
print(get_user())

# def insert_data(table, time, value, session_id):
# def get_user_data(table, session_id, num = -1):
# def delete_data(table, user_id):
# inserts data into current
print("Insert Current Data into Table")
insert_data('current', '10', '80', '7')
print(get_user_data('current', '7'))
# delete a row froms current
print("Delete Current Data from Table")
delete_data('current', '7')
print(get_user_data('current', '7'))


## inserts data into temperature
print("Insert Temperature Data into Table")
insert_data('temperature', '120', '20', '6')
print(get_user_data('temperature', '6'))
# delete a row froms temperature
print("Delete Temperature Data from Table")
delete_data('temperature', '6', '6')
print(get_user_data('temperature'))

# inserts data into voltage
print("Insert Voltage Data into Table")
insert_data('voltage', '5', '12', '7')
print(get_user_data('voltage', '7'))
# delete a row froms voltage
print("Delete Voltage Data from Table")
delete_data('voltage', '7')
print(get_user_data('voltage', '7'))