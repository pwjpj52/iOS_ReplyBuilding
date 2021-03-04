//
//  CSTableViewCell.swift
//  ReplyDemo
//
//  Created by wong sam on 2021/2/18.
//

import UIKit
import SnapKit

class CSTableViewCell: UITableViewCell {
    
    static let reusefulIdentifier = "CSTableViewCell"

    fileprivate var model: CSTableModel = CSTableModel()
    fileprivate var avator: UIImageView = UIImageView(image: UIImage(named: "reply_liked"))
    fileprivate var name: UILabel = UILabel()
    fileprivate var subName: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var replyView: CSReplyView = {
        let rpv = CSReplyView(width: self.bounds.size.width - 70, models: [])
        rpv.backgroundColor = UIColor.white
//        rpview.lineWidth =
        rpv.lineColor =  UIColor.lightGray
        return rpv
    }()
    fileprivate var contentLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    

    
    override func layoutSubviews() {
        addSubview(name)
        addSubview(avator)
        addSubview(subName)
        addSubview(replyView)
        addSubview(contentLabel)
        
        avator.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.width.height.equalTo(50)
        }
        name.snp.makeConstraints { (make) in
            make.left.equalTo(60)
            make.top.equalTo(10)
        }
        subName.snp.makeConstraints { (make) in
            make.left.equalTo(60)
            make.bottom.equalTo(avator.snp.bottom)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(60)
            make.bottom.equalTo(-10)
        }
        
        replyView.snp.makeConstraints { (make) in
            make.left.equalTo(60)
            make.right.equalTo(-10)
            make.top.equalTo(60)
            make.bottom.equalTo(contentLabel.snp.top).offset(-10)
        }
        
    }
    
    func fillData(data: CSTableModel) -> CGFloat  {
        self.model = data
        name.text = data.name
        subName.text = data.subtitle
        contentLabel.text = data.content
        let height = replyView.reLayoutUI(_with: data.replyModel)
        return height + 100.5
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
