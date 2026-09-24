import SwiftUI
import MapKit

func generateRandomId(_ x: Int) -> String {
    return String((0..<x).map { _ in "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".randomElement()! })
}

func distfn(_ p1: LocationEntryV2, _ p2: LocationEntryV2) -> Double {
    let lat1 = p1.lat * Double.pi / 180, lon1 = p1.lon * Double.pi / 180
    let lat2 = p2.lat * Double.pi / 180, lon2 = p2.lon * Double.pi / 180
    let dlat = lat2 - lat1
    let dlon = lon2 - lon1
    let a = sin(dlat/2)*sin(dlat/2) + cos(lat1) * cos(lat2) * sin(dlon/2) * sin(dlon/2)
    return 2 * 6_371_000.0 * atan2(sqrt(a), sqrt(1-a))
}

func CLtoLEV2(_ cl: CLLocation) -> LocationEntryV2 {
    return LocationEntryV2(id: generateRandomId(15), timestamp: cl.timestamp, lat: cl.coordinate.latitude, lon: cl.coordinate.longitude, alt: cl.altitude, xyacc: cl.horizontalAccuracy, zacc: cl.verticalAccuracy)
}

func convert(_ inp: [LocationEntryV2]) -> [CLLocationCoordinate2D] {
    let k: [CLLocationCoordinate2D] = inp.map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon) }
    return k
}

func LEV2toCL(_ lev2: LocationEntryV2) -> CLLocation {
    // LOSES ITS ID
    return CLLocation(coordinate: CLLocationCoordinate2D(latitude: lev2.lat, longitude: lev2.lon), altitude: lev2.alt, horizontalAccuracy: lev2.xyacc, verticalAccuracy: lev2.zacc, timestamp: lev2.timestamp)
}


func makeModel(_ entry: RunSessionEntryV2) -> RunSessionModelV2 {
    //if entry.coordinates.count < 5 { return nil } // throw some error**@moderate
    return RunSessionModelV2(id: generateRandomId(15), name: "New Run", checkpoints: entry.checkpoints.map { Checkpoint(id: generateRandomId(15), location: $0, location_name: "No name yet") }, start_coordinate: entry.coordinates.first!, end_coordinate: entry.coordinates.last!, destination: entry.destination, distance: entry.distance, displacement: entry.displacement) // needs renaming**@urgent
}

func reverseGeocode(_ coordinate: CLLocation) async throws -> Status {
    if let request = MKReverseGeocodingRequest(location: coordinate) {
        do {
            let mapItems = try await request.mapItems
            return Status(sucessful: true, data: mapItems.first)
        } catch {
            print(error)
            return Status(sucessful: false, data: "er1")
        }
    }
    return Status(sucessful: false, data: "er2")
}
