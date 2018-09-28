#!/system/bin/sh

#
#   init.asus.btwifi.sh
#   Set up properties for factory check
#

bt_mac=`getprop asus.btmac`
wifi_mac= `getprop asus.wifimac`

# Setting default value of property for the first time
if [ ".$bt_mac" == "." ]; then
    asus_btmac=`cat /factory/bd_addr.conf`
    setprop asus.btmac "$asus_btmac"
fi

if [ ".$wifi_mac" == "." ]; then
    asus_wifimac=`grep "MacAddress0" /factory/mac.txt`
    asus_wifimac=${asus_wifimac//MacAddress0=/}
    setprop asus.wifimac "$asus_wifimac"
fi
