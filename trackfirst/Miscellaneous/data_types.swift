import SwiftUI

struct LocationEntryV2: Codable {
    var id: String
    var timestamp: Date
    var lat: Double
    var lon: Double
    var alt: Double
    var xyacc: Double
    var zacc: Double
}

struct Checkpoint: Codable {
    var id: String
    var location: LocationEntryV2
    var location_name: String
}

struct RunSessionEntryV2: Codable {
    var id: String = generateRandomId(15)
    var start: Date
    var end: Date
    var coordinates: [LocationEntryV2]
    var checkpoints: [LocationEntryV2]
    var destination: String
    var distance: Double
    var displacement: Double
}

struct RunSessionModelV2: Codable {
    var id: String
    var name: String
    var description: String?
    var checkpoints: [Checkpoint]
    var start_coordinate: LocationEntryV2
    var end_coordinate: LocationEntryV2
    var destination: String
    var distance: Double
    var displacement: Double
}
