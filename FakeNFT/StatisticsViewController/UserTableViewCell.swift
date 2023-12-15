import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {

    private let cardView = UIView()
    private let rankingLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let nftCountLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        contentView.backgroundColor = .clear

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .ypLightGrey
        cardView.layer.cornerRadius = 12
        contentView.addSubview(cardView)

        rankingLabel.translatesAutoresizingMaskIntoConstraints = false
        rankingLabel.backgroundColor = .clear
        rankingLabel.textAlignment = .center
        rankingLabel.layer.cornerRadius = 10
        rankingLabel.layer.masksToBounds = true
        rankingLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(rankingLabel)

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.cornerRadius = 14
        avatarImageView.clipsToBounds = true
        contentView.addSubview(avatarImageView)

        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = .boldSystemFont(ofSize: 22)
        cardView.addSubview(usernameLabel)

        nftCountLabel.translatesAutoresizingMaskIntoConstraints = false
        nftCountLabel.font = .boldSystemFont(ofSize: 22)
        cardView.addSubview(nftCountLabel)

        NSLayoutConstraint.activate([

            cardView.leadingAnchor.constraint(equalTo: rankingLabel.trailingAnchor, constant: 10),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 308),
            cardView.heightAnchor.constraint(equalToConstant: 80),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
                cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            rankingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rankingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rankingLabel.widthAnchor.constraint(equalToConstant: 35),
            rankingLabel.heightAnchor.constraint(equalToConstant: 80),

            // Констрейнты для avatarImageView
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),

            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            usernameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),

            nftCountLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            nftCountLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }

    func configure(with user: User) {
        rankingLabel.text = Int(user.rating) != nil ? user.rating : "N/A"

        if let imageUrl = URL(string: user.avatar) {
                    avatarImageView.kf.setImage(with: imageUrl)
                }

        usernameLabel.text = user.name
        self.selectionStyle = .none

        nftCountLabel.text = "\(user.nfts.count)"
    }

  }
