cd /yourdirectory/vizit/results

eval `ssh-agent -s`
ssh-add ../../.ssh/id_rsa

cp yourinstitutionx__*.html ../yourlocalgitrepo/assets
cp multi_courses*.html ../yourlocalgitrepo/assets/
cd ../yourlocalgitrepo/assets/
git config user.name "Your name"
git config user.email "you@yourinstitutionx.com"
git add yourinstitutionx__*.html
git add multi_courses*.html
git commit -m "Update our dashboards"
git push