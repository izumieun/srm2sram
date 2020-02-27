#!/bin/sh

if [ -z $1 ]; then
    echo "$0 [add change delete check] FileName"
    exit
fi

if [ -z $2 ]; then
    echo "$0 [add change delete check] FileName"
    exit
fi

if [ ! -f $2 ]; then
    echo "not found input file"
    exit
fi


if [ $1 = 'add' ]; then
    sha1sum $2 |cut -f1 -d ' '|xxd -r -p > cartridge.sram.hash
    cat $2 cartridge.sram.hash > cartridge.sram
fi

if [ $1 = 'change' ]; then
    FULLSIZE=`wc -c < $2`
    SRMSIZE=`expr $FULLSIZE - 20`
    split -b $SRMSIZE $2 temp
    sha1sum tempaa |cut -f1 -d ' '|xxd -r -p > cartridge.sram.hash
    cat tempaa cartridge.sram.hash > cartridge.sram
fi

if [ $1 = 'delete' ]; then
    FULLSIZE=`wc -c < $2`
    SRMSIZE=`expr $FULLSIZE - 20`
    split -b $SRMSIZE $2 temp
    mv tempaa savedata.srm
fi

if [ $1 = 'check' ]; then
    FULLSIZE=`wc -c < $2`
    SRMSIZE=`expr $FULLSIZE - 20`
    split -b $SRMSIZE $2 temp
    HASH=`sha1sum tempaa |cut -f1 -d ' '`
    CHECKHASH=`xxd -p tempab`
    if [ $HASH = $CHECKHASH ]; then
        echo "OK"
    else
        echo "NG"
    fi
fi

