import UIKit
import Kingfisher

final class UserTableViewCell: UITableViewCell {
    
    private lazy var rankingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let cardView: UIView = {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .ypLightGrey
        cardView.layer.cornerRadius = 12
        return cardView
    }()
    
    private let avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.cornerRadius = 14
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()
    
    private let usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = .boldSystemFont(ofSize: 22)
        return usernameLabel
    }()
    
    private let nftCountLabel: UILabel = {
        let nftCountLabel = UILabel()
        nftCountLabel.translatesAutoresizingMaskIntoConstraints = false
        nftCountLabel.font = .boldSystemFont(ofSize: 22)
        return nftCountLabel
    }()
    
    private let spacerView: UIView = {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        return spacerView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        contentView.addSubview(spacerView)
        contentView.addSubview(cardView)
        contentView.addSubview(rankingLabel)
        contentView.addSubview(avatarImageView)
        cardView.addSubview(usernameLabel)
        cardView.addSubview(nftCountLabel)
    }
    
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        addSubViews()
        applyConstraints()
    }
    
    
    func applyConstraints() {
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
            
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),
            
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            usernameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            nftCountLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            nftCountLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            spacerView.heightAnchor.constraint(equalToConstant: 8),
            spacerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            spacerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            
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
