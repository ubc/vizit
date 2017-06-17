#!/bin/bash
#
# Script to download, unpack, and decrypt weekly course data files and upload to Google BigQuery 
#
institution=yourinstitutionx
institution_upper=YOURINSTITUTIONx
MAILADMIN=admin@yourinstitutionx.com
EDX_DATA_DIR=/yourdirectory/datadir
RAW_SQL_DIR=/yourdirectory/rawsqldir
edx2bqcmd=/yourdirectory/edx2bigquery

# read your passphrase in
mapfile < /yourdirectory/phrase.txt

ddate=`aws s3 ls s3://course-data | grep 'yourinstitutionx' | sort | tail -1 | sed 's/^.*yourinstitutionx-//' | sed 's/.zip$//'`
echo Retrieving $institution-$ddate.zip

# copy the most recent dump file from the bucket to your local computer
echo Fetching from Amazon S3

aws s3 cp s3://course-data/$institution-$ddate.zip $RAW_SQL_DIR

cd $RAW_SQL_DIR 

# unzip the dump file
echo Extracting and decrypting

unzip $institution-$ddate.zip

cd $institution-$ddate
 
for FILE in *.*.gpg; do
	echo "Extracting $FILE to ${FILE%.gpg}."
    	echo "${MAPFILE[@]}" | gpg --passphrase-fd n --batch -d --output "${FILE%.*}" "$FILE"
done

rm -rf *.gpg    

cd $EDX_DATA_DIR

date_year=`date +"%Y"`

# run the edx2bigquery commands
$edx2bqcmd --year2 waldofy $RAW_SQL_DIR/$institution-$ddate
$edx2bqcmd --year2 setup_sql
$edx2bqcmd --year2 axis2bq
$edx2bqcmd --year2 analyze_forum
$edx2bqcmd --year2 grading_policy
$edx2bqcmd --year2 analyze_videos
$edx2bqcmd --year2 analyze_problems
$edx2bqcmd --year2 item_tables
$edx2bqcmd --year2 show_answer
$edx2bqcmd --year2 --only-step=show_answer analyze_problems
$edx2bqcmd --year2 pcday_ip
$edx2bqcmd --year2 enrollment_day
$edx2bqcmd --year2 person_day
$edx2bqcmd --year2 pcday_trlang
$edx2bqcmd --year2 --end-date=$date_year'-12-31' --start-date=$date_year'-01-01' person_course
$edx2bqcmd --year2 analyze_problems

## Clean up
cd $RAW_SQL_DIR

echo Deleting weekly download
rm -rf $institution-$ddate.zip
echo Deleted $institution-$ddate.zip
    
# Mail the sysadmin
sendmail $MAILADMIN <<EOF
subject: EdX weekly data downloaded and imported to BigQuery 
Download completed.
Enjoy.
EOF
