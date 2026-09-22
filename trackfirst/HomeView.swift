import SwiftUI
func dist(_ p1: LocationEntry, _ p2: LocationEntry) -> Double {
    let lat1 = p1.latitude * Double.pi / 180, lon1 = p1.longitude * Double.pi / 180
    let lat2 = p2.latitude * Double.pi / 180, lon2 = p2.longitude * Double.pi / 180
    let dlat = lat2 - lat1
    let dlon = lon2 - lon1
    let a = sin(dlat/2)*sin(dlat/2) + cos(lat1) * cos(lat2) * sin(dlon/2) * sin(dlon/2)
    return 2 * 6_371_000.0 * atan2(sqrt(a), sqrt(1-a))
}
struct HomeView: View {
    let rt: RunTracker
    @State private var prev_runs: [RunSessionEntry] = []
    @Binding var userState: UserStates
    @Binding var iss: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 4) {
                Text("t").padding(4).background(Color.black).foregroundStyle(Color.white)
                Text("trackfirst")
                Spacer()
                Button(action: {iss = true}) {
                    Image(systemName: "plus")
                }
            }
            VStack(spacing: 8) {
                Text("History")
                ForEach(prev_runs, id: \.id) { prev_run in
                    Button(action: { userState = UserStates.historicalsession(id: prev_run.id) }) {
                        Text(prev_run.startedAt.formatted((.dateTime.year().month().day().hour().minute().second())))
                    }
                }
            }
        }.frame(maxHeight: .infinity, alignment: .top).padding(16).onAppear {
            if let d = UserDefaults.standard.data(forKey: "runs"), let decoded = try? JSONDecoder().decode([RunSessionEntry].self, from: d) {
                prev_runs = decoded
            }
        }
    }
}
