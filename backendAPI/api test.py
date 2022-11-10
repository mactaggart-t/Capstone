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
# Prevent multiple users with the same email
# delete_user()






### TESTING ###
# def insert_user(email, pwd, firstname=None, lastname=None):
# def get_user(email=None):
# def delete_user(email):
# inserts data into users
print("___________Insert User Data into Table___________")
insert_user('johndoe@capstone.com', 'johnnyBoy1!')
insert_user('alisonFlayer@capstone.com', 'mindflayer123@', 'Alison')
insert_user('corporalJackkson@stuff.com', 'password123', None, 'Jackson')
insert_user('ahaile@goog.eu', '1unkbux#', 'Alicia', 'Haile')
print(get_user(), end='\n\n')
# delete a row from users
print("___________Delete User Data from Table___________")
delete_user('johndoe@capstone.com')
delete_user('alisonFlayer@capstone.com')
delete_user('corporalJackkson@stuff.com')
delete_user('ahaile@goog.eu')
print(get_user(), end='\n\n')

# def insert_data(table, time, value, session_id):
# def get_user_data(table, session_id, num = -1):
# def delete_data(table, user_id):
# inserts data into current
print("___________Insert Current Data into Table___________")
insert_data('current', '10', '80', '7')
insert_data('current', '12', '54', '7')
print(get_user_data('current', '7'), end='\n\n')
# delete a row froms current
print("___________Delete Current Data from Table___________")
delete_data('current', '7')
print(get_user_data('current', '7'), end='\n\n')

# def insert_data(table, time, value, session_id):
# def insert_temp_data(time, value, session_id):
# def get_user_data(table, session_id, num = -1):
# def get_user_temp_data(session_id, num = -1):
# def delete_data(table, user_id):
## inserts data into temperature
print("___________Insert Temperature Data into Table___________")
insert_data('temperature', '120', ['20', '12'], '6')
print(get_user_data('temperature', '6'), end='\n\n')
# delete a row froms temperature
print("___________Delete Temperature Data from Table___________")
delete_data('temperature', '6')
print(get_user_data('temperature', '6'), end='\n\n')

# inserts data into voltage
print("___________Insert Voltage Data into Table___________")
insert_data('voltage', '5', '12', '7')
print(get_user_data('voltage', '7'), end='\n\n')
# delete a row froms voltage
print("___________Delete Voltage Data from Table___________")
delete_data('voltage', '7')
print(get_user_data('voltage', '7'), end='\n\n')