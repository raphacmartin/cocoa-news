import SwiftUI

extension Color {
    // SwiftUI has a default `secondary` static property, but it doesn't read from the assets catalog, differently from the `accent` property, that does read from the assets catalog ¯\_(ツ)_/¯
    public static let secondary = Color(uiColor: UIColor.secondary)
}
