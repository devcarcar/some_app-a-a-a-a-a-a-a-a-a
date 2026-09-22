import SwiftUI
import MapKit

// @db: persistent runs stored(completed)
// @ui: find runs history(partial completed)
// @ui: mapview
// @db: define run models
// @db: save checkpoints for run models
// @ui: live map + stats for cur run
// decide later...
struct RunSessionView: View {
    let rt: RunTracker
    @Binding var userState: UserStates
    var body: some View {
            VStack {
                Map() {
                    
                }
                Menu("Use") {
                    Button(action: {rt.whichAction = "road_1"}) {
                        Text("road_1")
                    }
                    Button(action: {rt.whichAction = "crossing_1"}) {
                        Text("crossing_1")
                    }
                    Button(action: {rt.whichAction = "road_2"}) {
                        Text("road_2")
                    }
                }
                Button(action: {rt.checkpoint.append(Date())}) {
                    Text("Checkpoint")
                }
                Text("Checkpoints: \(rt.checkpoint.count)")
                Button(action: {
                    Task {
                        await rt.saveLocal()
                        userState = .home
                    }
                }) {
                    Text("End this session")
                }
                Text("Started at \(rt.startedAt.formatted())")
            
            }
    }
}
