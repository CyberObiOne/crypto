#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
DELEGATOR='Delegator_address' # your address created or imported
VALIDATOR='Validator_address' # can get from Keplr (https://wallet.keplr.app/#/akashnet/stake?modal=detail&validator=akashvaloper14kn0kk33szpwus9nh8n87fjel8djx0y0uzn073) Forbole, as example
PASWD='Your_pass' # from 22 line of ReadMe file
ACC_NAME='Your_account_name'
for ((; ;));
 do
        BAL=$(osmosisd query bank balances ${DELEGATOR}  -o json | jq -r '.balances[7].amount'); #current balance
        echo ${BAL}
        echo -e "BALANCE: ${GREEN}${BAL}${NC} uakt\n"
        echo -e "Claim rewards\n"
        echo -e "${PASWD}\n" | osmosisd tx distribution withdraw-rewards ${VALIDATOR} --from ${ACC_NAME} --fees 200uosmo  -y #claim rewards
        for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
        BAL=$(osmosisd query bank balances ${DELEGATOR} -o json | jq -r '.balances[7].amount'); # balance after claim
        echo -e "BALANCE: ${GREEN}${BAL}${NC}uakt\n"
        echo -e "Stake ALL\n"
        COMMISSION=$((${BAL} - 500)) # commission fees
        echo -e "${PASWD}\n" | osmosisd tx staking delegate ${VALIDATOR} ${COMMISSION}uakt --from ${ACC_NAME} --fees 300uosmo -y #delegate claim rewards
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
done
