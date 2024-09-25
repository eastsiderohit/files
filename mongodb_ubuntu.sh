#!/bin/bash
os=$(cat /etc/os-release |awk -F '=' '/^NAME/{print $2}' | awk '{print $1}' | tr -d '"')

if [ $os == "Ubuntu" ]
then
	curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
	echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
	sudo apt update -y
	sudo apt install mongodb-org -y
	echo -e "security: \n  authorization: enabled" >> /etc/mongod.conf
	sudo systemctl start mongod
	mongo_admin_user=admin
	mongo_admin_pwd=$(openssl rand -base64 32|sed 's/[^a-z0-9A-Z]//g'|head -c${7:-19};echo;)


	mongo "admin" --eval "db.createUser({'user':'${mongo_admin_user}','pwd':'${mongo_admin_pwd}','roles': ['userAdminAnyDatabase','readWriteAnyDatabase']})"
        sudo sed -i "s,\\(^[[:blank:]]*bindIp:\\) .*,\\1 0.0.0.0," /etc/mongod.conf
        sudo systemctl restart mongod
	sudo systemctl enable mongod
        sudo systemctl status mongod
	cd
	echo -e " Username: $mongo_admin_user \n Password: $mongo_admin_pwd" >> mongodb_password.txt
	echo "Find MongaDB UserName/Password in $PWD/mongodb_password.txt"
      	echo "********Script complete.************"
elif [ $os == "Amazon" ]

