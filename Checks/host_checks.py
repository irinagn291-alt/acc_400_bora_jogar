"""Run the platform-independent season reducer directly from production source."""
from pathlib import Path
import os, subprocess
root = Path(__file__).resolve().parents[1]
s = (root / 'BoraJogar/Sources/Rook.swift').read_text()
fragments = s[s.index('struct zE:'):s.index('struct zC:')] + s[s.index('struct zRow:'):s.index('struct zW:')]
checks = '''
var fixtures:[zM] = []
for i in 0..<400 {
 var m = zM(home:"Team"+String(i%8),away:"Team"+String((i+1)%8),date:Date(timeIntervalSince1970:0),venue:"Court",season:"one")
 m.hg = (i*7)%6;m.ag = (i*11)%5;m.done = i%4 != 0;m.cancelled = i%9 == 0;fixtures.append(m)
}
let expected = fixtures.filter{$0.done && !$0.cancelled}
let rows = zTable(fixtures,(0..<8).map{"Team"+String($0)})
assert(rows.reduce(0){$0+$1.played} == expected.count*2)
assert(rows.reduce(0){$0+$1.gf} == rows.reduce(0){$0+$1.ga})
assert(rows.reduce(0){$0+$1.won} == rows.reduce(0){$0+$1.lost})
let draws = expected.filter{$0.hg == $0.ag}.count
assert(rows.reduce(0){$0+$1.drawn} == draws*2)
assert(rows.reduce(0){$0+$1.points} == (expected.count-draws)*3+draws*2)
assert(zTable([], ["C","A","B","A"]).map{$0.id} == ["A","B","C"])
let encoded = try JSONEncoder().encode(fixtures)
let restored = try JSONDecoder().decode([zM].self,from:encoded)
assert(restored == fixtures)
print("PASS: 400 protocols; excluded cancelled and unfinished games; conservation of goals, outcomes and points; deterministic ties; Codable round trip.")
'''
r = subprocess.run(['swift', '-module-cache-path', str(root/'Artifacts/HostSwiftCache'), '-'], input='import Foundation\n'+fragments+checks, text=True, capture_output=True, env={**os.environ,'DEVELOPER_DIR':'/Applications/Xcode.app/Contents/Developer'}, cwd=root)
(root/'QA/host-model.log').write_text(r.stdout+r.stderr)
print(r.stdout+r.stderr)
if r.returncode: raise SystemExit(r.returncode)
orbit = (root/'BoraJogar/Sources/Orbit2c8b1c.swift').read_text()
crypto = orbit[orbit.index(' func seal('):orbit.index(' func getSecret(')]
error = orbit[orbit.index('func vErr('):]
harness = '''
let organizer = Curve25519.KeyAgreement.PrivateKey()
let publicKey = organizer.publicKey.rawRepresentation.base64EncodedString()
let box = fProof(secretData:organizer.rawRepresentation)
let plain = Data("Private team message".utf8)
let encrypted = try box.seal(plain,publicKey)
let second = try box.seal(plain,publicKey)
assert(encrypted != second)
let recovered = try box.unseal(encrypted,"team")
assert(recovered == plain)
var changed = encrypted;changed[changed.count-1] ^= 1
var rejected = false
do {_ = try box.unseal(changed,"team")}catch{rejected = true}
assert(rejected)
let other = fProof(secretData:Curve25519.KeyAgreement.PrivateKey().rawRepresentation)
rejected = false
do {_ = try other.unseal(encrypted,"team")}catch{rejected = true}
assert(rejected)
assert(encrypted.range(of:plain) == nil)
print("PASS: production request encryption round trip; fresh ephemeral key; tampering and wrong organizer key rejected; plaintext absent from envelope.")
'''
program = 'import Foundation\nimport CryptoKit\nfunc zL(_ s:String)->String{s}\nstruct fProof{var secretData:Data;func getSecret(_ id:String)->Data?{secretData}\n'+crypto+'}\n'+error+'\n'+harness
r = subprocess.run(['swift','-module-cache-path',str(root/'Artifacts/HostSwiftCache'),'-'],input=program,text=True,capture_output=True,env={**os.environ,'DEVELOPER_DIR':'/Applications/Xcode.app/Contents/Developer'},cwd=root)
(root/'QA/host-crypto.log').write_text(r.stdout+r.stderr);print(r.stdout+r.stderr)
if r.returncode: raise SystemExit(r.returncode)
models = s if False else (root/'BoraJogar/Sources/Rook.swift').read_text()
models = models[models.index('struct zP:'):models.index('struct zA:')]
properties = orbit[orbit.index(' var team:zT?'):orbit.index(' func save(')]
edit = orbit[orbit.index(' func edit('):orbit.index(' func make(')]
actions = orbit[orbit.index(' func answer('):orbit.index(' func accept(')]
program = 'import Foundation\nimport Combine\nfunc zL(_ s:String)->String{s}\n'+models+'\nfinal class fState{ @Published var b = zB();var note = "";var ticks:[String:Int] = [:];var inbox:[zC] = [];var rendered:[String:zC] = [:];func save(_ dirty:Bool = true){}\n'+properties+edit+actions+'}\n'+'''
let state = fState()
let team = zT(name:"Aurora",city:"City")
state.b.teams = [team];state.b.selected = team.id;state.b.profile = "Alex"
assert(state.post("Meet by the gate"))
assert(state.team!.chat.count == 1 && state.team!.chat[0].state == "pending")
state.review(state.team!.chat[0].id,true)
assert(state.team!.chat[0].state == "approved")
assert(!state.post("https://example.com"))
assert(state.team!.chat.count == 1)
state.report(state.team!.chat[0])
assert(state.team!.chat[0].state == "removed")
let game = zM(home:"Aurora",away:"Vila",date:Date().addingTimeInterval(3600),venue:"Court",season:"")
state.edit{$0.games.append(game)}
state.answer(team.id,game.id,"yes")
assert(state.team!.games[0].rsvp["local"] == "yes")
state.b.cloudUser = "member";state.b.apple = "credential";state.b.shared[team.id] = "owner"
state.answer(team.id,game.id,"maybe")
assert(state.team!.games[0].rsvp["member"] == "maybe")
assert(state.b.outbox.count == 1 && state.b.outbox[0].kind == "rsvp")
assert(state.post("See you at kickoff"))
assert(state.b.outbox.last!.kind == "chat")
assert(state.team!.chat.count == 1)
let previous = state.team!.name
state.edit{$0.name = "Unauthorized"}
assert(state.team!.name == previous)
print("PASS: actual local state methods; premoderation, approval, report/hide, link rejection, local RSVP, participant queues, organizer write guard; no exclusivity crash.")
'''
r = subprocess.run(['swift','-module-cache-path',str(root/'Artifacts/HostSwiftCache'),'-'],input=program,text=True,capture_output=True,env={**os.environ,'DEVELOPER_DIR':'/Applications/Xcode.app/Contents/Developer'},cwd=root)
(root/'QA/host-state.log').write_text(r.stdout+r.stderr);print(r.stdout+r.stderr)
if r.returncode: raise SystemExit(r.returncode)
validation = orbit[orbit.index('func zDigest('):orbit.index('@MainActor final class')]
program = 'import Foundation\nimport CryptoKit\n'+models+validation+'''
let renderKey = Data(repeating:42,count:32)
let request = zQ(team:"team",kind:"chat",text:"Bring water",item:renderKey.base64EncodedString(),name:"Alex")
let message = zC(id:request.id,author:request.name,user:"member",text:request.text,date:request.date,state:"approved")
let original = try AES.GCM.seal(JSONEncoder().encode(message),using:SymmetricKey(data:renderKey)).combined!
guard let reviewed = zMirror(request,original,"member",request.id) else{fatalError("Valid request rejected")}
assert(zPinned(original,reviewed.digest))
assert(zMirror(request,original,"other-author",request.id) == nil)
assert(zMirror(request,original,"member","different-record") == nil)
var preview = request;preview.text = "Different preview"
assert(zMirror(preview,original,"member",request.id) == nil)
preview = request;preview.name = "Another name"
assert(zMirror(preview,original,"member",request.id) == nil)
var replaced = message;replaced.text = "Changed after approval"
let changed = try AES.GCM.seal(JSONEncoder().encode(replaced),using:SymmetricKey(data:renderKey)).combined!
assert(!zPinned(changed,reviewed.digest))
let join = zQ(team:"team",kind:"join",text:"",item:renderKey.base64EncodedString(),name:"Rafa")
let profile = zC(id:join.id,author:join.name,user:"member",text:"",date:join.date,state:"approved")
let profileBody = try AES.GCM.seal(JSONEncoder().encode(profile),using:SymmetricKey(data:renderKey)).combined!
assert(zMirror(join,profileBody,"member",join.id) != nil)
assert(!zPinned(Data(repeating:0,count:9000),reviewed.digest))
print("PASS: production moderation binding; matching preview accepted; foreign author, record substitution, preview text/name mismatch and post-approval replacement rejected; profiles checked too.")
'''
r = subprocess.run(['swift','-module-cache-path',str(root/'Artifacts/HostSwiftCache'),'-'],input=program,text=True,capture_output=True,env={**os.environ,'DEVELOPER_DIR':'/Applications/Xcode.app/Contents/Developer'},cwd=root)
(root/'QA/host-moderation.log').write_text(r.stdout+r.stderr);print(r.stdout+r.stderr)
raise SystemExit(r.returncode)
