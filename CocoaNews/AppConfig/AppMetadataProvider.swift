import Foundation

protocol AppMetadataProvider {
    var bundleVersion: Int { get }
    
    static var `default`: AppMetadataProvider { get }
}

extension AppMetadataProvider {
    static var `default`: AppMetadataProvider { DefaultAppMetadata() }
}

final class DefaultAppMetadata: AppMetadataProvider {
    var bundleVersion: Int {
        Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0") ?? 0
    }
}
