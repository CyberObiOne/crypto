#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
DELEGATOR='Delegator_address' # your address created or imported
VALIDATOR='Validator_address' # can get from Keplr (https://wallet.keplr.app/#/osmosis/stake?modal=detail&chainId=osmosis-1&validator=osmovaloper13tk45jkxgf7w0nxquup3suwaz2tx483xe832ge) - Bro_n_Bro validator id
PASWD='Your_pass_from_keyring' # 57 or 64 line from Readme file
ACC_NAME='Your_account_name'
NODE='node_IP' # Don't change that endpoint - it's our Validator node
KEYRING='file' # it can be different, reffer to 54 line in Readme file
CHAIN_ID='osmosis-1' # Don't change this parameter 
for ((; ;));
 do
        BAL=$(osmosisd query bank balances ${DELEGATOR} --node ${NODE}  -o json | jq -r '.balances[7].amount'); #current balance
        echo ${BAL}
        echo -e "BALANCE: ${GREEN}${BAL}${NC} uosmo\n"
        echo -e "Claim rewards\n"
        echo -e "${PASWD}\n" | osmosisd tx distribution withdraw-rewards ${VALIDATOR} --from ${ACC_NAME} --node ${NODE} --keyring-backend ${KEYRING} --chain-id ${CHAIN_ID} -y #claim rewards
        for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
        BAL=$(osmosisd query bank balances ${DELEGATOR} --node ${NODE} -o json | jq -r '.balances[7].amount'); # balance after claim
        echo -e "BALANCE: ${GREEN}${BAL}${NC}uosmo\n"
        echo -e "Stake ALL\n"
        echo -e "${PASWD}\n" | osmosisd tx staking delegate ${VALIDATOR} ${BAL}uosmo --from ${ACC_NAME} --node ${NODE} --keyring-backend ${KEYRING} --chain-id ${CHAIN_ID} -y #delegate claim rewards
done
