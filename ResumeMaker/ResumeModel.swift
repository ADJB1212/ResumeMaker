//
//  Created by Andrew Jaffe © 2025
//

import Foundation
import SwiftUI

struct ResumeModel: Codable {
    var personalInfo: PersonalInfo
    var experience: [Experience]
    var education: [Education]
    var skills: [String]
    
    struct PersonalInfo: Codable {
        var fullName: String
        var email: String
        var phone: String
        var location: String
        var linkedIn: String?
        var summary: String
    }
    
    struct Experience: Codable, Identifiable {
        var id = UUID()
        var title: String
        var company: String
        var startDate: Date
        var endDate: Date?
        var description: String
    }
    
    struct Education: Codable, Identifiable {
        var id = UUID()
        var degree: String
        var institution: String
        var graduationDate: Date
        var gpa: String?
    }
}
