#!/bin/bash
usercount=$(ldapsearch -x -D $LDAP_USER -h $LDAP_HOST -p $LDAP_PORT -w $LDAP_PASS -LLL "database=*" database databasePermission | grep dn | grep uid | wc -l)

i=1
while [[ $i -le $usercount ]]
do
    username[$i]=$(ldapsearch -x -D $LDAP_USER -h $LDAP_HOST -p $LDAP_PORT -w $LDAP_PASS -LLL "database=*" database databasePermission |  tr "," "\n"  | grep dn | sed -n $((i))p | awk '{print $2}' | cut -d "=" -f 2)
    dbcount[$i]=$(ldapsearch -x -D $LDAP_USER -h $LDAP_HOST -p $LDAP_PORT -w $LDAP_PASS -LLL "database=*" database | grep database | sed -n $((i))p | awk '{print $2}'|  tr "," "\n" | wc -l)

    j=1
    while [[ $j -le ${dbcount[$i]} ]]
    do
        database[$i,$j]=$(ldapsearch -x -D $LDAP_USER -h $LDAP_HOST -p $LDAP_PORT -w $LDAP_PASS -LLL "database=*" database | grep database | sed -n $((i))p | awk '{print $2}'|  tr "," "\n" | sed -n $((j))p)
        ((j++))
    done

    databasePermission[$i]=$(ldapsearch -x -D $LDAP_USER -h $LDAP_HOST -p $LDAP_PORT -w $LDAP_PASS -LLL "database=*" databasePermission | grep databasePermission | sed -n $((i))p | awk '{print $2}')
    ((i++))
done

usercounter=1
while [[ $usercounter -le $usercount ]]
do
        #Create the User if not exists
        user=${username[$usercounter]}
        mariadb -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -P $MYSQL_PORT -e "CREATE USER IF NOT EXISTS '$user'@'%' IDENTIFIED VIA pam USING 'mariadb'"

        #Create the DB Privileges
        dbcounter=1
        while [[ $dbcounter -le ${dbcount[$usercounter]} ]]
        do
                db=${database[$usercounter,$dbcounter]}
                grant=${databasePermission[$usercounter]}
                mariadb -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -P $MYSQL_PORT -e "GRANT $grant ON $db.* TO '$user'@'%' ; FLUSH PRIVILEGES"
                ((dbcounter++))
        done
        ((usercounter++))
done
