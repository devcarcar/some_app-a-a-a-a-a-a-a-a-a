import SwiftUI

struct HistoricalSessionView: View {
    var someid: String
    @Binding var userState: UserStates
    @State private var allData: [RunSessionEntry] = []
    @State private var someData: RunSessionEntry? = nil
    var body: some View {
        VStack {
            HStack {
                Button(action: { userState = .home }) {
                    Image(systemName: "arrow.left")
                }
                Spacer()
                Text("Session, ended \(someData?.endedAt.formatted(.dateTime.year().month().day().hour().minute().second()) ?? "Unavailable")")
                Spacer()
            }
            VStack(spacing: 4) {
                Text(someData?.destination ?? "Unavailable")
            }
        }.frame(maxHeight: .infinity, alignment: .top).padding(16).onAppear {
            if let d = UserDefaults.standard.data(forKey: "runs"), let decoded = try? JSONDecoder().decode([RunSessionEntry].self, from: d) {
                allData = decoded
                someData = decoded.first { $0.id == someid }
                }
        }
    }
}
