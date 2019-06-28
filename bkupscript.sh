#!/bin/bash
DATETIME=`date +%y%m%d-%H_%M_%S`
SRC=$1 #source 
DST=$2 #destination SPACE NAME
GIVENNAME=$3 #prefix name tar.gz
MYSQL_USER="_user"
MYSQL_PASSWORD="_password"
DATABASE_NAME="_db_name"

showhelp(){
        echo "\n\n############################################"
        echo "# bkupscript.sh                            #"
        echo "############################################"
        echo "\nThis script will backup files/folders into a single compressed file and will store it in the current folder."
        echo "In order to work, this script needs the following three parameters in the listed order: "
        echo "\t- The full path for the folder or file you want to backup."
        echo "\t- The name of the Space where you want to store the backup at (not the url, just the name)."
        echo "\t- The name for the backup file (timestamp will be added to the beginning of the filename)\n"
        echo "Example: sh bkupscript.sh ./testdir testSpace backupdata\n"
}
tarandzip(){
    echo "\n##### Gathering files #####\n"
    if tar -czvf $GIVENNAME-$DATETIME.tar.gz $SRC; then
        echo "\n##### Done gathering files #####\n"
        return 0
    else
        echo "\n##### Failed to gather files #####\n"
        return 1
    fi
}
movetoSpace(){
    echo "\n##### MOVING TO SPACE #####\n"
    if s3cmd put $GIVENNAME-$DATETIME.tar.gz s3://$DST; then
        echo "\n##### Done moving files to s3://"$DST" #####\n"
	rm -rf ~/$GIVENNAME-$DATETIME.tar.gz
        return 0
    else
        echo "\n##### Failed to move files to the Space #####\n"
        return 1
    fi
}
movetoSpaceDB(){
    echo "\n##### MOVING TO SPACE #####\n"
    if s3cmd put $DATABASE_NAME-$GIVENNAME-$DATETIME.sql s3://$DST; then
        echo "\n##### Done moving files dbs to s3://"$DST" #####\n"
        rm -rf ~/$DATABASE_NAME-$GIVENNAME-$DATETIME.sql
        return 0
    else
        echo "\n##### Failed to move files dbs to the Space #####\n"
        return 1
    fi
}


dumpDatabases(){
    echo "\n##### DUMP ALL DATABASES #####\n"
    mysqldump -u $DATABASE_NAME -p$MYSQL_PASSWORD $DATABASE_NAME > $DATABASE_NAME-$GIVENNAME-$DATETIME.sql
    return 0
}

if [ ! -z "$GIVENNAME" ]; then
    if tarandzip; then
        movetoSpace
	if dumpDatabases; then
	    movetoSpaceDB
	fi
    else
        showhelp
    fi
else
    showhelp
fi
