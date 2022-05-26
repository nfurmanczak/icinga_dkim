### Icinga DKIM check 

This tiny script checks a DKIM (DomainKeys) DNS-Record. It can be used for Icinga or similar monitor systems. 
This script expected two or three arguments: selector, domain and expacted DKIM key (TXT value). The last one is optional. 

If you run this script only with two argument, it will only check if a TXT record if existing. There is NO syntax check if this 
DKIM DNS-record is correct. If you run this script with three argumens, it will check if the DKIM TXT record is identical to the given argument "expected_public_key"


### Examples: 


With two arguments: 
```
bash check_dkim_pubkey.sh key1 example-domain.org 
```


With three arguments:
```
bash check_dkim_pubkey.sh key1 example-domain.org '"v=DKIM1; h=sha256; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6KN6G7Es3tiIj1w"'
```
