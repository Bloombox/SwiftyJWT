//
//  EncodableValue.swift
//  SwiftyJWT
//
//  Created by Shuo Wang on 2018/1/22.
//  Copyright © 2018年 Yufu. All rights reserved.
//

import Foundation


public enum JWTKey: String, CodingKey {
    case device = "dvc"
    case admin = "admin"
    case beta = "beta"
    case sandbox = "sandbox"
}


public struct EncodableValue: Codable {
    public let value: Encodable!

    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }

    public init(value _value: Encodable) {
        value = _value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intVal = try? container.decode(Int.self) {
            value = intVal
        } else if let doubleVal = try? container.decode(Double.self) {
            value = doubleVal
        } else if let boolVal = try? container.decode(Bool.self) {
            value = boolVal
        } else if let stringVal = try? container.decode(String.self) {
            value = stringVal
        } else {
            // it could be an array
            if var multiContainer = try? decoder.unkeyedContainer() {
                var items: [Codable] = []
                while !multiContainer.isAtEnd {
                    if let intVal = try? multiContainer.decodeIfPresent(Int.self) {
                        items.append(intVal)
                    } else if let doubleVal = try? multiContainer.decodeIfPresent(Double.self) {
                        items.append(doubleVal)
                    } else if let boolVal = try? multiContainer.decodeIfPresent(Bool.self) {
                        items.append(boolVal)
                    } else if let stringVal = try? multiContainer.decodeIfPresent(String.self) {
                        items.append(stringVal)
                    } else {
                        throw DecodingError.dataCorruptedError(
                            in: multiContainer,
                            debugDescription: "unable to type-identify array members")
                    }
                }
                value = nil  // TODO wtf
            } else if let keyedContainer = try? decoder.container(keyedBy: JWTKey.self) {
                var keyedItems: [JWTKey: Any] = [:]
                if let admin = try? keyedContainer.decode(Bool.self, forKey: .admin) {
                    keyedItems[.admin] = admin
                } else if let beta = try? keyedContainer.decode(Bool.self, forKey: .beta) {
                    keyedItems[.beta] = beta
                } else if let sandbox = try? keyedContainer.decode(Bool.self, forKey: .sandbox) {
                    keyedItems[.sandbox] = sandbox
                } else if let device = try? keyedContainer.decode(String.self, forKey: .device) {
                    keyedItems[.device] = device
                } else {
                    throw DecodingError.dataCorruptedError(
                        in: container,
                        debugDescription: "unable to identify property in JWT claims payload")
                }
                value = nil  // TODO wtf
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "the container contains nothing to serialize")
            }
        }
    }
}
