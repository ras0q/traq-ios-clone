#/bin/sh

[ $(basename $(pwd)) != "traq-ios-clone" ] && echo "Please run this script in from project root" && exit 1
[ $# -ne 2 ] && echo "Usage: ./add_package.sh <directory_name> <package_name>" && exit 1
[ -d "./$1/$2" ] && echo "$1/$2 already exists" && exit 1

ROOT=$PWD

mkdir -p ./$1/$2/Sources/$2
cat ./scripts/PackageTemplate/.gitignore.tmpl | PACKAGE=$2 envsubst >  ./$1/$2/.gitignore
cat ./scripts/PackageTemplate/Package.swift.tmpl | PACKAGE=$2 envsubst >  ./$1/$2/Package.swift
cat ./scripts/PackageTemplate/Sources/PackageTemplate/PackageTemplateView.swift.tmpl | PACKAGE=$2 envsubst >  ./$1/$2/Sources/$2View.swift

# xcodegen setting
cd $ROOT
echo \
"  $2:
    path: ./$1/$2
    group: ./$1" >> ./project.yml
xcodegen generate

echo "Done!!"
