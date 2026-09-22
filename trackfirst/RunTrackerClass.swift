import SwiftUI
import CoreLocation

struct LocationEntry: Codable {
    var timestamp: Date
    var longitude: Double
    var latitude: Double
    var altitude: Double
    var xyacc: Double
    var zacc: Double
    var use: String
}
struct RunSessionEntry: Codable {
    var id: String
    var startedAt: Date
    var endedAt: Date
    var locations: [LocationEntry]
    var checkpoint: [Date]
    var destination: String
    
}

func rgc(from location: CLLocation) async throws -> String {
    let geocoder = CLGeocoder()
    let placemarks = try await geocoder.reverseGeocodeLocation(location)

    guard let placemark = placemarks.first else {
            print("some error")
            return ""
        }
        
        let streetName = placemark.thoroughfare
        
    return "\(streetName?.description)"
    
}
@Observable class RunTracker: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var Clocations: [LocationEntry] = []
    private var authorization: Bool = false
    var checkpoint: [Date] = []
    var isStarted: Bool = false
    var startedAt: Date = Date()
    var whichAction: String = ""
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.activityType = .fitness
        manager.distanceFilter = kCLDistanceFilterNone
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        //background and foreground settings?
    }
    
    func start() {
       // UserDefaults.standard.removeObject(forKey: "locations") // DELETE THIS LINE*
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
           authorization = true
            manager.startUpdatingLocation()
            isStarted = true
            startedAt = Date()
            break
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let last = locations.last!
        if last.horizontalAccuracy < 4.5 { return }
        Clocations.append(LocationEntry(timestamp: last.timestamp, longitude: last.coordinate.longitude, latitude: last.coordinate.latitude, altitude: last.altitude, xyacc: last.horizontalAccuracy, zacc: last.verticalAccuracy, use: whichAction))
    }
    func saveLocal() async {
        guard let g = Clocations.last else {
            print("NPC detected")
            return
        }
        let cl = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: g.latitude, longitude: g.longitude),
            altitude: g.altitude,
            horizontalAccuracy: g.xyacc,
            verticalAccuracy: g.zacc,
            timestamp: g.timestamp
        )
        do {
            let dest = try await rgc(from: cl)
            let rs = RunSessionEntry(id: generateRandomId(15), startedAt: startedAt, endedAt: Date(), locations: Clocations, checkpoint: checkpoint, destination: dest)
            print("initials")
            var result: [RunSessionEntry] = []
            if let d = UserDefaults.standard.data(forKey: "runs") {
                if let decoded = try? JSONDecoder().decode([RunSessionEntry].self, from: d) {
                    result = decoded
                }
            }
                result.append(rs)
                print("trying to save")
                if let encoded = try? JSONEncoder().encode(result) {
                    print("did save")
                    UserDefaults.standard.set(encoded, forKey: "runs")
                }
            isStarted = false
            stopRecording()
        } catch {
            print("some err occured")
        }
    }
    
    func stopRecording() {
        //print("did stop")
        manager.stopUpdatingLocation()
    }
}
