import SwiftUI
import CoreLocation
import MapKit
import Combine

struct ContentView: View {
    @State private var rt = RunTracker()
    @State private var isSheetOpen: Bool = true
    @State private var whichId: String = ""
    @State private var sheetState: SheetStates = .home
    @State private var prev_runs: [RunSessionEntryV2] = []
    @State private var camera: MapCameraPosition = .automatic
    @State private var isReplaying: Bool = false
    @State private var elapsed: Double = 0
    @State private var displayRatio: Double = 1
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Map(position: $camera) {
                if rt.Clocations.count > 1 && sheetState == .inrunsession {
                    MapPolyline(coordinates: convert(rt.Clocations), contourStyle: .geodesic).stroke(.blue, lineWidth: 5)
                }
                if isReplaying {
                    if let k = prev_runs.first { $0.id == whichId }?.coordinates {
                        let g = k.filter { elapsed * displayRatio > ($0.timestamp.timeIntervalSince1970 - k.first!.timestamp.timeIntervalSince1970) }
                        if convert(g).count > 1 {
                            MapPolyline(coordinates: convert(g), contourStyle: .geodesic).stroke(.red, lineWidth: 5)
                        }
                    }
                }
                if sheetState == .historicalsession && whichId != "" && isReplaying == false {
                    MapPolyline(coordinates: convert(prev_runs.first { $0.id == whichId }!.coordinates), contourStyle: .geodesic).stroke(.blue, lineWidth: 5)
                }
                UserAnnotation()
            }.mapControls {
                MapScaleView()
                MapUserLocationButton()
            }
        }.onReceive(timer) { _ in
            if isReplaying {
                elapsed += 1
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
                HistoricalSessionView(rt: rt, sheetState: $sheetState, wid: $whichId, prev_runs: $prev_runs, ir: $isReplaying, el: $elapsed, dr: $displayRatio)
            case .isstartingsession:
                IsStartingSessionView(rt: rt, sheetState: $sheetState)
            }
            }
        }
    
}
//#Preview {
//    ContentView()
//}
