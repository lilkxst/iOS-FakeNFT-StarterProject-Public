import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {

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

            rankingLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(rankingLabel)

            avatarImageView.translatesAutoresizingMaskIntoConstraints = false
            avatarImageView.layer.cornerRadius = 20
            avatarImageView.clipsToBounds = true
            contentView.addSubview(avatarImageView)

            usernameLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(usernameLabel)

            nftCountLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(nftCountLabel)

            NSLayoutConstraint.activate([

                rankingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                rankingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

                avatarImageView.leadingAnchor.constraint(equalTo: rankingLabel.trailingAnchor, constant: 10),
                avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                avatarImageView.widthAnchor.constraint(equalToConstant: 40),
                avatarImageView.heightAnchor.constraint(equalToConstant: 40),

                usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
                usernameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

                nftCountLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 10),
                nftCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                nftCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }

    func configure(with user: User) {
        rankingLabel.text = user.rating

        if let imageUrl = URL(string: user.avatar) {
                    avatarImageView.kf.setImage(with: imageUrl)
                }

        usernameLabel.text = user.name

        nftCountLabel.text = "NFTs: \(user.nfts.count)"
    }

  }
