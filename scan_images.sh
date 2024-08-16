#!/bin/bash
# 
# List and scan images on your docker installation
# Author: Andre Luis Cardoso - a190468@hotmail.com
# Date: 15/aug/2024
# Review: 0.1
#

# Step 1 - download the SAST/CLi line command on https://cloud.appscan.com/plugins
# Step 2 - unpack on the file directory that you want
# Step 3 - optional - you can add this directory in yout PATH variable 

#docker images --all 
docker images -q > list_images.txt # list all images

PATH_SACCLI="/Users/a190468/Downloads/SAClientUtil.8.0.1574/bin"
key_secret="change_here"   #you must change this
key_id="change_here"               #you must change this
appASoC="change_here"              #you must change this, and get the app id on the dashboard page

$PATH_SACCLI/appscan.sh api_login -P $key_secret -u $key_id  -persist #login Appscan on cloud

while IFS= read -r line
 do 
    # List the id image
    echo "Processing image $line"
    lineirx=$line
    lineirx+=".irx"
    
    # downlod the image to computer
    #echo "Downloading image from docker $line"
    docker image save $line -o $line
    #echo "appscan prepare for $lineirx" 
    $PATH_SACCLI/appscan.sh prepare_sca -image $line -n $lineirx
    #echo "appscan queue for $lineirx" 
    $PATH_SACCLI/appscan.sh queue_analysis -a $appASoC -f $lineirx -n $line -nen  #send to ASoC the irx

    # remove the image in the computer
    rm -f $line $lineirx *logs.zip
 done < list_images.txt
