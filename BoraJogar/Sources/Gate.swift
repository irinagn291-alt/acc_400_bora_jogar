import SwiftUI
import CoreLocation
import EventKit
import EventKitUI
import UIKit
import UserNotifications

@main struct k73:App {
 @UIApplicationDelegateAdaptor(vDelegate.self) var delegate
 @StateObject var s = v73()
 var body:some Scene{WindowGroup{root.environmentObject(s).task{await s.reminders();await s.reconcileLive()}}}
 @MainActor @ViewBuilder private var root: some View {
  #if DEBUG && targetEnvironment(simulator)
  if let screen = BoraCapture.screen {
   n73(capture: screen, store: s).transaction {
    $0.animation = nil
    $0.disablesAnimations = true
   }
  } else {
   n73()
  }
  #else
  n73()
  #endif
 }
}
final class vDelegate:NSObject,UIApplicationDelegate,UNUserNotificationCenterDelegate {
 func application(_ application:UIApplication,didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey:Any]? = nil)->Bool {
  #if DEBUG && targetEnvironment(simulator)
  if BoraCapture.screen != nil {
   UIView.setAnimationsEnabled(false)
   return true
  }
  #endif
  UNUserNotificationCenter.current().delegate = self
  return true
 }
 nonisolated func userNotificationCenter(_ center:UNUserNotificationCenter,willPresent notification:UNNotification) async->UNNotificationPresentationOptions {[.banner,.list,.sound]}
}
struct vCalendar:UIViewControllerRepresentable {
 var game:zM;@Environment(\.dismiss) var dismiss
 func makeCoordinator()->vCalDelegate{vCalDelegate(dismiss)}
 func makeUIViewController(context:Context)->EKEventEditViewController {let c = EKEventEditViewController();let store = EKEventStore();c.eventStore = store;let e = EKEvent(eventStore:store);e.title = game.home+" · "+game.away;e.startDate = game.date;e.endDate = game.date.addingTimeInterval(Double(game.duration)*60);e.location = game.venue;e.notes = zL("Community football organized with Bora Jogar.");c.event = e;c.editViewDelegate = context.coordinator;return c}
 func updateUIViewController(_ c:EKEventEditViewController,context:Context){}
 final class vCalDelegate:NSObject,EKEventEditViewDelegate {var close:DismissAction;init(_ a:DismissAction){close = a};func eventEditViewController(_ controller:EKEventEditViewController,didCompleteWith action:EKEventEditViewAction){close()}}
}
final class vLocation:NSObject,ObservableObject,CLLocationManagerDelegate {
 @Published var point:CLLocation?;@Published var message = ""
 private let service = CLLocationManager()
 override init(){
  super.init()
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  service.delegate = self
  service.desiredAccuracy = kCLLocationAccuracyKilometer
 }
 func start(){
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  switch service.authorizationStatus{case .authorizedWhenInUse,.authorizedAlways:message = "Finding nearby courts…";service.requestLocation();case .notDetermined:service.requestWhenInUseAuthorization();case .denied,.restricted:message = "Location is unavailable. Search by city instead.";@unknown default:message = "Search by city instead."}
 }
 func locationManagerDidChangeAuthorization(_ manager:CLLocationManager){if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {manager.requestLocation()}else if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {message = "Location is unavailable. Search by city instead."}}
 func locationManager(_ manager:CLLocationManager,didUpdateLocations locations:[CLLocation]){point = locations.last;message = "Sorted by approximate distance."}
 func locationManager(_ manager:CLLocationManager,didFailWithError error:Error){message = "Could not find your location. Search by city instead."}
 func distance(_ v:zV,_ here:CLLocation)->Double{CLLocation(latitude:v.lat,longitude:v.lon).distance(from:here)}
}

#if DEBUG && targetEnvironment(simulator)
enum BoraCapture: String, CaseIterable {
 case matchday
 case matchDetails = "match-details"
 case createMatch = "create-match"
 case squad
 case courtDirectory = "court-directory"
 case courtDetails = "court-details"
 case seasonStandings = "season-standings"
 case teamChat = "team-chat"

 static let screen: BoraCapture? = {
  let launch = ProcessInfo.processInfo
  let arguments = launch.arguments
  func value(after flag: String) -> String? {
   guard let index = arguments.firstIndex(of: flag), index + 1 < arguments.count else { return nil }
   return arguments[index + 1]
  }

  if arguments.contains("-ReviewScreen") {
   return value(after: "-ReviewScreen").flatMap(BoraCapture.init(rawValue:))
  }
  let environmentFlag = launch.environment["APPSTORE_SCREENSHOTS"]?.lowercased() ?? ""
  guard arguments.contains("-AppStoreScreenshots") || ["1", "true", "yes"].contains(environmentFlag) else {
   return nil
  }
  let requested = value(after: "-AppStoreScreenshotScreen") ?? launch.environment["APPSTORE_SCREENSHOT_SCREEN"] ?? "0"
  guard let index = Int(requested), BoraCapture.allCases.indices.contains(index) else { return nil }
  return BoraCapture.allCases[index]
 }()

 var tab: Int {
  switch self {
  case .matchday, .matchDetails, .createMatch: return 0
  case .squad: return 1
  case .courtDirectory, .courtDetails: return 2
  case .seasonStandings: return 3
  case .teamChat: return 4
  }
 }

 var usesCourtPath: Bool {
  self == .courtDirectory || self == .courtDetails
 }

 private static let startedAt = Date()

 private static func kickoff(daysFromToday: Int, hour: Int, minute: Int = 0) -> Date {
  let calendar = Calendar.current
  let today = calendar.startOfDay(for: startedAt)
  let day = calendar.date(byAdding: .day, value: daysFromToday, to: today) ?? today
  return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: day) ?? day
 }

 static func demoStore(venues: [zV]) -> zB {
  let rafa = zP(name: "Rafa", number: 9, role: "Forward")
  let bia = zP(name: "Bia", number: 8, role: "Midfield")
  let lu = zP(name: "Lu", number: 4, role: "Defense")
  let nando = zP(name: "Nando", number: 1, role: "Goalkeeper")

  var team = zT(name: "Aurora FC", city: "São Paulo")
  let season = zS(name: "Weekend League", teams: [team.name, "Estrela FC", "Parque United", "Vila Nova"])
  team.players = [rafa, bia, lu, nando]
  team.seasons = [season]
  team.games = [
   zM(home: team.name, away: "Vila Nova", date: kickoff(daysFromToday: 1, hour: 10, minute: 30),
      venue: "CERET", season: season.id, confirmed: true,
      lineup: [rafa.id, bia.id, nando.id], rsvp: ["local": "yes"]),
   zM(home: team.name, away: "Estrela FC", date: kickoff(daysFromToday: -7, hour: 16),
      venue: "Parque Ibirapuera", season: season.id, confirmed: true, done: true, hg: 3, ag: 1,
      lineup: [rafa.id, bia.id], events: [
       zE(player: rafa.id, assist: bia.id, minute: 12),
       zE(player: bia.id, assist: lu.id, minute: 31),
       zE(player: rafa.id, minute: 47)
      ]),
   zM(home: team.name, away: "Parque United", date: kickoff(daysFromToday: -14, hour: 16),
      venue: "CERET", season: season.id, confirmed: true, done: true, hg: 2, ag: 2,
      lineup: [rafa.id, bia.id])
  ]

  let profile = "Alex"
  team.chat = [
   zC(author: profile, user: "local", text: "Meet by the CERET gate at 10:10.",
      date: startedAt.addingTimeInterval(-3600), state: "approved"),
   zC(author: profile, user: "local", text: "Bring both shirt colors on Sunday.",
      date: startedAt.addingTimeInterval(-1800))
  ]
  return zB(teams: [team], opponents: [zP(name: "Vila Nova"), zP(name: "Estrela FC")],
            venues: venues, selected: team.id, profile: profile)
 }

 static func matchDraft(team: zT?, data: zB) -> zM? {
  guard let team, let season = team.seasons.last,
        let opponent = data.opponents.first(where: { $0.name == "Estrela FC" }),
        let court = data.venues.first(where: { $0.id == "ibirapuera" }),
        let saturday = Calendar.current.nextDate(
         after: startedAt, matching: DateComponents(hour: 16, minute: 0, second: 0, weekday: 7),
         matchingPolicy: .nextTime
        ) else { return nil }
  return zM(home: team.name, away: opponent.name, date: saturday, venue: court.name,
            season: season.id, confirmed: true)
 }
}
#endif
