#!/bin/bash
#sleep 570;
bitcoin-cli -signet getblocktemplate '{"rules": ["signet","segwit"]}' |
    miner --cli="bitcoin-cli" genpsbt --address="tb1qcvt3y423q3ag38kk7eu7q2fc8dh7xnayv9w3k2" |
    bitcoin-cli -signet -stdin walletprocesspsbt |
    jq -r .psbt |
    miner --cli="bitcoin-cli" solvepsbt --grind-cmd="bitcoin-util grind" |
    bitcoin-cli -signet -stdin submitblock
#sleep 570;