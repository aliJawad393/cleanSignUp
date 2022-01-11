# cleanSignup
A repository demonstrating SOLID Principles and other good design practices for signup module and user input validation with following characteristics:
* Unit Tests
  * Testing UIKit (with UI created programatically)
    * UITextFields and delegates
    * Button taps (using Actions)
    * Alerts
  * Testing business logic
  * Testing View Appearance(with Snapshots)
    * using FBSnapshotTestCase
* Countinuous Integration
  * Using Travis CI
* Design Patterns
  * Builder - to build UserCredentials in steps
  * Composite - for validating user input
  * Abstract factory and Factory to create view controller
