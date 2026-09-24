import SwiftUI
import CoreLocation

struct ContentView: View {
    var rt = RunTracker()
    @State private var isSheetOpen: Bool = true
  //  @State private var isStartingSession: Bool = false
    @State private var userState: UserStates = .home
    @State private var whichAction: String = ""
    @State private var whichId: String = ""
    @State private var iss2: Bool = true
    @State private var sheetState: SheetStates = .home
    @State private var prev_runs: [RunSessionEntryV2] = []
    //@State private var someData: RunSessionEntryV2? = nil
    
    
    var body: some View {
        ZStack {
            switch (userState) {
            case .home:
                HomeView(rt: rt, userState: $userState, ss: $sheetState, iss2: $iss2)
            case .inrunsession:
                RunSessionView(rt: rt, userState: $userState)
            case .history:
                HistoryView(rt: rt, userState: $userState, ss: $sheetState, iss2: $iss2)
            case .historicalsession(let someid):
                HistoricalSessionView(someid: someid, userState: $userState)
            }
        }.onAppear {
            if let d = UserDefaults.standard.data(forKey: "runs"), let decoded = try? JSONDecoder().decode([RunSessionEntryV2].self, from: d) {
                prev_runs = decoded
            }
        }.sheet(isPresented: $isSheetOpen) {
            switch sheetState {
            case .home:
               ZStack(alignment: .center) {
                   HStack {
                       Spacer()
                       Button(action: { sheetState = .isstartingsession }) {
                           Image(systemName: "plus.circle.fill").font(.system(size: 36))
                       }
                       Button(action: {
                           userState = .history
                           sheetState = .history
                       }) {
                           Image(systemName: "arrow.clockwise.circle.fill").font(.system(size: 36))
                       }
                   }.frame(maxWidth: .infinity)
                   //                Rectangle().fill(Color.black).frame(maxWidth: .infinity, maxHeight: 1)
               }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(8).presentationDetents([.fraction(0.08), .medium]).presentationBackgroundInteraction(.enabled)
            case .inrunsession:
                ZStack(alignment: .center) {
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
                                userState = .home
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
                ZStack(alignment: .center) {
                    VStack {
                        ForEach(prev_runs, id: \.id) { run in
                            Button(action: {
                                userState = .historicalsession(id: run.id)
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
                ZStack {
                    VStack {
                        HStack {
                            Button(action: { userState = .home }) {
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
                ZStack(alignment: .top) {
                    VStack(spacing: 8) {
                               HStack {
                                   Button(action: {sheetState = .home}) {
                                       Image(systemName: "xmark")
                                   }
                                   Spacer()
                                   VStack {
                                       Text("New Session").font(.title).foregroundStyle(Color.black)
                                       Text("Start a new session").font(.caption2).foregroundStyle(Color.gray.opacity(0.5))
                                   }
                                   Spacer()
                                   Button(action: {}) {
                                       Image(systemName: "checkmark")
                                   }
                               }
                               Button(action: {
                                   print("should start send")
                                   rt.start()
                                   print("should complete send")
                                   sheetState = .inrunsession
                                   userState = .inrunsession
                               }) {
                                   Text("Run Session")
                                   Spacer()
                                   Image(systemName: "arrow.right")
                               }.frame(maxHeight: .infinity).padding().background(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                               
                               Button(action: {}) {
                                   Text("W I P")
                                   Spacer()
                                   Image(systemName: "arrow.right")
                               }.frame(maxHeight: .infinity).padding().background(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    }.padding(.top, 12).padding(.horizontal, 24)
                }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(8).presentationDetents([.fraction(0.08), .medium]).presentationBackgroundInteraction(.enabled)
            }
        }
        }
    
}
//#Preview {
//    ContentView()
//}
