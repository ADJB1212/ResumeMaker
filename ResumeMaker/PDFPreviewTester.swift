//
//  Created by Andrew Jaffe © 2025
//

import PDFKit
import SwiftUI

struct PDFPreviewTester: View {
    @State private var pdfData: Data?
    var colorPal: ColorPalette = ColorPalette.palettes[3]
    
    var body: some View {
        VStack {
            if let pdfData = pdfData {
                PDFPreviewView(pdfData: pdfData)
            } else {
                Text("Loading PDF...")
            }
        }
        .onAppear {
            generateSamplePDF()
        }
    }
    
    private func generateSamplePDF() {
        let sampleResume = ResumeModel(
            personalInfo: ResumeModel.PersonalInfo(
                fullName: "Andrew",
                email: "alex.johnson@email.com",
                phone: "(555) 123-4567",
                location: "San Francisco, CA",
                linkedIn: "linkedin.com/in/alexjohnson",
                summary:
                    "Experienced software developer with a passion for creating innovative solutions. Skilled in iOS development, cloud architecture, and team leadership. Proven track record of delivering high-quality applications while mentoring junior developers."
            ),
            experience: [
                ResumeModel.Experience(
                    title: "Senior iOS Developer",
                    company: "Tech Innovations Inc.",
                    startDate: Calendar.current.date(byAdding: .year, value: -2, to: Date())!,
                    endDate: nil,
                    description:
                        "Led development of flagship iOS application with over 1M downloads. Implemented CI/CD pipeline reducing deployment time by 60%. Mentored team of 5 junior developers. Architected and implemented major app redesign increasing user engagement by 40%"
                ),
                ResumeModel.Experience(
                    title: "Mobile Developer",
                    company: "Digital Solutions LLC",
                    startDate: Calendar.current.date(byAdding: .year, value: -4, to: Date())!,
                    endDate: Calendar.current.date(byAdding: .year, value: -2, to: Date())!,
                    description:
                        "Developed and maintained multiple iOS applications using Swift and UIKit. Collaborated with design team to implement pixel-perfect UI. Reduced app crash rate by 80% through robust error handling"
                ),
                ResumeModel.Experience(
                    title: "Software Engineer Intern",
                    company: "StartUp Co",
                    startDate: Calendar.current.date(byAdding: .year, value: -5, to: Date())!,
                    endDate: Calendar.current.date(byAdding: .year, value: -4, to: Date())!,
                    description:
                        "Assisted in development of iOS and Android applications. Implemented new features and fixed bugs. Participated in daily stand-ups and sprint planning"
                ),
            ],
            education: [
                ResumeModel.Education(
                    degree: "Master of Science in Computer Science",
                    institution: "Stanford University",
                    graduationDate: Calendar.current.date(byAdding: .year, value: -3, to: Date())!,
                    gpa: "3.92"
                ),
                ResumeModel.Education(
                    degree: "Bachelor of Science in Software Engineering",
                    institution: "University of California, Berkeley",
                    graduationDate: Calendar.current.date(byAdding: .year, value: -5, to: Date())!,
                    gpa: "3.85"
                ),
            ],
            skills: [
                "Swift",
                "SwiftUI",
                "UIKit",
                "Xcode",
                "Git",
                "CI/CD",
                "API Design",
                "Core Data",
                "Unit Testing",
                "Team Leadership",
                "Agile/Scrum",
                "Problem Solving",
                "Cloud Architecture",
                "Firebase",
                "AWS",
            ]
        )
        
        let pdfCreator = PDFGenerator(resume: sampleResume, colorPalette: colorPal)
        self.pdfData = pdfCreator.generatePDF()
    }
    private func generateEdgeCasesPDF() {
        let edgeCaseResume = ResumeModel(
            personalInfo: ResumeModel.PersonalInfo(
                fullName: "Dr. Alexandria Katherina Williamson-Montgomery III",  // Very long name
                email: "alexandria.katherina.williamson.montgomery@verylongdomain.com",
                phone: "+1 (555) 123-4567 ext. 12345",
                location: "San Francisco Bay Area, California, United States",
                linkedIn: "linkedin.com/in/alexandriakatherinamontgomery",
                summary: "A very short summary."  // Test minimal content
            ),
            experience: [
                ResumeModel.Experience(
                    title: "Senior Principal Technical Lead Architecture Developer Engineer",  // Long title
                    company: "Very Long Company Name That Might Break The Layout Industries, Inc.",
                    startDate: Date(),
                    endDate: nil,
                    description:
                        "An extremely long description that goes into great detail about every single responsibility and achievement, potentially causing layout issues if not handled properly. This description includes multiple sentences and might even have some very long technical terms like microservices architecture implementation."
                )
            ],
            education: [
                ResumeModel.Education(
                    degree: "Doctor of Philosophy in Computer Science and Artificial Intelligence",
                    institution: "Massachusetts Institute of Technology",
                    graduationDate: Date(),
                    gpa: "4.0"
                )
            ],
            skills: Array(repeating: "Very Long Skill Name That Might Break Layout", count: 20)
        )
        
        let pdfCreator = PDFGenerator(resume: edgeCaseResume, colorPalette: colorPal)
        self.pdfData = pdfCreator.generatePDF()
    }
}

#Preview {
    PDFPreviewTester()
}
