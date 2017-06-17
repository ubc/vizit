#!/bin/bash
#
# Script to download event logs from edX Amazon S3 bucket
echo Retrieving new event logs
MAILADMIN=admin@yourinstitutionx.com
mapfile < /yourdirectory/phrase.txt
event_log_datadir=/yourdirectory/rawlogsdirectory
edx2bigquery_data_dir=/yourdirectory/datadir
institution=yourinstitutionx
echo $institution

# copy the most recent tracking file from the bucket to your local computer
year=`date +%Y`
gpgfile=`aws s3 ls s3://edx-course-data/$institution/edx/events/$year/ | sort | tail -1 | sed 's/^.*'$institution/$institution/` 
edgegpgfiles=`aws s3 ls s3://edx-course-data/$institution/edge/events/$year/ | sort | tail -1 | sed 's/^.*'$institution/$institution/`
"gpgfile: $gpgfile" 

gzfile=${gpgfile%.*}
logfile=${gzfile%.*}

cd $event_log_datadir/$year 	
aws s3 cp s3://edx-course-data/$institution/edx/events/$year/$gpgfile .
aws s3 cp s3://edx-course-data/$institution/edge/events/$year/$edgegpgfiles .
		
for FILE in *.*.gpg; do
	echo "Extracting $FILE to ${FILE%.gpg}."
    	echo "${MAPFILE[@]}" | gpg --passphrase-fd n --batch -d --output "${FILE%.*}" "$FILE"
done

cd $edx2bigquery_data_dir

edx2bigquery split /yourdirectory/rawlogsdirectory/$year/*gz

edx2bigquery --year2 logs2gs /yourdirectory/LOGS/

edx2bigquery --year2 logs2bq

edx2bigquery --year2 enrollment_events

mail -s 'tracking logs loaded into BigQuery' $MAILADMIN

rm $event_log_datadir/$year/*.gz.gpg