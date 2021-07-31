#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
DELEGATOR='Delegator_address' # your address created or imported
VALIDATOR='Validator_address' # can get from Keplr (https://wallet.keplr.app/#/core/stake?modal=detail&validator=persistencevaloper1s8yr8sar5vkv56r9dv4rhv4ttzryzj4xjahvsl) - PersistenceHODL validator id
ACC_NAME='Your_account_name'
PASWD='Your_pass_from_keyring' # 55 or 62 line from Readme file
KEYRING='file' # it can be different, reffer to 55 line in Readme file
NODE='https://rpc.core.persistence.one:443' # Don't change that endpoint
DELAY=86400 #in secs (once per day)
CHAID_ID=core-1 # Don't change this parameter 
for ((; ;));
 do
        BAL=$(persistenceCore query bank balances ${DELEGATOR} --node ${NODE}  -o json | jq -r '.balances[].amount');
        echo ${BAL}
        echo -e "BALANCE: ${GREEN}${BAL}${NC} uxprt\n"
        echo -e "Claim rewards\n"
        echo -e "${PASWD}\n" | persistenceCore tx distribution withdraw-rewards ${VALIDATOR} --from ${ACC_NAME} --node ${NODE} --keyring-backend ${KEYRING} --chain-id ${CHAID_ID} -y
        for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
        BAL=$(persistenceCore query bank balances ${DELEGATOR} --node ${NODE}  -o json | jq -r '.balances[].amount');
        echo -e "BALANCE: ${GREEN}${BAL}${NC}uxprt\n"
        echo -e "Stake ALL\n"
        echo -e "${PASWD}\n" | persistenceCore tx staking delegate ${VALIDATOR} ${BAL}uxprt --from ${ACC_NAME} --node ${NODE} --keyring-backend ${KEYRING} --chain-id ${CHAID_ID} -y
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
done
