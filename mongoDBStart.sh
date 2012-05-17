#!/bin/bash

DATA=/Users/ruibando/Mongo/mongodb_data/
if [ -f $DATA ]
then
    echo "Connect MongoDB"
    mongod --dbpath=/Users/ruibando/Mongo/mongodb_data/
elif [ ! -f $DATA ]
then
    echo "Make directry for save MongoDB data"
    mkdir -p $DATA
    echo "Connect MongoDB"
    mongod --dbpath=/Users/ruibando/Mongo/mongodb_data/
fi









