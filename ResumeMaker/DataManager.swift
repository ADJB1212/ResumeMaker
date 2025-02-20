import Foundation

class DataManager {
    static let shared = DataManager()
    private let userDefaultsKey = "savedResume"

    func saveResume(_ resume: ResumeModel) {
        if let encoded = try? JSONEncoder().encode(resume) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    func loadResume() -> ResumeModel? {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
            let decodedResume = try? JSONDecoder().decode(ResumeModel.self, from: savedData)
        {
            return decodedResume
        }
        return nil
    }

    func clearSavedData() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
