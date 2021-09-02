#!/bin/bash
function usage() {
	cat <<_EOT_
Usage:
`basename $0` [-v|t|h] [base url] [target filename]

Options:
	-v : verbose
	-t : itest mode : show target url and exit. doesn't execute download.
	-h : show this usage

_EOT_
		exit 1
}

VERBOSE=false
TEST_MODE=false

while getopts "tvh" OPT
do
	case $OPT in
		t) TEST_MODE=true;;
		v) VERBOSE=true;;
		h) usage;;
		\?) usage;;
	esac
done
shift $(($OPTIND - 1))

BASE_URL=${1}
TARGET_FILE=${2}
URL=`curl -s ${BASE_URL}/releases | grep ${TARGET_FILE} | grep -Po '(?<=href=")[^"]*' | head -n 1 | sed -e "s|^|https://github.com|g"`
if [ ${VERBOSE} ] ; then echo ${URL};fi
TARGET_URL=`curl -I -Ls -o /dev/null -w %{url_effective} ${URL}`
if [ ${VERBOSE} ] ; then echo ${TARGET_URL};fi
if [ ${TEST_MODE} ] ; then
	echo ${TARGET_URL}
	exit
fi
curl ${TARGET_URL} -o ${TARGET_FILE} || exit 1
