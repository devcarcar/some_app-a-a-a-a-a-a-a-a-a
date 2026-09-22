import SwiftUI
import CoreLocation
enum UserStates {
    case home
    case inrunsession
    case historicalsession(id: String)
}
struct ContentView: View {
    var rt = RunTracker()
    @State private var isStartingSession: Bool = false
    @State private var userState: UserStates = .home
    @State private var whichAction: String = ""
    @State private var whichId: String = ""
    
    var body: some View {
        ZStack {
            switch (userState) {
            case .home:
                HomeView(rt: rt, userState: $userState, iss: $isStartingSession)
            case .inrunsession:
                RunSessionView(rt: rt, userState: $userState)
            case .historicalsession(let someid):
                HistoricalSessionView(someid: someid, userState: $userState)
            }
        }.sheet(isPresented: $isStartingSession) {
            VStack(spacing: 8) {
                HStack {
                    Button(action: {isStartingSession = false}) {
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
                    isStartingSession = false
                    print("should start send")
                    rt.start()
                    print("should complete send")
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
                .presentationDetents([.height(200)])
        }
           
        }
    
}
//#Preview {
//    ContentView()
//}

