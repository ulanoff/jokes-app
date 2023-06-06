import UIKit

class ViewController: UIViewController, JokeFactoryDelegate, AlertPresenterDelegate {
	
	@IBOutlet weak var showPuchlineButtonView: UILabel!
	@IBOutlet weak var newJokeButtonView: UIView!
	@IBOutlet weak var jokeIdLabel: UILabel!
	@IBOutlet weak var jokeTypeLabel: UILabel!
	@IBOutlet weak var jokeSetupLabel: UILabel!
	@IBOutlet var viewsWithBorder: [UIView]!
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	
	private var jokeFactory: JokeFactoryProtocol?
	private var alertPresenter: AlertPresenter?
	private var currentJoke: JokeViewModel?
	private var didBordersAdd = false
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		jokeFactory = JokeFactory(delegate: self, jokeLoader: JokeLoader())
		alertPresenter = AlertPresenter()
		jokeFactory?.requestNextJoke()
	}
	
	override func viewDidLayoutSubviews() {
		if !didBordersAdd {
			setupBorders()
		}
	}
	
	// MARK: - JokeFactoryDelegate
	
	func didReceiveNextJoke(joke: JokeViewModel?) {
		guard let joke else { return }
		show(joke)
		currentJoke = joke
		loadingIndicator.stopAnimating()
		enableButtons()
	}
	
	func didFailToLoadData(with error: Error) {
		loadingIndicator.stopAnimating()
		let alertModel = AlertModel(title: "Ошибка",
									text: "\(error.localizedDescription)",
									buttonText: "Ок")
		alertPresenter?.presentAlert(to: self, with: alertModel)
		enableButtons()
	}
	
	func didStartLoadingNewJoke() {
		clearDataLabels()
		loadingIndicator.startAnimating()
		disableButtons()
	}
	
	// MARK: - AlertPresenterDelegate
	func didDismissAlert() {
		
	}
	
	// MARK: - Actions
	@IBAction func newJokeButtonPressed(_ sender: UITapGestureRecognizer) {
		jokeFactory?.requestNextJoke()
	}
	
	@IBAction func showPunchlineButtonPressed(_ sender: UITapGestureRecognizer) {
		guard let currentJoke else { return }
		let alertModel = AlertModel(title: "Punchline",
									text: currentJoke.punchline,
									buttonText: "Ok")
		alertPresenter?.presentAlert(to: self, with: alertModel)
	}
	
	// MARK: - Private Functions
	
	private func show(_ joke: JokeViewModel) {
		self.jokeIdLabel.text = String(joke.id)
		self.jokeTypeLabel.text = joke.type
		self.jokeSetupLabel.text = joke.setup
	}
	
	private func clearDataLabels() {
		jokeSetupLabel.text = ""
		jokeIdLabel.text = "-"
		jokeTypeLabel.text = "-"
	}
	
	private func disableButtons() {
		newJokeButtonView.isUserInteractionEnabled = false
		showPuchlineButtonView.isUserInteractionEnabled = false
	}
	
	private func enableButtons() {
		newJokeButtonView.isUserInteractionEnabled = true
		showPuchlineButtonView.isUserInteractionEnabled = true
	}
	
	private func setupBorders() {
		for view in viewsWithBorder {
			view.layer.masksToBounds = true
			view.layer.borderColor = UIColor.jaBlack.cgColor
			view.layer.borderWidth = 2
			view.layer.cornerRadius = 8
		}
		
		jokeSetupLabel.layer.masksToBounds = true
		jokeSetupLabel.layoutIfNeeded()
		
		let topBorder = CALayer()
		topBorder.frame = CGRect(x: 0, y: 0, width: jokeSetupLabel.frame.width, height: 2)
		topBorder.backgroundColor = UIColor.jaBlack.cgColor
		jokeSetupLabel.layer.addSublayer(topBorder)

		let bottomBorder = CALayer()
		bottomBorder.frame = CGRect(x: 0, y: jokeSetupLabel.frame.height - 2, width: jokeSetupLabel.frame.width, height: 2)
		bottomBorder.backgroundColor = UIColor.jaBlack.cgColor
		jokeSetupLabel.layer.addSublayer(bottomBorder)
		
		didBordersAdd = true
	}
}

