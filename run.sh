#!/bin/bash

#
# update all the things
#

set -e # fail if any command fails

NEW_VERSION=$1

ZIP_FILE=angular-$NEW_VERSION.zip
ZIP_FILE_URL=http://code.angularjs.org/$NEW_VERSION/angular-$NEW_VERSION.zip
ZIP_DIR=angular-$NEW_VERSION

REPOS=(
  angular           \
  angular-animate   \
  angular-cookies   \
  angular-i18n      \
  angular-loader    \
  angular-mocks     \
  angular-route     \
  angular-resource  \
  angular-sanitize  \
  angular-scenario  \
  angular-touch     \
)

#
# get the old version number
#

OLD_VERSION=`node -e "console.log(require('./bower-angular/bower').version)"`

#
# download and unzip the file
#

wget ZIP_FILE_URL && \
  unzip ZIP_FILE -d ZIP_DIR

exit

#
# move the files from the zip
#

for repo in "${REPOS[@]}"
do
  mv ZIP_DIR/$repo* bower-$repo/
done

# move i18n files


#
# update bower.json
# tag each repo
#

for i in "${REPOS[@]}"
do
  cd bower-$i
  sed -i 's/$OLD_VERSION/$NEW_VERSION/g' bower.json
  git checkout master
  git add -A
  git commit -m "v$NEW_VERSION"
  git tag v$NEW_VERSION
  git push origin master
  git push origin v$NEW_VERSION
done
