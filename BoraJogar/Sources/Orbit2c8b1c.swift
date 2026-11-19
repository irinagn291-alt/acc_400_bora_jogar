import SwiftUI
import CryptoKit
import Security
import WidgetKit
import UserNotifications
import ActivityKit

func zDigest(_ d:Data)->String {Data(SHA256.hash(data:d)).base64EncodedString()}
func zPinned(_ d:Data,_ hash:String?)->Bool {guard let hash,d.count <= 8192 else{return false};return zDigest(d) == hash}
func zMirror(_ q:zQ,_ body:Data,_ creator:String,_ record:String)->zC? {
 guard q.id == record,body.count <= 8192,let key = Data(base64Encoded:q.item),key.count == 32,
 let box = try? AES.GCM.SealedBox(combined:body),let data = try? AES.GCM.open(box,using:SymmetricKey(data:key)),
 var message = try? JSONDecoder().decode(zC.self,from:data),message.id == q.id,message.user == creator,message.author == q.name,message.text == q.text else{return nil}
 message.digest = zDigest(body);return message
}

@MainActor final class v73: ObservableObject {
 @Published var b:zB
 @Published var note = ""
 @Published var busy = false
 @Published var cloudNote = "Local only"
 @Published var inbox:[zC] = []
 @Published var invitation:BoraLetter?
 @Published var conflict:zT?
 @Published var rendered:[String:zC] = [:]
 var visibleChat:[zC] { (team?.chat ?? []).filter{$0.state == "approved"}.compactMap{m in let x = m.text.isEmpty ? rendered[m.id]:m;guard let x,!b.blocked.contains(x.user),!(team?.blocked.contains(x.user) ?? false) else{return nil};return x}.sorted{$0.date < $1.date} }
 var ticks:[String:Int] = [:]
 init(){
  #if DEBUG && targetEnvironment(simulator)
  if BoraCapture.screen != nil {
   b = BoraCapture.demoStore(venues: Self.bundledCourts())
   return
  }
  #endif
  if let d = zDisk.read("club.json",zB.self) { b = d }
  else if let d = zDisk.read("club-backup.json",zB.self) { b = d; note = zL("Recovered the last local backup.") }
  else { b = zB(); if FileManager.default.fileExists(atPath:zDisk.url.appendingPathComponent("club.json").path){ note = zL("Local data could not be read. Keep a copy before deleting the app.") } }
  if b.venues.isEmpty { b.venues = Self.bundledCourts() }
  b.apple="";b.cloudOn=false;rendered=zDisk.read("chat-cache.json",[String:zC].self) ?? [:];loadQueue();drain();glance()
 }
 private static func bundledCourts() -> [zV] {
  guard let url = Bundle.main.url(forResource: "courts", withExtension: "json"),
        let data = try? Data(contentsOf: url) else { return [] }
  return (try? JSONDecoder().decode([zV].self, from: data)) ?? []
 }
 var team:zT? { b.teams.first { $0.id == b.selected } }
 var mine:Bool { guard let t = team else{return false}; return b.shared[t.id] == nil && (t.owner.isEmpty || t.owner == b.cloudUser) }
 var me:String { b.cloudUser.isEmpty ? "local":b.cloudUser }
 func save(_ dirty:Bool = true){
  if dirty, let id = team?.id, mine, !b.dirty.contains(id) { b.dirty.append(id) }
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  do { if let old = try? Data(contentsOf:zDisk.url.appendingPathComponent("club.json")){ try old.write(to:zDisk.url.appendingPathComponent("club-backup.json"),options:.atomic) }; try zDisk.write(b,"club.json"); glance() } catch { note = zL("Could not save on this device.")+" "+error.localizedDescription }
 }
 func edit(_ f:(inout zT)->Void){ guard mine, let i = b.teams.firstIndex(where:{$0.id == b.selected}) else {note = zL("Only the organizer can change this.");return}; f(&b.teams[i]);ticks[b.teams[i].id,default:0] += 1; save() }
 func make(_ name:String,_ city:String){ let t = zT(name:name.trimmingCharacters(in:.whitespacesAndNewlines),city:city,owner:b.cloudUser); b.teams.append(t); b.selected = t.id; save() }
 func glance(){
  var w = zW(); if let t = team {
   w.name = t.name; w.team = t.id; let all = t.games.filter{!$0.cancelled};let g = all.filter{$0.home == t.name || $0.away == t.name}
   w.next = g.filter{ !$0.done && $0.date > Date() }.min{$0.date < $1.date}; w.last = g.filter{$0.done}.max{$0.date < $1.date}
   let s = t.seasons.last; let games = all.filter{s == nil || $0.season == s?.id}; w.rows = zTable(games,s?.teams ?? [t.name]); w.played = w.rows.first{$0.id == t.name}?.played ?? 0; w.wins = w.rows.first{$0.id == t.name}?.won ?? 0; w.answer = w.next?.rsvp[me] ?? ""
  }; try? zDisk.write(w,"glance.json"); WidgetCenter.shared.reloadAllTimelines()
 }
 func drain(){
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  let urls = (try? FileManager.default.contentsOfDirectory(at:zDisk.url,includingPropertiesForKeys:nil)) ?? []
  for u in urls where u.lastPathComponent.hasPrefix("tap-") {
   if let d = try? Data(contentsOf:u), let q = try? JSONDecoder().decode(zQ.self,from:d) { answer(q.team,q.item,q.text); try? FileManager.default.removeItem(at:u) }
  }
 }
 func answer(_ tid:String,_ mid:String,_ value:String){
  guard let i = b.teams.firstIndex(where:{$0.id == tid}), let j = b.teams[i].games.firstIndex(where:{$0.id == mid}), !b.teams[i].games[j].done, !b.teams[i].games[j].cancelled else{return}
  let attendee = me;b.teams[i].games[j].rsvp[attendee] = value;ticks[tid,default:0] += 1
  if b.shared[tid] != nil { b.outbox.removeAll{$0.team == tid && $0.item == mid && $0.kind == "rsvp"}; b.outbox.append(zQ(team:tid,kind:"rsvp",text:value,item:mid,name:b.profile)) }
  else if !b.dirty.contains(tid) {b.dirty.append(tid)};save(false)
 }
 func n0(){DispatchQueue.main.async{[weak self] in self?.note = ""}}
 func post(_ text:String)->Bool {
  let t = text.trimmingCharacters(in:.whitespacesAndNewlines)
  guard !t.isEmpty, t.count <= 500, !b.profile.isEmpty else{note = zL("Add a profile name first.");return false}
  guard !t.contains("://"), !t.contains("www."), !t.contains("@") else {note = zL("Links and contact details are not allowed in chat.");return false}
  guard let a = team else{return false}
  guard !a.blocked.contains(me) else{note = zL("Your participation is blocked by the organizer.");return false}
  if b.shared[a.id] != nil {
   b.outbox.append(zQ(team:a.id,kind:"chat",text:t,item:"",name:b.profile)); save(false); note = zL("Queued for organizer review. Open sync to send.")
  } else {let author = b.profile;let identity = me;edit{$0.chat.append(zC(author:author,user:identity,text:t))};note = zL("Pending organizer review.")}
  return true
 }
 func review(_ id:String,_ allow:Bool){
  defer{persistQueue()}
  if let m = inbox.first(where:{$0.id == id}) {
   edit { a in
    a.handled.append(id)
    if allow && !a.blocked.contains(m.user) {
     if m.state == "join" {if !a.players.contains(where:{$0.cloud == m.user}) {a.players.append(zP(name:m.author,cloud:m.user,reference:m.id,secret:m.reason,digest:m.digest))}}
     else if m.state == "report" {if let j = a.chat.firstIndex(where:{$0.id == m.reason}) {a.chat[j].state = "removed"}}
     else{var x=m;x.state="approved";a.chat.append(x)}
    }
   };inbox.removeAll{$0.id == id}
  } else {edit { a in if let j = a.chat.firstIndex(where:{$0.id == id}){a.chat[j].state = allow ? "approved":"removed"} }}
 }
 func block(_ id:String){ edit{ if !$0.blocked.contains(id){$0.blocked.append(id)}; $0.chat.removeAll{$0.user == id} }; b.blocked.append(id); save(false) }
 func report(_ m:zC){
  guard let t = team else{return}; b.blocked.append(m.user)
  if mine { edit { if let j = $0.chat.firstIndex(where:{$0.id == m.id}){$0.chat[j].state = "removed"} } }
  else { b.outbox.append(zQ(team:t.id,kind:"report",text:"Message reported",item:m.id,name:b.profile)); save(false) }
  note = zL("Report saved for the organizer. This author is hidden on your device.")
 }
 func loadQueue(){
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  inbox=zDisk.read("inbox-"+b.selected+".json",[zC].self) ?? []
 }
 func persistQueue(){
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  guard UUID(uuidString:b.selected) != nil else{return};do{try zDisk.write(inbox,"inbox-"+b.selected+".json")}catch{note=error.localizedDescription}
 }
 func share() async {
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  guard var t=team else{return}
  do{
   let url:URL
   if mine {t.chat=visibleChat;t.handled=[];t.key="";for i in t.players.indices{t.players[i].secret=nil;t.players[i].digest=nil};url=try MatchEnvelope.export(t,group:t.id,kind:"host")}
   else{url=try MatchEnvelope.export(b.outbox.filter{$0.team==t.id},group:t.id,kind:"guest")}
   invitation=BoraLetter(url:url)
  }catch{note=error.localizedDescription}
 }
 func acceptFile(_ u:URL){
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  do{
   let (packet,sender)=try MatchEnvelope.open(u);let cache="bora.received."+packet.group+"."+sender
   guard packet.version>UserDefaults.standard.integer(forKey:cache) else{return}
   if packet.kind=="host"{
    var t=try JSONDecoder().decode(zT.self,from:packet.body)
    guard t.id==packet.group,!t.name.isEmpty,t.name.count<=100,t.players.count<=2000,t.games.count<=5000,t.chat.count<=5000,Set(t.players.map(\.id)).count==t.players.count,Set(t.games.map(\.id)).count==t.games.count,
     t.games.allSatisfy({(0...999).contains($0.hg) && (0...999).contains($0.ag) && (1...1440).contains($0.duration)}) else{throw CocoaError(.fileReadCorruptFile)}
    t.owner=sender;t.chat=t.chat.filter{$0.state=="approved"};t.handled=[];t.key=""
    if let i=b.teams.firstIndex(where:{$0.id==t.id}){guard b.shared[t.id]==sender else{throw CocoaError(.fileReadNoPermission)};b.teams[i]=t}else{b.teams.append(t)}
    b.shared[t.id]=sender;b.selected=t.id;loadQueue()
   }else{
    guard let i=b.teams.firstIndex(where:{$0.id==packet.group}),b.shared[packet.group]==nil,!b.teams[i].blocked.contains(sender) else{throw CocoaError(.fileReadNoPermission)}
    let requests=try JSONDecoder().decode([zQ].self,from:packet.body);guard requests.count<=5000 else{throw CocoaError(.fileReadTooLarge)}
    b.selected=packet.group;loadQueue()
    for r in requests where r.team==packet.group && r.name.count<=45 && r.text.count<=500{
     let id=sender+"/"+r.id;guard !b.teams[i].handled.contains(id),!inbox.contains(where:{$0.id==id}) else{continue}
     if r.kind=="rsvp",["yes","no","maybe","Yes","No","Maybe","going","out"].contains(r.text),let j=b.teams[i].games.firstIndex(where:{$0.id==r.item && !$0.done && !$0.cancelled}){b.teams[i].games[j].rsvp[sender]=r.text;continue}
     guard ["chat","report","join"].contains(r.kind),!r.name.isEmpty,!r.text.contains("://"),!r.text.contains("@"),!r.text.lowercased().contains("www.") else{continue}
     inbox.append(zC(id:id,author:r.name,user:sender,text:r.text,state:r.kind=="chat" ? "pending":r.kind,reason:r.item))
    }
    persistQueue()
   }
   save(false);if note.isEmpty{UserDefaults.standard.set(packet.version,forKey:cache)}
  }catch{note=error.localizedDescription}
 }
 func join(){ guard let t = team else{return};guard !b.profile.isEmpty else{note = zL("Add a profile name first.");return};b.outbox.append(zQ(team:t.id,kind:"join",text:"",item:"",name:b.profile));save(false) }
 func erase() async {
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  guard !busy else{return};busy = true;defer{busy = false}
   for t in b.teams {let q:[String:Any] = [kSecClass as String:kSecClassGenericPassword,kSecAttrService as String:"BoraOrganizer73",kSecAttrAccount as String:t.id];SecItemDelete(q as CFDictionary)}
   b = zB();if let u = Bundle.main.url(forResource:"courts",withExtension:"json"),let data = try? Data(contentsOf:u),let venues = try? JSONDecoder().decode([zV].self,from:data){b.venues = venues};inbox = [];rendered = [:];try? FileManager.default.removeItem(at:zDisk.url.appendingPathComponent("chat-cache.json"));save(false);try? FileManager.default.removeItem(at:zDisk.url.appendingPathComponent("club-backup.json"));UNUserNotificationCenter.current().removeAllPendingNotificationRequests();for key in UserDefaults.standard.dictionaryRepresentation().keys where key.hasPrefix("noticed-"){UserDefaults.standard.removeObject(forKey:key)};for a in Activity<zA>.activities {await a.end(nil,dismissalPolicy:.immediate)};note = zL("Profile and device data deleted.")
  for u in (try? FileManager.default.contentsOfDirectory(at:zDisk.url,includingPropertiesForKeys:nil)) ?? [] where u.lastPathComponent.hasPrefix("inbox-"){try? FileManager.default.removeItem(at:u)}
 }
 func reminders() async {
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  let center = UNUserNotificationCenter.current(); center.removeAllPendingNotificationRequests()
  guard b.notifications else{return}
  let settings = await center.notificationSettings();guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else{return}
  let games = b.teams.flatMap{$0.games}.filter{!$0.done && !$0.cancelled && $0.date > Date()}.sorted{$0.date < $1.date}
  for g in games.prefix(24) {
   let date = g.date.addingTimeInterval(-86400)
   if date > Date(){let content = UNMutableNotificationContent();content.title = zL("Match tomorrow");content.body = g.home+" · "+g.away;content.sound = .default;try? await center.add(UNNotificationRequest(identifier:"tomorrow-"+g.id,content:content,trigger:UNTimeIntervalNotificationTrigger(timeInterval:date.timeIntervalSinceNow,repeats:false)))}
   let flag = "noticed-"+g.id
   if g.confirmed && !UserDefaults.standard.bool(forKey:flag) {let content = UNMutableNotificationContent();content.title = zL("Opponent confirmed");content.body = g.home+" · "+g.away;try? await center.add(UNNotificationRequest(identifier:flag,content:content,trigger:nil));UserDefaults.standard.set(true,forKey:flag)}
  }
 }
 func live(_ g:zM) async {
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  guard g.date > Date(),g.date.timeIntervalSinceNow <= 7.9*3600 else{note = zL("Start the countdown within 8 hours of kickoff.");return}
  guard ActivityAuthorizationInfo().areActivitiesEnabled else{note = zL("Live Activities are disabled in Settings.");return}
  for a in Activity<zA>.activities {await a.end(nil,dismissalPolicy:.immediate)}
  do { _ = try Activity.request(attributes:zA(team:g.home,game:g.id),content:ActivityContent(state:zA.ContentState(date:g.date,opponent:g.away,venue:g.venue),staleDate:g.date),pushType:nil) }catch{note = error.localizedDescription}
 }
 func reconcileLive() async {
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  for a in Activity<zA>.activities {
   guard let g = b.teams.flatMap({$0.games}).first(where:{$0.id == a.attributes.game}),!g.done,!g.cancelled,g.date > Date(),g.date.timeIntervalSinceNow <= 7.9*3600 else{await a.end(nil,dismissalPolicy:.immediate);continue}
   await a.update(ActivityContent(state:zA.ContentState(date:g.date,opponent:g.away,venue:g.venue),staleDate:g.date))
  }
 }
 func stopLive() async {
  #if DEBUG && targetEnvironment(simulator)
  guard BoraCapture.screen == nil else { return }
  #endif
  for a in Activity<zA>.activities {await a.end(nil,dismissalPolicy:.immediate)}
 }
}
func vErr(_ s:String)->NSError { NSError(domain:"Bora",code:73,userInfo:[NSLocalizedDescriptionKey:zL(s)]) }

import CryptoKit
struct MatchEnvelope:Codable {
 struct Contents:Codable {let format:String;let group:String;let kind:String;let body:Data;let version:Int}
 let signed:Data
 let key:Data
 let signature:Data
 static func keyForDevice() throws -> Curve25519.Signing.PrivateKey {
  let root=FileManager.default.urls(for:.applicationSupportDirectory,in:.userDomainMask)[0]
  try FileManager.default.createDirectory(at:root,withIntermediateDirectories:true)
  var url=root.appendingPathComponent("BoraSquad.identity")
  if FileManager.default.fileExists(atPath:url.path){return try Curve25519.Signing.PrivateKey(rawRepresentation:Data(contentsOf:url))}
  let key=Curve25519.Signing.PrivateKey()
  try key.rawRepresentation.write(to:url,options:[.atomic,.completeFileProtection])
  var flags=URLResourceValues();flags.isExcludedFromBackup=true;try url.setResourceValues(flags);return key
 }
 static func export<T:Encodable>(_ item:T,group:String,kind:String) throws ->URL {
  let key=try keyForDevice()
  let counter="BoraSquad.sequence";let version=UserDefaults.standard.integer(forKey:counter)+1
  let content=Contents(format:"BoraSquad/1",group:group,kind:kind,body:try JSONEncoder().encode(item),version:version)
  let raw=try JSONEncoder().encode(content)
  let envelope=Self(signed:raw,key:key.publicKey.rawRepresentation,signature:try key.signature(for:raw))
  let url=FileManager.default.temporaryDirectory.appendingPathComponent("BoraSquad-"+kind+"-"+String(version)+".json")
  try JSONEncoder().encode(envelope).write(to:url,options:[.atomic,.completeFileProtection]);UserDefaults.standard.set(version,forKey:counter);return url
 }
 static func open(_ url:URL)throws ->(Contents,String) {
  let scoped=url.startAccessingSecurityScopedResource();defer{if scoped{url.stopAccessingSecurityScopedResource()}}
  guard try url.resourceValues(forKeys:[.fileSizeKey]).fileSize.map({$0>0 && $0<=8_000_000})==true else{throw CocoaError(.fileReadTooLarge)}
  let envelope=try JSONDecoder().decode(Self.self,from:Data(contentsOf:url))
  let key=try Curve25519.Signing.PublicKey(rawRepresentation:envelope.key)
  guard key.isValidSignature(envelope.signature,for:envelope.signed) else{throw CocoaError(.fileReadCorruptFile)}
  let c=try JSONDecoder().decode(Contents.self,from:envelope.signed)
  guard c.format=="BoraSquad/1",UUID(uuidString:c.group) != nil,c.version>0,["host","guest"].contains(c.kind) else{throw CocoaError(.fileReadCorruptFile)}
  return(c,envelope.key.base64EncodedString())
 }
}

struct BoraLetter: Identifiable{let id=UUID();let url:URL}
struct BoraLetterPanel:UIViewControllerRepresentable{
 let item:BoraLetter
 func makeUIViewController(context:Context)->UIActivityViewController{UIActivityViewController(activityItems:[item.url],applicationActivities:nil)}
 func updateUIViewController(_ vc:UIActivityViewController,context:Context){}
}
