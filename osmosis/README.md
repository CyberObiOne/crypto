First of all update your current system (Ubuntu) 
```
$ sudo apt update 
$ sudo apt install curl wget git make unzip jq screen -y
```
Now download the Go language binary archive file using following link. To find and download latest version available version go to official [download page](https://golang.org/dl/)

```
$ wget https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz 
```

Now extract the downloaded archive and install it to the desired location on the system.

```
$ sudo tar -xvf go1.16.4.linux-amd64.tar.gz   
$ sudo mv go /usr/local
```

Now you need to setup Go language environment variables for your project. Commonly you need to set 3 environment variables as GOROOT, GOPATH and PATH

```
$ export GOROOT=/usr/local/go
$ export GOPATH=/root
$ export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

All the above environment will be set for your current session only. To make it permanent add above commands in ~/.profile file.

At this step, you have successfully installed and configured go language on your system. First, use the following command to check the Go version.

```
$ go version
go version go1.16.4 linux/amd64
```
Clone current Osmosis Git repo:

```
$ clone git https://github.com/osmosis-labs/osmosis
```
Than build Osmosis CLI:

```
$ cd osmosis
$ make build
```

Copy file to /usr/local/bin to make it availible as global application:

```
$ cd osmosis/build/
$ cp osmosisd /usr/local/bin
```
Create new Osmosis address:
Please, in below command use your own "$KEY_NAME" and "$KEYRING_BACKEND" # --keyring-backend string   Select keyring's backend (os|file|test) (default "os")

```
$ osmosisd keys add "$KEY_NAME" --keyring-backend "$KEYRING_BACKEND"
```
You need to setup a password. It will be used in future to confirm your transactions.

If you want to export existing address:

```
$ osmosisd keys add "$KEY_NAME" --keyring-backend "$KEYRING_BACKEND" --recover

> Enter your bip39 mnemonic

Enter keyring passphrase:
Re-enter keyring passphrase:

- name: Osmosis
  type: local
  address: ---- # your wallet ID
  pubkey: -----
  mnemonic: ""
  threshold: 0
  pubkeys: []

```
You will need to input your current menemonic. If you creates an address from previous command, you don't need to execute this one.

Create a bash script: osmosis_commission.sh

Due to reward coming once per day - setup a cronjob:

```
$ crontab -e
```

Than setup a time and path to your script, as example:
```
05 20 * * * bash /path/to/your/script/osmosis_commission.sh
```

