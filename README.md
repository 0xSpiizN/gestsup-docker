# GestSup - Docker

Unofficial dockerized version of [GestSup](https://gestsup.fr/), IT ticketing platform and issue tracking system.

## Install

To install, you simply have to:
```bash
git clone https://github.com/0xSpiizN/gestsup-docker.git
cd gestsup-docker/
docker compose up -d
```

It is also recommended to change the values from the `.env` file:
```conf
#--------------------------------------------------
# GestSup
#--------------------------------------------------
EXTERNAL_HTTP="8080"

#--------------------------------------------------
# GestSup - Database
#--------------------------------------------------
DB_NAME="gestsup"
DB_USER="gestsup"
DB_PASSWORD="gestsup"
```

After deploying with docker compose, go to `http://[SERVER_IP]:[DOTENV_PORT]/` and perform the installation with your `.env` file values.

After completing installation, you'll need to remove the install folder. Simply do it with:
```bash
docker exec gestsup-app rm -rf /var/www/html/install/
```