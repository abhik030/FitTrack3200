from flask import Blueprint, request, jsonify, make_response
import json
from src import db


profile = Blueprint('profile', __name__)

# Create a new member profile
@profile.route('/profile', methods=['POST'])
def create_profile():
    cursor = db.get_db().cursor()
    cursor.execute('insert into profiles (first_name, last_name, email, phone, address) values (%s, %s, %s, %s, %s)', 
        (request.json['first_name'], request.json['last_name'], request.json['email'], request.json['phone'], request.json['address']))
    db.get_db().commit()
    the_response = make_response(jsonify('Profile added successfully'))
    the_response.status_code = 201
    the_response.mimetype = 'application/json'
    return the_response

# Updating a member profile
@profile.route('/profile/<profileID>', methods=['PUT'])
def update_profile(profileID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from profiles where id = %s', (profileID,))
    profile = cursor.fetchone()
    if profile is None:
        the_response = make_response(jsonify('Profile not found'))
        the_response.status_code = 404
        the_response.mimetype = 'application/json'
        return the_response
    else:
        cursor.execute('update profiles set first_name = %s, last_name = %s, email = %s, phone = %s, address = %s where id = %s',
                       (request.json['first_name'], request.json['last_name'], request.json['email'], request.json['phone'], request.json['address'], profileID))
        db.get_db().commit()
        the_response = make_response(jsonify('Profile updated successfully'))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    
# Delete a member profile
@profile.route('/profile/<profileID>', methods=['DELETE'])
def delete_profile(profileID):
    cursor = db.get_db().cursor()
    cursor.execute('delete from profiles where id = %s', (profileID,))
    db.get_db().commit()
    the_response = make_response(jsonify('Profile deleted successfully'))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Return specific profile details
@profile.route('/profile/<profileID>', methods=['GET'])
def get_profileDetails(profileID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from profiles where id = %s', (profileID,))
    profile = cursor.fetchone()
    if profile is None:
        the_response = make_response(jsonify('Profile not found'))
        the_response.status_code = 404
        the_response.mimetype = 'application/json'
        return the_response
    else:
        profile_details = {
            'id': profile[0],
            'first_name': profile[1],
            'last_name': profile[2],
            'email': profile[3],
            'phone': profile[4],
            'address': profile[5]
        }
        the_response = make_response(jsonify(profile_details))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
