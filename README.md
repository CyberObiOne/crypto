First of all update your current system (Ubuntu)
sudo apt update
sudo apt install curl wget git make unzip -y

Set variables 

export AKASH_NET="https://raw.githubusercontent.com/ovrclk/net/master/mainnet"
export AKASH_VERSION="$(curl -s "$AKASH_NET/version.txt")"

export KEY_NAME="Key_name" #Change to yourself

export KEYRING_BACKEND="os"
export AKASH_CHAIN_ID="$(curl -s "$AKASH_NET/chain-id.txt")"
export AKASH_NODE="$(curl -s "$AKASH_NET/rpc-nodes.txt" | shuf -n 1)"

Install Akash CLI Tool and copy it to folder, that includes into PATH:

wget https://github.com/ovrclk/akash/releases/download/v0.12.1/akash_0.12.1_linux_amd64.zip
unzip akash_0.12.1_linux_amd64.zip
cd akash_0.12.1_linux_amd64
sudo cp akash /usr/local/bin
cd ~

Create new Akash address:

akash keys add "$KEY_NAME" --keyring-backend "$KEYRING_BACKEND"

You need to setup a passwrod. It will be used in future to confirm your transactions.

If you want to export existing address:

akash keys add "$KEY_NAME"  --keyring-backend "$KEYRING_BACKEND" --recover
You will need to input your current menemonic. If you creates an address from previous command, you don't need to execute this one.

Create a bash script:
#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
DELEGATOR='Delegator_address' # your address created or imported
VALIDATOR='Validator_address' # can get from Keplr (https://wallet.keplr.app/#/akashnet/stake?modal=detail&validator=akashvaloper14kn0kk33szpwus9nh8n87fjel8djx0y0uzn073) Forbole, as example
PASWD='Your_pass' # from 26 line
DELAY=57600 #in secs # it depends of your stake
ACC_NAME=Akash
for ((; ;));
 do
        BAL=$(./akash query bank balances ${DELEGATOR}  -o json | jq -r '.balances[].amount'); #current balance
        echo ${BAL}
        echo -e "BALANCE: ${GREEN}${BAL}${NC} uakt\n"
        echo -e "Claim rewards\n"
        echo -e "${PASWD}\n" | ./akash tx distribution withdraw-rewards ${VALIDATOR} --from ${ACC_NAME} --fees 200uakt  -y #claim rewards
        for (( timer=10; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
        BAL=$(./akash query bank balances ${DELEGATOR} -o json | jq -r '.balances[].amount'); # balance after claim
        echo -e "BALANCE: ${GREEN}${BAL}${NC}uakt\n"
        echo -e "Stake ALL\n"
        COMMISSION=$((${BAL} - 500)) # commission fees
        echo $TEST
        echo -e "${PASWD}\n" | ./akash tx staking delegate ${VALIDATOR} ${COMMISSION}uakt --from ${ACC_NAME} --fees 300uakt -y #delegate claim rewards
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED}%02d${NC} sec\r" $timer
                sleep 1
        done
done
