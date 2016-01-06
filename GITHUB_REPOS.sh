#!/bin/bash
[ ! $1 ] && echo "Falta el nombre de usuario" && exit 1
[ $1  ] && USUARIO=$1
curl https://api.github.com/users/$USUARIO/repos 2>/dev/null | sed 's/\"//g' | sed 's/,//g' | grep html_url | awk -F: '{ print $2 ":" $3 }' | sort | uniq
