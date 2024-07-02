import os, sys
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from api_helper import NorenApiPy
import logging
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()
#enable dbug to see request and responses
logging.basicConfig(level=logging.DEBUG)

#start of our program
api = NorenApiPy()

#set token and user id
#paste the token generated using the login flow described 
# in LOGIN FLOW of https://pi.flattrade.in/docs
usersession=os.getenv('USERSESSION')
userid = os.getenv('USERID')

ret = api.set_session(userid= userid, password = '', usertoken= usersession)

ret = api.get_positions()

p = ret[0]
ret = api.position_product_conversion(p['exch'], p['tsym'], p['netqty'], 'I', p['prd'], 'B', 'DAY')

print(ret)