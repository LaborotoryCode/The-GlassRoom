//
//  GlassRoomAPIProtocol+Standard.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomCreatable: GlassRoomAPIProtocol {
    associatedtype CreatePathParameters
    associatedtype CreateQueryParameters
    associatedtype CreateRequestData
    associatedtype CreateResponseData
    static func create(params: CreatePathParameters,
                       query: CreateQueryParameters,
                       data: CreateRequestData) -> CreateResponseData?
}

protocol GlassRoomDeletable: GlassRoomAPIProtocol {
    associatedtype DeletePathParameters
    associatedtype DeleteQueryParameters
    associatedtype DeleteRequestData
    associatedtype DeleteResponseData
    static func delete(params: DeletePathParameters,
                       query: DeleteQueryParameters,
                       data: DeleteRequestData) -> DeleteResponseData?
}

protocol GlassRoomGettable: GlassRoomAPIProtocol {
    associatedtype GetPathParameters
    associatedtype GetQueryParameters
    associatedtype GetRequestData
    associatedtype GetResponseData
    static func get(params: GetPathParameters,
                    query: GetQueryParameters,
                    data: GetRequestData) -> GetResponseData?
}

protocol GlassRoomListable: GlassRoomAPIProtocol {
    associatedtype ListPathParameters
    associatedtype ListQueryParameters
    associatedtype ListRequestData
    associatedtype ListResponseData
    static func list(params: ListPathParameters,
                     query: ListQueryParameters,
                     data: ListRequestData) -> ListResponseData?
}

protocol GlassRoomPatchable: GlassRoomAPIProtocol {
    associatedtype PatchPathParameters
    associatedtype PatchQueryParameters
    associatedtype PatchRequestData
    associatedtype PatchResponseData
    static func patch(params: PatchPathParameters,
                      query: PatchQueryParameters,
                      data: PatchRequestData) -> PatchResponseData?
}

protocol GlassRoomUpdatable: GlassRoomAPIProtocol {
    associatedtype UpdatePathParameters
    associatedtype UpdateQueryParameters
    associatedtype UpdateRequestData
    associatedtype UpdateResponseData
    static func update(params: UpdatePathParameters,
                       query: UpdateQueryParameters,
                       data: UpdateRequestData) -> UpdateResponseData?
}
