from flask import Blueprint, request, jsonify, make_response, Flask
from flaskext.mysql import MySQL

db = MySQL()

def create_app():
    app = Flask(__name__)
    
    app.config['SECRET_KEY'] = 'someCrazyS3cR3T!Key.!'
    app.config['MYSQL_DATABASE_USER'] = 'root'
    app.config['MYSQL_DATABASE_PASSWORD'] = open('/secrets/db_root_password.txt').readline().strip()
    app.config['MYSQL_DATABASE_HOST'] = 'db'
    app.config['MYSQL_DATABASE_PORT'] = 4000
    app.config['MYSQL_DATABASE_DB'] = 'fittrack'

    db.init_app(app)
    
    @app.route("/")
    def welcome():
        return "<h1>Welcome to the 3200 boilerplate app</h1>"

    from src.customers.customers import customers

    app.register_blueprint(customers, url_prefix='/customers')

    return app