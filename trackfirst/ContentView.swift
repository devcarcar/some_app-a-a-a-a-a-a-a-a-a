import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    var rt = RunTracker()
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
                prev_runs = decoded
            }
        }.sheet(isPresented: $isSheetOpen) {
            switch sheetState {
            case .home:
                HomeView(rt: rt, sheetState: $sheetState, pr: $prev_runs, wid: $whichId)
            case .inrunsession:
                ZStack(alignment: .top) {
                    VStack {
                        Button(action: {
                            print("did reg. click")
                            //  print(rt.Clocations.description) // crash testing
                            if rt.Clocations.last != nil {
                                rt.checkpoints.append(rt.Clocations.last!)
                            } // HANDLE THIS THROW ERROR**@urgent
                        }) {
                            Text("Checkpoint")
                        }
                        Text("Checkpoints: \(rt.checkpoints.count)")
                        Button(action: {
                            Task {
                                await rt.saveLocal()
                                sheetState = .home
                                
                            }
                        }) {
                            Text("End this session")
                        }
                        Text("Started at \(rt.startedAt.formatted())")
                    }.frame(maxWidth: .infinity)
                    //                Rectangle().fill(Color.black).frame(maxWidth: .infinity, maxHeight: 1)
                }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(8).presentationDetents([.fraction(0.08), .medium]).presentationBackgroundInteraction(.enabled)
            case .history:
                ZStack(alignment: .top) {
                    VStack {
                        ForEach(prev_runs, id: \.id) { run in
                            Button(action: {
                                sheetState = .historicalsession
                                whichId = run.id
                            }) {
                                Text("Run, \(run.start.formatted(.dateTime.year().month().day().hour().minute().second())) to \(run.destination)")
                            }
                        }
                    }
                    //                Rectangle().fill(Color.black).frame(maxWidth: .infinity, maxHeight: 1)
                }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(8).presentationDetents([.fraction(0.08), .medium]).presentationBackgroundInteraction(.enabled)
            case .historicalsession:
                let someData: RunSessionEntryV2? = prev_runs.first { $0.id == whichId }
                ZStack(alignment: .top) {
                    VStack {
                        HStack {
                            Button(action: { sheetState = .home }) {
                                Image(systemName: "arrow.left")
                            }
                            Spacer()
                            Text("Session, ended \(someData?.end.formatted(.dateTime.year().month().day().hour().minute().second()) ?? "Unavailable")")
                            Spacer()
                            Button(action: { if someData != nil {
                                let res = appendRunSessionModel(makeModel(someData!))
                                if !res.sucessful {
                                    print(someData)
                                    print("SOME SEP")
                                    print(makeModel(someData!))
                                    print("some sep")
                                    print("Some error when trying to save someData")
                                }
                            } }) {
                                Image(systemName: "square.and.arrow.down")
                            }
                        }
                        VStack(spacing: 4) {
                            Text(someData?.destination ?? "Unavailable")
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(8).presentationDetents([.fraction(0.08), .medium]).presentationBackgroundInteraction(.enabled)
            case .isstartingsession:
                IsStartingSessionView(rt: rt, sheetState: $sheetState)
            }
            }
        }
    
}
//#Preview {
//    ContentView()
//}
