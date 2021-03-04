//
//  CSReplyNormalView.swift
//  ReplyDemo
//
//  Created by wong sam on 2021/2/7.
//

import SnapKit
import UIKit


class CSReplyNormalView: CSReplyTapView {
    
    fileprivate let titleView = UILabel()
    fileprivate let subTitleView = UILabel()
    fileprivate let likeBtn = UIButton(type: .custom)

    fileprivate var nameViewClickCallback: CSReplyTapCallback?
    fileprivate var likeButtonClickCallback: CSReplyTapCallback?
    fileprivate var itemClickCallback: CSReplyTapCallback?
   
    /// 顶部距离
    override func getTopMargin() -> CGFloat {
        // 38 是标题和子标题占用的高度
        return self.marginTop + 38 + marginBottom
    }
    
    /// 获取宽度
    override func getContentWidth(selfWidth: CGFloat) -> CGFloat {
        return selfWidth - marginLeft - marginRight
    }
    
  
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private override init() {
        super.init(frame: .zero)
        setupUI()
        bindEvents()
    }
    
    convenience init(model: CSReplyVModel) {
        self.init()
        self.model = model
        loadModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    fileprivate func setupUI(){
        titleView.font = UIFont.systemFont(ofSize: 13)
        titleView.numberOfLines = 1
        titleView.lineBreakMode = .byTruncatingTail
        titleView.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        subTitleView.font = UIFont.systemFont(ofSize: 10)
        subTitleView.textColor = #colorLiteral(red: 0.7490196078, green: 0.7490196078, blue: 0.7490196078, alpha: 1)
        likeBtn.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
        likeBtn.setTitleColor(#colorLiteral(red: 0.8470588235, green: 0.1176470588, blue: 0.02352941176, alpha: 1), for: .selected)
        likeBtn.setImage(UIImage.init(named: "reply_like"), for: .normal)
        likeBtn.setImage(UIImage.init(named: "reply_liked"), for: .selected)
        likeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        likeBtn.semanticContentAttribute = .forceRightToLeft
        likeBtn.imageView?.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        contentView.font = contentFont
        contentView.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        contentView.numberOfLines = 0
        contentView.textAlignment = .left
        addSubview(titleView)
        addSubview(subTitleView)
        addSubview(likeBtn)
        addSubview(contentView)
    }
    
    
    fileprivate func loadModel(){
        let title = model.likeCount > 999 ? "999+" : "\(model.likeCount)"
        likeBtn.setTitle(title, for: .normal)
        titleView.text = model.name
        subTitleView.text = model.subtitle
        contentView.text = model.content
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        likeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(marginTop)
            make.right.equalTo(-marginRight)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        
        titleView.snp.makeConstraints { (make) in
            make.left.equalTo(marginLeft)
            make.top.equalTo(marginTop)
            make.right.equalTo(likeBtn.snp.left)
        }
        
        subTitleView.snp.makeConstraints { (make) in
            make.left.equalTo(marginLeft)
            make.top.equalTo(titleView.snp.bottom).offset(marginTop)
            make.right.equalTo(likeBtn.snp.left)
        }
        
        contentView.snp.remakeConstraints { (make) in
            make.left.equalTo(marginLeft)
            make.right.equalTo(-marginRight)
            make.top.equalTo(subTitleView.snp.bottom).offset(marginTop)
        }
        
    }
}

//MARK: - 事件
extension CSReplyNormalView {
    
    fileprivate func bindEvents(){
        titleView.isUserInteractionEnabled = true
        let titlegesture = UITapGestureRecognizer(target: self, action: #selector(nameViewClick))
        titleView.addGestureRecognizer(titlegesture)
        
        likeBtn.isUserInteractionEnabled = true
        let likegesture = UITapGestureRecognizer(target: self, action: #selector(likeButtonClick))
        likeBtn.addGestureRecognizer(likegesture)
        
        self.isUserInteractionEnabled = true
        let itemgesture = UITapGestureRecognizer(target: self, action: #selector(itemClick))
        self.addGestureRecognizer(itemgesture)
    }
    
    @objc fileprivate func nameViewClick(){
        guard let callback = nameViewClickCallback else {
            return
        }
        callback(model)
    }
    
    @objc fileprivate func likeButtonClick(){
        
        likeBtn.isSelected = !likeBtn.isSelected
        if likeBtn.isSelected {
            model.likeCount += 1
        }else{
            model.likeCount -= 1
        }
        let likeTitle = model.likeCount > 999 ? "999+" : "\(model.likeCount)"
        likeBtn.setTitle(likeTitle, for: .normal)
        likeBtn.setTitle(likeTitle, for: .selected)

        guard let callback = likeButtonClickCallback else {
            return
        }
        callback(model)
    }
    
    @objc fileprivate func itemClick(){
        guard let callback = itemClickCallback else {
            return
        }
        callback(model)
    }
    
    func setNameViewClickCallback(callback: @escaping CSReplyTapCallback) {
        self.nameViewClickCallback = callback
    }
    
    func setLikeButtonClickCallback(callback: @escaping CSReplyTapCallback) {
        self.likeButtonClickCallback = callback
    }
    
    func setItemClickCallback(callback: @escaping CSReplyTapCallback) {
        self.itemClickCallback = callback
    }
}
