#!/bin/bash 

mkdir -p results

echo "Generating multi-course page for all courses..."
jupyter nbconvert --execute multi_courses_all.ipynb --ExecutePreprocessor.kernel_name=python --ExecutePreprocessor.timeout=-1 --ExecutePreprocessor.allow_errors=True
mv multi_courses_all.html results/

echo "Generating multi-course page for current courses..."
jupyter nbconvert --execute multi_courses_current.ipynb --ExecutePreprocessor.kernel_name=python --ExecutePreprocessor.timeout=-1 --ExecutePreprocessor.allow_errors=True
mv multi_courses_current.html results/

for arraycourse in `cat courses.txt`
do
  echo "Generating single-course page for $arraycourse..."
  current_course=$arraycourse jupyter nbconvert --execute $current_course coursepage.ipynb --ExecutePreprocessor.kernel_name=python
  mv coursepage.html results/$arraycourse.html
done
