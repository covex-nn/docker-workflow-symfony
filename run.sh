for FILE in `ls -a | grep -v "run.sh\|.git$"`; do
  rm -rf $FILE
done
composer create-project symfony/skeleton
mv .git .git-backup
mv skeleton/** .
mv skeleton/.* .
rm -r skeleton .git
mv .git-backup .git
composer env:apply docker-ci
git checkout .env.dist
git add .
