#!/bin/bash

BASEURL="https://github.com/yownas/llama-cpp-python-wheels/releases/download"
INDEXDIR="index"
PKGNAME="llama-cpp-python"
TAGS=$(gh release list --json tagName | jq -r '.[]|[.tagName] | @tsv')
BUILDS=$(cd $INDEXDIR;ls -1d */|tr -d /)

# Headers
for BUILD in $BUILDS;do
  cat <<EOF > ${INDEXDIR}/${BUILD}/${PKGNAME}/index.html
<!DOCTYPE html>
  <html>
    </body>
EOF
done

for TAG in $TAGS; do
  FILES=$(gh release view $TAG --json assets | jq -r '.[]|.[]|[.name]|@tsv')
  for BUILD in $BUILDS;do
    echo "      ${TAG}<br/>" >> ${INDEXDIR}/${BUILD}/${PKGNAME}/index.html
    for WHEEL in $(tr ' ' '\012' <<<$FILES | grep "\+cpu${BUILD,,}-"); do
      echo "      <a href=\"${BASEURL}/${TAG}/${WHEEL}\">${WHEEL}</a><br/>" >> ${INDEXDIR}/${BUILD}/${PKGNAME}/index.html
    done
  done
done

# Footers
for BUILD in $BUILDS;do
  cat <<EOF >> ${INDEXDIR}/${BUILD}/${PKGNAME}/index.html
    </body>
  </html>
EOF
  echo ${INDEXDIR}/${BUILD}/${PKGNAME}/index.html
done
