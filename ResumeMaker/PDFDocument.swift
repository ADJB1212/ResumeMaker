//
//  Created by Andrew Jaffe © 2025
//

import SwiftUI
import UniformTypeIdentifiers

struct ResumePDFDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.pdf] }
    
    var pdfData: Data
    
    init(pdfData: Data) {
        self.pdfData = pdfData
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.pdfData = data
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: pdfData)
    }
}
