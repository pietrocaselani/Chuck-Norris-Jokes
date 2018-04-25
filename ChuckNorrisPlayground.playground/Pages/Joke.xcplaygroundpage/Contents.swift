import Foundation
import PlaygroundSupport
import UIKit
@testable import ChuckNorrisPlaygroundFramework

let jokeView = JokeModule.setupModule()

guard let jokeViewController = jokeView as? UIViewController else {
    Swift.fatalError("Should be an instance of UIViewController")
}

let (parent, _) = playgroundControllers(device: .phone4inch, orientation: .portrait, child: jokeViewController)
let frame = parent.view.frame
PlaygroundPage.current.liveView = parent
parent.view.frame = frame
