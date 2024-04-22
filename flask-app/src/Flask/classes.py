from flask import Blueprint, request, jsonify, make_response
import json
from src import db

classes = Blueprint('classes', __name__)


# Returns a list of all gym classes
@classes.route('/classes', methods=['GET'])
def get_classes():
    cursor = db.get_db().cursor()
    cursor.execute('select * from fitness_classes')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Returns a list of all classes at a specific gym 
@classes.route('/classes/<gymID>', methods=['GET'])
def get_classes_by_gym(gymID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from fitness_classes where gym_id = {0}'.format(gymID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Allows to sign up for fitness class
@classes.route('/classes/signup', methods=['POST'])
def signup_for_class():
    cursor = db.get_db().cursor()
    cursor.execute('insert into class_signups (class_id, member_id) values (%s, %s)', 
        (request.json['class_id'], request.json['member_id']))
    db.get_db().commit()
    the_response = make_response(jsonify('Signed up for class successfully'))
    the_response.status_code = 201
    the_response.mimetype = 'application/json'
    return the_response


# Allows to cancel fitness class sign up
@classes.route('/classes/cancel', methods=['POST'])
def cancel_class_signup():
    cursor = db.get_db().cursor()
    cursor.execute('delete from class_signups where class_id = %s and member_id = %s', 
        (request.json['class_id'], request.json['member_id']))
    db.get_db().commit()
    the_response = make_response(jsonify('Cancelled class sign up successfully'))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Returns a list of all classes a member is signed up for
@classes.route('/classes/member/<memberID>', methods=['GET'])
def get_classes_by_member(memberID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from fitness_classes where id in (select class_id from class_signups where member_id = {0})'.format(memberID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


#Returns specific details of a class
@classes.route('/classes/<classID>', methods=['GET'])
def get_classDetails(classID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from fitness_classes where id = {0}'.format(classID))
    gym_class = cursor.fetchone()
    if gym_class is None:
        the_response = make_response(jsonify('Class not found'))
        the_response.status_code = 404
        the_response.mimetype = 'application/json'
        return the_response
    else:
        class_details = {
            'id': gym_class[0],
            'name': gym_class[1],
            'description': gym_class[2],
            'start_time': gym_class[3],
            'end_time': gym_class[4],
            'gym_id': gym_class[5]
        }
        the_response = make_response(jsonify(class_details))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    



    