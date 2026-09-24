import SwiftUI

struct Status {
    var sucessful: Bool
    var data: Any?
}

func appendRunSessionEntry(_ newObj: RunSessionEntryV2) -> Status {
    var result: [RunSessionEntryV2] = []
    if let d = UserDefaults.standard.data(forKey: "runs"),
       let decoded = try? JSONDecoder().decode([RunSessionEntryV2].self, from: d) {
        result = decoded
    }
        if let encoded = try? JSONEncoder().encode(result + [newObj]) {
            UserDefaults.standard.set(encoded, forKey: "runs")
            return Status(sucessful: true)
        }
    return Status(sucessful: false)
}

func getAllRunSessionEntry() -> Status {
    if let d = UserDefaults.standard.data(forKey: "runs"),
       let decoded = try? JSONDecoder().decode([RunSessionEntryV2].self, from: d) {
        return Status(sucessful: true, data: decoded)
    }
    return Status(sucessful: false, data: "Error thrown")
}

func appendRunSessionModel(_ newObj: RunSessionModelV2) -> Status {
    var result: [RunSessionModelV2] = []
    if let d = UserDefaults.standard.data(forKey: "run_models"),
       let decoded = try? JSONDecoder().decode([RunSessionModelV2].self, from: d) {
        result = decoded
    }
        if let encoded = try? JSONEncoder().encode(result + [newObj]) {
            UserDefaults.standard.set(encoded, forKey: "run_models")
            return Status(sucessful: true)
        }
    return Status(sucessful: false)
}

func getAllRunSessionModel() -> Status {
    if let d = UserDefaults.standard.data(forKey: "run_models"),
       let decoded = try? JSONDecoder().decode([RunSessionModelV2].self, from: d) {
        return Status(sucessful: true, data: decoded)
    }
    return Status(sucessful: false, data: "Error thrown")
}

// @fix generic error messages @not_urgent
