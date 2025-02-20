//
//  Created by Andrew Jaffe © 2025
//

import PDFKit
import SwiftUI
import UIKit

class PDFGenerator {
    let resume: ResumeModel
    let colorPalette: ColorPalette
    
    
    let separatorColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    
    init(resume: ResumeModel, colorPalette: ColorPalette) {
        self.resume = resume
        self.colorPalette = colorPalette
    }
    
    func generatePDF() -> Data? {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let topMargin: CGFloat = 25
        let sideMargin: CGFloat = 50
        let contentWidth = pageWidth - (sideMargin * 2)
        
        let format = UIGraphicsPDFRendererFormat()
        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
            format: format
        )
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            var yPosition: CGFloat = topMargin
            
            // Header section with background
            let headerHeight: CGFloat = 100
            let headerPath = UIBezierPath(
                rect: CGRect(x: 0, y: 0, width: pageWidth, height: headerHeight))
            colorPalette.uiPrimaryColor.setFill()
            headerPath.fill()
            
            // Name
            let nameFont =
            UIFont(name: "HelveticaNeue-Bold", size: 32)
            ?? .systemFont(ofSize: 32, weight: .bold)
            yPosition += drawText(
                resume.personalInfo.fullName,
                font: nameFont,
                color: .white,
                rect: CGRect(x: sideMargin, y: yPosition + 5, width: contentWidth, height: 40),
                alignment: .center
            )
            
            // Contact Info with icons
            let contactFont = UIFont(name: "HelveticaNeue", size: 12) ?? .systemFont(ofSize: 12)
            let contactInfo: [(String, String)] = [
                ("envelope.fill", resume.personalInfo.email),
                ("phone.fill", resume.personalInfo.phone),
                ("mappin.circle.fill", resume.personalInfo.location),
                
            ]
            
            let iconSize: CGFloat = 14
            let spacing: CGFloat = 10
            let contactY = yPosition + 8
            
            // Calculate widths and create item measurements
            struct ContactItemMeasurement {
                let iconWidth: CGFloat
                let textWidth: CGFloat
                let totalWidth: CGFloat
                let text: String
                let symbol: String
            }
            
            let measurements = contactInfo.map { symbol, text in
                let textWidth = (text as NSString).size(withAttributes: [.font: contactFont]).width
                return ContactItemMeasurement(
                    iconWidth: iconSize,
                    textWidth: textWidth,
                    totalWidth: iconSize + spacing + textWidth,
                    text: text,
                    symbol: symbol
                )
            }
            
            // Calculate total width of all items including spacing between them
            let totalWidth =
            measurements.reduce(0) { $0 + $1.totalWidth }
            + (spacing * CGFloat(measurements.count - 1))
            
            // Calculate starting X position to center everything
            let startX = sideMargin + (contentWidth - totalWidth) / 2
            var currentX = startX
            
            // Draw each item
            for measurement in measurements {
                // Draw the SF Symbol
                drawSFSymbol(
                    measurement.symbol,
                    at: CGPoint(x: currentX, y: contactY),
                    size: iconSize,
                    color: .white
                )
                
                // Draw the contact text
                drawText(
                    measurement.text,
                    font: contactFont,
                    color: .white,
                    rect: CGRect(
                        x: currentX + iconSize + spacing,
                        y: contactY,
                        width: measurement.textWidth,
                        height: 20
                    ),
                    alignment: .left
                )
                
                // Move to next item position
                currentX += measurement.totalWidth + spacing
            }
            
            yPosition = headerHeight + topMargin - 10
            
            // Summary Section
            yPosition += drawSection(
                title: "Professional Summary",
                content: resume.personalInfo.summary,
                startY: yPosition,
                margin: sideMargin,
                contentWidth: contentWidth
            ) + 8
            
            // Experience Section
            yPosition += drawSection(
                title: "Professional Experience",
                content: "",
                startY: yPosition,
                margin: sideMargin,
                contentWidth: contentWidth
            )
            for experience in resume.experience {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM yyyy"
                let dateString =
                "\(dateFormatter.string(from: experience.startDate)) - \(experience.endDate.map { dateFormatter.string(from: $0) } ?? "Present")"
                
                yPosition += drawExperienceItem(
                    title: experience.title,
                    company: experience.company,
                    dates: dateString,
                    description: experience.description,
                    startY: yPosition,
                    margin: sideMargin,
                    contentWidth: contentWidth
                )
            }
            
            // Education Section
            yPosition += drawSection(
                title: "Education",
                content: "",
                startY: yPosition,
                margin: sideMargin,
                contentWidth: contentWidth
            )
            for education in resume.education {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM yyyy"
                
                yPosition += drawEducationItem(
                    degree: education.degree,
                    institution: education.institution,
                    graduation: dateFormatter.string(from: education.graduationDate),
                    gpa: education.gpa,
                    startY: yPosition,
                    margin: sideMargin,
                    contentWidth: contentWidth
                )
            }
            
            // Skills Section
            
            drawSkillsSection(
                skills: resume.skills,
                startY: yPosition,
                margin: sideMargin,
                contentWidth: contentWidth
            )
        }
        
        return data
    }
    
    private func drawSection(
        title: String, content: String, startY: CGFloat, margin: CGFloat, contentWidth: CGFloat
    ) -> CGFloat {
        var yPosition = startY
        
        // Section Title with underline
        let titleFont =
        UIFont(name: "HelveticaNeue-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        yPosition += drawText(
            title,
            font: titleFont,
            color: colorPalette.uiPrimaryColor,
            rect: CGRect(x: margin, y: yPosition, width: contentWidth, height: 25),
            alignment: .left
        )
        
        // Draw underline
        let underlinePath = UIBezierPath()
        underlinePath.move(to: CGPoint(x: margin, y: yPosition))
        underlinePath.addLine(to: CGPoint(x: margin + contentWidth, y: yPosition))
        colorPalette.uiAccentColor.setStroke()
        underlinePath.lineWidth = 1
        underlinePath.stroke()
        
        yPosition += 10
        
        // Content
        let contentFont = UIFont(name: "HelveticaNeue", size: 12) ?? .systemFont(ofSize: 12)
        if !content.isEmpty{
            yPosition += drawText(
                content,
                font: contentFont,
                color: .black,
                rect: CGRect(x: margin, y: yPosition, width: contentWidth, height: calculateContentHeight(content, font: contentFont, width: contentWidth)),
                alignment: .left
            )
        }
        
        return yPosition - startY
    }
    private func drawExperienceItem(
        title: String, company: String, dates: String, description: String, startY: CGFloat,
        margin: CGFloat, contentWidth: CGFloat
    ) -> CGFloat {
        var yPosition = startY
        
        // Company and Title
        let titleFont =
        UIFont(name: "HelveticaNeue-Medium", size: 14)
        ?? .systemFont(ofSize: 14, weight: .medium)
        let companyFont =
        UIFont(name: "HelveticaNeue-Bold", size: 16) ?? .systemFont(ofSize: 16, weight: .bold)
        
        // Draw company with background accent
        let companyText = NSAttributedString(
            string: company,
            attributes: [
                .font: companyFont,
                .foregroundColor: colorPalette.uiPrimaryColor,
            ])
        companyText.draw(in: CGRect(x: margin, y: yPosition, width: contentWidth * 0.7, height: 20))
        
        
        // Draw dates aligned to the right
        let datesFont = UIFont(name: "HelveticaNeue", size: 12) ?? .systemFont(ofSize: 12)
        let datesText = NSAttributedString(
            string: dates,
            attributes: [
                .font: datesFont,
                .foregroundColor: UIColor.gray,
            ])
        
        let datesRect = CGRect(
            x: margin + (contentWidth * 0.7), y: yPosition+4, width: contentWidth * 0.3, height: 20)
        let datesTextSize = datesText.size()
        datesText.draw(at: CGPoint(x: datesRect.maxX - datesTextSize.width, y: datesRect.minY))
        
        yPosition += 20
        
        // Draw title
        let titleText = NSAttributedString(
            string: title,
            attributes: [
                .font: titleFont,
                .foregroundColor: UIColor.darkGray,
            ])
        titleText.draw(in: CGRect(x: margin, y: yPosition, width: contentWidth, height: 20))
        
        yPosition += 20
        
        // Draw description with bullet points
        let bulletPoints = description.components(separatedBy: ". ")
        let descriptionFont = UIFont(name: "HelveticaNeue", size: 11) ?? .systemFont(ofSize: 11)
        
        for point in bulletPoints where !point.isEmpty {
            let bullet = "• "
            let bulletText = NSAttributedString(
                string: bullet,
                attributes: [
                    .font: descriptionFont,
                    .foregroundColor: colorPalette.uiPrimaryColor,
                ])
            
            bulletText.draw(at: CGPoint(x: margin, y: yPosition))
            
            let pointText = NSAttributedString(
                string: point.trimmingCharacters(in: .whitespaces),
                attributes: [
                    .font: descriptionFont,
                    .foregroundColor: UIColor.black,
                ])
            
            pointText.draw(
                in: CGRect(x: margin + 15, y: yPosition, width: contentWidth - 15, height: 20))
            yPosition += 15
        }
        
        return yPosition - startY + 10
    }
    
    private func drawEducationItem(
        degree: String, institution: String, graduation: String, gpa: String?, startY: CGFloat,
        margin: CGFloat, contentWidth: CGFloat
    ) -> CGFloat {
        var yPosition = startY
        
        // Institution name
        let institutionFont =
        UIFont(name: "HelveticaNeue-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        yPosition += drawText(
            institution,
            font: institutionFont,
            color: colorPalette.uiPrimaryColor,
            rect: CGRect(x: margin, y: yPosition, width: contentWidth * 0.7, height: 18),
            alignment: .left
        )
        
        
        // Graduation date
        let dateFont = UIFont(name: "HelveticaNeue", size: 12) ?? .systemFont(ofSize: 12)
        drawText(
            graduation,
            font: dateFont,
            color: .gray,
            rect: CGRect(
                x: margin + (contentWidth * 0.7), y: yPosition - 16, width: contentWidth * 0.3,
                height: 20),
            alignment: .right
        )
        
        // Degree and GPA
        let degreeFont = UIFont(name: "HelveticaNeue", size: 12) ?? .systemFont(ofSize: 12)
        var degreeText = degree
        if let gpa = gpa {
            degreeText += " | GPA: \(gpa)"
        }
        
        yPosition += drawText(
            degreeText,
            font: degreeFont,
            color: .darkGray,
            rect: CGRect(x: margin, y: yPosition, width: contentWidth, height: 20),
            alignment: .left
        )
        
        return yPosition - startY + 8
    }
    
    private func drawSkillsSection(
        skills: [String], startY: CGFloat, margin: CGFloat, contentWidth: CGFloat
    ) -> CGFloat {
        var yPosition = startY
        
        // Section Title
        let titleFont =
        UIFont(name: "HelveticaNeue-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        yPosition += drawText(
            "Skills",
            font: titleFont,
            color: colorPalette.uiPrimaryColor,
            rect: CGRect(x: margin, y: yPosition, width: contentWidth, height: 25),
            alignment: .left
        )
        
        // Draw underline
        let underlinePath = UIBezierPath()
        underlinePath.move(to: CGPoint(x: margin, y: yPosition))
        underlinePath.addLine(to: CGPoint(x: margin + contentWidth, y: yPosition))
        colorPalette.uiAccentColor.setStroke()
        underlinePath.lineWidth = 1
        underlinePath.stroke()
        
        yPosition += 15
        
        // Draw skills in a grid with rounded rectangles
        let skillFont = UIFont(name: "HelveticaNeue", size: 11) ?? .systemFont(ofSize: 11)
        let skillHeight: CGFloat = 15
        let skillSpacing: CGFloat = 10
        let maxSkillWidth: CGFloat = 150
        
        var currentX = margin
        var currentY = yPosition
        
        for skill in skills {
            let skillSize = (skill as NSString).size(withAttributes: [.font: skillFont])
            let skillWidth = min(skillSize.width + 20, maxSkillWidth)
            
            if currentX + skillWidth > margin + contentWidth {
                currentX = margin
                currentY += skillHeight + skillSpacing
            }
            
            // Draw skill background
            let skillRect = CGRect(x: currentX, y: currentY, width: skillWidth, height: skillHeight)
            let path = UIBezierPath(roundedRect: skillRect, cornerRadius: 12)
            colorPalette.uiAccentColor.withAlphaComponent(0.1).setFill()
            path.fill()
            
            // Draw skill text
            drawText(
                skill,
                font: skillFont,
                color: colorPalette.uiPrimaryColor,
                rect: skillRect,
                alignment: .center
            )
            
            currentX += skillWidth + skillSpacing
        }
        
        return currentY - startY + skillHeight + margin
    }
    
    private func drawText(
        _ text: String, font: UIFont, color: UIColor, rect: CGRect,
        alignment: NSTextAlignment = .left
    ) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        attributedText.draw(in: rect)
        
        return rect.height
    }
    
    private func drawSFSymbol(
        _ systemName: String, at point: CGPoint, size: CGFloat, color: UIColor
    ) {
        let configuration = UIImage.SymbolConfiguration(pointSize: size, weight: .regular)
        if let image = UIImage(systemName: systemName, withConfiguration: configuration)?
            .withTintColor(color, renderingMode: .alwaysOriginal)
        {
            let width = image.size.width
            let height = image.size.height
            let imageRect = CGRect(x: point.x, y: point.y, width: width, height: height)
            
            // Create a new graphics context for the symbol
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
            if let context = UIGraphicsGetCurrentContext() {
                // Draw the symbol in the new context
                image.draw(in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
                if let symbolImage = UIGraphicsGetImageFromCurrentImageContext() {
                    UIGraphicsEndImageContext()
                    // Draw the symbol image in the PDF context
                    symbolImage.draw(in: imageRect)
                }
            }
            UIGraphicsEndImageContext()
        }
    }
    private func measureText(_ text: String, font: UIFont, width: CGFloat) -> CGRect {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return boundingBox
    }
    
    private func calculateContentHeight(_ content: String, font: UIFont, width: CGFloat) -> CGFloat {
        let rect = measureText(content, font: font, width: width)
        return ceil(rect.height)
        
    }
}

#Preview {
    PDFPreviewTester()
}
