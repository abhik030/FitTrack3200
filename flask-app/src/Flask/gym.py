from flask import Blueprint, request, jsonify, make_response
import json
from src import db


gym = Blueprint('gym', __name__)

# Get a list of all available gyms -> Working
@gym.route('/gyms', methods=['GET'])
def get_gyms():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Gym')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Add a new gym to the DB -> Works
@gym.route('/gyms', methods=['POST'])
def add_gym():
    cursor = db.get_db().cursor()
    cursor.execute('insert into Gym (Gym_ID, Name, Address) values (%s, %s, %s)', 
        (request.json['Gym_ID'], request.json['Name'], request.json['Address']))
    db.get_db().commit()
    the_response = make_response(jsonify('Gym added successfully'))
    the_response.status_code = 201
    the_response.mimetype = 'application/json'
    return the_response

# Return gym name and address for a specific gym -> Works
@gym.route('/gyms/<gymID>', methods=['GET']) 
def get_gymDetails(gymID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Gym where gym_id = {0}'.format(gymID))
    gym = cursor.fetchone()
    if gym is None:
        the_response = make_response(jsonify('Gym not found'))
        the_response.status_code = 404
        the_response.mimetype = 'application/json'
        return the_response
    else:
        gym_details = {
            'name': gym[1],
            'address': gym[2],
        }
        the_response = make_response(jsonify(gym_details))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response