from api_helper import NorenApiPy
import logging
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

# Enable debug to see request and responses
logging.basicConfig(level=logging.DEBUG)

# Start of our program
api = NorenApiPy()

# Get token and user id from environment variables
usersession = os.getenv('USERSESSION')
userid = os.getenv('USERID')

ret = api.set_session(userid=userid, password='', usertoken=usersession)

ret = api.get_limits()

print(ret)
