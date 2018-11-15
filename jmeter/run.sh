#!/bin/bash
# Starts a JMeter test that is passed via command line arguments
clear
./launch_test.sh chaos.jmx results localhost 1 20
cat results/result.tlf 
