//
//  Created by Andrew Jaffe © 2025
//

import PDFKit
import SwiftUI
import UniformTypeIdentifiers

struct EnhancedPDFPreviewView: View {
    let pdfData: Data
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false
    @State private var showExportOptions = false
    
    var body: some View {
        NavigationView {
            PDFPreviewView(pdfData: pdfData)
                .navigationTitle("Resume Preview")
                .navigationBarItems(
                    leading: Button("Done") { dismiss() },
                    trailing: Menu {
                        Button(action: { showShareSheet = true }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        
                        Button(action: saveToFiles) {
                            Label("Save to Files", systemImage: "folder")
                        }
                        
                        Button(action: { showExportOptions = true }) {
                            Label("Export Options", systemImage: "doc.on.doc")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                )
                .sheet(isPresented: $showShareSheet) {
                    ShareSheet(items: [pdfData])
                }
                .fileExporter(
                    isPresented: $showExportOptions,
                    document: ResumePDFDocument(pdfData: pdfData),
                    contentType: .pdf,
                    defaultFilename: "Resume.pdf"
                ) { result in
                    switch result {
                    case .success(let url):
                        print("Saved to \(url)")
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    private func saveToFiles() {
        showExportOptions = true
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
