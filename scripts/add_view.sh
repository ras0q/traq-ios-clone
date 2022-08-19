#/bin/sh

[ -z "$1" ] && echo "Usage: ./add_view.sh <view_name>" && exit 1
[ -d "./Views/$1" ] && echo "View $1 already exists" && exit 1

ROOT=$PWD

mkdir -p ./Views/$1
cd ./Views/$1

# create view package
swift package init --name $1 --type library \

# add platform
cat ./Package.swift \
| sed "s/products: /platforms: [\n        .iOS(.v14),\n    ],\n    products:/g" \
> ./Package.swift.tmp \
&& mv ./Package.swift.tmp ./Package.swift

# replace source file
rm ./Sources/$1/$1.swift
echo \
"import SwiftUI

public struct $1View: View {
    public init() {}
    public var body: some View {
        Text(\"Hello $1!\")
    }
}

struct $1View_Previews: PreviewProvider {
    static var previews: some View {
        $1View()
    }
}" > ./Sources/$1/$1View.swift

# xcodegen setting
cd $ROOT
echo \
"  $1:
    path: ./Views/$1
    group: ./Views" >> ./project.yml
xcodegen generate

echo "Done!!"
