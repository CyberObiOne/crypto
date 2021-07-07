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
akash_commission.sh
