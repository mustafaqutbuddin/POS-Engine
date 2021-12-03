//
//  Observable.swift
//  POS
//
//  Created by Mustafa on 2021-11-29.
//

import Foundation

/// Reactive object which allows you to bind a closure and set a value to an object.
public class Observable<T> {

    public typealias Listener = (T) -> Void
    public var listener: Listener?

    public var value: T {
        didSet {
            listener?(value)
        }
    }

    /// Initialize Observable object with value
    /// - Parameter value: The initial value to set to Observable object
    init(_ value: T) {
        self.value = value
    }

    /// Binds closure to Observable object
    /// - Parameter closure: The closure to bind
    public func bind(_ closure: Listener?) {
        listener = closure
    }

    /// Binds closure to Observable object and runs the closure
    /// - Parameter closure: The closure to bind
    public func bindAndFire(_ closure: Listener?) {
        self.listener = closure
        closure?(value)
    }
}



