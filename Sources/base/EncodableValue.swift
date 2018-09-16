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
    case avatar = "avatar_url"
    case nonce = "nce"
    case userId = "prn"

    static let all: [JWTKey] = [
        .device, .admin, .beta, .sandbox, .avatar, .nonce, .userId]

    var type: Decodable.Type {
        switch self {
        case .device: return String.self
        case .admin: return Bool.self
        case .beta: return Bool.self
        case .sandbox: return Bool.self
        case .avatar: return String.self
        case .nonce: return String.self
        case .userId: return String.self
        }
    }
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
            } else if let _ = try? decoder.container(keyedBy: JWTKey.self) {
                value = nil  // TODO wtf
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "the container contains nothing to serialize")
            }
        }
    }
}
