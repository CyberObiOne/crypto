#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
DELEGATOR='chihuahua1tqdvlku97p88z5ndf3j' # your address created or imported
VALIDATOR='chihuahuavaloper1d6kn7u40yhm4gdqzjegpzv2kqndf2yk4m0z74m' # can get from Mintscan (https://www.mintscan.io/chihuahua/validators/chihuahuavaloper1d6kn7u40yhm4gdqzjegpzv2kqndf2yk4m0z74m) - CyberDuck validator id
PASWD='Your_pass' # 57 line from Readme file
ACC_NAME='Your_acc_name' # 52 line from Readme file
NODE='https://rpc.chihuahua.wtf:443' # Don't change that endpoint
KEYRING='file' # it can be different, reffer to 55 line in Readme file
CHAIN_ID='chihuahua-1' # Don't change this parameter
DELAY=7200 # time in seconds
for ((; ;));
 do
        BAL=$(chihuahuad query bank balances ${DELEGATOR} --node ${NODE}  -o json --output=json --denom=uhuahua | jq -r '.amount'); #current balance
        echo ${BAL}
        echo -e "BALANCE: ${GREEN}${BAL}${NC} uhuahua\n"
        echo -e "Claim rewards\n"
        echo -e "${PASWD}\n" | chihuahuad tx distribution withdraw-rewards ${VALIDATOR} --from ${ACC_NAME} --node ${NODE} --keyring-backend ${KEYRING} --chain-id ${CHAIN_ID} -y --fees 5000uhuahua
        for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
        BAL=$(chihuahuad query bank balances ${DELEGATOR} --node ${NODE} -o json --output=json --denom=uhuahua | jq -r '.amount'); # balance after claim
        echo -e "BALANCE: ${GREEN}${BAL}${NC} uhuahua\n"
        echo -e "Stake ALL\n"
        COMMISSION=$((${BAL} - 6000)) # balance minus commission fees for paying transaction fees
        echo -e "${PASWD}\n" | chihuahuad tx staking delegate ${VALIDATOR} ${COMMISSION}uhuahua --from ${ACC_NAME} --node ${NODE} --keyring-backend ${KEYRING} --chain-id ${CHAIN_ID} -y --fees 5000uhuahua
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
done
