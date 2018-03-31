import UIKit
import ChuckNorrisCore

final class JokeViewController: UIViewController, JokeView {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addJokeButton: UIButton!

	var presenter: JokePresenter!
	private var jokes = [Joke]()

	override func viewDidLoad() {
		super.viewDidLoad()

		guard presenter != nil else {
			Swift.fatalError("view was loaded without a presenter!")
		}

		tableView.estimatedRowHeight = 68.0
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.dataSource = self
		tableView.delegate = self

		fetchDevJoke()
	}

	@IBAction func addJoke(_ sender: Any) {
		fetchDevJoke(forcing: true)
	}

	func show(jokes: [Joke]) {
		self.jokes = jokes
		self.tableView.reloadData()
	}

	func showError(message: String) {
		let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

		let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
			self?.dismiss(animated: true, completion: nil)
		}

		alertController.addAction(okAction)

		present(alertController, animated: true, completion: nil)
	}

	private func fetchDevJoke(forcing update: Bool = false) {
		presenter.fetchJoke(of: "dev", forcing: update)
	}
}

extension JokeViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return jokes.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath) as! JokeCell

		let joke = jokes[indexPath.row]

		cell.jokeLabel.text = joke.value

		return cell
	}
}

extension JokeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
}
