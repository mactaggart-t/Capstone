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
insert_data('current', '2020081329', '80', '7')
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

# checks if user already exists
print("___________Inserting Already Existing User___________")
insert_user('ethanlam27@gmail.com', 'duplicate email')

# check login functionality working
print("___________Checking Login Functionality___________")
print("email: ethanlam27@gmail.com; password: capstone ==> PASS")
print(login("ethanlam27@gmail.com", "capstone"))
print("email: ethanlam27@gmail.com; password: stonecap ==> FAIL")
login("ethanlam27@gmail.com", "stonecap")
print("email: lamethan72@gmail.com; password: capstone ==> FAIL")
login("lamethan72@gmail.com", "capstone")




# placing extra code here - want to keep this just in case database_interactions isn't working

### Voltage ###
# insert query into voltage table for totalVoltage
#def insert_voltage_total(time, data, session_id):
#   cur=conn.cursor()
#   cur.execute("INSERT INTO voltage (session_id, time_tot, voltage_tot) VALUES (%s, %s, %s)", (session_id, time, data))
#   conn.commit()

# insert query into voltage table for totalVoltage
#def insert_voltage1(time, data, session_id):
#   cur=conn.cursor()
#   cur.execute("INSERT INTO voltage (session_id, time1, voltage1) VALUES (%s, %s, %s)", (session_id, time, data))
#   conn.commit()

# insert query into voltage table for totalVoltage
#def insert_voltage2(time, data, session_id):
#   cur=conn.cursor()
#   cur.execute("INSERT INTO voltage (session_id, time2, voltage2) VALUES (%s, %s, %s)", (session_id, time, data))
#   conn.commit()

### Temperature ###
# insert query into temperature table
#def insert_temp1(time, temp, session_id):
#   cur=conn.cursor()
#   cur.execute("INSERT INTO temperature (session_id, time1, temp1) VALUES (%s, %s, %s)", (session_id, time, temp))
#   conn.commit()

# insert query into temperature table
#def insert_temp2(time, temp, session_id):
#   cur=conn.cursor()
#   cur.execute("INSERT INTO temperature (session_id, time2, temp2) VALUES (%s, %s, %s)", (session_id, time, temp))
#   conn.commit()





## read user data from temperature table
## TODO Needs to be changed slightly now that database is different
##def get_user_temp_data(session_id, num = -1):
#   cur=conn.cursor()
#   cur.execute("SELECT session_id, time, temp1, temp2 FROM temperature WHERE session_id=%s order by time desc", (session_id))
#   if (num > -1):
#      data = cur.fetchmany(size = num)
#   else:
#      data = cur.fetchall()
#   return data



## insert session information into data_session table, get current time and date of the start of the session
## Outdated
#def insert_session(battery_id, cur_capacity):
#    cur=conn.cursor()
#    now = datetime.datetime.now()
#    cur.execute("INSERT INTO data_session (battery_id, session_start, cur_capacity)", (battery_id, now, cur_capacity))
#    conn.commit()