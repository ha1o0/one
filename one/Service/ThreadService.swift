//
//  ThreadService.swift
//  one
//
//  Created by sidney on 2021/9/16.
//

import Foundation

class ThreadService {
    static let shared = ThreadService()
    
    var name = ""
    var age = 0
    var dispatchGroup = DispatchGroup()
    var lock = NSLock()
    
    private init() {}
    
    func update(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func thread1() {
        DispatchQueue.global().async {
            while true {
                self.lock.lock()
                self.update(name: "jack", age: 20)
                self.lock.unlock()
            }
        }
    }
    
    func thread2() {
        DispatchQueue.global().async {
            while true {
                self.lock.lock()
                self.update(name: "bob", age: 21)
                self.lock.unlock()
            }
        }
    }
    
    func log() {
        print("\(self.name)---\(self.age)")
    }
}
