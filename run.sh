#!/bin/bash

cd /app/
./scrape.sh -f ./districts.conf | tee -i /data/workers.csv
