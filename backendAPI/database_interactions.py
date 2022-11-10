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
    if check_email(email):
        # TODO: handle this better within the api (frontend)
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
        # TODO: have a better way of handling this within the api (frontend)
        #print("Incorrect username and/or password. Please try again.")
        return -1


### Current/Voltage ###
# insert query into voltage/current table
def insert_cur_vol(table, time, data, session_id):
   cur=conn.cursor()
   cur.execute("INSERT INTO " + table + " (session_id, time, data) VALUES (%s, %s, %s)", (session_id, time, data))
   conn.commit()

### Temperature ###
# insert query into temperature table
def insert_temp(time, temp1, temp2, session_id):
   cur=conn.cursor()
   cur.execute("INSERT INTO temperature (session_id, time, temp1, temp2) VALUES (%s, %s, %s, %s)", (session_id, time, temp1, temp2))
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
    
### SESSION TABLE ###
# insert session information into data_session table, get current time and date of the start of the session
def insert_session(battery_id, cur_capacity):
    cur=conn.cursor()
    now = datetime.datetime.now()
    cur.execute("INSERT INTO data_session (battery_id, session_start, cur_capacity)", (battery_id, now, cur_capacity))
    cur.commit()
    
# see sessions in the data_session table, either all of them or ones for a specific battery
def get_sessions(battery_id=None):
    cur=conn.cursor()
    if battery_id is None:
        cur.execute("SELECT * FROM data_session")
    else:
        cur.execute("SELECT * FROM data_session WHERE battery_id=%s", (battery_id))
    sessions = cur.fetchall()
    return sessions
    
# delete row from data_session table based on session id
def delete_session(session_id):
    cur=conn.cursor()
    cur.execute("DELETE FROM data_session WHERE session_id=%s", (session_id))
    cur.commit()
    
### Current/Temperature/Voltage ###
# insert query into a Current/Voltage table
def insert_data(table, time, value, session_id):
    if table == 'temperature':
      insert_temp_data(time, value, session_id)
      return
    cur=conn.cursor()
    cur.execute("INSERT INTO " + table + " (session_id, time, value) VALUES (%s, %s, %s)", (session_id, time, value))
    conn.commit()

# insert query into a Temperature table
def insert_temp_data(time, value, session_id):
    cur = conn.cursor()
    cur.execute("INSERT INTO temperature (session_id, time, temp1, temp2) VALUES (%s, %s, %s, %s)", (session_id, time, value[0], value[1]))
    conn.commit()

# read the data from a table
def get_table_data(table):
    cur=conn.cursor()
    cur.execute("SELECT * FROM " + table)
    data = cur.fetchall()
    return data

# read user data from current/voltage table
def get_user_data(table, session_id, num = -1):
   if table == 'temperature':
      return get_user_temp_data(session_id, num)
   cur=conn.cursor()
   cur.execute("SELECT session_id, time, value FROM " + table + " WHERE session_id=%s order by time desc", (session_id))
   if (num > -1):
      data = cur.fetchmany(size = num)
   else:
      data = cur.fetchall()
   return data

# read user data from temperature table
def get_user_temp_data(session_id, num = -1):
   cur=conn.cursor()
   cur.execute("SELECT session_id, time, temp1, temp2 FROM temperature WHERE session_id=%s order by time desc", (session_id))
   if (num > -1):
      data = cur.fetchmany(size = num)
   else:
      data = cur.fetchall()
   return data

# delete row from a table based on user id
# TODO: needs to be fixed
def delete_data(table, session_id):
    cur = conn.cursor()
    cur.execute("DELETE FROM " + table + " WHERE session_id=%s", (session_id))
    conn.commit()
    
# create a new session in the database
def create_new_session(battery_id, cur_capacity):
    cur=conn.cursor()
    now = datetime.datetime.now()
    cur.execute("INSERT INTO data_session (battery_id, session_start, cur_capacity) VALUES (%s, %s, %s)", (battery_id, now, cur_capacity))
    conn.commit()
    cur.execute("SELECT session_id WHERE session_start = %s", (now))
    return cur.fetchone()
    
# create new entries for the given values for the given session_id
def add_raw_data_to(session_id, total_voltage, temperature, voltage_one,
 voltage_two, current):
    pass

# get the current temperature for the given session_id (take mean or median of up to previous 30 entries)
def get_current_temp(session_id):
    return 100.4
    
# get the peak temperature recorded during the given session_id
def get_max_ride_temp(session_id):
   cur=conn.cursor()
   cur.execute("SELECT temp1 FROM temperature WHERE session_id=%s order by temp1 desc", (session_id))
   data = cur.fetchone()
   cur.execute("SELECT temp2 FROM temperature WHERE session_id=%s order by temp2 desc", (session_id))
   temp = cur.fetchone()
   if temp == None:
    return data if data != None else None
   if temp > data:
      return temp
   return data
    
# get the minimum temperature recorded during the given session_id
def get_min_ride_temp(session_id):
   cur=conn.cursor()
   cur.execute("SELECT temp1 FROM temperature WHERE session_id=%s order by temp1 asc", (session_id))
   data = cur.fetchone()
   cur.execute("SELECT temp2 FROM temperature WHERE session_id=%s order by temp2 asc", (session_id))
   temp = cur.fetchone()
   if temp < data:
      return temp
   return data

# provides battery_id from user_id (needs to be changed in the future to support multiple batteries)
def link_to_battery_id(user_id):
    cur=conn.cursor()
    cur.execute("SELECT battery_id WHERE user_id=%s", (user_id))
    return cur.fetchone()

# Main insert data function
def add_raw_data_to(session_id, total_voltage, temperature, voltage_one, voltage_two, current):
    for i in current:
        insert_cur_vol("current", i["timestamp"], i["value"], session_id)
    # TODO
    
    # insert_cur_vol("voltage", timestamp, data, session_id):