#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
DELEGATOR='Delegator_address' # your address created or imported
VALIDATOR='Validator_address' # can get from Keplr (https://wallet.keplr.app/#/cosmoshub/stake?modal=detail&chainId=cosmoshub-4&validator=cosmosvaloper1qaa9zej9a0ge3ugpx3pxyx602lxh3ztqgfnp42) CNN, as example
ACC_NAME='Your_account_name' #Account name from Keyring
PASWD='Your_pass' # from 22 line of ReadMe file
DELAY=57600 #in secs # it depends on your stake
NODE='http://api.cosmos.network:443'
CHAIN_ID='cosmoshub-4'
KEYRING='file'
for ((; ;));
 do
        BAL=$(gaiad query bank balances ${DELEGATOR} --node ${NODE} -o json | jq -r '.balances[].amount'); #current balance
        echo ${BAL}
        echo -e "BALANCE: ${GREEN}${BAL}${NC} uakt\n"
        echo -e "Claim rewards\n"
        echo -e "${PASWD}\n" | gaiad tx distribution withdraw-rewards ${VALIDATOR} --from ${ACC_NAME} --node ${NODE} --chain-id ${CHAIN_ID} --keyring-backend ${KEYRING} --fees 100uatom  -y #claim rewards
        for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
        BAL=$(gaiad query bank balances ${DELEGATOR} --node ${NODE}-o json | jq -r '.balances[].amount'); # balance after claim
        echo -e "BALANCE: ${GREEN}${BAL}${NC}uakt\n"
        echo -e "Stake ALL\n"
        COMMISSION=$((${BAL} - 500)) # balance minus commission fees for paying transaction fees
        echo -e "${PASWD}\n" | gaiad tx staking delegate ${VALIDATOR} ${COMMISSION}uatom --from ${ACC_NAME} --node ${NODE} --chain-id ${CHAIN_ID} --keyring-backend ${KEYRING} --fees 200uatom -y #delegate claim rewards
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
done
