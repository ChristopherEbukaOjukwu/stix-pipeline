set exuo pipefail

export DEBIAN_FRONTEND=noninteractive
### some common dependencies
### could probably pare it down a bit
################################################################################
sudo apt-get update
sudo apt-get install -y \
    build-essential curl git libcurl4-openssl-dev \
    curl wget software-properties-common libxml2-dev mime-support \
    automake libtool pkg-config libssl-dev ncurses-dev awscli \
    python-pip libbz2-dev liblzma-dev unzip imagemagick openjdk-11-jdk \
    gcc make autoconf zlib1g-dev ruby g++ python3 \


################################################################################
###installing bedtools

git clone https://github.com/arq5x/bedtools2.git
cd bedtools2
make
cd bin
export PATH=$PATH:`pwd`
cd ../..


#################################################################################
###installing giggle

git clone https://github.com/ryanlayer/giggle.git
cd giggle
make
export GIGGLE_ROOT=`pwd`
cd ..

cd $GIGGLE_ROOT/test/func
./giggle_tests.sh
cd ../unit
make
cd ../../..
