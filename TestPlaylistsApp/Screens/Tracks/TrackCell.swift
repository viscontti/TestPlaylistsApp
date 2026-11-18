//
//  TrackCell.swift
//  TestPlaylistsApp
//

import UIKit

final class TrackCell: UITableViewCell {
    static let reuseIdentifier = "TrackCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let playlistLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: TrackItem) {
        titleLabel.text = item.title
        playlistLabel.text = item.playlistTitle
        durationLabel.text = Self.formatDuration(item.duration)
    }

    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(playlistLabel)
        contentView.addSubview(durationLabel)

        let margins = contentView.layoutMarginsGuide

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: durationLabel.leadingAnchor, constant: -8),

            playlistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            playlistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            playlistLabel.trailingAnchor.constraint(lessThanOrEqualTo: durationLabel.leadingAnchor, constant: -8),
            playlistLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),

            durationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
    }

    private static func formatDuration(_ seconds: Double) -> String {
        let total = Int(seconds)
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}
