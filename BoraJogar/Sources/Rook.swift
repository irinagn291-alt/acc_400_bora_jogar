import Foundation
import ActivityKit
import WidgetKit
import AppIntents

let zOrange = "FF6B00"
func zL(_ a:String)->String { NSLocalizedString(a, comment: "") }
let zGroup = "group.org.courtyard.borajogar.a73f2"
let zContainer = "iCloud.org.courtyard.borajogar.a73f2"
struct zP: Codable, Identifiable, Equatable { var id = UUID().uuidString; var name:String; var number:Int = 1; var role:String = "Midfield"; var cloud:String = ""; var reference:String?; var secret:String?; var digest:String? }
struct zE: Codable, Identifiable, Equatable { var id = UUID().uuidString; var player:String; var assist:String = ""; var minute:Int = 0 }
struct zM: Codable, Identifiable, Equatable {
 var id = UUID().uuidString; var home:String; var away:String; var date:Date; var duration:Int = 60; var venue:String; var season:String; var confirmed = false; var done = false; var cancelled = false; var hg = 0; var ag = 0; var lineup:[String] = []; var rsvp:[String:String] = [:]; var events:[zE] = []
}
struct zC: Codable, Identifiable, Equatable { var id = UUID().uuidString; var author:String; var user:String; var text:String; var date = Date(); var state = "pending"; var reason = ""; var digest:String? }
struct zS: Codable, Identifiable, Equatable { var id = UUID().uuidString; var name:String; var teams:[String] }
struct zT: Codable, Identifiable, Equatable {
 var id = UUID().uuidString; var name:String; var city:String; var owner = ""; var key = ""; var players:[zP] = []; var games:[zM] = []; var seasons:[zS] = []; var chat:[zC] = []; var blocked:[String] = []; var handled:[String] = []; var revision = 0
}
struct zV: Codable, Identifiable, Hashable { var id = UUID().uuidString; var name:String; var city:String; var address:String; var lat:Double; var lon:Double; var source:String; var custom = false }
struct zB: Codable { var teams:[zT] = []; var opponents:[zP] = []; var venues:[zV] = []; var selected = ""; var profile = ""; var apple = ""; var cloudUser = ""; var blocked:[String] = []; var cloudOn = false; var notifications = false; var shared:[String:String] = [:]; var dirty:[String] = []; var outbox:[zQ] = [] }
struct zQ: Codable, Identifiable { var id = UUID().uuidString; var team:String; var kind:String; var text:String; var item:String; var name:String; var date = Date() }
struct zRow: Codable, Identifiable { var id:String; var played = 0; var won = 0; var drawn = 0; var lost = 0; var gf = 0; var ga = 0; var points:Int { won * 3 + drawn }; var diff:Int { gf-ga } }
func zTable(_ games:[zM], _ teams:[String])->[zRow] {
 var rows = Dictionary(uniqueKeysWithValues: Array(Set(teams)).map { ($0,zRow(id:$0)) })
 for g in games where g.done && !g.cancelled {
   if rows[g.home] == nil { rows[g.home] = zRow(id:g.home) }; if rows[g.away] == nil { rows[g.away] = zRow(id:g.away) }
   rows[g.home]!.played += 1; rows[g.away]!.played += 1; rows[g.home]!.gf += g.hg; rows[g.home]!.ga += g.ag; rows[g.away]!.gf += g.ag; rows[g.away]!.ga += g.hg
   if g.hg == g.ag { rows[g.home]!.drawn += 1; rows[g.away]!.drawn += 1 } else { let w = g.hg > g.ag ? g.home:g.away; let l = g.hg > g.ag ? g.away:g.home; rows[w]!.won += 1; rows[l]!.lost += 1 }
 }
 return rows.values.sorted { if $0.points != $1.points { return $0.points > $1.points }; if $0.diff != $1.diff { return $0.diff > $1.diff }; if $0.gf != $1.gf { return $0.gf > $1.gf }; return $0.id.localizedStandardCompare($1.id) == .orderedAscending }
}
struct zW: Codable { var name = "Bora Jogar"; var next:zM?; var last:zM?; var rows:[zRow] = []; var played = 0; var wins = 0; var team = ""; var stamp = Date(); var answer = "" }
struct zA: ActivityAttributes { struct ContentState: Codable, Hashable { var date:Date; var opponent:String; var venue:String }; var team:String; var game:String }
enum zDisk {
 static var url:URL {
  let fm = FileManager.default
  let x = fm.containerURL(forSecurityApplicationGroupIdentifier:zGroup) ?? fm.urls(for:.applicationSupportDirectory,in:.userDomainMask)[0].appendingPathComponent("BoraLocal")
  try? fm.createDirectory(at:x,withIntermediateDirectories:true); return x
 }
 static func read<T:Decodable>(_ n:String, _ t:T.Type)->T? { guard let d = try? Data(contentsOf:url.appendingPathComponent(n)) else { return nil }; return try? JSONDecoder().decode(t,from:d) }
 static func write<T:Encodable>(_ v:T,_ n:String) throws { let d = try JSONEncoder().encode(v); try d.write(to:url.appendingPathComponent(n),options:[.atomic,.completeFileProtectionUntilFirstUserAuthentication]) }
 static var widget:zW { read("glance.json",zW.self) ?? zW() }
}
struct zTap: AppIntent {
 static var title: LocalizedStringResource = "I'm in"
 static var description = IntentDescription("Save your attendance locally. It syncs when you open Bora Jogar.")
 @Parameter(title:"Match") var game:String
 @Parameter(title:"Team") var team:String
 init(){}; init(_ a:String,_ b:String){ game = a; team = b }
 func perform() async throws -> some IntentResult {
  let q = zQ(team:team,kind:"rsvp",text:"yes",item:game,name:"")
  try zDisk.write(q,"tap-"+q.id+".json")
  var w = zDisk.widget; if w.next?.id == game { w.answer = "pending"; try zDisk.write(w,"glance.json") }
  WidgetCenter.shared.reloadAllTimelines(); return .result()
 }
}
