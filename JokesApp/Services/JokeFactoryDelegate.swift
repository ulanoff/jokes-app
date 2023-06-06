import Foundation

protocol JokeFactoryDelegate: AnyObject {
	func didReceiveNextJoke(joke: JokeViewModel?)
	func didFailToLoadData(with error: Error)
	func didStartLoadingNewJoke()
}
