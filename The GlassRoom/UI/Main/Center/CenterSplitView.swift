//
//  CenterSplitView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomAPI

struct CenterSplitView: View {
    @Binding var selectedCourse: GeneralCourse?
    @Binding var selectedPost: CoursePost?
    
    @State var coursePostsManager: CoursePostsDataManager?
    @State var currentPage: CourseDisplayOption = .allPosts

    @StateObject var displayedCoursesManager: DisplayedCourseManager = .init()

    @ObservedObject var configuration = GlobalCoursesDataManager.global.configuration

    @AppStorage("tintToCourseColor") var tintToCourseColor: Bool = true
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.001) // prevent view from jumping around
            if let selectedCourse {
                if tintToCourseColor {
                    configuration.colorFor(selectedCourse.id)
                        .opacity(0.1)
                }
                switch selectedCourse {
                case .course(_):
                    if let coursePostsManager {
                        SingleCoursePostListView(selectedPost: $selectedPost,
                                                 displayOption: $currentPage,
                                                 posts: coursePostsManager)
                        .scrollContentBackground(.hidden)
                    } else {
                        Text("Course post manager not found")
                    }
                default:
                    MultiCoursePostListView(selectedPost: $selectedPost,
                                            displayOption: $currentPage,
                                            displayedCourseIds: displayedCoursesManager)
                    .scrollContentBackground(.hidden)
                }
            } else {
                ZStack {
                    Text("No Course Selected")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                }
                .frame(maxHeight: .infinity)
            }
        }
        .safeAreaInset(edge: .top) {
            CenterSplitViewToolbarTop(selectedCourse: $selectedCourse,
                                      currentPage: $currentPage,
                                      displayedCourseManager: displayedCoursesManager)
        }
        .onChange(of: selectedCourse) { _ in
            reloadAnnouncements()
        }
        .onAppear {
            reloadAnnouncements()
        }
    }
    
    var notImplementedYet: some View {
        ZStack {
            Text("Not Implemented Yet")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
        }
        .frame(maxHeight: .infinity)
    }
    
    func reloadAnnouncements() {
        guard let selectedCourse else { return }
        switch selectedCourse {
        case .course(let course):
            let selectedCourseId = course
            let manager = CoursePostsDataManager.getManager(for: selectedCourseId)
            self.coursePostsManager = manager
            if manager.courseAnnouncements.isEmpty || manager.lastRefreshDate == nil {
                manager.loadList(bypassCache: true)
            }

            // if the class register is currently focused, reload it
            let profileManager = GlobalUserProfilesDataManager.global
            if currentPage == .userRegister,
               (profileManager.students[course]?.isEmpty ?? true) &&
               (profileManager.teachers[course]?.isEmpty ?? true) {
                profileManager.loadList(for: course)
            }

            // TODO: Intelligently refresh
        default: return
        }
    }

    enum CourseDisplayOption: String, CaseIterable {
        case allPosts = "All Posts"
        case announcements = "Announcements"
        case courseWork = "Course Works"
        case courseMaterial = "Course Material"
        case userRegister = "Register"

        static var allCases: [CenterSplitView.CourseDisplayOption] = [
            .allPosts, .announcements, .courseWork, .courseMaterial, .userRegister
        ]
    }
}

struct CenterSplitView_Previews: PreviewProvider {
    static var previews: some View {
        CenterSplitView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}

class DisplayedCourseManager: ObservableObject {
    @Published var displayedAggregateCourseIds: [String]

    init(displayedAggregateCourseIds: [String] = []) {
        self.displayedAggregateCourseIds = displayedAggregateCourseIds
    }
}
