# This file contains backend interaction with the database (AWS Server).
import datetime
import pymysql
# TODO: remove unused import after getting voltages is fixed
import random
from datetime import datetime, timedelta

# Establish a conection with the database
conn = pymysql.connect(
        host= 'capstone.cmkbscvpp696.us-east-1.rds.amazonaws.com',
        port = 3306,
        user = 'admin',
        password = 'ChuckGroup3!',
        db = 'default_app',
        )


"________________________________________________________________"
#_##_##_##_##_##_##_##_##_# USER TABLE #_##_##_##_##_##_##_##_##_#
"________________________________________________________________"


# insert user data into users table, get the current time and date for joining, first and last names are optional
def insert_user(email, pwd, firstname=None, lastname=None):
    cur=conn.cursor()
    if check_email(email):
        #print("User already exists!")
        return -1
    now = datetime.datetime.now()
    if(firstname!=None and lastname!=None):
        cur.execute("INSERT INTO users (email, pwd, join_date, firstname, lastname) VALUES (%s, %s, %s, %s, %s)", (email, pwd, now, firstname, lastname))
    elif(firstname!=None):
        cur.execute("INSERT INTO users (email, pwd, join_date, firstname) VALUES (%s, %s, %s, %s)", (email, pwd, now, firstname))
    elif(lastname!=None):
        cur.execute("INSERT INTO users (email, pwd, join_date, lastname) VALUES (%s, %s, %s, %s)", (email, pwd, now, lastname))
    else:
        cur.execute("INSERT INTO users (email, pwd, join_date) VALUES (%s, %s, %s)", (email, pwd, now))
    conn.commit()
    cur.execute("SELECT * FROM users WHERE email=%s", (email))
    return cur.fetchone()[0]

# see all users in the user table or a specific user based on their email
# TODO: split up and rename this function to be better
def get_user(email=None):
    cur=conn.cursor()
    if email is None:
        cur.execute("SELECT * FROM users")
    else:
        cur.execute("SELECT * FROM users WHERE email=%s", (email))
    user = cur.fetchall()
    return user

# Get all information about a user based on their user_id
def get_user_by_id(user_id):
    cur=conn.cursor()
    cur.execute("SELECT * FROM users WHERE user_id=%s", (user_id))
    user = cur.fetchone()
    return user

# delete row from users table based on email
# TODO: rename this function to be better
def delete_user(email):
    cur = conn.cursor()
    cur.execute("DELETE FROM users WHERE email=%s", (email))
    conn.commit()

# Check if email already exists, returns 1 if true and 0 if false
def check_email(email):
    cur = conn.cursor()
    cur.execute("SELECT EXISTS(SELECT * FROM users WHERE email=%s)", (email))
    return cur.fetchone()[0]

# Handle logging in, return user_id if successful
def login(email, pwd):
    cur = conn.cursor()
    cur.execute("SELECT EXISTS(SELECT * FROM users WHERE email=%s AND pwd=%s)", (email, pwd))
    if cur.fetchone()[0]:
        return get_user(email)[0][0]
    else:
        return -1


"______________________________________________________________"
#_##_##_##_##_##_##_##_# RAW DATA TABLE #_##_##_##_##_##_##_##_#
"______________________________________________________________"


# insert query into database tables
# Table Names:
# current
# temperature1
# temperature2
# voltage1
# voltage2
# voltage_total
def insert_data(table, time, value, session_id):
   cur=conn.cursor()
   cur.execute("INSERT INTO " + table + " (session_id, time, value) VALUES (%s, %s, %s)", (session_id, time, value))
   conn.commit()


def get_time_since_start(current_time, start_time):
    return datetime.fromtimestamp(float(current_time)) - start_time


# Main insert data function
def add_raw_data_to(session_id, total_voltage, temperature_one, temperature_two, voltage_one, voltage_two, current):
    start_time = get_start_time(session_id)
    for h in total_voltage:
        insert_data("voltage_total", get_time_since_start(h["timestamp"], start_time), h["value"], session_id)
    for i in temperature_one:
        insert_data("temperature1", get_time_since_start(i["timestamp"], start_time), i["value"], session_id)
    for j in temperature_two:
        insert_data("temperature2", get_time_since_start(j["timestamp"], start_time), j["value"], session_id)
    for k in voltage_one:
        insert_data("voltage1", get_time_since_start(k["timestamp"], start_time), k["value"], session_id)
    for l in voltage_two:
        insert_data("voltage2", get_time_since_start(l["timestamp"], start_time), l["value"], session_id)
    for m in current:
        insert_data("current", get_time_since_start(m["timestamp"], start_time), m["value"], session_id)

def get_total_voltages(session_id):
    conn_local = pymysql.connect(
            host= 'capstone.cmkbscvpp696.us-east-1.rds.amazonaws.com',
            port = 3306,
            user = 'admin',
            password = 'ChuckGroup3!',
            db = 'default_app',
            )

    cur=conn_local.cursor()
    cur.execute("SELECT value, time FROM voltage_total WHERE session_id=%s", session_id)
    data = cur.fetchall()
    return data
    # return [
    # (random.choice([23.0, 23.55, 24, 24.05, 25, 25.8, 26.10, 26.5, 26.6, 26.9, 27, 27.11]),
    #  idx)
    #   for idx in range(135)]

def get_currents(session_id):
    conn_local = pymysql.connect(
            host= 'capstone.cmkbscvpp696.us-east-1.rds.amazonaws.com',
            port = 3306,
            user = 'admin',
            password = 'ChuckGroup3!',
            db = 'default_app',
            )
    cur=conn_local.cursor()
    cur.execute("SELECT value, time FROM current WHERE session_id=%s", session_id)
    data = cur.fetchall()
    return data
    # return [
    # (random.choice([.001, .002, .0025, .003, .005, .01, .02, .033, .05, .075, .08, .1]),
    #  idx)
    #   for idx in range(13)]



# insert query into voltage table for totalVoltage
def insert_voltage1(time, data, session_id):
   cur=conn.cursor()
   cur.execute("INSERT INTO voltage (session_id, time1, voltage1) VALUES (%s, %s, %s)", (session_id, time, data))
   conn.commit()

# read the data from a table
def get_table_data(table):
    cur=conn.cursor()
    cur.execute("SELECT * FROM " + table)
    data = cur.fetchall()
    return data

# get a specific row of a table based on its entry id
def get_table_by_id(table, entry_id):
    cur=conn.cursor()
    cur.execute("SELECT * FROM " + table + " WHERE entry_id=%s", (entry_id))
    data = cur.fetchone()
    return data

# read user's session data from table
def get_user_data(table, session_id, num = -1):
   cur=conn.cursor()
   cur.execute("SELECT session_id, time, value FROM " + table + " WHERE session_id=%s order by time desc", (session_id))
   if (num > -1):
      data = cur.fetchmany(size = num)
   else:
      data = cur.fetchall()
   return data

# delete a row from a table based on its entry id
def delete_data_by_id(table, entry_id):
    cur=conn.cursor()
    cur.execute("DELETE FROM " + table + " WHERE entry_id=%s", (entry_id))
    conn.commit()

# delete rows from a table based on session id
# TODO: rename this function to be better
def delete_data(table, session_id):
    cur = conn.cursor()
    cur.execute("DELETE FROM " + table + " WHERE session_id=%s", (session_id))
    conn.commit()


"_____________________________________________________________"
#_##_##_##_##_##_##_##_# BATTERY TABLE #_##_##_##_##_##_##_##_#
"_____________________________________________________________"


# insert battery data into battery table, and return inserted battery id
def insert_battery(user_id, max_capacity):
    cur=conn.cursor()
    cur.execute("INSERT INTO battery (user_id, max_capacity) VALUES (%s, %s)", (user_id, max_capacity))
    conn.commit()
    cur.execute("SELECT battery_id FROM battery WHERE user_id=%s", (user_id))
    return cur.fetchone()

# see batteries in the battery table, either all of them or a specific user's
# TODO: split up and rename this function to be better
def get_battery_id(user_id=None):
    cur=conn.cursor()
    if user_id is None:
        cur.execute("SELECT * FROM battery")
    else:
        cur.execute("SELECT * FROM battery WHERE user_id=%s", (user_id))
    batteries = cur.fetchall()
    return batteries

# get battery based on a given battery id
def get_battery_by_id(battery_id):
    cur=conn.cursor()
    cur.execute("SELECT * FROM battery WHERE battery_id=%s", (battery_id))
    battery = cur.fetchone()
    return battery

# delete row from battery table based on battery id
# TODO: rename this function to be better
def delete_battery(battery_id):
    cur=conn.cursor()
    cur.execute("DELETE FROM battery WHERE battery_id=%s", (battery_id))
    conn.commit()


"_____________________________________________________________"
#_##_##_##_##_##_##_##_# SESSION TABLE #_##_##_##_##_##_##_##_#
"_____________________________________________________________"


# create a new session in the database, and return session_id
def create_new_session(battery_id, cur_capacity):
    cur=conn.cursor()
    now = datetime.now()
    cur.execute("INSERT INTO data_session (battery_id, session_start, cur_capacity) VALUES (%s, %s, %s)", (battery_id, now, cur_capacity))
    conn.commit()
    cur.execute("SELECT session_id FROM data_session ORDER BY session_id DESC")
    session_id, = cur.fetchone()
    return session_id

# see sessions in the data_session table, either all of them or ones for a specific battery
# TODO: split up and rename this function to be better
def get_sessions(battery_id=None):
    cur=conn.cursor()
    if battery_id is None:
        cur.execute("SELECT * FROM data_session")
    else:
        cur.execute("SELECT * FROM data_session WHERE battery_id=%s", (battery_id))
    sessions = cur.fetchall()
    return sessions

# get session based on a given session id
def get_session_by_id(session_id):
    cur=conn.cursor()
    cur.execute("SELECT * FROM data_session WHERE session_id=%s", (session_id))
    session = cur.fetchone()
    return session

# delete row from data_session table based on session id
# TODO: rename this function to be better
def delete_session(session_id):
    cur=conn.cursor()
    cur.execute("DELETE FROM data_session WHERE session_id=%s", (session_id))
    conn.commit()

def get_start_time(session_id):
    cur=conn.cursor()
    cur.execute("SELECT session_start FROM data_session WHERE session_id=%s", (session_id))
    start = cur.fetchone()
    return start


"_______________________________________________________________"
#_##_##_##_##_##_##_##_# FUNCTION CALLS #_##_##_##_##_##_##_##_#
"_______________________________________________________________"


# get the current temperature for the given session_id (take mean or median of up to previous 30 entries)
def get_current_temp(session_id):
    try:
        cur=conn.cursor()
        # TODO: Which current temp? temp1 or temp2? I could try joining the tables and picking the most recent of them both I suppose?
        cur.execute("""SELECT value from temperature1 WHERE session_id=%s
                       UNION ALL
                       SELECT value from temperature2 WHERE session_id=%s
                       order by time desc""", (session_id, session_id))
        data = cur.fetchone()
        return data
    except InterfaceError:
        return 100.4

# get the peak temperature recorded during the given session_id
def get_max_ride_temp(session_id):
   try:
       cur=conn.cursor()
       cur.execute("SELECT value FROM temperature1 WHERE session_id=%s order by value desc", (session_id))
       data = cur.fetchone()
       cur.execute("SELECT value FROM temperature2 WHERE session_id=%s order by value desc", (session_id))
       temp = cur.fetchone()
       if temp == None:
        return data if data != None else 130.4
       if temp > data:
          return temp
       return data
   except InterfaceError:
       return 130.4

# get the minimum temperature recorded during the given session_id
def get_min_ride_temp(session_id):
    try:
        cur=conn.cursor()
        cur.execute("SELECT value FROM temperature1 WHERE session_id=%s order by value asc", (session_id))
        data = cur.fetchone()
        cur.execute("SELECT value FROM temperature2 WHERE session_id=%s order by value asc", (session_id))
        temp = cur.fetchone()
        if temp == None:
         return data if data != None else 91.55
        if temp < data:
           return temp
        return data
    except InterfaceError:
        return 91.55


# provides battery_id from user_id (needs to be changed in the future to support multiple batteries)
def link_to_battery_id(user_id):
    cur=conn.cursor()
    cur.execute("SELECT battery_id WHERE user_id=%s", (user_id))
    return cur.fetchone()


# Calculate battery percentage based on voltage, v
def get_battery_percentage(v):
    if v > 25.8:
        battery_percentage = 33.5466*(v**2) - 1688.4695*v + 21239.0384
    else:
        battery_percentage = 4.72*v - 111
    return max(0, min(100, battery_percentage))
