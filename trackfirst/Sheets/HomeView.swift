import SwiftUI

struct HomeView: View {
    var rt: RunTracker
    @Binding var sheetState: SheetStates
    @Binding var pr: [RunSessionEntryV2]
    @Binding var wid: String
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                Button(action: { sheetState = .isstartingsession }) {
                    Image(systemName: "plus.circle.fill").font(.system(size: 36))
                }
                Button(action: {
                    sheetState = .history
                }) {
                    Image(systemName: "arrow.clockwise.circle.fill").font(.system(size: 36))
                }
            }.padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(.systemBackground))
                .zIndex(1)
            
            ScrollView {
                VStack(alignment: .trailing) {
                    HStack(spacing: 4) {
                        Text("History").font(.system(.title)).fontWeight(.semibold)
                        Image(systemName: "chevron.right")
                        Spacer()
                    }
                    VStack {
                        ForEach(pr, id: \.id) { r in
                            Button(action: {
                                sheetState = .historicalsession
                                wid = r.id
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(r.destination).fontWeight(.semibold)
                                        Text("Ended at \(r.end.formatted(.dateTime.year().month().day().hour().minute().second()))")
                                    }
                                    Spacer()
                                }
                            }.padding(8).frame(maxWidth: .infinity).background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.3)).frame(maxWidth: .infinity))
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(8)
        .presentationDetents([.height(80), .medium])
        .presentationBackgroundInteraction(.enabled)
        .presentationDragIndicator(.visible)
    }
}

