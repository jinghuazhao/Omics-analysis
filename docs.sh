#!/usr/bin/bash

function setup()
{
  module load python/3.8
  source ~/rds/public_databases/software/py38/bin/activate
}

if [ "$(uname -n | sed 's/-[0-9]*$//')" == "login-q" ]; then
   module load ceuadmin/libssh/0.10.6-icelake
   module load ceuadmin/openssh/9.7p1-icelake
fi

setup
mkdocs build
mkdocs gh-deploy

for d in README.md .gitignore docs mkdocs.yml
do
   git add $d
   git commit -m "$d"
done
git push
