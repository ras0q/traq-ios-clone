import Foundation

public extension Array {
    func toDictionary<K>(id: KeyPath<Element, K>) -> [K: Element] {
        reduce([K: Element]()) { dic, value in
            var newDic = dic
            newDic[value[keyPath: id]] = value
            return newDic
        }
    }
}
