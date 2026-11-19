import XCTest

final class u73:XCTestCase {
 func test00TableUsesOnlyFinalProtocols(){
  var a = zM(home:"Aurora",away:"Vila",date:Date(),venue:"Court",season:"s");a.done = true;a.hg = 3;a.ag = 1
  var b = zM(home:"Vila",away:"Aurora",date:Date(),venue:"Court",season:"s");b.done = true;b.hg = 2;b.ag = 2
  var c = a;c.cancelled = true;c.hg = 40
  var pending = a;pending.done = false
  let rows = zTable([a,b,c,pending],["Aurora","Vila","Aurora","Sol"])
  XCTAssertEqual(rows.count,3);XCTAssertEqual(rows[0].id,"Aurora");XCTAssertEqual(rows[0].points,4);XCTAssertEqual(rows[0].played,2);XCTAssertEqual(rows[0].gf,5);XCTAssertEqual(rows[0].ga,3);XCTAssertEqual(rows[1].id,"Vila");XCTAssertEqual(rows[1].points,1);XCTAssertEqual(rows[2].played,0)
 }
 func test01TiesAndRoundTrip()throws {
  let rows = zTable([], ["C","A","B"]);XCTAssertEqual(rows.map{$0.id},["A","B","C"])
  var team = zT(name:"Aurora",city:"São Paulo");let player = zP(name:"Rafa",number:9,role:"Forward");team.players = [player]
  var m = zM(home:team.name,away:"Vila",date:Date(timeIntervalSince1970:1900000000),venue:"CERET",season:"s");m.lineup=[player.id];m.rsvp=["local":"yes"];m.events=[zE(player:player.id,minute:12)];team.games=[m]
  let restored = try JSONDecoder().decode(zT.self,from:JSONEncoder().encode(team));XCTAssertEqual(restored,team)
 }
 @MainActor func element(_ app:XCUIApplication,_ text:String)->XCUIElement {app.descendants(matching:.any).matching(NSPredicate(format:"label CONTAINS %@",text)).firstMatch}
 @MainActor func shot(_ label:String){let a = XCTAttachment(screenshot:XCUIScreen.main.screenshot());a.name = label;a.lifetime = .keepAlways;add(a)}
 @MainActor func tab(_ a:XCUIApplication,_ name:String){let x = a.tabBars.buttons[name];if x.exists{x.tap()}else{a.buttons[name].firstMatch.tap()}}
 @MainActor func test10OfflineJourney()throws {
  let a = XCUIApplication();a.launchArguments = ["-AppleLanguages","(en)","-AppleLocale","en_US"];a.launch()
  XCTAssertTrue(a.buttons["Create your team"].waitForExistence(timeout:15));shot("01-first-launch")
  a.buttons["Create your team"].tap();a.textFields["teamName"].tap();a.textFields["teamName"].typeText("Aurora FC");a.buttons["Create"].tap()
  XCTAssertTrue(a.staticTexts["Aurora FC"].firstMatch.waitForExistence(timeout:5))
  tab(a,"Squad");a.buttons["Add player"].tap();a.textFields["Name"].tap();a.textFields["Name"].typeText("Rafa");a.buttons["Save"].tap();XCTAssertTrue(a.staticTexts["Rafa"].waitForExistence(timeout:3));shot("02-squad")
  tab(a,"Season");a.buttons["Create season"].tap();a.textFields["Season name"].tap();a.textFields["Season name"].typeText("Weekend League");a.buttons["Create"].tap();XCTAssertTrue(a.staticTexts["Standings"].waitForExistence(timeout:4));shot("03-season")
  tab(a,"Courts");XCTAssertTrue(element(a,"CERET").waitForExistence(timeout:5));shot("04-directory")
  a.buttons["Nearby"].tap();let spring = XCUIApplication(bundleIdentifier:"com.apple.springboard");if spring.buttons["Don’t Allow"].waitForExistence(timeout:4){spring.buttons["Don’t Allow"].tap()}else if spring.buttons["Don't Allow"].exists{spring.buttons["Don't Allow"].tap()}
  XCTAssertTrue(element(a,"CERET").exists)
  tab(a,"Matchday");a.buttons["Create match"].firstMatch.tap();a.textFields["opponent"].tap();a.textFields["opponent"].typeText("Vila Nova")
  let court = a.buttons["courtPicker"];if !court.isHittable{a.swipeUp()};court.tap()
  let venue = a.buttons["CERET · São Paulo"];if venue.waitForExistence(timeout:3){venue.tap()}else{a.staticTexts["CERET · São Paulo"].tap()}
  a.buttons["Save"].tap();XCTAssertTrue(element(a,"Vila Nova").waitForExistence(timeout:5));shot("05-matchday")
  a.terminate();a.launch();XCTAssertTrue(a.staticTexts["Aurora FC"].firstMatch.waitForExistence(timeout:10));XCTAssertTrue(element(a,"Vila Nova").exists);shot("06-restored")
  a.buttons["Profile & privacy"].tap()
  a.textFields["profileName"].tap();a.textFields["profileName"].typeText("Alex");a.buttons["Done"].tap()
  tab(a,"Team chat");let composer = a.descendants(matching:.any).matching(identifier:"reviewComposer").firstMatch;XCTAssertTrue(composer.waitForExistence(timeout:4));composer.tap();composer.typeText("Meet by the gate")
  a.buttons["sendReview"].tap();XCTAssertTrue(a.alerts.buttons["OK"].waitForExistence(timeout:5));a.alerts.buttons["OK"].tap()
  XCTAssertTrue(a.buttons["Approve"].waitForExistence(timeout:4));a.buttons["Approve"].tap()
  XCTAssertTrue(element(a,"Meet by the gate").exists);shot("07-reviewed-chat")
  a.buttons["Report"].tap();XCTAssertTrue(a.alerts.buttons["OK"].waitForExistence(timeout:5));a.alerts.buttons["OK"].tap()
  XCTAssertFalse(element(a,"Meet by the gate").exists)
  tab(a,"Matchday");a.buttons["Profile & privacy"].tap()
  let reminder = a.switches["Match reminders"]
  for _ in 0..<5 {if reminder.isHittable{break};a.swipeUp()}
  if reminder.switches.firstMatch.exists{reminder.switches.firstMatch.tap()}else{reminder.tap()};XCTAssertTrue(a.alerts.buttons["Enable"].waitForExistence(timeout:4));a.alerts.buttons["Enable"].tap()
  if spring.buttons["Don’t Allow"].waitForExistence(timeout:5){spring.buttons["Don’t Allow"].tap()}else if spring.buttons["Don't Allow"].exists{spring.buttons["Don't Allow"].tap()}
  XCTAssertTrue(a.alerts.buttons["OK"].waitForExistence(timeout:5));a.alerts.buttons["OK"].tap()
  XCTAssertEqual(reminder.value as? String,"0")
  let erase = a.buttons["Delete profile & data"]
  for _ in 0..<5 {if erase.isHittable{break};a.swipeUp()}
  erase.tap()
  let choices = a.buttons.matching(identifier:"Delete profile & data").allElementsBoundByIndex
  guard let confirm = choices.reversed().first(where:{$0.isHittable}) else{XCTFail("Missing delete confirmation");return}
  confirm.tap()
  if a.alerts.buttons["OK"].waitForExistence(timeout:5){a.alerts.buttons["OK"].tap()}
  a.buttons["Done"].tap()
  XCTAssertTrue(a.buttons["Create your team"].waitForExistence(timeout:5))
  tab(a,"Courts");XCTAssertTrue(element(a,"CERET").waitForExistence(timeout:4));shot("08-reference-after-profile-deletion")
 }
}
