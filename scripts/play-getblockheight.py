#!/usr/bin/env python3
# import the required modules
import json
import requests

# define the URL of the Bitcoin node
node_url = "http://127.0.0.1:38332"

# define the username and password for the node
node_user = "bitcoin"
node_pass = "c8c8b9740a470454255b7a38d4f38a52$e8530d1c739a3bb0ec6e9513290def11651afbfd2b979f38c16ec2cf76cf348a"

# create a dictionary with the node credentials
credentials = {"user": node_user, "pass": node_pass}

# define the method to call
method = "getblockchaininfo"

# create the payload for the request
payload = {"method": method, "params": [], "jsonrpc": "2.0", "id": 0}

# send the request to the node
response = requests.post(node_url, json=payload, auth=credentials)

# parse the response
response_json = json.loads(response.text)

# extract the current block height from the response
blockheight = response_json["result"]["blocks"]

# print the current block height
print(blockheight)
