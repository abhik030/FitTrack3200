from flask import Blueprint, request, jsonify, make_response
import flask.json
import json
from src import db
from datetime import timedelta

def serialize_timedelta(td):
    if isinstance(td, timedelta):
        return str(td)
    return td

occupancy = Blueprint('occupancy', __name__)

# Returns a list of occupancy at all gyms
@occupancy.route('/occupancy', methods=['GET'])
def get_occupancy():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Occupancy')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append({header: serialize_timedelta(value) for header, value in zip(row_headers, row)})
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response



# NO IDEA WHY THIS DOES NOT WORK
# # Returns a list of occupancy at a specific gym
# @occupancy.route('/occupancy/<gymID>', methods=['GET'])
# def get_occupancy_by_gym(gymID):
#     try:
#         cursor = db.get_db().cursor()
#         cursor.execute('select * from Occupancy where Gym_ID = %s', (gymID,))
#         row_headers = [x[0] for x in cursor.description]
#         json_data = []
#         theData = cursor.fetchall()
#         for row in theData:
#             json_data.append({header: serialize_timedelta(value) for header, value in zip(row_headers, row)})
#         the_response = make_response(jsonify(json_data))
#         the_response.status_code = 200
#         the_response.mimetype = 'application/json'
#         return the_response
#     except Exception as e:
#         print(f"Error: {e}")
#         return make_response(jsonify({"error": "An error occurred"}), 500)