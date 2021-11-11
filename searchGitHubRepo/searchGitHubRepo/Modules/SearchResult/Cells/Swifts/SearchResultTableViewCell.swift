//
//  SearchResultTableViewCell.swift
//  searchGitHubRepo
//
//  Created by Phyo Kyaw Swar on 10/11/2021.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvater: UIImageView!
    @IBOutlet weak var lblRepoName: UILabel!
    @IBOutlet weak var lblAuthorName: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblStars: UILabel!
    @IBOutlet weak var lblForks: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - setup cell data
    func setupCell(item : Item?) {
        DispatchQueue.main.async {
            if let image = try? UIImage(data: Data(contentsOf: URL(string: item?.owner?.avatarURL ?? "")!)){
                self.imgAvater.image = image
            }
        }
        lblRepoName.text = item?.fullName ?? ""
        lblAuthorName.text = "Author : \(item?.owner?.login ?? "")"
        lblLanguage.text = "Language : \(item?.language ?? "")"
        lblStars.text = "\(item?.stargazersCount ?? 0)"
        lblForks.text = "\(item?.forksCount ?? 0)"
        
    }
    
    // MARK: - setup ui and font
    private func setupUI() {
        self.imgAvater.layer.cornerRadius = 40
        self.imgAvater.layer.borderColor = UIColor.darkGray.cgColor
        self.imgAvater.clipsToBounds = true
        self.imgAvater.layer.borderWidth = 1
        
        lblRepoName.font = .robotoBoldFont
        lblRepoName.textColor = .black
        lblRepoName.numberOfLines = 0
        lblAuthorName.font = .robotoRegularFont
        lblAuthorName.textColor = .darkGray
        lblAuthorName.numberOfLines = 0
        lblLanguage.font = .robotoRegularFont
        lblLanguage.textColor = .darkGray
        lblLanguage.numberOfLines = 0
        lblStars.font = .robotoRegularFont
        lblStars.textColor = .darkGray
        lblForks.font = .robotoRegularFont
        lblForks.textColor = .darkGray
    }
    
}
