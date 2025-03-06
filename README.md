# ResumeMaker

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)

A modern, intuitive iOS app for creating professional resumes on the go. Build, customize, and export polished resumes directly from your iPhone.

## Features

- **User-friendly interface**: Easily input and edit personal information, work experience, education, and skills
- **Real-time preview**: See how your resume looks as you build it
- **Custom styling**: Choose from multiple professional color palettes to personalize your resume
- **PDF export**: Generate high-quality PDF documents ready for sharing or printing
- **Data persistence**: Your resume data is automatically saved between app sessions
- **Share options**: Send your resume via email, messages, or save to cloud storage

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.9+

## Installation

1. Clone the repository:

```bash
git clone https://github.com/ADJB1212/ResumeMaker.git
```

2. Open the project in Xcode:

```bash
cd ResumeMaker
open ResumeMaker.xcodeproj
```

3. Build and run the app on your simulator or device

## Usage

1. **Personal Information**: Start by filling in your basic contact details and professional summary
2. **Experience**: Add your work history with detailed descriptions of roles and responsibilities
3. **Education**: Include your academic background and achievements
4. **Skills**: List your professional skills and competencies
5. **Styling**: Choose a color palette that matches your professional style
6. **Export**: Generate a PDF and share it through various channels

## Implementation Details

The app is built using SwiftUI and follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Model**: `ResumeModel` represents the resume data structure
- **ViewModel**: `ResumeViewModel` handles data management and business logic
- **Views**: Various SwiftUI views for displaying and editing resume components

Key components:

- PDF generation using `PDFKit`
- Data persistence with `UserDefaults`
- Custom UI components and styling
