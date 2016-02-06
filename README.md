# Chocolate
An iOS framework that uses storyboards and operations instead of view controllers.

The original drive behind this framework was to solve the Massive View Controller problem by allowing relatively rapid construction of small apps that include no new UIViewController subclasses. The secondary objective of the project was to encourage all (or at least most) non-UIKit code that would normally be in a UIViewController to be run on a background thread.

# Setup
Build the Chocolate project
Add the Chocolate.framework file produced to the list of frameworks in your project

# Usage
1. In your storyboard add a ChocolateViewCOntroller or a ChocolateCollectionViewController (ChocolateTableViewController coming soon).
2. Add views to the view controller as you normally would.
3. Add NSObjects (that match the types required by the view controller) to your storyboard and connect them to the IBOutlets in the view controller
4. The main method in your NSObject will be called by the view controller according to which IBOutlet it was attached to.

# Demo
For a demo of this framework see https://github.com/TristanBurnside/ChocolateDemo
