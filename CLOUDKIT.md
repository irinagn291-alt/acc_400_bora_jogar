# CloudKit setup and collaboration

The app has no custom server and no third-party API keys. Offline features are immediately usable. Cloud collaboration needs an Apple Developer team, registered capabilities and a deployed CloudKit schema. These account-owned resources cannot be created or verified by an unsigned local build.

Identifiers:

- Application: `org.courtyard.borajogar.a73f2`
- Widget extension: `org.courtyard.borajogar.a73f2.touchline`
- Container: `iCloud.org.courtyard.borajogar.a73f2`
- App Group: `group.org.courtyard.borajogar.a73f2`

Enable iCloud/CloudKit, App Groups, Apple sign-in and push capability on the app identifier. Enable the same App Group on the widget identifier. Select your development team in Xcode. No APNs provider or push token registration is used; notifications are local.

## Schema

Create these record types in the CloudKit development environment, then deploy to Production:

| Record type | Fields | Use |
| --- | --- | --- |
| `Squad` | `payload`: Bytes | Team JSON in an organizer-owned private custom zone; read-only CKShare for participants |
| `KeyVault` | `key`: Bytes | Organizer's Curve25519 private key in their private default database, for recovery on another organizer device |
| `Envelope` | `team`: String, `sender`: String, `cipher`: Bytes, `render`: Bytes (optional) | Public transport containing encrypted membership requests, chat, RSVP and reports |

Add QUERYABLE indexes for `Envelope.team` and `Envelope.sender`. Envelope security roles: `_icloud` may CREATE and READ; `_creator` may READ and WRITE; `_world` has no grants. Never grant WRITE to all authenticated users. Public transport is readable only to signed-in iCloud accounts and contains ciphertext. `Squad` and `KeyVault` are used only in private databases; do not grant public read access to them.

`creatorUserRecordID` is checked against the sender before a request is accepted. Profile display names are user chosen and organizer reviewed; Apple sign-in is a profile credential, while CloudKit's account identity is the security authority.

## Moderation and permissions

A team invitation is a real private CKShare link, managed by `UICloudSharingController`. Participants receive read-only access to the approved team root, preventing client-side score or moderation changes from becoming authorized writes. At most 100 people can participate in a share, and each needs iCloud.

Participants encrypt pending requests to the organizer with ephemeral Curve25519, HKDF-SHA256 and AES-GCM using Apple's CryptoKit. Only the organizer's local/private-iCloud key can decrypt these requests. Membership requires explicit approval. RSVP from an approved member is applied when the organizer syncs; it becomes visible to other participants after the organizer publishes the updated root. The interface reports remaining local changes. A participant keeps their local RSVP until its request identifier is acknowledged in the organizer root. Organizer edits made while a network save is in flight remain dirty and are not overwritten. Message render keys are persisted before upload so retries keep an identical reference key.

A chat submission additionally contains an independently encrypted render body. The organizer only publishes its identifier and render key after approval. Pending text is never included in the shared root. Approved membership uses the same author-owned encrypted record pattern: the root contains an opaque record identifier and key, while the participant name and CloudKit identity are resolved from their original record. The decoded render body must match the encrypted moderation preview, CloudKit creator and record identifier. The approved root also pins SHA-256 of the render ciphertext; editing a creator-owned record after approval cannot replace the approved text or profile. The original author owns the transport record, so deleting their profile can remove their message body without needing write access to the team root. Other devices purge it when they next sync. Deleted content can remain in an offline device's cache until that sync; instantaneous cross-device deletion is not promised.

Reports go into the same encrypted organizer review queue and immediately hide the author locally. Organizers can remove content and block CloudKit identities. Remote data is checked on foreground entry or manual Sync, with no continuous connection or background real-time promise. Conflicting organizer edits require choosing the cloud version or this device's version.

## Acceptance still needed on provisioned hardware

Use two different iCloud accounts on real devices: create a team, invite, accept both on a cold launch and while running, request membership, approve, submit RSVP and a message, confirm it remains unpublished before review, approve/reject, report/block, test offline edits and conflict choice, then delete each profile and verify records disappear. Also verify Apple credential revocation, signed App Group widget exchange, all widget families on the Home and Lock Screens, medium-widget RSVP and a real Live Activity with update/cancellation/expiry. An unsigned simulator test does not prove these account-backed flows.

## Primary references checked 2026-11-15

- [CloudKit](https://developer.apple.com/icloud/cloudkit/): private data uses users' iCloud storage; public storage can scale to 1 PB. The app does not promise unlimited storage or a fixed free request quota. Cloud errors preserve local changes.
- [Enable CloudKit](https://developer.apple.com/documentation/cloudkit/enabling-cloudkit-in-your-app)
- [CKShare and participant limits](https://developer.apple.com/documentation/cloudkit/ckshare)
- [Cloud sharing controller and permissions](https://developer.apple.com/documentation/uikit/uicloudsharingcontroller)
- [CloudKit account identity](https://developer.apple.com/documentation/cloudkit/ckcontainer)
- [Live Activities](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities): maximum lifetime is eight hours. The app permits starting during the last 7.9 hours before kickoff, uses a system countdown and a stale date, and ends/updates it on the next foreground entry. The OS can keep stale content on the Lock Screen until dismissal; it does not execute arbitrary app code at kickoff.
- [EventKit migration](https://developer.apple.com/documentation/technotes/tn3152-migrating-to-the-latest-calendar-access-levels): the system event editor on iOS 17+ can save a user-confirmed fixture without reading calendar data or requesting broad calendar access.
- [Widget interaction](https://developer.apple.com/documentation/widgetkit/adding-interactivity-to-widgets-and-live-activities): AppIntent writes a local RSVP request for the app to drain on foreground entry.
