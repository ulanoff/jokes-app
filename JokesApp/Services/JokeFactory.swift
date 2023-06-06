import Foundation

class JokeFactory: JokeFactoryProtocol {
	weak var delegate: JokeFactoryDelegate?
	private let jokeLoader: JokeLoader
	
	init(delegate: JokeFactoryDelegate, jokeLoader: JokeLoader) {
		self.delegate = delegate
		self.jokeLoader = jokeLoader
	}
	
	func requestNextJoke() {
		delegate?.didStartLoadingNewJoke()
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			guard let self else { return }
			
			jokeLoader.loadJoke { [weak self] result in
				DispatchQueue.main.async {
					guard let self else { return }
					
					switch result {
					case .success(let data):
						let joke = JokeViewModel(id: data.id, setup: data.setup, punchline: data.punchline, type: data.type)
						self.delegate?.didReceiveNextJoke(joke: joke)
					case .failure(let error):
						self.delegate?.didFailToLoadData(with: error)
					}
				}
			}
		}
	}
}
