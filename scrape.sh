#!/bin/bash -e

INPUT_FILE=""
STATE="++"
DISTRICT_NAME="N/A"
DISTRICT="+++"
HTML_FOLDER="/data/html"
mkdir -p ${HTML_FOLDER}

function lookupDistrict () {
  cat districts.map | egrep "${1}" | awk '{print $1}'
}

function reverseLookupDistrict () {
  cat districts.map | egrep "${1}" | awk '{$1=""; print $0}'
}

while getopts "d:s:f:" opt; do
  case $opt in
    d) 
      DISTRICT_NAME="${OPTARG}"
      DISTRICT="$(lookupDistrict "${DISTRICT_NAME}")"
      ;;
    s)
      STATE="${OPTARG}"
      ;;
    f)
      INPUT_FILE="${OPTARG}"
      ;;
  esac
done

function search () {
  curl -s -d "Classification=+++&Submit=Submit&district=${DISTRICT}&firstname=&lastname=&lookup=&state=${STATE}" -X POST   http://locator.lcms.org/nworkers_frm/w_summary.asp  | egrep '<A HREF="w_detail.asp\?.*"' | egrep -oh '"w_detail.asp.*?"' | sed -e 's/"//g' | sed -e 's/w_detail.asp?//g' | egrep -oh "W[0-9]+"
}

function getProfile() {
  if [ ! -f ${HTML_FOLDER}/${1}.html ]
  then
    curl -s -X GET "http://locator.lcms.org/nworkers_frm/w_detail.asp?${1}" | dos2unix > ${HTML_FOLDER}/${1}.html
  fi
}

function getName() {
  cat ${HTML_FOLDER}/${1}.html | grep "w_detail.asp?${1}" | egrep -oh '<b>.*' | sed -e 's/<b>//g' | sed -e 's/&nbsp;/ /g'
}

getAddress() {
  # One line
  cat ${HTML_FOLDER}/${1}.html | sed -n -e '/<td><em>Address:/,/<\/span><\/td><\/tr>/ p' | sed -e 's/<br>//g' | egrep -v "<.*>" | egrep -oh "[A-Za-z0-9].*" | tr '\n' ', ' | sed 's/.\{2\}$//'

  # Multiple lines
  #cat ${HTML_FOLDER}/${1}.html | sed -n -e '/<td><em>Address:/,/<\/span><\/td><\/tr>/ p' | sed -e 's/<br>//g' | egrep -v "<.*>" | egrep -oh "[A-Za-z0-9].*"
}

getEmail() {
  cat ${HTML_FOLDER}/${1}.html | egrep "mailto:" | tail -1 |egrep -oh ">.*<" | sed -e 's/<//g' | sed 's/>//g'
}

getPhone() {
  cat ${HTML_FOLDER}/${1}.html | sed -n -e '/<td><em>Phone:/,/<\/span>/ p' | sed -e 's/<br>//g' | egrep -v "<.*>" | egrep -oh "[()A-Za-z0-9].*"
}

function scrape () {
  for personId in $(search)
  do
    getProfile "${personId}"
    local fullname="$(getName ${personId} | cat | tail -1)"
    local email="$(getEmail ${personId})"
    local address="$(getAddress ${personId})"
    local phone="$(getPhone ${personId})"
    echo "${STATE}| ${DISTRICT_NAME}| ${fullname}| ${address}| ${phone}| ${email}"
  done
}

#echo STATE, DISTRICT, NAME, ADDRESS, PHONE, EMAIL, CLASSIFICATION, DISTRICT
echo STATE|DISTRICT|NAME|ADDRESS|PHONE|EMAIL

if [ -f "${INPUT_FILE}" ]
then
  #for district in $(cat "${INPUT_FILE}")
  while read district
  do
    DISTRICT_NAME="${district}"
    DISTRICT="$(lookupDistrict "${district}")"
    scrape
  done < ${INPUT_FILE}
  #done
else
  scrape
fi
