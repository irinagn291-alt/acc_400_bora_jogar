import SwiftUI
import MapKit
import UniformTypeIdentifiers
import UserNotifications

let vInk = Color(red:17/255,green:17/255,blue:17/255)
let vFire = Color(red:1,green:107/255,blue:0)
let vPanel = Color(red:0.16,green:0.16,blue:0.16)
struct n73: View {
 @EnvironmentObject var s:v73
 @State var tab = 0
 @State var teamForm = false
 @State var gameForm = false
 @State var focus:zM?
 @State var showSettings = false
 @Environment(\.scenePhase) var phase
 #if DEBUG && targetEnvironment(simulator)
 @State private var courtPath: [zV] = []

 init() {}

 @MainActor init(capture: BoraCapture, store: v73) {
  _tab = State(initialValue: capture.tab)
  _gameForm = State(initialValue: capture == .createMatch)
  if capture == .matchDetails {
   _focus = State(initialValue: store.team.flatMap { Self.nextKickoff(for: $0) })
  }
  if capture == .courtDetails, let ceret = store.b.venues.first(where: { $0.id == "ceret" }) {
   _courtPath = State(initialValue: [ceret])
  }
 }
 #endif

 var body:some View {
  TabView(selection:$tab) {
   NavigationStack { home.navigationTitle("Bora Jogar").toolbar {ToolbarItem(placement:.topBarTrailing){Button{showSettings = true}label:{Image(systemName:"person.crop.circle")}.accessibilityLabel(zL("Profile & privacy"))}} }.tabItem{Label(zL("Matchday"),systemImage:"soccerball")}.tag(0)
   NavigationStack { teamView.navigationTitle(zL("Squad")) }.tabItem{Label(zL("Squad"),systemImage:"person.3.fill")}.tag(1)
   courtsStack.tabItem{Label(zL("Courts"),systemImage:"mappin.and.ellipse")}.tag(2)
   NavigationStack { seasonView.navigationTitle(zL("Season")) }.tabItem{Label(zL("Season"),systemImage:"chart.bar.xaxis")}.tag(3)
   NavigationStack { c73().navigationTitle(zL("Team chat")) }.tabItem{Label(zL("Team chat"),systemImage:"bubble.left.and.bubble.right.fill")}.tag(4)
  }.tint(vFire).preferredColorScheme(.dark)
   .sheet(isPresented:$teamForm){e73()}
   .sheet(isPresented:$gameForm){matchForm}
   .sheet(item:$focus){g73(gameID:$0.id).modifier(vNotice())}
   .sheet(isPresented:$showSettings){p73()}
   .sheet(item:Binding(get:{showSettings ? nil:s.invitation},set:{s.invitation=$0})){BoraLetterPanel(item:$0)}
   .alert(zL("Bora Jogar"),isPresented:Binding(get:{!s.note.isEmpty && !teamForm && !gameForm && focus == nil && !showSettings && s.invitation == nil},set:{if !$0{s.n0()}})){Button(zL("OK")){s.n0()}}message:{Text(s.note)}


   .onOpenURL(perform: openURL)
   .onChange(of:phase){_,p in if p == .active {s.drain();Task{await s.reminders();await s.reconcileLive()}}}
 }
 private func openURL(_ url: URL) {
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  guard url.scheme == "borajogar" else { return }
  if let id = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first(where: { $0.name == "team" })?.value,
     s.b.teams.contains(where: { $0.id == id }) {
   s.b.selected = id
  }
  tab = 0
  s.drain()
 }

 private var seasonView: l73 {
  #if DEBUG && targetEnvironment(simulator)
  if BoraCapture.screen == .seasonStandings, let season = s.team?.seasons.last {
   return l73(initialSeasonID: season.id)
  }
  #endif
  return l73()
 }

 @ViewBuilder private var courtsStack: some View {
  #if DEBUG && targetEnvironment(simulator)
  if BoraCapture.screen?.usesCourtPath == true {
   NavigationStack(path: $courtPath) { f73().navigationTitle(zL("Courts")) }
  } else {
   NavigationStack { f73().navigationTitle(zL("Courts")) }
  }
  #else
  NavigationStack { f73().navigationTitle(zL("Courts")) }
  #endif
 }

 @ViewBuilder private var matchForm: some View {
  #if DEBUG && targetEnvironment(simulator)
  if BoraCapture.screen == .createMatch, let draft = BoraCapture.matchDraft(team: s.team, data: s.b) {
   m73(draft: draft)
  } else {
   m73()
  }
  #else
  m73()
  #endif
 }

 var selector:some View {
  Group {if s.b.teams.count > 1 {Picker(zL("Team"),selection:$s.b.selected){ForEach(s.b.teams){Text($0.name).tag($0.id)}}.onChange(of:s.b.selected){_,_ in s.loadQueue();s.save(false)}}}
 }
 private static func nextKickoff(for team: zT) -> zM? {
  team.games.filter {
   !$0.done && !$0.cancelled && $0.date > Date() && ($0.home == team.name || $0.away == team.name)
  }.sorted { $0.date < $1.date }.first
 }
 var home:some View {
  ScrollView {VStack(alignment:.leading,spacing:22){
   HStack{Text(zL("GET YOUR TEAM TOGETHER")).font(.caption.weight(.heavy)).tracking(2).foregroundStyle(vFire);Spacer();Image(systemName:"figure.soccer").foregroundStyle(vFire)}
   selector
   if let t = s.team {
    HStack(alignment:.top){VStack(alignment:.leading,spacing:5){Text(t.name).font(.largeTitle.bold());Text(t.city).foregroundStyle(.secondary)};Spacer();Text(String(t.players.count)).font(.system(size:42,weight:.black,design:.rounded)).foregroundStyle(vFire)}
    if let g = Self.nextKickoff(for: t) {Button{focus = g}label:{hero(g)}.buttonStyle(.plain)}
    else {VStack(alignment:.leading,spacing:14){Image(systemName:"calendar.badge.plus").font(.largeTitle);Text(zL("The next game starts here.")).font(.title.bold());Text(zL("Choose a court, set kickoff and bring the squad.")).foregroundStyle(.secondary);if s.mine {Button(zL("Create match")){gameForm = true}.buttonStyle(vButton())}}.frame(maxWidth:.infinity,alignment:.leading).padding(24).background(vPanel,in:RoundedRectangle(cornerRadius:24))}
    HStack{metric(String(t.games.filter{$0.done && !$0.cancelled && ($0.home == t.name || $0.away == t.name)}.count),"Played");metric(String(t.players.count),"Players");metric(String(t.games.filter{!$0.done && !$0.cancelled}.count),"Scheduled")}
    HStack{Text(zL("Match calendar")).font(.title2.bold());Spacer();if s.mine {Button{gameForm = true}label:{Image(systemName:"plus.circle.fill").font(.title2)}.accessibilityLabel(zL("Create match"))}}
    if t.games.isEmpty {Text(zL("No matches yet.")).foregroundStyle(.secondary)}
    ForEach(t.games.sorted{$0.date > $1.date}){g in Button{focus = g}label:{HStack(spacing:14){VStack{Text(g.date,format:.dateTime.day()).font(.title2.bold());Text(g.date,format:.dateTime.month(.abbreviated)).font(.caption)}.frame(width:52).padding(.vertical,10).background(vPanel,in:RoundedRectangle(cornerRadius:13));VStack(alignment:.leading,spacing:5){Text(g.home+" · "+g.away).font(.headline);Text(g.venue).font(.caption).foregroundStyle(.secondary);Text(g.cancelled ? zL("Cancelled"):(g.done ? "\(g.hg) : \(g.ag)":g.date.formatted(date:.omitted,time:.shortened))).foregroundStyle(g.cancelled ? .secondary:vFire)};Spacer();Image(systemName:"chevron.right").foregroundStyle(.secondary)}.padding(.vertical,4)}.buttonStyle(.plain)}
    Button(zL("Create another team")){teamForm = true}.font(.footnote)
   } else {
    VStack(alignment:.leading,spacing:18){HStack(spacing:12){Image(systemName:"tshirt.fill").rotationEffect(.degrees(-12));Image(systemName:"tshirt.fill").rotationEffect(.degrees(12))}.font(.system(size:72)).foregroundStyle(vFire).padding(.vertical,24);Text(zL("Less planning.\nMore playing.")).font(.system(size:42,weight:.black,design:.rounded));Text(zL("Your squad, your court, your next match. All in one place, even offline.")).font(.title3).foregroundStyle(.secondary);Button(zL("Create your team")){teamForm = true}.buttonStyle(vButton());Text(zL("Have an invitation? Open the iCloud link from your organizer.")).font(.footnote).foregroundStyle(.secondary)}.padding(25).frame(maxWidth:.infinity,alignment:.leading).background(vPanel,in:RoundedRectangle(cornerRadius:26))
    HStack(alignment:.top){mini("person.3.fill","Build a squad");mini("calendar","Plan a match");mini("chart.bar.fill","Track a season")}
   }

  }.padding(20).frame(maxWidth:1000,alignment:.leading).frame(maxWidth:.infinity)}.background(vInk)
 }
 func mini(_ icon:String,_ text:String)->some View {VStack(alignment:.leading,spacing:10){Image(systemName:icon).foregroundStyle(vFire).font(.title2);Text(zL(text)).font(.subheadline.bold())}.frame(maxWidth:.infinity,alignment:.leading).padding(14)}
 func metric(_ n:String,_ label:String)->some View {VStack(alignment:.leading,spacing:4){Text(n).font(.system(size:30,weight:.heavy,design:.rounded));Text(zL(label)).font(.caption).foregroundStyle(.secondary)}.frame(maxWidth:.infinity,alignment:.leading).padding(16).background(vPanel,in:RoundedRectangle(cornerRadius:17))}
 func hero(_ g:zM)->some View {
  VStack(alignment:.leading,spacing:18){HStack{Text(zL("NEXT KICKOFF")).font(.caption.bold()).tracking(2);Spacer();Image(systemName:"arrow.up.right")};Text(g.date,format:.dateTime.weekday(.wide).day().month(.abbreviated).hour().minute()).font(.title3.bold());HStack(alignment:.center){Text(g.home).font(.system(size:29,weight:.black,design:.rounded));Spacer();Text("×").font(.title);Spacer();Text(g.away).font(.system(size:29,weight:.black,design:.rounded))};Divider().overlay(.black.opacity(0.3));HStack{Label(g.venue,systemImage:"mappin.circle.fill").font(.subheadline);Spacer();Text("\(g.rsvp.values.filter{$0 == "yes"}.count) "+zL("going")).font(.caption.bold())}}.foregroundStyle(.black).padding(24).background(vFire,in:RoundedRectangle(cornerRadius:24))
 }
 var teamView:some View {q73(selector:AnyView(selector))}
}
struct vButton:ButtonStyle {func makeBody(configuration:Configuration)->some View {configuration.label.font(.headline).foregroundStyle(.black).padding(.vertical,15).frame(maxWidth:.infinity).background(vFire.opacity(configuration.isPressed ? 0.75:1),in:RoundedRectangle(cornerRadius:14))}}
struct e73:View {
 @EnvironmentObject var s:v73;@Environment(\.dismiss) var dismiss;@State var name = "";@State var city = "São Paulo"
 var body:some View {NavigationStack{Form{Section(zL("Your team")){TextField(zL("Team name"),text:$name).accessibilityIdentifier("teamName");TextField(zL("City"),text:$city)};Section{Text(zL("You are the organizer. Create matches, approve chat and invite players when you're ready.")).foregroundStyle(.secondary)}}.navigationTitle(zL("Create team")).toolbar{ToolbarItem(placement:.cancellationAction){Button(zL("Cancel")){dismiss()}};ToolbarItem(placement:.confirmationAction){Button(zL("Create")){s.make(name,city);dismiss()}.disabled(name.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty || name.count > 45 || city.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty)}}}}
}
struct m73:View {
 @EnvironmentObject var s:v73;@Environment(\.dismiss) var dismiss
 @State var away = "";@State var home = "";@State var date = Date().addingTimeInterval(86400);@State var duration = 60;@State var court = "";@State var season = "";@State var confirm = false
 #if DEBUG && targetEnvironment(simulator)
 private let hasCaptureDraft: Bool

 init() {
  hasCaptureDraft = false
 }

 init(draft: zM) {
  hasCaptureDraft = true
  _away = State(initialValue: draft.away)
  _home = State(initialValue: draft.home)
  _date = State(initialValue: draft.date)
  _duration = State(initialValue: draft.duration)
  _court = State(initialValue: draft.venue)
  _season = State(initialValue: draft.season)
  _confirm = State(initialValue: draft.confirmed)
 }
 #endif
 private func setFormDefaults() {
  #if DEBUG && targetEnvironment(simulator)
  guard !hasCaptureDraft else { return }
  #endif
  home = s.team?.name ?? ""
  season = s.team?.seasons.last?.id ?? ""
 }
 var body:some View {NavigationStack{Form{
  Section(zL("Fixture")){TextField(zL("Home team"),text:$home);TextField(zL("Opponent"),text:$away).accessibilityIdentifier("opponent");if !s.b.opponents.isEmpty {Picker(zL("Saved opponents"),selection:$away){Text(zL("Choose")).tag("");ForEach(s.b.opponents){Text($0.name).tag($0.name)}}};DatePicker(zL("Kickoff"),selection:$date,in:Date()...);Stepper("\(zL("Minutes")): \(duration)",value:$duration,in:15...180,step:5);Toggle(zL("Opponent confirmed"),isOn:$confirm)}
  Section(zL("Court & season")){Picker(zL("Court"),selection:$court){Text(zL("Choose")).tag("");ForEach(s.b.venues){Text($0.name+" · "+$0.city).tag($0.name)}}.accessibilityIdentifier("courtPicker");Picker(zL("Season"),selection:$season){Text(zL("Friendly match")).tag("");ForEach(s.team?.seasons ?? []){Text($0.name).tag($0.id)}}}
  Section{Text(zL("Court details are an offline directory. Contact the venue yourself to check access; creating a match does not reserve a court.")).font(.footnote).foregroundStyle(.secondary)}
 }.navigationTitle(zL("Create match")).toolbar{ToolbarItem(placement:.cancellationAction){Button(zL("Cancel")){dismiss()}};ToolbarItem(placement:.confirmationAction){Button(zL("Save")){
  let h = home.trimmingCharacters(in:.whitespacesAndNewlines),a = away.trimmingCharacters(in:.whitespacesAndNewlines)
  s.edit {t in t.games.append(zM(home:h,away:a,date:date,duration:duration,venue:court,season:season,confirmed:confirm));if let i = t.seasons.firstIndex(where:{$0.id == season}){for n in [h,a] where !t.seasons[i].teams.contains(n){t.seasons[i].teams.append(n)}}};Task{await s.reminders()};dismiss()
 }.disabled(home.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty || away.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty || home.trimmingCharacters(in:.whitespacesAndNewlines) == away.trimmingCharacters(in:.whitespacesAndNewlines) || court.isEmpty || home.count > 45 || away.count > 45)}}.onAppear(perform: setFormDefaults)}}
}
struct g73:View {
 @EnvironmentObject var s:v73;@Environment(\.dismiss) var dismiss;var gameID:String
 @State var scorer = "";@State var assist = "";@State var minute = 0;@State var calendar = false;@State var cancel = false
 var g:zM? {s.team?.games.first{$0.id == gameID}}
 func patch(_ f:(inout zM)->Void){s.edit{t in if let i = t.games.firstIndex(where:{$0.id == gameID}){f(&t.games[i])}}}
 private func openCalendar() {
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  calendar = true
 }
 @ViewBuilder private func attendancePicker(for game: zM) -> some View {
  let picker = Picker(zL("RSVP"), selection: Binding(
   get: { game.rsvp[s.me] ?? "unknown" },
   set: { s.answer(s.b.selected, game.id, $0) }
  )) {
   Text(zL("No response")).tag("unknown")
   Text(zL("I'm in")).tag("yes")
   Text(zL("Can't play")).tag("no")
   Text(zL("Maybe")).tag("maybe")
  }.pickerStyle(.segmented)

  #if DEBUG && targetEnvironment(simulator)
  if BoraCapture.screen == .matchDetails {
   picker.listRowInsets(EdgeInsets(top: 14, leading: 6, bottom: 14, trailing: 6))
  } else {
   picker
  }
  #else
  picker
  #endif
 }
 var body:some View {NavigationStack{Group{if let g = g {Form{
  Section{HStack{Text(g.home).font(.title2.bold());Spacer();Text("\(g.hg) : \(g.ag)").font(.system(size:40,weight:.black,design:.rounded)).foregroundStyle(vFire);Spacer();Text(g.away).font(.title2.bold())}.padding(.vertical,15);Label(g.date.formatted(date:.complete,time:.shortened),systemImage:"calendar");Label(g.venue,systemImage:"mappin.and.ellipse");if g.cancelled{Text(zL("Cancelled")).foregroundStyle(.red)}}
  if !g.cancelled && !g.done {
   Section(zL("Your attendance")) {
    attendancePicker(for: g)
    Text(zL("Attendance syncs when the app opens. Unsynced responses stay on this device.")).font(.caption).foregroundStyle(.secondary)
   }
   Section{Button{openCalendar()}label:{Label(zL("Add to Calendar"),systemImage:"calendar.badge.plus")};Button{Task{await s.live(g)}}label:{Label(zL("Start kickoff countdown"),systemImage:"timer")};Button{Task{await s.stopLive()}}label:{Label(zL("End countdown"),systemImage:"stop.circle")}}
  }
  Section(zL("Lineup")){ForEach(s.team?.players ?? []){p in HStack{Text("\(p.number)").foregroundStyle(vFire);Text(p.name);Spacer();if s.mine {Toggle(zL("Selected"),isOn:Binding(get:{g.lineup.contains(p.id)},set:{on in patch{m in m.lineup.removeAll{$0 == p.id};if on{m.lineup.append(p.id)}}})).labelsHidden().disabled(g.home != s.team?.name && g.away != s.team?.name)}else if g.lineup.contains(p.id){Image(systemName:"checkmark.circle.fill").foregroundStyle(vFire)};if !p.cloud.isEmpty {Text(zL(g.rsvp[p.cloud] == "yes" ? "Going":g.rsvp[p.cloud] == "no" ? "Unavailable":"No response")).font(.caption).foregroundStyle(.secondary)}}};if s.team?.players.isEmpty == true{Text(zL("Add players in Squad.")).foregroundStyle(.secondary)}}
  if s.mine && !g.cancelled {
   Section(zL("Organizer protocol")){DatePicker(zL("Kickoff"),selection:Binding(get:{g.date},set:{v in patch{$0.date = v};Task{await s.reconcileLive();await s.reminders()}}));Picker(zL("Court"),selection:Binding(get:{g.venue},set:{v in patch{$0.venue = v};Task{await s.reconcileLive()}})){ForEach(s.b.venues){Text($0.name).tag($0.name)}};Toggle(zL("Opponent confirmed"),isOn:Binding(get:{g.confirmed},set:{v in patch{$0.confirmed = v};Task{await s.reminders()}}));Stepper("\(zL("Home goals")): \(g.hg)",value:Binding(get:{g.hg},set:{v in patch{$0.hg = v}}),in:(g.home == s.team?.name ? g.events.count:0)...99);Stepper("\(zL("Away goals")): \(g.ag)",value:Binding(get:{g.ag},set:{v in patch{$0.ag = v}}),in:(g.away == s.team?.name ? g.events.count:0)...99);Toggle(zL("Final score"),isOn:Binding(get:{g.done},set:{v in patch{$0.done = v};if v{Task{await s.stopLive();await s.reminders()}}}));Text(zL("Only final protocols count toward standings. Player goals are recorded separately and must match the team score.")).font(.caption).foregroundStyle(.secondary)}
   Section(zL("Goal log")){
    ForEach(g.events){e in HStack{Text("\(e.minute)′").foregroundStyle(vFire);Text(s.team?.players.first{$0.id == e.player}?.name ?? zL("Removed player"));Spacer();if let p = s.team?.players.first(where:{$0.id == e.assist}){Text(p.name).font(.caption).foregroundStyle(.secondary)};Button(role:.destructive){patch{$0.events.removeAll{$0.id == e.id}}}label:{Image(systemName:"minus.circle")}}}
    Picker(zL("Scorer"),selection:$scorer){Text(zL("Choose")).tag("");ForEach(s.team?.players ?? []){Text($0.name).tag($0.id)}}
    Picker(zL("Assist"),selection:$assist){Text(zL("None")).tag("");ForEach((s.team?.players ?? []).filter{$0.id != scorer}){Text($0.name).tag($0.id)}}
    Stepper("\(zL("Minute")): \(minute)",value:$minute,in:0...g.duration)
    Button(zL("Record goal")){patch{$0.events.append(zE(player:scorer,assist:assist,minute:minute))};scorer = "";assist = ""}.disabled(scorer.isEmpty || scorer == assist || (g.home != s.team?.name && g.away != s.team?.name) || g.events.count >= (g.home == s.team?.name ? g.hg:g.ag))
   }
   Section{Button(zL("Cancel match"),role:.destructive){cancel = true}}
  }
 }.sheet(isPresented:$calendar){vCalendar(game:g)}}else{Text(zL("Match not found."))}}.navigationTitle(zL("Match details")).toolbar{ToolbarItem(placement:.confirmationAction){Button(zL("Done")){dismiss()}}}.confirmationDialog(zL("Cancel this match?"),isPresented:$cancel,titleVisibility:.visible){Button(zL("Cancel match"),role:.destructive){patch{$0.cancelled = true};Task{await s.stopLive();await s.reminders()}}}}}
}
struct q73:View {
 @EnvironmentObject var s:v73;var selector:AnyView
 @State var add = false;@State var opponent = false;@State var name = "";@State var number = 1;@State var role = "Midfield"
 var body:some View {List{
  selector
  if let t = s.team {
   Section{HStack{Image(systemName:"tshirt.fill").font(.largeTitle).foregroundStyle(vFire);VStack(alignment:.leading){Text(t.name).font(.title2.bold());Text(t.city).foregroundStyle(.secondary)};Spacer();Text(zL(s.mine ? "Organizer":"Participant")).font(.caption).foregroundStyle(vFire)}}
   Section(zL("Invitations")){Button(zL("Share a copy")){Task{await s.share()}};if !s.mine{Button(zL("Request a place in the squad")){s.join()}};Text(zL("Choose a file to open, or send a copy directly to someone. Changes stay on this device until you share again.")).font(.footnote)}
   Section(zL("Players")){ForEach(t.players){p in HStack{Text(String(format:"%02d",p.number)).font(.title2.bold()).foregroundStyle(vFire).frame(width:44);VStack(alignment:.leading){Text(p.name).font(.headline);Text(zL(p.role)).font(.caption).foregroundStyle(.secondary)};Spacer();let matches = t.games.filter{$0.done && !$0.cancelled};let goals = matches.flatMap{$0.events}.filter{$0.player == p.id}.count;let assists = matches.flatMap{$0.events}.filter{$0.assist == p.id}.count;VStack(alignment:.trailing){Text("\(goals) "+zL("goals"));Text("\(assists) "+zL("assists")).font(.caption).foregroundStyle(.secondary)};if s.mine && !p.cloud.isEmpty {Menu{Button(zL("Block player"),role:.destructive){s.block(p.cloud)}}label:{Image(systemName:"ellipsis.circle")}}}}.onDelete{idx in if s.mine{s.edit{a in let ids = idx.map{a.players[$0].id};a.players.removeAll{ids.contains($0.id)}}}}
    if s.mine {Button(zL("Add player")){opponent = false;name = "";add = true}}
   }
   Section(zL("Opponents")){ForEach(s.b.opponents){p in Label(p.name,systemImage:"tshirt")}.onDelete{idx in s.b.opponents.remove(atOffsets:idx);s.save(false)};Button(zL("Add opponent")){opponent = true;name = "";add = true};Text(zL("Keep teams you know here, then select them when creating a match. Share invitations through the system sheet.")).font(.caption).foregroundStyle(.secondary)}
  } else{Text(zL("Create a team on Matchday first."))}
 }.scrollContentBackground(.hidden).background(vInk).sheet(isPresented:$add){NavigationStack{Form{TextField(zL("Name"),text:$name);if !opponent{Stepper("\(zL("Shirt number")): \(number)",value:$number,in:1...99);Picker(zL("Position"),selection:$role){ForEach(["Goalkeeper","Defense","Midfield","Forward"],id:\.self){Text(zL($0)).tag($0)}}}}.navigationTitle(zL(opponent ? "Add opponent":"Add player")).toolbar{ToolbarItem(placement:.cancellationAction){Button(zL("Cancel")){add = false}};ToolbarItem(placement:.confirmationAction){Button(zL("Save")){let p = zP(name:name.trimmingCharacters(in:.whitespacesAndNewlines),number:number,role:role);if opponent{s.b.opponents.append(p);s.save(false)}else{s.edit{$0.players.append(p)}};add = false}.disabled(name.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty || name.count > 45)}}}}}
}
struct f73:View {
 @EnvironmentObject var s:v73;@StateObject var loc = vLocation();@State var query = "";@State var add = false;@State var map = false
 var venues:[zV] {let a = s.b.venues.filter{query.isEmpty || ($0.name+" "+$0.city).localizedCaseInsensitiveContains(query)};guard let here = loc.point else{return a};return a.sorted{loc.distance($0,here)<loc.distance($1,here)}}
 @ViewBuilder var body: some View {
  #if DEBUG && targetEnvironment(simulator)
  if BoraCapture.screen?.usesCourtPath == true {
   directory.navigationDestination(for: zV.self) { venue in courtDetails(venue) }
  } else {
   directory
  }
  #else
  directory
  #endif
 }

 private var directory:some View {List{
  Section{Text(zL("A court for every game.")).font(.largeTitle.bold());Text(zL("Offline directory · approximate map pins. Access, opening hours and availability must be confirmed with the venue.")).font(.caption).foregroundStyle(.secondary);HStack{Button{loc.start()}label:{Label(zL("Nearby"),systemImage:"location")};Spacer();Toggle(zL("Map"),isOn:$map).fixedSize()};if !loc.message.isEmpty{Text(zL(loc.message)).font(.caption)}}
  if map {Section{Map{ForEach(venues){v in Marker(v.name,coordinate:CLLocationCoordinate2D(latitude:v.lat,longitude:v.lon)).tint(vFire)}}.frame(height:300);Text(zL("Map tiles need a connection. The court list remains available offline.")).font(.caption).foregroundStyle(.secondary)}}
  Section(zL("Directory")) { ForEach(venues) { courtLink($0) } }
  Button(zL("Add your own court")){add = true}
 }.searchable(text:$query,prompt:zL("Search city or court")).scrollContentBackground(.hidden).background(vInk).sheet(isPresented:$add){vCourtForm()}}

 @ViewBuilder private func courtLink(_ venue: zV) -> some View {
  #if DEBUG && targetEnvironment(simulator)
  if BoraCapture.screen?.usesCourtPath == true {
   NavigationLink(value: venue) { courtRow(venue) }
  } else {
   NavigationLink { courtDetails(venue) } label: { courtRow(venue) }
  }
  #else
  NavigationLink { courtDetails(venue) } label: { courtRow(venue) }
  #endif
 }

 private func courtDetails(_ venue: zV) -> some View {
  vVenue(v: venue, loc: loc)
 }

 private func courtRow(_ venue: zV) -> some View {
  HStack(alignment: .top) {
   Image(systemName: "sportscourt.fill").font(.title2).foregroundStyle(vFire).frame(width: 38)
   VStack(alignment: .leading, spacing: 5) {
    Text(venue.name).font(.headline)
    Text(venue.city).foregroundStyle(.secondary)
    if let point = loc.point {
     Text(loc.distance(venue, point) / 1000, format: .number.precision(.fractionLength(1))) + Text(" km")
    }
   }
  }
 }
}
struct vVenue:View {
 var v:zV;@ObservedObject var loc:vLocation
 var body:some View{List{Section{Image(systemName:"sportscourt.fill").font(.system(size:70)).foregroundStyle(vFire).frame(maxWidth:.infinity).padding(28);Text(v.name).font(.title.bold());Text(v.address);Text(v.city);Text(zL("Approximate location")).font(.caption).foregroundStyle(.secondary)};Section{Button(zL("Open in Maps")){let item = MKMapItem(placemark:MKPlacemark(coordinate:CLLocationCoordinate2D(latitude:v.lat,longitude:v.lon)));item.name = v.name;item.openInMaps()};if let u = URL(string:v.source),u.scheme == "https" {Link(zL("Venue source"),destination:u)};Text(zL("This is a reference listing, not a reservation service. Check the venue before traveling.")).font(.caption).foregroundStyle(.secondary)}}.navigationTitle(zL("Court details"))}
}
struct vCourtForm:View {
 @EnvironmentObject var s:v73;@Environment(\.dismiss) var dismiss;@State var name = "";@State var city = "";@State var address = "";@State var lat = "";@State var lon = ""
 var valid:Bool{guard let a = Double(lat.replacingOccurrences(of:",",with:".")),let b = Double(lon.replacingOccurrences(of:",",with:".")) else{return false};return (-90...90).contains(a) && (-180...180).contains(b) && !name.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty && !city.isEmpty}
 var body:some View{NavigationStack{Form{TextField(zL("Court name"),text:$name);TextField(zL("City"),text:$city);TextField(zL("Address"),text:$address);TextField(zL("Latitude"),text:$lat).keyboardType(.numbersAndPunctuation);TextField(zL("Longitude"),text:$lon).keyboardType(.numbersAndPunctuation);Text(zL("Coordinates are optional to obtain from Maps, but required to place your court accurately in this directory.")).font(.caption)}.navigationTitle(zL("Add court")).toolbar{ToolbarItem(placement:.cancellationAction){Button(zL("Cancel")){dismiss()}};ToolbarItem(placement:.confirmationAction){Button(zL("Save")){s.b.venues.append(zV(name:name,city:city,address:address,lat:Double(lat.replacingOccurrences(of:",",with:"."))!,lon:Double(lon.replacingOccurrences(of:",",with:"."))!,source:"",custom:true));s.save(false);dismiss()}.disabled(!valid)}}}}
}
struct l73:View {
 @EnvironmentObject var s:v73;@State var chosen = "";@State var create = false;@State var name = ""
 #if DEBUG && targetEnvironment(simulator)
 init() {}

 init(initialSeasonID: String) {
  _chosen = State(initialValue: initialSeasonID)
 }
 #endif

 @ViewBuilder private func standings(_ rows: [zRow]) -> some View {
  #if DEBUG && targetEnvironment(simulator)
  if BoraCapture.screen == .seasonStandings {
   ViewThatFits(in: .horizontal) {
    standingsGrid(rows, spacing: 20)
    ScrollView(.horizontal) { standingsGrid(rows, spacing: 6) }
   }
  } else {
   ScrollView(.horizontal) { standingsGrid(rows, spacing: 20) }
  }
  #else
  ScrollView(.horizontal) { standingsGrid(rows, spacing: 20) }
  #endif
 }

 private func standingsGrid(_ rows: [zRow], spacing: CGFloat) -> some View {
  Grid(alignment: .leading, horizontalSpacing: spacing, verticalSpacing: 18) {
   GridRow {
    ForEach(["Team", "P", "W", "D", "L", "GF", "GA", "GD", "Pts"], id: \.self) {
     Text(zL($0)).font(.caption.bold()).foregroundStyle(.secondary)
    }
   }
   ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
    GridRow {
     Text("\(index + 1)  " + row.id).font(.headline).frame(minWidth: 130, alignment: .leading)
     Text("\(row.played)")
     Text("\(row.won)")
     Text("\(row.drawn)")
     Text("\(row.lost)")
     Text("\(row.gf)")
     Text("\(row.ga)")
     Text("\(row.diff)")
     Text("\(row.points)").font(.headline).foregroundStyle(vFire)
    }
   }
  }
  .padding(20)
  .background(vPanel, in: RoundedRectangle(cornerRadius: 20))
 }

 var body:some View{ScrollView{VStack(alignment:.leading,spacing:22){
  if let t = s.team{
   HStack{VStack(alignment:.leading){Text(zL("Every game counts.")).font(.largeTitle.bold());Text(t.name).foregroundStyle(vFire)};Spacer();if s.mine{Button{create = true}label:{Image(systemName:"plus.circle.fill").font(.title)}.accessibilityLabel(zL("Create season"))}}
   if t.seasons.isEmpty{Text(zL("Create a season to group fixtures and build a table from final scores.")).foregroundStyle(.secondary)}else{
    Picker(zL("Season"),selection:$chosen){ForEach(t.seasons){Text($0.name).tag($0.id)}}.pickerStyle(.menu)
    let season = t.seasons.first{$0.id == chosen} ?? t.seasons.last!
    let games = t.games.filter{$0.season == season.id};let rows = zTable(games,season.teams)
    HStack{vStat(n:games.filter{$0.done && !$0.cancelled}.count,label:"Played");vStat(n:games.filter{!$0.done && !$0.cancelled}.count,label:"Scheduled");vStat(n:rows.count,label:"Teams")}
    Text(zL("Standings")).font(.title2.bold());standings(rows)
    Text(zL("3 points for a win, 1 for a draw. Ties: goal difference, goals scored, team name. Cancelled matches do not count.")).font(.caption).foregroundStyle(.secondary)
    Text(zL("Player statistics")).font(.title2.bold());ForEach(t.players){p in let finals = games.filter{$0.done && !$0.cancelled};HStack{Text(p.name);Spacer();VStack(alignment:.trailing){Text("\(finals.filter{$0.lineup.contains(p.id)}.count) "+zL("appearances"));Text("\(finals.flatMap{$0.events}.filter{$0.player == p.id}.count) "+zL("goals")+" · \(finals.flatMap{$0.events}.filter{$0.assist == p.id}.count) "+zL("assists")).foregroundStyle(vFire)}}.padding(.vertical,8)}
   }
  }else{Text(zL("Create a team on Matchday first."))}
 }.padding(22).frame(maxWidth:1100,alignment:.leading).frame(maxWidth:.infinity)}.background(vInk).onAppear{chosen = s.team?.seasons.last?.id ?? ""}.sheet(isPresented:$create){NavigationStack{Form{TextField(zL("Season name"),text:$name);Text(zL("Teams are added to the table when fixtures are created in this season.")).font(.caption)}.navigationTitle(zL("Create season")).toolbar{ToolbarItem(placement:.cancellationAction){Button(zL("Cancel")){create = false}};ToolbarItem(placement:.confirmationAction){Button(zL("Create")){let x = zS(name:name,teams:[s.team?.name ?? ""]);s.edit{$0.seasons.append(x)};chosen = x.id;name = "";create = false}.disabled(name.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty || name.count > 50)}}}}}
}
struct vStat:View{var n:Int;var label:String;var body:some View{VStack(alignment:.leading){Text("\(n)").font(.system(size:32,weight:.black,design:.rounded)).foregroundStyle(vFire);Text(zL(label)).font(.caption)}.frame(maxWidth:.infinity,alignment:.leading).padding(18).background(vPanel,in:RoundedRectangle(cornerRadius:18))}}
struct c73:View {
 @EnvironmentObject var s:v73;@State var text = "";@FocusState var zFocus:Bool
 var body:some View{VStack(spacing:0){List{
  Section{Text(zL("A good game starts with respect.")).font(.title2.bold());Text(zL("Messages appear after organizer approval. No links, personal contacts or abusive content. Reports hide the author immediately on your device.")).font(.caption).foregroundStyle(.secondary);Button(zL("Share a copy")){Task{await s.share()}}.disabled(s.busy)}
  if let t = s.team {
   if s.mine {let pending = t.chat.filter{$0.state == "pending"}+s.inbox;Section(zL("Organizer review")){if pending.isEmpty{Text(zL("Nothing waiting for review.")).foregroundStyle(.secondary)};ForEach(pending){m in VStack(alignment:.leading,spacing:10){Text(m.author).font(.headline);Text(m.state == "join" ? zL("Membership request"):m.state == "report" ? zL("Message report"):m.text);HStack{Button(zL("Approve")){s.review(m.id,true)}.buttonStyle(.borderedProminent);Button(zL("Reject"),role:.destructive){s.review(m.id,false)}.buttonStyle(.bordered)}}}}
   }
   Section(zL("Approved messages")){ForEach(s.visibleChat){m in VStack(alignment:.leading,spacing:9){HStack{Text(m.author).font(.headline).foregroundStyle(vFire);Spacer();Text(m.date,style:.date).font(.caption).foregroundStyle(.secondary)};Text(m.text).textSelection(.enabled);HStack{Button(zL("Report"),role:.destructive){s.report(m)}.buttonStyle(.borderless);Spacer();if s.mine {Button(zL("Block player"),role:.destructive){s.block(m.user)}.buttonStyle(.borderless)}else{Button(zL("Hide author")){s.b.blocked.append(m.user);s.save(false)}.buttonStyle(.borderless)}}.font(.caption)}}}
   if !s.b.outbox.isEmpty{Section{Text("\(s.b.outbox.count) "+zL("requests waiting to sync")).font(.caption).foregroundStyle(vFire)}}
  }
 }.scrollContentBackground(.hidden)
 if s.team != nil {HStack(alignment:.bottom){TextField(zL("Message for review"),text:$text,axis:.vertical).lineLimit(1...4).accessibilityIdentifier("reviewComposer").focused($zFocus).padding(12).background(vPanel,in:RoundedRectangle(cornerRadius:14));Button{if s.post(text){text = "";zFocus = false}}label:{Image(systemName:"arrow.up.circle.fill").font(.largeTitle).foregroundStyle(vFire)}.accessibilityLabel(zL("Send for review")).accessibilityIdentifier("sendReview").disabled(text.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty || text.count > 500)}.padding()}
 }.background(vInk).navigationTitle(zL("Team chat"))}
}
struct vExport:FileDocument {
 static var readableContentTypes:[UTType]{[.json]};var data:Data
 init(_ d:Data){data = d};init(configuration:ReadConfiguration)throws{data = configuration.file.regularFileContents ?? Data()};func fileWrapper(configuration:WriteConfiguration)throws->FileWrapper{FileWrapper(regularFileWithContents:data)}
}
struct p73:View {
 @EnvironmentObject var s:v73;@Environment(\.dismiss) var dismiss;@State var erase = false;@State var export = false;@State var notification = false;@State var privacy = false;@State var pick=false
 private func toggleReminders(_ enabled: Bool) {
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  if enabled {
   notification = true
  } else {
   s.b.notifications = false
   s.save(false)
   Task { await s.reminders(); await s.reconcileLive() }
  }
 }
 var body:some View{NavigationStack{Form{
  Section(zL("Profile")){TextField(zL("Your name"),text:Binding(get:{s.b.profile},set:{v in s.b.profile = String(v.prefix(45));s.save(false)})).accessibilityIdentifier("profileName")}
  Section{Text(zL("Choose a file to open, or send a copy directly to someone. Changes stay on this device until you share again."));Button(zL("Open a shared file")){pick=true};Button(zL("Share a copy")){Task{await s.share()}}.disabled(s.team==nil)}
  Section(zL("Reminders")){Toggle(zL("Match reminders"),isOn:Binding(get:{s.b.notifications},set:toggleReminders));Text(zL("Local reminders for tomorrow's match and newly confirmed opponents. No real-time delivery is promised.")).font(.caption).foregroundStyle(.secondary)}
  Section(zL("Your data")){Button(zL("Export device data")){export = true};Button(zL("Privacy & community rules")){privacy = true};if !s.b.blocked.isEmpty{Button(zL("Unhide authors on this device")){s.b.blocked = [];s.save(false)}};Button(zL("Delete profile & data"),role:.destructive){erase = true}}
  Section{Text(zL("Free, without ads or purchases. Designed for community football.")).font(.footnote).foregroundStyle(.secondary);Text("1.3.2 · 73").font(.caption).foregroundStyle(.secondary)}
 }.navigationTitle(zL("Profile & privacy")).toolbar{ToolbarItem(placement:.confirmationAction){Button(zL("Done")){dismiss()}}}.sheet(item:$s.invitation){BoraLetterPanel(item:$0)}.fileImporter(isPresented:$pick,allowedContentTypes:[.json]){if case let .success(u)=$0{s.acceptFile(u)}}.fileExporter(isPresented:$export,document:vExport((try? JSONEncoder().encode(s.b)) ?? Data()),contentType:.json,defaultFilename:"Bora-Jogar-data"){r in if case .failure(let e) = r{s.note = e.localizedDescription}}.confirmationDialog(zL("Delete profile & data"),isPresented:$erase,titleVisibility:.visible){Button(zL("Delete profile & data"),role:.destructive){Task{await s.erase()}}}.alert(notification ? zL("Match reminders"):zL("Bora Jogar"),isPresented:Binding(get:{!privacy && !export && !erase && (notification || !s.note.isEmpty)},set:{if !$0{if notification{notification = false}else{s.n0()}}})){
   if notification {Button(zL("Enable")){Task{try? await Task.sleep(for:.milliseconds(400));do {s.b.notifications = try await UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound,.badge]);s.save(false);await s.reminders();if !s.b.notifications{s.note = zL("Notifications are disabled. You can enable them in Settings.")}}catch{s.note = error.localizedDescription}}};Button(zL("Cancel"),role:.cancel){}}
   else {Button(zL("OK")){s.n0()}}
  }message:{Text(notification ? zL("Get a reminder the day before kickoff. Your match calendar works if you decline."):s.note)}.sheet(isPresented:$privacy){NavigationStack{ScrollView{VStack(alignment:.leading,spacing:20){Text(zL("Privacy & community rules")).font(.largeTitle.bold());Text(zL("Choose a file to open, or send a copy directly to someone. Changes stay on this device until you share again."));Text(zL("Messages appear after organizer approval. No links, personal contacts or abusive content. Reports hide the author immediately on your device."))}.padding(24)}.toolbar{Button(zL("Done")){privacy=false}}}}}
}

}
struct vNotice:ViewModifier {
 @EnvironmentObject var s:v73
 func body(content:Content)->some View {content.alert(zL("Bora Jogar"),isPresented:Binding(get:{!s.note.isEmpty},set:{if !$0{s.n0()}})){Button(zL("OK")){s.n0()}}message:{Text(s.note)}}
}
