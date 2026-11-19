import SwiftUI
import WidgetKit
import ActivityKit

struct r73:TimelineEntry {var date:Date;var w:zW}
struct rFeed:TimelineProvider {
 func placeholder(in context:Context)->r73{r73(date:Date(),w:zW())}
 func getSnapshot(in context:Context,completion:@escaping(r73)->Void){completion(r73(date:Date(),w:zDisk.widget))}
 func getTimeline(in context:Context,completion:@escaping(Timeline<r73>)->Void){let w = zDisk.widget;let now = Date();var entries = [r73(date:now,w:w)];if let next = w.next,next.date > now {var ended = w;ended.next = nil;entries.append(r73(date:next.date,w:ended))};completion(Timeline(entries:entries,policy:.after(now.addingTimeInterval(1800))))}
}
struct rFace:View {
 var entry:r73;@Environment(\.widgetFamily) var family
 let orange = Color(red:1,green:107/255,blue:0)
 var body:some View {Group{switch family{
 case .accessoryInline:if let g = entry.w.next {Text(g.date,style:.relative)+Text(" · "+g.away)}else{Text(zL("No upcoming match"))}
 case .accessoryCircular:VStack{Image(systemName:"soccerball");if let g = entry.w.next{Text(g.date,style:.timer).font(.caption2).minimumScaleFactor(0.5)}else{Text("—")}}
 case .accessoryRectangular:VStack(alignment:.leading){Text(entry.w.name).font(.headline);if let g = entry.w.next{Text(g.away).font(.caption);Text(g.date,style:.relative)}else{Text(zL("No upcoming match")).font(.caption)}}
 case .systemSmall:VStack(alignment:.leading,spacing:10){Label(zL("Last result"),systemImage:"soccerball").font(.caption).foregroundStyle(orange);if let g = entry.w.last {Text("\(g.hg) : \(g.ag)").font(.system(size:37,weight:.black,design:.rounded));Text(g.home+" · "+g.away).font(.caption).lineLimit(2);Text(g.date,style:.date).font(.caption2).foregroundStyle(.secondary)}else{Text(zL("Your next result starts on the pitch.")).font(.headline)};Spacer(minLength:0)}.frame(maxWidth:.infinity,alignment:.leading)
 default:VStack(alignment:.leading,spacing:12){HStack{Text(entry.w.name).font(.headline);Spacer();Image(systemName:"tshirt.fill").foregroundStyle(orange)};if let g = entry.w.next {HStack(alignment:.top){VStack(alignment:.leading,spacing:4){Text(g.home+" · "+g.away).font(.headline).lineLimit(1);Text(g.date,format:.dateTime.weekday(.abbreviated).hour().minute()).font(.subheadline).foregroundStyle(orange);Text(g.venue).font(.caption).foregroundStyle(.secondary).lineLimit(1)};Spacer();Button(intent:zTap(g.id,entry.w.team)){Label(zL(entry.w.answer == "pending" ? "Saved locally":"I'm in"),systemImage:"checkmark.circle.fill").font(.caption)}.tint(orange)}}else{Text(zL("No upcoming match")).foregroundStyle(.secondary)}
 if family == .systemLarge {Divider();HStack{Text("\(entry.w.played) "+zL("played"));Spacer();Text("\(entry.w.wins) "+zL("wins"))}.font(.caption).foregroundStyle(orange);ForEach(Array(entry.w.rows.prefix(5).enumerated()),id:\.element.id){i,r in HStack{Text("\(i+1)").foregroundStyle(.secondary);Text(r.id).lineLimit(1);Spacer();Text("\(r.played)").foregroundStyle(.secondary);Text("\(r.points)").bold().foregroundStyle(orange)}.font(.caption)};Spacer(minLength:0);Text(zL("Updated")+" "+entry.w.stamp.formatted(date:.omitted,time:.shortened)).font(.caption2).foregroundStyle(.secondary)}
 }.frame(maxWidth:.infinity,alignment:.leading)
 }}.containerBackground(for:.widget){Color(red:17/255,green:17/255,blue:17/255)}.widgetURL(URL(string:"borajogar://match?team="+entry.w.team))}
}
struct rWidget:Widget {
 var body:some WidgetConfiguration{StaticConfiguration(kind:"BoraSeason73",provider:rFeed()){rFace(entry:$0)}.configurationDisplayName("Bora Jogar").description(zL("Team scores, your next kickoff and the season table, from your device.")).supportedFamilies([.systemSmall,.systemMedium,.systemLarge,.accessoryInline,.accessoryCircular,.accessoryRectangular])}
}
struct rLive:Widget {
 var body:some WidgetConfiguration {ActivityConfiguration(for:zA.self){c in HStack{Image(systemName:"soccerball").font(.largeTitle);VStack(alignment:.leading){Text(c.attributes.team+" · "+c.state.opponent).font(.headline);Text(c.state.venue).font(.caption);Text(timerInterval:Date()...max(Date(),c.state.date),countsDown:true).font(.title2.monospacedDigit()).foregroundStyle(.orange)}}.padding(18).activityBackgroundTint(Color.black).activitySystemActionForegroundColor(.orange).widgetURL(URL(string:"borajogar://match"))}dynamicIsland:{c in DynamicIsland{DynamicIslandExpandedRegion(.leading){Label(c.attributes.team,systemImage:"tshirt.fill")};DynamicIslandExpandedRegion(.trailing){Text(c.state.opponent)};DynamicIslandExpandedRegion(.bottom){Text(timerInterval:Date()...max(Date(),c.state.date),countsDown:true).monospacedDigit().foregroundStyle(.orange)}}compactLeading:{Image(systemName:"soccerball").foregroundStyle(.orange)}compactTrailing:{Text(timerInterval:Date()...max(Date(),c.state.date),countsDown:true).monospacedDigit().frame(width:60)}minimal:{Image(systemName:"soccerball").foregroundStyle(.orange)}.widgetURL(URL(string:"borajogar://match"))}}
}
@main struct rBundle:WidgetBundle{var body:some Widget{rWidget();rLive()}}
