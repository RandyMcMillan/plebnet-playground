#!/usr/bin/env python3
# Copyright (c) 2021 Richard Safier
# Copyright (c) 2020 The Bitcoin Core developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.

import argparse
import subprocess
import requests
import sys
import json
from pprint import pprint
from glom import glom

sys.path.append('.')
sys.path.append("/usr/local/lib/python3.7/site-packages")
sys.path.append("/usr/local/lib/python3.8/site-packages")
sys.path.append("/usr/local/lib/python3.9/site-packages")
#print(sys.path)

parser = argparse.ArgumentParser(description='Script to get coins from a faucet.')
parser.add_argument('-c', '--cmd', dest='cmd', default='docker', help='bitcoin-cli command to use')
parser.add_argument('-f', '--faucet', dest='faucet', default='http://signet.xenon.fun:5000/faucet', help='URL of the faucet')
parser.add_argument('-a', '--address', dest='address', default='', help='Bitcoin address to which the faucet should send')
parser.add_argument('-r', '--report', dest='report', default='false', help='Return session data')
parser.add_argument('-s', '--success', dest='success', default='false', help='return 0 if true')
parser.add_argument('-res', '--response', dest='response', default='false', help='Return response from faucet')

args = parser.parse_args()

def print_report():
    #print(data)
    if args.report == 'true':
        # NOTE: jq expected syntax
        #  echo  {\"address\": \"tb1qhjd4lxv7vkqp7pen34t8zfxvvc8f8eqpppug26\"} | jq .
        print(data) #return session data first!
        if res == '<Response [200]>':
            try:
                print(data)
            except:
                print('Printing session data failed.')
                exit()
        if res.text != 'Success':
            print(res)

if args.address == '':
    # get address for receiving coins
    args.address = json.loads(subprocess.check_output([args.cmd] + ['exec','-it','playground-lnd', 'lncli', '--macaroonpath', '/root/.lnd/data/chain/bitcoin/signet/admin.macaroon', 'newaddress', 'p2wkh']))["address"]

    data = {'address': args.address}
try:
    res = requests.get(args.faucet, params=data)
    print_report()
    if res.text != 'Success':
        print(res)
except:
    print('Unexpected error when contacting faucet:', sys.exc_info()[0])
    exit()

if args.response == 'true':
    print(res.text)
    if res.text != 'Success':
        print(res)

