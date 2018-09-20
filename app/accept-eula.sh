#!/usr/bin/env bash

# Determine if End-User License (EULA) has been accepted.

ACCEPTED=1
NOT_ACCEPTED=0

# Check if OS environment variable exists. If not, license has not been accepted

if [[ -z "${ACCEPT_EULA}" ]]; then
    echo "The mock program did not run."
    echo "Must accept End-User License Agreement (EULA) by setting ACCEPT_EULA=Y"
    exit ${NOT_ACCEPTED}
fi

# Compare ACCEPT_EULA values in lower case.

LOWERCASE_ACCEPT_EULA=$(echo "${ACCEPT_EULA}" | tr '[:upper:]' '[:lower:]')

# Determine if license has been accepted.

if [ ${LOWERCASE_ACCEPT_EULA} == "y" ]; then
    exit ${ACCEPTED}
elif [ ${LOWERCASE_ACCEPT_EULA} == "yes" ]; then
    exit ${ACCEPTED}
elif [ ${LOWERCASE_ACCEPT_EULA} == "1" ]; then
    exit ${ACCEPTED}
elif [ ${LOWERCASE_ACCEPT_EULA} == "true" ]; then
    exit ${ACCEPTED}
fi

# License not accepted.

echo "The mock program did not run."
echo "Must accept End-User License Agreement (EULA) by setting ACCEPT_EULA=Y"
exit ${NOT_ACCEPTED}
