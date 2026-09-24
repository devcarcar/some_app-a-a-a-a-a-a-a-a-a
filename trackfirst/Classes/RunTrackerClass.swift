import SwiftUI
import CoreLocation
import MapKit

@Observable class RunTracker: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var Clocations: [LocationEntryV2] = []
    private var authorization: Bool = false
    var checkpoints: [LocationEntryV2] = []
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
       // if last.horizontalAccuracy > 4.5 { return }
        Clocations.append(CLtoLEV2(last))
    }
    func saveLocal() async {
        guard let g = Clocations.last else {
            print("NPC detected")
            return
        } // REHANDLE THE THROW**@moderate
        do {
            let res = try await reverseGeocode(LEV2toCL(g))
            var dest = ""
            if !res.sucessful {
                // throw some erorr
                print("some error")
            }
            dest = (res.data as! MKMapItem).name!
            print("dest:_\(dest)_")
            var dist: Double = 0
            for i in 0..<Clocations.count-1 {
                dist += distfn(Clocations[i], Clocations[i+1])
            }
            // HANDLE THROW IF LENGTH < SOME SPECIFIC*@moderate
            let rs = RunSessionEntryV2(start: startedAt, end: Date(), coordinates: Clocations, checkpoints: checkpoints, destination: dest, distance: dist, displacement: distfn(Clocations.first!, Clocations.last!))
            print("initials")
            var result: [RunSessionEntryV2] = []
            if let d = UserDefaults.standard.data(forKey: "runs") {
                if let decoded = try? JSONDecoder().decode([RunSessionEntryV2].self, from: d) {
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
            print("i did arrive at savings")
        } catch {
            print("some err occured")
        }
    }
    
    func stopRecording() {
        //print("did stop")
        manager.stopUpdatingLocation()
    }
}
