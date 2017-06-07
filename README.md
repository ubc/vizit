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


## Developer

* Clone the current repository

* Copy Google Credentials into the repo directory and name it as `google.json`

* Copy the course list `courses.txt` into the repo directory and name it as `courses.txt`

* Update the ipynb files

* Run the following command to generate the pages:
```bash
docker run -it -v $(pwd):/home/jovyan/work ubcctlt/vizit ./generate.sh
```
The pages will be generated in `results/` directory

* To generate a single page just run command
```bash
docker run -it -v $(pwd):/home/jovyan/work -e current_course=COURSE_NAME ubcctlt/vizit jupyter nbconvert --execute $current_course coursepage.ipynb --ExecutePreprocessor.kernel_name=python && mv coursepage.html results/$current_course.html
```
