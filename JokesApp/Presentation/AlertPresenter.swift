import UIKit

class AlertPresenter {
	var delegate: AlertPresenterDelegate?
	
	func presentAlert(to controller: UIViewController, with model: AlertModel) {
		let alert = UIAlertController(title: model.title,
									  message: model.text,
									  preferredStyle: .alert)
		let action = UIAlertAction(title: model.buttonText, style: .default) { [weak self] _ in
			guard let self else { return }
			if let completion = model.completion {
				completion()
				return
			}
			self.delegate?.didDismissAlert()
		}
		alert.addAction(action)
		controller.present(alert, animated: true)
	}
}


