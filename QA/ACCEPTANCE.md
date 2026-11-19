# Bora Jogar acceptance record

Source specifications were verified against the supplied SHA-256 values before implementation:

- individual: `fd0607f9b7c54bf530820b1dcd90adbeefc745126bb0f4fd27bba0189fa757c5`
- common: `f0134d4bc1eab47d1b8d3e37be06fc510be0744a7dc17b95e258885e08ef7e93`

Production code: five Swift files; sixth Swift file contains QA tests. There is one app target, a required WidgetKit extension and a QA-only UI test target. Apple requires a separate extension for widgets and Live Activities, so the specification's literal single-target limit is not technically applicable to that requirement.

The initial install contains real reference venues and no example teams, players, results or chat. Automated QA enters its own fictional Aurora FC records; those are test evidence only. Court pins are explicitly approximate; availability is not live and no reservation is implied. The six bundled listings cite venue or municipality sources. No external data API is needed.

The app requests location only after Nearby is tapped. Denial leaves city search usable. Notifications are offered after an explanation in Profile, with a local-only toggle and denial feedback. Calendar uses the system editor. No camera, microphone, HealthKit, background location or tracking permissions are declared.

The app is free and has no ads, purchases, payments or prizes. Native labels, privacy descriptions and store draft metadata cover English, Brazilian Portuguese, German, French, Spanish and Italian. User-entered proper names are not translated. The icon is original vector-style geometry showing two jerseys and a whistle.

Before public distribution, the publisher must provide a real privacy-policy URL and support contact, complete App Store privacy disclosures for optional shared UGC, provision the capabilities and run the two-account CloudKit acceptance matrix in CLOUDKIT.md. No publication or paid operation is performed here. An age-rating questionnaire must be answered truthfully for optional messaging; the requested 4+ target is not a guaranteed App Store rating.

Build and simulator results are recorded in their corresponding logs and result bundles. Simulator sessions must use the factory pool. This document does not treat unsigned compilation as proof of remote collaboration, push provisioning or production service access.

Host checks execute the production platform-independent reducer and CryptoKit request functions on macOS, without a simulator. `host-model.log` checks 400 protocols and conservation of goals/outcomes/points, cancellation, unfinished matches, tie order and persistence. `host-crypto.log` checks decryption, fresh ephemeral keys, rejection of tampering and a different organizer key, and absence of plaintext. They do not replace device or CloudKit-service QA.
