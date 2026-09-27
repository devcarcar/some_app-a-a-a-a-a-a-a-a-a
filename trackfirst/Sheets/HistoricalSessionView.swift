import SwiftUI

struct HistoricalSessionView: View {
    var rt: RunTracker
    @Binding var sheetState: SheetStates
    @Binding var wid: String
    @Binding var prev_runs: [RunSessionEntryV2]
    @Binding var ir: Bool
    @Binding var el: Double
    @Binding var dr: Double
    @State private var someData: RunSessionEntryV2?
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    ir = false
                    sheetState = .home
                }) {
                    Image(systemName: "arrow.left")
                }
                Spacer()
                VStack {
                    Text("Session, ended \(someData?.end.formatted(.dateTime.year().month().day().hour().minute().second()) ?? "Unavailable")")
                }
                Spacer()
                Button(action: { if someData != nil {
                    let res = appendRunSessionModel(makeModel(someData!))
                    if res.sucessful == false {
                        print(someData)
                        print("SOME SEP")
                        print(makeModel(someData!))
                        print("some sep")
                        print("Some error when trying to save someData")
                    }
                } }) {
                    Image(systemName: "square.and.arrow.down")
                }
                Button(action: {
                    ir.toggle()
                    el = 0
                    print("i did click")
                }) {
                    if ir == true {
                        Image(systemName: "play")
                    } else {
                        Image(systemName: "play.fill")
                    }
                }
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .zIndex(1)

            ScrollView {
                VStack {
                    //
                    VStack(alignment: .leading, spacing: 4) {
                        Text(someData?.destination ?? "Unavailable")
                        HStack {
                            Text("Some scale: \(dr)")
                            Slider(value: $dr, in: 1...60)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
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
        .interactiveDismissDisabled()
        .onAppear {
            someData = prev_runs.first { $0.id == wid }
        }
    }
}
