import SwiftUI

func generateRandomId(_ x: Int) -> String {
    return String((0..<x).map { _ in "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".randomElement()! })
}
