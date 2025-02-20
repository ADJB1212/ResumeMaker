//
//  Created by Andrew Jaffe © 2025
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ResumeViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Personal Information")) {
                    NavigationLink(destination: PersonalInfoView(viewModel: viewModel)) {
                        HStack {
                            Image(systemName: "person.circle")
                            Text("Personal Details")
                        }
                    }
                }
                
                Section(header: Text("Experience")) {
                    ForEach(viewModel.resume.experience) { experience in
                        ExperienceRow(experience: experience)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.editingExperience = experience
                                viewModel.showEditExperience = true
                            }
                    }
                    .onDelete(perform: viewModel.removeExperience)
                    
                    Button(action: {
                        viewModel.showAddExperience = true
                    }) {
                        Label("Add Experience", systemImage: "plus.circle")
                    }
                }
                
                Section(header: Text("Education")) {
                    ForEach(viewModel.resume.education) { education in
                        EducationRow(education: education)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.editingEducation = education
                                viewModel.showEditEducation = true
                            }
                    }
                    .onDelete(perform: viewModel.removeEducation)
                    
                    Button(action: {
                        viewModel.showAddEducation = true
                    }) {
                        Label("Add Education", systemImage: "plus.circle")
                    }
                }
                
                Section(header: Text("Skills")) {
                    NavigationLink(destination: SkillsView(viewModel: viewModel)) {
                        HStack {
                            Image(systemName: "star.circle")
                            Text("Manage Skills")
                        }
                    }
                }
                Section(header: Text("Appearance")) {
                    Button(action: {
                        viewModel.showColorPicker = true
                    }) {
                        HStack {
                            Image(systemName: "paintpalette")
                            Text("Color Palette")
                            Spacer()
                            Text(viewModel.selectedPalette.name)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.generatePDF()
                    }) {
                        Text("Generate Resume")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Resume Builder")
            .sheet(isPresented: $viewModel.showAddExperience) {
                ExperienceEditView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showEditExperience) {
                if let experience = viewModel.editingExperience {
                    ExperienceEditView(viewModel: viewModel, experience: experience)
                }
            }
            .sheet(isPresented: $viewModel.showAddEducation) {
                EducationEditView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showEditEducation) {
                if let education = viewModel.editingEducation {
                    EducationEditView(viewModel: viewModel, education: education)
                }
            }
            .sheet(isPresented: $viewModel.showPDFPreview) {
                EnhancedPDFPreviewView(pdfData: viewModel.generatedPDF!)
            }
            .sheet(isPresented: $viewModel.showColorPicker) {
                ColorPaletteView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
