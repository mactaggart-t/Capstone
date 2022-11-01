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

# see all users in the user table
def get_all_users():
    cur=conn.cursor()
    cur.execute("SELECT * FROM users")
    users = cur.fetchall()
    return users
    
# see information for a specific user, based on their email
def get_user(email):
    cur=conn.cursor()
    cur.execute("SELECT * FROM users WHERE email=%s", (email))
    user = cur.fetchall()
    return user

# delete row from users table based on email
def delete_from_users(email):
    cur = conn.cursor()
    cur.execute("DELETE FROM users WHERE email=%s", (email))
    conn.commit()

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

# read the data from a table
def get_table_data(table):
    cur=conn.cursor()
    cur.execute("SELECT * FROM " + table)
    data = cur.fetchall()
    return data

# read user data from current/voltage table
def get_user_data(table, session_id, num = -1):
   cur=conn.cursor()
   cur.execute("SELECT session_id, time, value FROM " + table + " WHERE session_id=%s order by time desc", (session_id))
   if (num > -1):
      data = cur.fetchall()
   else:
      data = cur.fetchmany(size = num)
   return data

# read user data from temperature table
def get_user_temp_data(session_id, num = -1):
   cur=conn.cursor()
   cur.execute("SELECT session_id, time, temp1, temp2 FROM temperature WHERE session_id=%s order by time desc", (session_id))
   if (num > -1):
      data = cur.fetchall()
   else:
      data = cur.fetchmany(size = num)
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
