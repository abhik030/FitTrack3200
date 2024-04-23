from flask import Blueprint, request, jsonify, make_response
import json
from src import db

attendance = Blueprint('attendance', __name__)


# Returns gym attendance data
@attendance.route('/attendance', methods=['GET'])
def get_attendance():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Attendance')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Tracks gym attendance
@attendance.route('/attendance', methods=['POST'])
def track_attendance():
    cursor = db.get_db().cursor()
    cursor.execute('insert into Attendance (member_id, gym_id, date) values (%s, %s, %s)', 
        (request.json['member_id'], request.json['gym_id'], request.json['date']))
    db.get_db().commit()
    the_response = make_response(jsonify('Attendance tracked successfully'))
    the_response.status_code = 201
    the_response.mimetype = 'application/json'
    return the_response

# # Updates gym attendance | Not working
# @attendance.route('/attendance/<int:member_id>', methods=['PUT'])
# def update_attendance(member_id):
#     cursor = db.get_db().cursor()
#     cursor.execute('update Attendance set Workout_Freq = %s where Member_ID = %s', 
#         (request.json['workout_freq'], member_id))
#     print(request.json['workout_freq'])
#     db.get_db().commit()
#     the_response = make_response(jsonify('Attendance updated successfully'))
#     the_response.status_code = 200
#     the_response.mimetype = 'application/json'
#     return the_response