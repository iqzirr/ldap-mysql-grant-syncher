#!/bin/bash
usercount=$(ldapsearch -x -D $LDAP_USER -h $LDAP_HOST -p $LDAP_PORT -w $LDAP_PASS -LLL "database=*" database databasePermission | grep dn | grep uid | wc -l)

i=1
while [[ $i -le $usercount ]]
do
    username[$i]=$(ldapsearch -x -D $LDAP_USER -h $LDAP_HOST -p $LDAP_PORT -w $LDAP_PASS -LLL "database=*" database databasePermission |  tr "," "\n"  | grep dn | awk '{print $2}' | cut -d "=" -f 2)
    database[$i]=$(ldapsearch -x -D $LDAP_USER -h $LDAP_HOST -p $LDAP_PORT -w $LDAP_PASS -LLL "database=*" database | grep database | sed -n $((i))p | awk '{print $2}')
    databasePermission[$i]=$(ldapsearch -x -D $LDAP_USER -h $LDAP_HOST -p $LDAP_PORT -w $LDAP_PASS -LLL "database=*" databasePermission | grep databasePermission | sed -n $((i))p | awk '{print $2}')
    ((i++))
done

counter=1
while [[ $counter -le $((usercount)) ]]
do
        user=${username[$counter]}
        db=${database[$counter]}
        grant=${databasePermission[$counter]}
        mariadb -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -P $MYSQL_PORT -e "CREATE USER IF NOT EXISTS '$user'@'%' IDENTIFIED VIA pam USING 'mariadb'"
        mariadb -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -P $MYSQL_PORT -e "GRANT $grant ON $db.* TO '$user'@'%' ; FLUSH PRIVILEGES"
        ((counter++))
done

