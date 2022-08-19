#  traQ Clone App

## Developper memo

### モジュールの追加方法

`Views`ディレクトリ下に作成する場合を仮定

1. `Views`にカーソルを当て、File→New→Package(もしくはcontrol+shift+command+N)からパッケージ(`Hoge`とする)を作成
    - 作成場所が`Views`下になっていることを確認
    - Git repositoryを作成しない設定になっていることを確認
    - "Add to: "を`TraqClone`に、"Group: "を`Views`に設定
1. `Views`にカーソルを当て、"Sort by Type"を実行
1. `Views/Hoge/Package.swift`にplatformを設定(iOS14)
1. `Views/Hoge/Source/Hoge/`にある`Hoge.swift`を`HogeView.swift`に改名
1. `HogeView.swift`を以下のように書き換え
    - `Views/`にある他のパッケージをコピペして文字列置換すると楽
1. `Hoge`に依存するパッケージの`Package.swift`を書き換え、その後`import Hoge`で`HogeView()`が使用可能に

```swift
//
//  HogeView.swift
//
//
//  Created by Kira Kawai on 2022/08/19.
//

import SwiftUI

public struct HogeView: View {
    public init() {}
    public var body: some View {
        Text("Hello Hoge!")
    }
}

struct HogeView_Previews: PreviewProvider {
    static var previews: some View {
        HogeView()
    }
}
```
