//
//  GRAnnouncements.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses.GRAnnouncements: GlassRoomCreatableDeletable,
                                                  GlassRoomGettableListable,
                                                  GlassRoomAssigneeModifiable,
                                                  GlassRoomPatchable {
    public typealias CreatePathParameters = CourseIDPathParameters
    public typealias CreateQueryParameters = VoidStringCodable
    public typealias CreateRequestData = CourseAnnouncement
    public typealias CreateResponseData = CourseAnnouncement

    public static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/announcements"

    public typealias DeletePathParameters = CourseIDAnnouncementPathParameters
    public typealias DeleteQueryParameters = VoidStringCodable
    public typealias DeleteRequestData = VoidStringCodable
    public typealias DeleteResponseData = VoidStringCodable

    public static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/announcements/{id}"

    public typealias GetPathParameters = CourseIDAnnouncementPathParameters
    public typealias GetQueryParameters = VoidStringCodable
    public typealias GetRequestData = VoidStringCodable
    public typealias GetResponseData = CourseAnnouncement

    public static var apiGettable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/announcements/{id}"

    public typealias ListPathParameters = CourseIDPathParameters
    public typealias ListQueryParameters = ListableQueryParameters
    public typealias ListRequestData = VoidStringCodable
    public typealias ListResponseData = ListableResponseData

    public static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/announcements/"

    public typealias ModifyAssigneePathParameters = CourseIDAnnouncementPathParameters
    public typealias ModifyAssigneeQueryParameters = VoidStringCodable
    public typealias ModifyAssigneeRequestData = AssigneeModifiableRequestData
    public typealias ModifyAssigneeResponseData = CourseAnnouncement

    public static var apiAssigneeModifiable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/announcements/{id}:modifyAssignees"

    public typealias PatchPathParameters = CourseIDAnnouncementPathParameters
    public typealias PatchQueryParameters = PatchableQueryParameters
    public typealias PatchRequestData = CourseAnnouncement
    public typealias PatchResponseData = CourseAnnouncement

    public static var apiPatchable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/announcements/{id}"

    public struct CourseIDAnnouncementPathParameters: StringCodable {
        public var courseId: String
        public var id: String

        public func stringDictionaryEncoded() -> [String: String] {
            [
                "courseId": courseId,
                "id": id
            ]
        }
    }

    public struct ListableQueryParameters: StringCodable {
        public var announcementStates: [AnnouncementState]?
        public var orderBy: String?
        public var pageSize: Int?
        public var pageToken: String?

        public func stringDictionaryEncoded() -> [String: String] {
            var dict = [String: String]()
            if let announcementStates { dict["announcementStates"] = announcementStates.description } // TODO: Check this
            if let orderBy { dict["orderBy"] = orderBy }
            if let pageSize { dict["pageSize"] = pageSize.description }
            if let pageToken { dict["pageToken"] = pageToken }
            return dict
        }
    }

    public struct ListableResponseData: Codable {
        public var announcements: [CourseAnnouncement]
        public var nextPageToken: String
    }

    public struct AssigneeModifiableRequestData: Codable {
        public var assigneeMode: AssigneeMode
        public var modifyIndividualStudentsOptions: ModifyIndividualStudentsOptions
    }

    public struct PatchableQueryParameters: StringCodable {
        /// Only the following are valid: `text`, `state`, `scheduledTime`
        public var updateMask: [String]

        public func stringDictionaryEncoded() -> [String: String] {
            ["updateMask": updateMask.joined(separator: ",")]
        }
    }
}
