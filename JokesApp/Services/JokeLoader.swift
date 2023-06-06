import Foundation

struct JokeLoader {
	private let networkManager = NetworkManager()
	
	private var jokeURL: URL {
		guard let url = URL(string: "https://official-joke-api.appspot.com/jokes/random") else {
			preconditionFailure("Unable to construct joke")
		}
		return url
	}
	
	func loadJoke(handler: @escaping (Result<Joke, Error>) -> Void) {
		networkManager.fetch(url: jokeURL) { result in
			switch result {
			case .success(let data):
				do {
					let joke = try JSONDecoder().decode(Joke.self, from: data)
					handler(.success(joke))
				}
				catch {
					handler(.failure(error))
				}
			case .failure(let error):
				handler(.failure(error))
			}
		}
	}
}

