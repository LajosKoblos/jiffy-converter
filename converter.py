import sys
import csv
import sqlite3
import uuid
import datetime

csv_file_path = sys.argv[1]
sqlite_file_path = sys.argv[2]
user_id = sys.argv[3]
zone = sys.argv[4]
color = -12566464
archived = 'false'
worktime = 0
time_local = 0
rowstate = 0
local = 'true'

con = sqlite3.connect(sqlite_file_path)
cur = con.cursor()


def handle_time_tree(name, parent_uuid_m, parent_uuid_l, expanded):
    cur.execute('select uuidM, uuidL from jiffy_time_tree where name = ?', (customer,))
    result = cur.fetchone()
    if result is None:
        result = (get_uuid(), get_uuid())
        cur.execute('insert into jiffy_time_tree values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', (
            user_id,
            name,
            color,
            archived,
            worktime,
            rowstate,
            result[0],
            result[1],
            parent_uuid_m,
            parent_uuid_l,
            local,
            expanded,
            None,
            get_now(),
            0,
            0
        ))
    return result


def insert_row(row, owner_m, owner_l):
    cur.execute('insert into jiffy_times values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', (
        user_id,
        get_time(row['Start time']),
        get_time(row['Stop time']),
        0,
        None,
        zone,
        zone,
        get_uuid(),
        get_uuid(),
        owner_m,
        owner_l,
        'true',
        -1,
        get_now(),
        None,
        None
    ))


def get_now():
    return round(datetime.datetime.now().timestamp() * 1000)


def get_time(datetime_string):
    return datetime.datetime.strptime(datetime_string, '%Y-%m-%d %H:%M:%S').timestamp() * 1000


def get_uuid():
    return int(uuid.uuid1().int >> 64)


with open(csv_file_path) as csv_file:
    reader = csv.DictReader(csv_file)
    for row in reader:
        customer = handle_time_tree(row['Customer'], 0, 0, 'false')
        project = handle_time_tree(row['Project'], customer[0], customer[1], 'true')
        if row['Task'] == "":
            insert_row(row, project[0], project[1])
        else:
            task = handle_time_tree(row['Task'], project[0], project[1], 'false')
            insert_row(row, task[0], task[1])

con.commit()
con.close()
