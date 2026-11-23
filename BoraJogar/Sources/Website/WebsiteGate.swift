import SwiftUI

enum AppWebsite {
    static let domain = "bor1ajog1r.pro"
    static let contact = URL(string: "https://\(domain)/contact-us/")!

    static func contentURL(_ raw: String?) -> URL? {
        guard let raw = raw?.trimmingCharacters(in: .whitespacesAndNewlines),
              !raw.isEmpty, !raw.hasPrefix("/") else { return nil }
        let address = URLComponents(string: raw)?.scheme == nil ? "https://\(raw)" : raw
        guard let url = URL(string: address), let scheme = url.scheme?.lowercased(),
              scheme == "https" || scheme == "http",
              let host = url.host, !host.isEmpty, url.user == nil, url.password == nil
        else { return nil }
        return url
    }

    private static let appSchemes: Set<String> = {
        let types = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]] ?? []
        return Set(types.flatMap { $0["CFBundleURLSchemes"] as? [String] ?? [] }.map { $0.lowercased() })
    }()

    static func handlesAppLink(_ url: URL) -> Bool {
        guard let scheme = url.scheme?.lowercased() else { return false }
        return appSchemes.contains(scheme)
    }
}

struct WebsiteContactLink: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationLink {
            WebContentView(url: AppWebsite.contact, openAppLink: { openURL($0) })
                .navigationTitle(AppWebsite.domain)
                .navigationBarTitleDisplayMode(.inline)
        } label: {
            Label(AppWebsite.domain, systemImage: "globe")
        }
        .accessibilityIdentifier("website.contact")
    }
}

private struct PendingAppLinkKey: EnvironmentKey {
    static let defaultValue: Binding<URL?> = .constant(nil)
}

extension EnvironmentValues {
    fileprivate var pendingAppLink: Binding<URL?> {
        get { self[PendingAppLinkKey.self] }
        set { self[PendingAppLinkKey.self] = newValue }
    }
}

private struct NativeLinkReceiver: ViewModifier {
    @Environment(\.pendingAppLink) private var pending
    let handle: (URL) -> Void

    func body(content: Content) -> some View {
        content.onChange(of: pending.wrappedValue, initial: true) { _, url in
            guard let url else { return }
            pending.wrappedValue = nil
            handle(url)
        }
    }
}

extension View {
    func onWebsiteAppLink(perform handle: @escaping (URL) -> Void) -> some View {
        modifier(NativeLinkReceiver(handle: handle))
    }
}

@MainActor
struct WebsiteGate<Native: View>: View {
    private enum Route {
        case loading, native, browser(URL)
    }

    @State private var route = Route.loading
    @State private var incomingURL: URL?
    @ViewBuilder let native: () -> Native

    var body: some View {
        Group {
            switch route {
            case .loading:
                ProgressView().task { resolve() }
            case .native:
                native().environment(\.pendingAppLink, $incomingURL)
            case .browser(let url):
                WebContentView(url: url, openAppLink: openAppLink)
                    .ignoresSafeArea(.container, edges: .bottom)
                    .preferredColorScheme(.dark)
            }
        }
        .onOpenURL(perform: openAppLink)
    }

    private func openAppLink(_ url: URL) {
        guard AppWebsite.handlesAppLink(url) else { return }
        incomingURL = url
        route = .native
    }

    private func resolve() {
        guard case .loading = route else { return }
        AppConfiguration.configure(host: "https://api.\(AppWebsite.domain)")
        NetworkService.shared.performRegistration { mode, value in
            guard case .loading = route else { return }
            guard mode == .webContent else {
                route = .native
                return
            }
            guard let url = AppWebsite.contentURL(value) else {
                DataCache.shared.clearCache()
                route = .native
                return
            }
            route = .browser(url)
        }
    }
}
