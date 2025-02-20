import PDFKit
import SwiftUI
import UniformTypeIdentifiers

class ResumeViewModel: ObservableObject {
    @Published var resume: ResumeModel {
        didSet {
            DataManager.shared.saveResume(resume)
        }
    }
    @Published var showAddExperience = false
    @Published var showAddEducation = false
    @Published var showPDFPreview = false
    @Published var showExportOptions = false
    @Published var generatedPDF: Data?
    @Published var editingExperience: ResumeModel.Experience?
    @Published var editingEducation: ResumeModel.Education?
    @Published var showEditExperience = false
    @Published var showEditEducation = false

    init() {
        if let savedResume = DataManager.shared.loadResume() {
            self.resume = savedResume
        } else {
            self.resume = ResumeModel(
                personalInfo: ResumeModel.PersonalInfo(
                    fullName: "",
                    email: "",
                    phone: "",
                    location: "",
                    linkedIn: "",
                    summary: ""
                ),
                experience: [],
                education: [],
                skills: []
            )
        }
    }

    func addExperience(_ experience: ResumeModel.Experience) {
        resume.experience.append(experience)
        showAddExperience = false
    }

    func removeExperience(at offsets: IndexSet) {
        resume.experience.remove(atOffsets: offsets)
    }

    func addEducation(_ education: ResumeModel.Education) {
        resume.education.append(education)
        showAddEducation = false
    }

    func removeEducation(at offsets: IndexSet) {
        resume.education.remove(atOffsets: offsets)
    }

    func updateExperience(_ updatedExperience: ResumeModel.Experience) {
        if let index = resume.experience.firstIndex(where: { $0.id == updatedExperience.id }) {
            resume.experience[index] = updatedExperience
        }
        showEditExperience = false
        editingExperience = nil
    }

    func updateEducation(_ updatedEducation: ResumeModel.Education) {
        if let index = resume.education.firstIndex(where: { $0.id == updatedEducation.id }) {
            resume.education[index] = updatedEducation
        }
        showEditEducation = false
        editingEducation = nil
    }

    func generatePDF() {
        let pdfCreator = PDFGenerator(resume: resume)
        if let pdfData = pdfCreator.generatePDF() {
            self.generatedPDF = pdfData
            self.showPDFPreview = true
        }
    }

    func exportPDF() {
        showExportOptions = true
    }
}
