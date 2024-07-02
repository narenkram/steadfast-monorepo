from flask import Flask, jsonify
from flask_cors import CORS
from flask_socketio import SocketIO, emit
from api_helper import NorenApiPy
import os
from dotenv import load_dotenv

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes
socketio = SocketIO(app, cors_allowed_origins="*")  # Enable WebSocket with CORS

# Load environment variables from .env file
load_dotenv()

# Initialize API
api = NorenApiPy()

@app.route('/get_limits', methods=['GET'])
def get_limits():
    usersession = os.getenv('USERSESSION')
    userid = os.getenv('USERID')
    api.set_session(userid=userid, password='', usertoken=usersession)
    ret = api.get_limits()
    return jsonify(ret)

@socketio.on('subscribe')
def handle_subscribe(data):
    symbol = data.get('symbol')
    if symbol:
        # Example subscription logic
        api.subscribe(symbol, on_price_update)

def on_price_update(price_data):
    # Emit the price update to the client
    socketio.emit('price_update', price_data)

if __name__ == '__main__':
    socketio.run(app, debug=True)
