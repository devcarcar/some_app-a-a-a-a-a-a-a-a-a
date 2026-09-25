import SwiftUI

struct HistoricalSessionView: View {
    var rt: RunTracker
    @Binding var sheetState: SheetStates
    @Binding var wid: String
    @Binding var prev_runs: [RunSessionEntryV2]
    @State private var someData: RunSessionEntryV2?
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { sheetState = .home }) {
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
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.systemBackground))
            .zIndex(1)

            ScrollView {
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

                .padding(12)
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(8)
        .presentationDetents([.height(80), .medium])
        .presentationBackgroundInteraction(.enabled)
        .presentationDragIndicator(.visible)
        .onAppear {
            someData = prev_runs.first { $0.id == wid }
        }
    }
}
