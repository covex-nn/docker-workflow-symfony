for FILE in `ls | grep -v "composer.json\|run.sh\|.git"`; do
  rm -rf $FILE
done
composer install
git add .
