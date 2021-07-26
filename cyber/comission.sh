#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
DELEGATOR='your_account_address'
VALIDATOR='validator_address'
ACC_NAME=Keyring_account_name
PASWD='password_from_keyring'
DELAY=3600 #in secs

for ((; ;));
 do
        BAL=$(docker exec -ti bostrom-testnet-3 cyber q bank balances ${DELEGATOR} --chain-id bostrom-testnet-3 -o json | jq -r '.balances[1].amount');
        echo ${BAL}
        echo -e "BALANCE: ${GREEN}${BAL}${NC} boot\n"
        echo -e "Claim rewards\n"
        echo -e "${PASWD}\n" | docker exec -i bostrom-testnet-3 cyber tx distribution withdraw-rewards ${VALIDATOR} --from ${ACC_NAME} --chain-id bostrom-testnet-3 --commission -y --gas-prices 0.01boot --gas 300000
        for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
        BAL=$(docker exec -ti bostrom-testnet-3 cyber q bank balances ${DELEGATOR} --chain-id bostrom-testnet-3 -o json | jq -r '.balances[1].amount');
        echo -e "BALANCE: ${GREEN}${BAL}${NC} boot\n"
        echo -e "Stake ALL\n"
        echo -e "${PASWD}\n" | docker exec -i bostrom-testnet-3 cyber tx staking delegate ${VALIDATOR} ${BAL}boot --from ${ACC_NAME} --chain-id bostrom-testnet-3 -y --gas-prices 0.01boot --gas 300000
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
done
