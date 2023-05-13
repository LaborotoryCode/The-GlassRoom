//
//  SidebarView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomAPI

struct SidebarView: View {
    @Binding var selection: Course?
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global

    var body: some View {
<<<<<<< HEAD:The GlassRoom/UI/Main/Sidebar/SidebarView.swift
        SidebarOutlineView(selectedCourse: $selection, courses: coursesManager.courses)
//        List {
//            ForEach(0..<coursesManager.courses.count, id: \.self) { index in
//                let course = coursesManager.courses[index]
//                VStack(alignment: .leading) {
//                    Text(course.name)
//                    if let description = course.description {
//                        Text(description)
//                    }
//                }
//            }
//        }
=======
        List {
            ForEach(0..<coursesManager.courses.count, id: \.self) { index in
                let course = coursesManager.courses[index]
                Button {
                    selection = course
                } label: {
                    VStack(alignment: .leading) {
                        Text(course.name)
                        if let description = course.description {
                            Text(description)
                        }
                    }
                }
            }
        }
>>>>>>> main:The GlassRoom/UI/Main/SidebarView.swift
        .overlay {
            if coursesManager.courses.isEmpty {
                Text("No Classes")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if coursesManager.loading {
                ProgressView()
                    .progressViewStyle(.linear)
                    .frame(maxWidth: .infinity)
                    .padding(10)
            }
        }
        .onAppear {
            guard coursesManager.courses.isEmpty else { return }
            coursesManager.loadList()
        }
    }
}

struct CourseCategoryHeaderView: View {
    var name: String

    var body: some View {
        HStack {
            Text(name)
                .bold()
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.horizontal, 5)
    }
}

struct CourseView: View {
    var course: Course

    var body: some View {
        VStack(alignment: .leading) {
            Text(course.name)
            if let description = course.description {
                Text(description)
            }
        }
        .padding(.horizontal, 5)
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(selection: .constant(nil))
    }
}
