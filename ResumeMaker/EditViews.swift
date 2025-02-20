//
//  Created by Andrew Jaffe © 2025
//

import SwiftUI

struct ExperienceEditView: View {
    @ObservedObject var viewModel: ResumeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var company: String
    @State private var startDate: Date
    @State private var endDate: Date?
    @State private var description: String
    @State private var isCurrentJob: Bool
    
    private let experience: ResumeModel.Experience?
    private let isEditing: Bool
    
    init(viewModel: ResumeViewModel, experience: ResumeModel.Experience? = nil) {
        self.viewModel = viewModel
        self.experience = experience
        self.isEditing = experience != nil
        
        _title = State(initialValue: experience?.title ?? "")
        _company = State(initialValue: experience?.company ?? "")
        _startDate = State(initialValue: experience?.startDate ?? Date())
        _endDate = State(initialValue: experience?.endDate)
        _description = State(initialValue: experience?.description ?? "")
        _isCurrentJob = State(initialValue: experience?.endDate == nil)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Job Details")) {
                    TextField("Job Title", text: $title)
                    TextField("Company", text: $company)
                }
                
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    Toggle("Current Position", isOn: $isCurrentJob)
                    if !isCurrentJob {
                        DatePicker(
                            "End Date",
                            selection: Binding(
                                get: { endDate ?? Date() },
                                set: { endDate = $0 }
                            ), displayedComponents: .date)
                    }
                }
                
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
            }
            .navigationTitle(isEditing ? "Edit Experience" : "Add Experience")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    let experience = ResumeModel.Experience(
                        id: self.experience?.id ?? UUID(),
                        title: title,
                        company: company,
                        startDate: startDate,
                        endDate: isCurrentJob ? nil : endDate,
                        description: description
                    )
                    
                    if isEditing {
                        viewModel.updateExperience(experience)
                    } else {
                        viewModel.addExperience(experience)
                    }
                    dismiss()
                }
                    .disabled(title.isEmpty || company.isEmpty || description.isEmpty)
            )
        }
    }
}

struct EducationEditView: View {
    @ObservedObject var viewModel: ResumeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var degree: String
    @State private var institution: String
    @State private var graduationDate: Date
    @State private var gpa: String
    
    private let education: ResumeModel.Education?
    private let isEditing: Bool
    
    init(viewModel: ResumeViewModel, education: ResumeModel.Education? = nil) {
        self.viewModel = viewModel
        self.education = education
        self.isEditing = education != nil
        
        _degree = State(initialValue: education?.degree ?? "")
        _institution = State(initialValue: education?.institution ?? "")
        _graduationDate = State(initialValue: education?.graduationDate ?? Date())
        _gpa = State(initialValue: education?.gpa ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Education Details")) {
                    TextField("Degree", text: $degree)
                    TextField("Institution", text: $institution)
                }
                
                Section(header: Text("Graduation")) {
                    DatePicker(
                        "Graduation Date", selection: $graduationDate, displayedComponents: .date)
                    TextField("GPA (Optional)", text: $gpa)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle(isEditing ? "Edit Education" : "Add Education")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    let education = ResumeModel.Education(
                        id: self.education?.id ?? UUID(),
                        degree: degree,
                        institution: institution,
                        graduationDate: graduationDate,
                        gpa: gpa.isEmpty ? nil : gpa
                    )
                    
                    if isEditing {
                        viewModel.updateEducation(education)
                    } else {
                        viewModel.addEducation(education)
                    }
                    dismiss()
                }
                    .disabled(degree.isEmpty || institution.isEmpty)
            )
        }
    }
}
