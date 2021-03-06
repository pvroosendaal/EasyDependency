//
//  Registry.swift
//  EasyDependency
//
//  Created by Niels Koole on 18/10/2017.
//  Copyright © 2017 ByNelus. All rights reserved.
//

import Foundation

public enum EasyDependencyError: LocalizedError {
    case implementationNotFound(name: String)
	
	public var errorDescription: String? {
		switch self {
		case .implementationNotFound(let name):
			return "EasyDependencyError - Implementation Not Found: \(name)"
		}
	}
}

public protocol Container: AnyObject {
    var superContainer: Container? { get set }
    var registrations: [Any] { get set }
    
    init(container: Container?)
}

extension Container {
    
    public func register<T>(_ interface: T.Type, _ type: RegistrationType = .none, _ handler: @escaping (Self) throws -> T) {
        let registration = Registration<T>(type: type) { () -> T in
            return try handler(self)
        }
        
        registrations.append(registration)
    }
    
    public func resolve<T>(_ interface: T.Type = T.self) throws -> T {
        // Due to potential performance decrease, the `resolveList` function is not used.
        for object in registrations {
            if let registration = object as? Registration<T> {
                return try registration.resolve()
            }
        }
        
		guard let container = superContainer else { throw EasyDependencyError.implementationNotFound(name: String(describing: T.self)) }
        return try container.resolve(interface)
    }
    
    public func resolveList<T>(_ interface: T.Type = T.self) -> [T] {
        var implementations: [T] = []
        for object in registrations {
            if let registration = object as? Registration<T>,
                let instance = try? registration.resolve() {
                implementations.append(instance)
            }
        }
        
        let superContainerImplementations: [T] = superContainer?.resolveList() ?? []
        return implementations + superContainerImplementations
    }
}
