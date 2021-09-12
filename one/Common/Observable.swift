//
//  Observable.swift
//  one
//
//  Created by sidney on 2021/9/12.
//

import Foundation

struct Observer<Value> {
    weak var observer: AnyObject?
    let block: (Value) -> Void
}

final class Observable<Value> {
    
    private var observers: [Observer<Value>] = [Observer<Value>]()
    
    public init(_ value: Value) {
        self.value = value
    }
    
    var value: Value {
        didSet {
            self.notifyObservers()
        }
    }
    
    private func notifyObservers() {
        for observer in observers {
            DispatchQueue.main.async {
                observer.block(self.value)
            }
        }
    }
    
    public func observe(on observer: AnyObject, observerBlock: @escaping (Value) -> Void) {
        observers.append(Observer(observer: observer, block: observerBlock))
        DispatchQueue.main.async {
            observerBlock(self.value)
        }
    }
    
    public func remove(observer: AnyObject) {
        observers = observers.filter({ (item) -> Bool in
            return item.observer !== observer
        })
    }
}
