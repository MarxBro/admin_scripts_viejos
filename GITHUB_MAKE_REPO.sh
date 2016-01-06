#!/bin/bash
[ ! $1  ] && echo "ERROR, no se especifico el nombre del nuevo repo" && exit 1;

USERNAME="SomeOne"
REPO_NAME="$1"

STRING_PRE='{ "name":"'
STRING_POST='" }'
STRING="$STRING_PRE"$REPO_NAME"$STRING_POST"

curl -u $USERNAME https://api.github.com/user/repos -d "$STRING" > /dev/null


MSG=$( cat<<EOSG

Listo!
El repo esta en github, nuevo, en esta URL: https://github.com/$USERNAME/$REPO_NAME\n

Ahora queda hacer un git init y Agregar github a los origins:\n
cd carpete && git init && git remote add origin https://github.com/$USERNAME/$REPO_NAME.git\n

Agregar un README.md y pushear:\n
git push origin master\n
\nZaijian.\t\t\t\t MarxBro\n
EOSG
)

echo -e $MSG && exit 0

