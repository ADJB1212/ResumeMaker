//
//  Created by Andrew Jaffe © 2025
//

import SwiftUI

struct ExperienceRow: View {
    let experience: ResumeModel.Experience
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(experience.title)
                .font(.headline)
            Text(experience.company)
                .font(.subheadline)
            Text(formatDateRange(start: experience.startDate, end: experience.endDate))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private func formatDateRange(start: Date, end: Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        let startString = dateFormatter.string(from: start)
        let endString = end.map { dateFormatter.string(from: $0) } ?? "Present"
        return "\(startString) - \(endString)"
    }
}

struct EducationRow: View {
    let education: ResumeModel.Education
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(education.degree)
                .font(.headline)
            Text(education.institution)
                .font(.subheadline)
            HStack {
                Text(formatDate(education.graduationDate))
                if let gpa = education.gpa {
                    Text("GPA: \(gpa)")
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: date)
    }
}
