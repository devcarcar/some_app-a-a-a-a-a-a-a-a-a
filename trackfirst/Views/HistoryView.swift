import SwiftUI
import MapKit

struct HistoryView: View {
    let rt: RunTracker
    @State private var prev_runs: [RunSessionEntryV2] = []
    @Binding var userState: UserStates
    @Binding var ss: SheetStates
    @Binding var iss2: Bool
    @State private var camera: MapCameraPosition = .automatic
    // @State private var camera: MapCameraPosition = .automatic
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(position: $camera) {
                UserAnnotation()
            }.mapControls {
                MapScaleView()
                MapUserLocationButton()
            }
            // END OF VSTACK
        }
    }
}
