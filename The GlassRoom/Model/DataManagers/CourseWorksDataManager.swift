//
//  CourseWorksDataManager.swift
//  The GlassRoom
//
//  Created by Tristan on 14/05/2023.
//

import Foundation
@testable import GlassRoomAPI

class CourseWorksDataManager: ObservableObject {
    @Published private(set) var courseWorks: [CourseWork]
    @Published private(set) var loading: Bool = false
    @Published private(set) var nextPageToken: String?

    let courseId: String

    init(courseId: String) {
        self.courseWorks = []
        self.courseId = courseId

        CourseWorksDataManager.loadedManagers[courseId] = self
    }

    func loadList(bypassCache: Bool = false) {
        loading = true
        if bypassCache {
            // use cache first anyway
            let cachedCourseWorks = readCache()
            if !cachedCourseWorks.isEmpty {
                courseWorks = cachedCourseWorks
            }
            refreshList()
        } else {
            // load from cache first, if that fails load from the list.
            let cachedCourseWorks = readCache()
            if cachedCourseWorks.isEmpty {
                refreshList()
            } else {
                self.courseWorks = cachedCourseWorks
                loading = false
            }
        }
    }

    func clearCache(courseId: String) {
        FileSystem.write([CourseWork](), to: "\(courseId)_courseWorks.json")
    }

    /// Loads the courses, possibly recursively.
    ///
    /// - Parameters:
    ///   - nextPageToken: The token from the previous page for pagnation
    ///   - requestNextPageIfExists: If the API request returns a nextPageToken and this value is true, it will recursively call itself to load all pages.
    func refreshList(nextPageToken: String? = nil, requestNextPageIfExists: Bool = false) {
        GlassRoomAPI.GRCourses.GRCourseWork.list(params: .init(courseId: courseId),
                                                 query: .init(courseWorkStates: nil,
                                                              orderBy: nil,
                                                              pageSize: nil,
                                                              pageToken: nil),
                                                    data: VoidStringCodable()
        ) { response in
            switch response {
            case .success(let success):
                self.courseWorks.append(contentsOf: success.courseWork)
                if let token = success.nextPageToken, requestNextPageIfExists {
                    self.refreshList(nextPageToken: token, requestNextPageIfExists: requestNextPageIfExists)
                } else {
                    self.nextPageToken = success.nextPageToken
                    DispatchQueue.main.async {
                        self.loading = false
                        self.writeCache()
                    }
                }
            case .failure(let failure):
                print("Failure: \(failure.localizedDescription)")
                self.loading = false
            }
        }
    }

    // MARK: Private methods
    private func readCache() -> [CourseWork] {
        // if the file exists in CourseCache
        if FileSystem.exists(file: "\(courseId)_courseWorks.json"),
           let cacheItems = FileSystem.read([CourseWork].self, from: "\(courseId)_courseWorks.json") {
            return cacheItems
        }
        return []
    }

    private func writeCache() {
        FileSystem.write(courseWorks, to: "\(courseId)_courseWorks.json") { error in
            print("Error writing: \(error.localizedDescription)")
        }
    }

    // MARK: Static functions
    static private(set) var loadedManagers: [String: CourseWorksDataManager] = [:]

    static func getManager(for courseId: String) -> CourseWorksDataManager {
        if let manager = loadedManagers[courseId] {
            return manager
        }
        return .init(courseId: courseId)
    }
}
