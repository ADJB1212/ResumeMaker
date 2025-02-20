import SwiftUI

struct PersonalInfoView: View {
    @ObservedObject var viewModel: ResumeViewModel

    var body: some View {
        Form {
            Section(header: Text("Basic Information")) {
                TextField("Full Name", text: $viewModel.resume.personalInfo.fullName)
                TextField("Email", text: $viewModel.resume.personalInfo.email)
                    .keyboardType(.emailAddress)
                TextField("Phone", text: $viewModel.resume.personalInfo.phone)
                    .keyboardType(.phonePad)
                TextField("Location", text: $viewModel.resume.personalInfo.location)
            }

            Section(header: Text("Professional Profile")) {
                TextField(
                    "LinkedIn URL",
                    text: Binding(
                        get: { viewModel.resume.personalInfo.linkedIn ?? "" },
                        set: { viewModel.resume.personalInfo.linkedIn = $0.isEmpty ? nil : $0 }
                    ))

                TextEditor(text: $viewModel.resume.personalInfo.summary)
                    .frame(height: 100)
            }
        }
        .navigationTitle("Personal Information")
    }
}

struct AddExperienceView: View {
    @ObservedObject var viewModel: ResumeViewModel
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var company = ""
    @State private var startDate = Date()
    @State private var endDate: Date? = nil
    @State private var description = ""
    @State private var isCurrentJob = false

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
            .navigationTitle("Add Experience")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    let experience = ResumeModel.Experience(
                        title: title,
                        company: company,
                        startDate: startDate,
                        endDate: isCurrentJob ? nil : endDate,
                        description: description
                    )
                    viewModel.addExperience(experience)
                    dismiss()
                }
                .disabled(title.isEmpty || company.isEmpty || description.isEmpty)
            )
        }
    }
}

struct AddEducationView: View {
    @ObservedObject var viewModel: ResumeViewModel
    @Environment(\.dismiss) var dismiss

    @State private var degree = ""
    @State private var institution = ""
    @State private var graduationDate = Date()
    @State private var gpa = ""

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
            .navigationTitle("Add Education")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    let education = ResumeModel.Education(
                        degree: degree,
                        institution: institution,
                        graduationDate: graduationDate,
                        gpa: gpa.isEmpty ? nil : gpa
                    )
                    viewModel.addEducation(education)
                    dismiss()
                }
                .disabled(degree.isEmpty || institution.isEmpty)
            )
        }
    }
}

struct SkillsView: View {
    @ObservedObject var viewModel: ResumeViewModel
    @State private var newSkill = ""

    var body: some View {
        List {
            Section(header: Text("Add New Skill")) {
                HStack {
                    TextField("New Skill", text: $newSkill)
                    Button(action: addSkill) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(newSkill.isEmpty)
                }
            }

            Section(header: Text("Current Skills")) {
                ForEach(viewModel.resume.skills, id: \.self) { skill in
                    Text(skill)
                }
                .onDelete(perform: deleteSkills)
            }
        }
        .navigationTitle("Skills")
    }

    private func addSkill() {
        viewModel.resume.skills.append(newSkill)
        newSkill = ""
    }

    private func deleteSkills(at offsets: IndexSet) {
        viewModel.resume.skills.remove(atOffsets: offsets)
    }
}
