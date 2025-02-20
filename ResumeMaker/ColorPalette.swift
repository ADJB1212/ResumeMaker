//
//  Created by Andrew Jaffe © 2025
//

import SwiftUI

struct ColorPalette: Identifiable {
    let id: Int
    let name: String
    let primaryColor: RGBColor
    let accentColor: RGBColor
    
    var uiPrimaryColor: UIColor {
        UIColor(red: primaryColor.red, green: primaryColor.green, blue: primaryColor.blue, alpha: 1.0)
    }
    
    var uiAccentColor: UIColor {
        UIColor(red: accentColor.red, green: accentColor.green, blue: accentColor.blue, alpha: 1.0)
    }
    
    var swiftUIPrimaryColor: Color {
        Color(red: primaryColor.red, green: primaryColor.green, blue: primaryColor.blue)
    }
    
    var swiftUIAccentColor: Color {
        Color(red: accentColor.red, green: accentColor.green, blue: accentColor.blue)
    }
}

struct RGBColor: Codable {
    let red: Double
    let green: Double
    let blue: Double
}

extension ColorPalette {
    static let palettes: [ColorPalette] = [
        ColorPalette(
            id: 0,
            name: "Classic Blue",
            primaryColor: RGBColor(red: 0.2, green: 0.2, blue: 0.6),
            accentColor: RGBColor(red: 0.4, green: 0.4, blue: 0.8)
        ),
        ColorPalette(
            id: 1,
            name: "Professional Gray",
            primaryColor: RGBColor(red: 0.2, green: 0.2, blue: 0.2),
            accentColor: RGBColor(red: 0.4, green: 0.4, blue: 0.4)
        ),
        ColorPalette(
            id: 2,
            name: "Forest Green",
            primaryColor: RGBColor(red: 0.1, green: 0.3, blue: 0.1),
            accentColor: RGBColor(red: 0.2, green: 0.5, blue: 0.2)
        ),
        ColorPalette(
            id: 3,
            name: "Deep Purple",
            primaryColor: RGBColor(red: 0.3, green: 0.1, blue: 0.3),
            accentColor: RGBColor(red: 0.5, green: 0.2, blue: 0.5)
        ),
        ColorPalette(
            id: 4,
            name: "Ocean Blue",
            primaryColor: RGBColor(red: 0.1, green: 0.2, blue: 0.4),
            accentColor: RGBColor(red: 0.2, green: 0.4, blue: 0.6)
        ),
        ColorPalette(
            id: 5,
            name: "Burgundy",
            primaryColor: RGBColor(red: 0.4, green: 0.1, blue: 0.1),
            accentColor: RGBColor(red: 0.6, green: 0.2, blue: 0.2)
        )
    ]
}
