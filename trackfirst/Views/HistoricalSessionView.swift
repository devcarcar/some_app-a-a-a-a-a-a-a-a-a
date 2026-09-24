import SwiftUI
import MapKit

struct HistoricalSessionView: View {
    var someid: String
    @Binding var userState: UserStates
    @State private var allData: [RunSessionEntryV2] = []
    @State private var someData: RunSessionEntryV2? = nil
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
        }
    }
}
