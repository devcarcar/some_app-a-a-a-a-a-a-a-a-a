import SwiftUI
import MapKit

struct HomeView: View {
    let rt: RunTracker
    @State private var prev_runs: [RunSessionEntryV2] = []
    @Binding var userState: UserStates
    @Binding var ss: SheetStates
    @Binding var iss2: Bool
    @State private var camera: MapCameraPosition = .automatic
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(position: $camera) {
                UserAnnotation()
            }.mapControls {
                MapScaleView()
                MapUserLocationButton()
            }
            // END OF VSTACK
        }.frame(maxHeight: .infinity, alignment: .top).onAppear {
            if let d = UserDefaults.standard.data(forKey: "runs"), let decoded = try? JSONDecoder().decode([RunSessionEntryV2].self, from: d) {
                prev_runs = decoded
            }
        }.onAppear {
           let k = getAllRunSessionEntry()
            let g = getAllRunSessionModel()
            print(k.data)
            print(g.data)
//            UserDefaults.standard.removeObject(forKey: "runs")
//            UserDefaults.standard.removeObject(forKey: "run_models")
        }
    }
}
