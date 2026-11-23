import UIKit
import WebKit

extension WebViewController {
    func handleExternalNavigation(_ action: WKNavigationAction) -> Bool {
        guard let url = action.request.url, let scheme = url.scheme?.lowercased() else { return false }
        if AppWebsite.handlesAppLink(url) {
            if action.sourceFrame.isMainFrame, action.targetFrame?.isMainFrame != false,
               action.navigationType == .linkActivated || action.targetFrame == nil {
                openAppLink(url)
            }
            return true
        }

        let nativeSchemes = ["metamask", "trust", "trustwallet", "wc", "tg", "vk",
                             "vkauthorize", "steam", "itms-apps", "mailto", "tel"]
        if nativeSchemes.contains(scheme) {
            openNativeApp(url)
            return true
        }

        guard scheme == "https", let parts = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let host = parts.host?.lowercased(), parts.user == nil, parts.password == nil,
              parts.port == nil || parts.port == 443 else { return false }
        let wallets = ["link.trustwallet.com": "trust", "link.metamask.io": "metamask",
                       "metamask.app.link": "metamask"]
        guard let wallet = wallets[host], url.lastPathComponent.lowercased() == "wc",
              parts.queryItems?.contains(where: { $0.name == "uri" && $0.value?.hasPrefix("wc:") == true }) == true
        else { return false }

        UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { [weak self] opened in
            guard !opened else { return }
            var native = URLComponents()
            native.scheme = wallet
            native.host = "wc"
            native.percentEncodedQuery = parts.percentEncodedQuery
            if let fallback = native.url { self?.openNativeApp(fallback) }
        }
        return true
    }

    private func openNativeApp(_ url: URL) {
        UIApplication.shared.open(url) { [weak self] opened in
            guard !opened, let self, self.presentedViewController == nil else { return }
            let alert = UIAlertController(title: "Could not open the app",
                                          message: "Check that the selected app is installed and try again.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}
