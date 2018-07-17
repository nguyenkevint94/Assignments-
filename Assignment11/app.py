from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/api/v1.0/precipitation")
def precipitation():
    return jsonify(precipitation_data)

@app.route("/api/v1.0/stations")
def stations():
    return jsonify(station_list)

@app.route("/api/v1.0/tobs")
def robs():

@   