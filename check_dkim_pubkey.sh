#!/bin/bash 

## README 
## This tiny script checks a DKIM (DomainKeys) DNS-Record. It can be used for Icinga or similar monitor systems. 
## This script expected two or three arguments: selector, domain and expacted DKIM key (TXT value). The last one is optional. 
## With two atguments (selector and domain) 
##
## If you run this script only with two argument, it will only check if a TXT record if existing. There is NO syntax check if this 
## DKIM DNS-record is correct. 
##
## If you run this script with three argumens, it will check if the DKIM TXT record is identical to the given argument "expected_public_key"
##
## Example:
## bash check_dkim_pubkey.sh key1 example-domain.org 
## 
## bash check_dkim_pubkey.sh key1 example-domain.org '"v=DKIM1; h=sha256; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6KN6G7Es3tiIj1w"'

function check_if_dkim_record_exists()
{
    local public_key_in_dnszone=$1

    if [ -z "$public_key_in_dnszone" ]
    then
        echo "Error: No DNS-Record found."
        return 2
    else
        echo "O.K."
        return 0
    fi
}

function compare_dkim_reord_with_arguments()
{
    local expected_public_key=$1
    local public_key_in_dnszone=$2
    
    if [ "$expected_public_key" = "$public_key_in_dnszone" ]; then
        echo "O.K."
        return 0
    else
        echo "Error: DKIM Key in DNS-Record is not as expected."
        return 2
    fi
}


## Exit this script when only one argument is detected 
if [ "$#" -lt 2 ]; then
    echo "Error: Arguments missing or invalid."
    exit 2
fi

## Exit this script when the command line tool dig is not found
if ! command -v /usr/bin/dig &> /dev/null
then
    echo "Error: dig could not be found."
    exit 2
fi

selector=$1
domain=$2
expected_public_key=$3
exit_code=3

## Get the TXT record for the given domain and DKIM key selector 
public_key_in_dnszone=$(/usr/bin/dig -t txt +short "$selector._domainkey.$domain")

if [ "$#" = 2 ]; then
    # Check if a DKIM key can be found in the DNS zone with the selector and Domain 
    exit_code=$(check_if_dkim_record_exists $public_key_in_dnszone)
elif [ "$#" = 3 ]; then
    # Compare the found DKIM key with the given one
    exit_code=$(compare_dkim_reord_with_arguments "$expected_public_key" "$public_key_in_dnszone")
fi

exit $? 