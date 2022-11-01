
# create a new session in the database
def create_new_session():
    return 1
    
# create new entries for the given values for the given session_id
def add_raw_data_to(session_id, total_voltage, temperature, voltage_one,
 voltage_two, current):
    pass

# get the current temperature for the given session_id (take mean or median of up to previous 30 entries)
def get_current_temp(session_id):
    return 100.4
    
# get the peak temperature recorded during the given session_id
def get_max_ride_temp(session_id):
    return 185.2
    
# get the minimum temperature recorded during the given session_id
def get_min_ride_temp(session_id):
    return 85.01
