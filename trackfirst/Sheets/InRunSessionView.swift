import SwiftUI

struct InRunSessionView: View {
    var rt: RunTracker
    @Binding var sheetState: SheetStates
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
    }
}
