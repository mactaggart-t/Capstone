# This file contains backend interaction with the database (AWS Server).
import datetime
import pymysql

# Establish a conection with the database
conn = pymysql.connect(
        host= 'capstone.cmkbscvpp696.us-east-1.rds.amazonaws.com',
        port = 3306,
        user = 'admin',
        password = 'ChuckGroup3!',
        db = 'default_app',
        )

### USER TABLE ###
# insert user data into users table, get the current time and date for joining, first and last names are optional
def insert_user(email, pwd, firstname=None, lastname=None):
    cur=conn.cursor()
    now = datetime.datetime.now()
    cur.execute("INSERT INTO users (email, pwd, join_date, firstname, lastname) VALUES (%s, %s, %s, %s, %s, %s)", (email, pwd, now, firstname, lastname))
    conn.commit()

# see all users in the user table or a specific user based on their email
def get_user(email=None):
    cur=conn.cursor()
    if email is None:
        cur.execute("SELECT * FROM users")
    else:
        cur.execute("SELECT * FROM users WHERE email=%s", (email))
    user = cur.fetchall()
    return user

# delete row from users table based on email
def delete_user(email):
    cur = conn.cursor()
    cur.execute("DELETE FROM users WHERE email=%s", (email))
    conn.commit()
    
### BATTERY TABLE ###
# insert battery data into battery table
def insert_battery(user_id, max_capacity):
    cur=conn.cursor()
    cur.execute("INSERT INTO battery (user_id, max_capacity) VALUES (%s, %s)", (user_id, max_capacity))
    conn.commit()
    
# see batteries in the battery table, either all of them or a specific user's
def get_batteries(user_id=None):
    cur=conn.cursor()
    if user_id is None:
        cur.execute("SELECT * FROM battery")
    else:
        cur.execute("SELECT * FROM battery WHERE user_id=%s", (user_id))
    batteries = cur.fetchall()
    return batteries
    
# delete row from battery table based on battery id
def delete_battery(battery_id):
    cur=conn.cursor()
    cur.execute("DELETE FROM battery WHERE battery_id=%s", (battery_id))
    cur.commit()
    
### Current/Temperature/Voltage ###
# insert query into a table
def insert_data(table, time, data, user_id):
    cur=conn.cursor()
    cur.execute("INSERT INTO " + table + " (time, " + table + ", user_id) VALUES (%s, %s, %s)", (time, data, user_id))
    conn.commit()

# read the data from a table
def get_data(table):
    cur=conn.cursor()
    cur.execute("SELECT * FROM " + table)
    data = cur.fetchall()
    return data

# delete row from a table based on user id
def delete_data(table, user_id):
    cur = conn.cursor()
    cur.execute("DELETE FROM " + table + " WHERE user_id=%s", (user_id))
    conn.commit()
    
def create_new_session_and_add_data(total_voltage, temperature, voltage_one,
 voltage_two, current):
    return 1
    
def add_raw_data_to(session_id, total_voltage, temperature, voltage_one,
 voltage_two, current):
    pass
