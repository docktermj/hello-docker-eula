#!/bin/sh

# !/usr/bin/env bash

# Determine if End-User License (EULA) has been accepted.

# Check if OS environment variable exists. If not, license has not been accepted

if [[ -z "${ACCEPT_EULA}" ]]; then
    exit 1
fi

# Compare ACCEPT_EULA values in lower case.

LOWERCASE_ACCEPT_EULA="${ACCEPT_EULA,,}"

# Determine if license has been accepted.

if [ ${LOWERCASE_ACCEPT_EULA} == "y" ]; then
    exit 0
elif [ ${LOWERCASE_ACCEPT_EULA} == "yes" ]; then
    exit 0
elif [ ${LOWERCASE_ACCEPT_EULA} == "1" ]; then
    exit 0
elif [ ${LOWERCASE_ACCEPT_EULA} == "true" ]; then
    exit 0    
fi

# License not accepted

exit 1