# VizIT

## Features

- Course metrics dashboard:
  - Develop metrics and visualizations to present and compare
    - course structure,
    - enrollment and retention,
    - students’ engagement and learning patterns etc. for edX instructors and administrators
  - Streamline and automate the process of data import, data munging and visualization in creating dashboards for various courses

## Prerequisites:

1. You need a Google account with Editor access to a BigQuery project. The owner of the account must generate a [service account](https://developers.google.com/identity/protocols/OAuth2ServiceAccount).

2. Download the [Google Credentials](https://developers.google.com/identity/protocols/application-default-credentials) file:

    * "Go to the API Console Credentials page.
    * From the project drop-down, select your project.
    * On the Credentials page, select the Create credentials drop-down, then select Service account key.
    * From the Service account drop-down, select an existing service account or create a new one.
    * For Key type, select the JSON key option, then select Create. The file automatically downloads to your computer.
    * Put the *.json file you just downloaded in a directory of your choosing. This directory must be private (you can't let anyone get access to this).
    * Set the environment variable GOOGLE_APPLICATION_CREDENTIALS to the path of the JSON file downloaded."

3. Prepare a list of the courses to be processed (one course name a row) and put them into a file named `courses.txt`

4. You also need to load all your edX data into Google BigQuery using [edx2bigquery](https://github.com/mitodl/edx2bigquery)

## Using VizIT

* Create an empty directory to host generated pages
```bash
mkdir vizit
```

* Run VizIT docker container to generate pages:
```
docker run -it -v /PATH/TO/GOOGLE_CREDENTIALS:/home/jovyan/work/google.json -v /PATH/TO/courses.txt:/home/jovyan/work/courses.txt -v $(pwd)/vizit:/home/jovyan/work/results ubcctlt/vizit ./generate.sh
```
All the pages will be placed inside `vizit` directory.

## Developers

* Clone the current repository

### Download from edX and upload to Google BigQuery

* Get in touch with edX for arranging data downloads for your institution

* Set up credentials for data download [here](http://edx.readthedocs.io/projects/devdata/en/latest/data_czars/credentials.html)

* Set up your passphrase to phrase.txt

* Edit edx_weekly_course_data_download_import2BigQuery.sh and edx_download_dailyevents_moveto_BigQuery.sh to specify your directories, as appropriate

* Clone the edx2bigquery [repository](https://github.com/mitodl/edx2bigquery) and follow their [instructions](https://github.com/mitodl/edx2bigquery/blob/master/README.md) for installation

* Maintain the list of courses for which you wish to upload events and course data in edx2bigquery_config.py from edx2bigquery 

* Set up cronjobs for uploading events daily, and course data weekly:
```
0 8 * * * source /yourdirectory/.bash_profile; /yourdirectory/edx_download_dailyevents_moveto_BigQuery.sh >> /yourdirectory/events.log 2>&1
```
```
0 11 * * 1 source /yourdirectory/.bash_profile; /yourdirectory/edx_weekly_course_data_download_import2BigQuery.sh >> /yourdirectory/courses.log 2>&1
```

* Set up cronjobs for automatically adding new courses, as they appear in the edX dumps, to edx2bigquery_config.py
```
55 10 * * 2 cd /yourdirectory/rawsqldir/; DIRECTORY=$(ls -td -- */ | head -n 1); ls $DIRECTORY | grep .xml.tar.gz > /yourdirectory/directory.txt
```
```
0 11 * * 2 cd /yourdirectory; /yourdirectory/python /yourdirectory/addcourses.py
```

### Generate dashboards pages

* Copy your Google Credential file into the repo directory and name it as `google.json`

* Copy the course list `courses.txt` into the repo directory and name it as `courses.txt`

* Update the ipynb files

* Run the following command to generate the pages:
```bash
docker run -it -v $(pwd):/home/jovyan/work yourdirectory/vizit ./generate.sh
```
The pages will be generated in the `results/` directory

* To generate a single page simply run the command
```bash
docker run -it -v $(pwd):/home/jovyan/work -e current_course=COURSE_NAME yourdirectory/vizit jupyter nbconvert --execute $current_course coursepage.ipynb --ExecutePreprocessor.kernel_name=python && mv coursepage.html results/$current_course.html
```

* To periodically generate dashboards pages, set a cronjob:
```
0 11 * * 2 cd /yourdirectory/vizit; docker run -v $(pwd):/home/jovyan/work yourdirectory/vizit ./generate.sh >> generatedashboards.log 2>&1
```

### Deploy VizIT

* Set up a build system with a Git repository that will deploy to a public-facing website/URL

* Edit deploy.sh to match your directories as appropriate

* Set up a cronjob to periodically deploy generated dashboards pages:
```
0 14 * * 2 /bin/bash /yourdirectory/deploy.sh >> /yourdirectory/generatepushalledge.log 2>&1
```