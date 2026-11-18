import UIKit

final class TracksViewController: UIViewController {
    private let generator = Generator()
    private let repository = TracksRepository()
    private var items: [TrackItem] = []

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.reuseIdentifier)
        tableView.estimatedRowHeight = 60
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tracks"
        view.backgroundColor = .systemBackground
        setupLayout()
        loadData()
    }

    private func setupLayout() {
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func loadData() {
        activityIndicator.startAnimating()
        generator.generateIfNeeded { [weak self] result in
            switch result {
            case .success:
                self?.fetchTracks()
            case .failure(let error):
                self?.showError(error)
            }
        }
    }

    private func fetchTracks() {
        repository.fetchTracks { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let items):
                self.activityIndicator.stopAnimating()
                self.items = items
                self.title = "Tracks: \(items.count)"
                self.tableView.reloadData()
            case .failure(let error):
                self.showError(error)
            }
        }
    }

    private func showError(_ error: Error) {
        activityIndicator.stopAnimating()
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension TracksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseIdentifier, for: indexPath) as? TrackCell else {
            return UITableViewCell()
        }
        cell.configure(with: items[indexPath.row])
        return cell
    }
}
