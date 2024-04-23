from flask import Blueprint, request, jsonify, make_response, Flask
from flaskext.mysql import MySQL

db = MySQL()

def create_app():
    app = Flask(__name__)
    
    app.config['SECRET_KEY'] = 'someCrazyS3cR3T!Key.!'
    app.config['MYSQL_DATABASE_USER'] = 'root'
    app.config['MYSQL_DATABASE_PASSWORD'] = open('/secrets/db_root_password.txt').readline().strip()
    app.config['MYSQL_DATABASE_HOST'] = 'db'
    app.config['MYSQL_DATABASE_PORT'] = 3306
    app.config['MYSQL_DATABASE_DB'] = 'fittrack'

    db.init_app(app)
    
    @app.route("/")
    def welcome():
        return "<h1>Welcome to the 3200 boilerplate app</h1>"

    from src.customers.customers import customers
    from src.Flask.gym import gym
    from src.Flask.attendance import attendance
    from src.Flask.classes import classes
    from src.Flask.occupancy import occupancy
    from src.Flask.profile import profile




    app.register_blueprint(customers, url_prefix='/customers')
    app.register_blueprint(gym, url_prefix='/gym')
    app.register_blueprint(attendance, url_prefix='/attendance')
    app.register_blueprint(classes, url_prefix='/classes')
    app.register_blueprint(occupancy, url_prefix='/occupancy')
    app.register_blueprint(profile, url_prefix='/profile')




    return app