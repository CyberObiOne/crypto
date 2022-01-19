<h3>Please, use these scripts on your own risks.</h3>

<h4>I'm not responsible for mnemonic saving. If you server will be compromised or you lost access to it - I can't help you with it.</h4>

First of all update your current system (Ubuntu) 
```
$  apt update 
$  apt install curl wget git make unzip jq screen -y
```
Now download the Go language binary archive file using following link. To find and download latest version available version go to official [download page](https://golang.org/dl/)

```
$ wget https://golang.org/dl/go1.17.5.linux-amd64.tar.gz
```

Now extract the downloaded archive and install it to the desired location on the system.

```
$  tar -C /usr/local -xzf go1.17.5.linux-amd64.tar.gz  
$  mv go /usr/local
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
go version go1.17.5 linux/amd64
```
Clone current Huahua Git repo:

```
$ git clone https://github.com/ChihuahuaChain/chihuahua.git
```
Than build Huahua CLI:

```
$ cd chihuahua
$ make all
```

Create new Huahua address:
Please, in below command use your own "$KEY_NAME" and "$KEYRING_BACKEND" # --keyring-backend string   Select keyring's backend (os|file|test) (default "os")

```
$ chihuahuad  keys add "$KEY_NAME" --keyring-backend "$KEYRING_BACKEND"
```
You need to setup a password. It will be used in future to confirm your transactions.

If you want to export existing address:

```
$ chihuahuad  keys add "$KEY_NAME" --keyring-backend "$KEYRING_BACKEND" --recover

> Enter your bip39 mnemonic

Enter keyring passphrase:
Re-enter keyring passphrase:

- name: Chihuahua
  type: local
  address: ---- # your wallet ID
  pubkey: -----
  mnemonic: ""
  threshold: 0
  pubkeys: []

```
You will need to input your current menemonic. If you creates an address from previous command, you don't need to execute this one.

Create a bash script: huahua_commission.sh

