import SwiftUI

enum UserStates {
    case home
    case inrunsession
    case history
    case historicalsession(id: String)
}

enum SheetStates {
    case home
    case inrunsession
    case history
    case historicalsession
    case isstartingsession
}

let db_RunSessionEntry = "runs"
let db_RunSessionModel = "run_models"
