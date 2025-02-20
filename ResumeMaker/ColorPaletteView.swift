//
//  Created by Andrew Jaffe © 2025
//

import SwiftUI

struct ColorPaletteView: View {
    @ObservedObject var viewModel: ResumeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List(ColorPalette.palettes, id: \.id) { palette in
                HStack {
                    VStack(alignment: .leading) {
                        Text(palette.name)
                            .font(.headline)
                        HStack(spacing: 10) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(palette.swiftUIPrimaryColor)
                                .frame(width: 30, height: 30)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(palette.swiftUIAccentColor)
                                .frame(width: 30, height: 30)
                        }
                    }
                    Spacer()
                    if viewModel.selectedPalette.id == palette.id {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.updateColorPalette(palette)
                    dismiss()
                }
            }
            .navigationTitle("Color Palettes")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}
