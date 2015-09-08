#!/bin/sh

echo "bash version: $BASH_VERSION"
echo ""

Level2DB=Level2DB
Phenix=Phenix
spin=spin
vtxpixel=vtxpixel
FileCatalog=FileCatalog
fvtx=fvtx
rpc=rpc
daq=daq
calibrations=calibrations

for dbname in Level2DB Phenix spin vtxpixel FileCatalog fvtx rpc daq calibrations
do
echo $dbname
eval dbbackupfile=\$$dbname
if [ ! -f ./$dbbackupfile ]; then
echo  :$dbbackupfile not exsit !
fi
done
