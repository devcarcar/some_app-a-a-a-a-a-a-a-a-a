import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    @State private var rt = RunTracker()
    @State private var isSheetOpen: Bool = true
    @State private var whichId: String = ""
    @State private var sheetState: SheetStates = .home
    @State private var prev_runs: [RunSessionEntryV2] = []
    @State private var camera: MapCameraPosition = .automatic
    
    var body: some View {
        ZStack {
            Map(position: $camera) {
                if rt.Clocations.count > 1 {
                    MapPolyline(coordinates: convert(rt.Clocations), contourStyle: .geodesic).stroke(.blue, lineWidth: 5)
                }
                UserAnnotation()
            }.mapControls {
                MapScaleView()
                MapUserLocationButton()
            }
        }.onAppear {
//            UserDefaults.standard.removeObject(forKey: "runs")
//            UserDefaults.standard.removeObject(forKey: "run_models")
            if let d = UserDefaults.standard.data(forKey: "runs"), let decoded = try? JSONDecoder().decode([RunSessionEntryV2].self, from: d) {
                //print(decoded)
                prev_runs = decoded
            }
        }.sheet(isPresented: $isSheetOpen) {
            switch sheetState {
            case .home:
                HomeView(rt: rt, sheetState: $sheetState, pr: $prev_runs, wid: $whichId)
            case .inrunsession:
                InRunSessionView(rt: rt, sheetState: $sheetState)
            case .historicalsession:
                HistoricalSessionView(rt: rt, sheetState: $sheetState, wid: $whichId, prev_runs: $prev_runs)
            case .isstartingsession:
                IsStartingSessionView(rt: rt, sheetState: $sheetState)
            }
            }
        }
    
}
//#Preview {
//    ContentView()
//}
