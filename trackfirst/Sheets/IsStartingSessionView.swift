import SwiftUI

struct IsStartingSessionView: View {
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
                VStack(spacing: 8) {
                    Button(action: {
                        print("should start send")
                        rt.start()
                        print("should complete send")
                        sheetState = .inrunsession
                    }) {
                        Text("Run Session")
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, idealHeight: 100)
                    .background(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    Button(action: {
                        print("should start send")
                        rt.start()
                        print("should complete send")
                        sheetState = .inrunsession
                    }) {
                        Text("W I P")
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, idealHeight: 100)
                    .background(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2), lineWidth: 1))
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
