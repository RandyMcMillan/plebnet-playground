if [ -z "$1" ]
    then
    if [[ "$(echo uname -m)" == "arm64" ]];then
        TRIPLET="aarch64-linux-gnu"
        echo TRIPLET=$TRIPLET
    else
        #echo 'You must provide TRIPLET as first parameter'
        #echo './install.sh x86_64-linux-gnu'
        echo
    fi
    echo "EXAMPLE:"
    echo "         TRIPLET=x86_64-linux-gnu ./install.sh"
    echo "EXAMPLE:"
    echo "         TRIPLET=x86_64-linux-gnu services=bitcoind,lnd ./install.sh"
    TRIPLET=$(uname -m)-linux-gnu
    echo TRIPLET=$TRIPLET
    echo services:$services
    echo
else
TRIPLET=$1
: ${TRIPLET:=$TRIPLET}
: ${services:=Null}
fi


#Remove any old version
docker-compose down

python3 plebnet_generate.py TRIPLET=$TRIPLET services=$services

sudo rm -rf volumes

#Create Datafile
mkdir -p volumes
mkdir -p volumes/lnd_datadir
mkdir -p volumes/bitcoin_datadir
mkdir -p volumes/thub_datadir
mkdir -p volumes/rtl_datadir
mkdir -p volumes/tor_datadir
mkdir -p volumes/tor_servicesdir
mkdir -p volumes/tor_torrcdir
mkdir -p volumes/lndg_datadir
touch -p volumes/lndg_datadir/db.sqlite3

docker-compose build --build-arg TRIPLET=$TRIPLET
docker-compose up --remove-orphans -d
