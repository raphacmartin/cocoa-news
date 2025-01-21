import Foundation

protocol AppMetadataProvider {
    var bundleVersion: Int { get }
}

final class DefaultAppMetadata: AppMetadataProvider {
    var bundleVersion: Int {
        Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0") ?? 0
    }
}
