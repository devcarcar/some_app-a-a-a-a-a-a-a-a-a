import SwiftUI

struct InRunSessionView: View {
    var rt: RunTracker
    @Binding var sheetState: SheetStates
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    Task {
                        await rt.saveLocal()
                        sheetState = .home
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                }
                Spacer()
                VStack {
                    Text("In Run Session").font(.title).foregroundStyle(Color.black)
                }
                Spacer()
                Button(action: {
                    if rt.Clocations.last != nil {
                        rt.checkpoints.append(rt.Clocations.last!)
                    }
                }) {
                    Image(systemName: "flag.fill").font(.system(size: 18)).foregroundStyle(Color.blue)
                }.background(Circle().fill(Color.blue.opacity(0.3)).frame(width: 32, height: 32)).overlay(alignment: .topTrailing) {
                    Text(rt.checkpoints.count.description).font(.caption2).padding(4).foregroundStyle(Color.white).background(Circle().fill(Color.red)).offset(x: 12, y: -12)
                }.frame(width: 40, height: 40)

            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .zIndex(1)

            ScrollView {
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        Text("View Details").font(.system(.title3)).fontWeight(.semibold)
                        Spacer()
                    }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Session started at \(rt.startedAt.formatted(.dateTime.year().month().day().hour().minute().second()))")
                            Text("Distance travelled: \(rt.distance)m")
                            Text("Points registered: \(rt.Clocations.count)")
                        }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(8)
        .presentationDetents([.height(80), .medium])
        .presentationBackgroundInteraction(.enabled)
        .presentationDragIndicator(.visible)
        .interactiveDismissDisabled()
    }
}
