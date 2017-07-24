#!/bin/bash


# read -p "Do you want to add SSL to default domain name? (y/n) " add_domainame_ssl
# do_add_domainame_ssl=0
# if [ "${add_domainame_ssl}" == "y" ]; then

#     echo "domain list: ${domain}"
#     do_add_domainame_ssl=1
# fi

# if [ $do_add_domainame_ssl == 1 ]; then
# 	echo "run ssl!"
# fi


Add_SSL()
{
    echo $1
}


Add_SSL test