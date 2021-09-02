#!/bin/bash
cd `dirname $0`
rm /usr/local/bin/get_github_release
ln -s `pwd`/get_github_release /usr/local/bin/


