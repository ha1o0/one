//
//  UserDefault.swift
//  one
//
//  Created by sidney on 2021/7/5.
//

import Foundation
import UIKit

struct Key: RawRepresentable {
    let rawValue: String
}

extension Key: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}

extension Key {
    static let isFirstLaunch: Key = "isFirstLaunch"
    static let musicPlayProgress: Key = "musicPlayProgress"
    static let themeStyle: Key = "themeStyle"
    static let mediaCache: Key = "mediaCache"
    static let pipVideo: Key = "pipVideo"
}

struct Storage {

    @UserDefault(.isFirstLaunch, defaultValue: true)
    static var isFirstLaunch: Bool
    
    @UserDefault(.musicPlayProgress, defaultValue: [:])
    static var musicPlayProgress: [String: Int]
    
    @UserDefault(.themeStyle, defaultValue: -1)
    static var themeStyle: Int
    
    @UserDefault(.mediaCache, defaultValue: [:])
    static var mediaCache: [String: String]
    
    @UserDefault(.pipVideo, defaultValue: [:])
    static var pipVideo: [String: String]
}


/// A type safe property wrapper to set and get values from UserDefaults with support for defaults values.
///
/// Usage:
/// ```
/// @UserDefault("has_seen_app_introduction", defaultValue: false)
/// static var hasSeenAppIntroduction: Bool
/// ```
///
/// [Apple documentation on UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults)
@available(iOS 2.0, OSX 10.0, tvOS 9.0, watchOS 2.0, *)
@propertyWrapper
public struct UserDefault<Value: PropertyListValue> {
    let key: String
    let defaultValue: Value
    var userDefaults: UserDefaults

    init(_ key: Key, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key.rawValue
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    public var wrappedValue: Value {
        get {
            return userDefaults.object(forKey: getKey()) as? Value ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: getKey())
        }
    }

    private func getKey() -> String {
        return self.key
    }
}

/// A type than can be stored in `UserDefaults`.
///
/// - From UserDefaults;
/// The value parameter can be only property list objects: NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary.
/// For NSArray and NSDictionary objects, their contents must be property list objects. For more information, see What is a
/// Property List? in Property List Programming Guide.
public protocol PropertyListValue {}

extension Data: PropertyListValue {}
extension NSData: PropertyListValue {}

extension String: PropertyListValue {}
extension NSString: PropertyListValue {}

extension Date: PropertyListValue {}
extension NSDate: PropertyListValue {}

extension NSNumber: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Int8: PropertyListValue {}
extension Int16: PropertyListValue {}
extension Int32: PropertyListValue {}
extension Int64: PropertyListValue {}
extension UInt: PropertyListValue {}
extension UInt8: PropertyListValue {}
extension UInt16: PropertyListValue {}
extension UInt32: PropertyListValue {}
extension UInt64: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}
#if os(macOS)
extension Float80: PropertyListValue {}
#endif

extension Array: PropertyListValue where Element: PropertyListValue {}

extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}
