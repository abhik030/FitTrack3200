from flask import Blueprint, request, jsonify, make_response
import json
from src import db

profile = Blueprint('profile', __name__)

# Create a new member profile -> Partially Works (If a member ID is given then a profile can be made)
@profile.route('/profile', methods=['POST'])
def create_profile():
    cursor = db.get_db().cursor()
    cursor.execute('insert into Member_Profile (Member_ID, Home_Gym_ID, Fitness_Goal, UserName, Gender, Achievements, Preferences, Membership_Start_Date) values (%s, %s, %s, %s, %s, %s, %s, %s)', 
        (request.json['Member_ID'], request.json['Home_Gym_ID'], request.json['Fitness_Goal'], request.json['UserName'], request.json['Gender'], request.json['Achievements'], request.json['Preferences'], request.json['Membership_Start_Date']))
    db.get_db().commit()
    the_response = make_response(jsonify('Profile added successfully'))
    the_response.status_code = 201
    the_response.mimetype = 'application/json'
    return the_response


# Return specific profile details -> Works
@profile.route('/profile/<profileID>', methods=['GET'])
def get_profileDetails(profileID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Member_Profile where Member_ID = %s', (profileID,))
    profile = cursor.fetchone()
    if profile is None:
        the_response = make_response(jsonify('Profile not found'))
        the_response.status_code = 404
        the_response.mimetype = 'application/json'
        return the_response
    else:
        profile_details = {
            'Member_ID': profile[0],
            'Home_Gym_ID': profile[1],
            'Fitness_Goal': profile[2],
            'UserName': profile[3],
            'Gender': profile[4],
            'Achievements': profile[5],
            'Preferences': profile[6],
            'Membership_Start_Date': profile[7]
        }
        the_response = make_response(jsonify(profile_details))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response

# Updating a member profile -> Works
@profile.route('/profile/<profileID>', methods=['PUT'])
def update_profile(profileID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Member_Profile where Member_ID = %s', (profileID,))
    profile = cursor.fetchone()
    if profile is None:
        the_response = make_response(jsonify('Profile not found'))
        the_response.status_code = 404
        the_response.mimetype = 'application/json'
        return the_response
    else:
        cursor.execute('update Member_Profile set Home_Gym_ID = %s, Fitness_Goal = %s, UserName = %s, Gender = %s, Achievements = %s, Preferences = %s, Membership_Start_Date = %s where Member_ID = %s',
                       (request.json['Home_Gym_ID'], request.json['Fitness_Goal'], request.json['UserName'], request.json['Gender'], request.json['Achievements'], request.json['Preferences'], request.json['Membership_Start_Date'], profileID))
        db.get_db().commit()
        the_response = make_response(jsonify('Profile updated successfully'))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    
# Delete a member profile -> Works
@profile.route('/profile/<profileID>', methods=['DELETE'])
def delete_profile(profileID):
    cursor = db.get_db().cursor()
    cursor.execute('delete from Member_Profile where Member_ID = %s', (profileID,))
    db.get_db().commit()
    the_response = make_response(jsonify('Profile deleted successfully'))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
