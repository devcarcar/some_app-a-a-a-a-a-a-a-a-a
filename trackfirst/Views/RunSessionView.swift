import SwiftUI
import MapKit

struct RunSessionView: View {
    let rt: RunTracker
    @Binding var userState: UserStates
    @State private var camera: MapCameraPosition = .userLocation(fallback: .automatic)
    var body: some View {
            VStack {
                Map(position: $camera) {
                    if rt.Clocations.count > 1 {
                        MapPolyline(coordinates: convert(rt.Clocations), contourStyle: .geodesic).stroke(.blue, lineWidth: 5)
                    }
                    UserAnnotation()
                }.mapControls {
                    MapScaleView()
                    MapUserLocationButton()
                }
            
            }
    }
}
