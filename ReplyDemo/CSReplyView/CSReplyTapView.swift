//
//  CSReplyTapView.swift
//  ReplyDemo
//
//  Created by wong sam on 2021/2/7.
//  点击展示更多

import UIKit
typealias CSReplyTapCallback = (CSReplyVModel)->()
class CSReplyTapView: UIView {
    let marginLeft: CGFloat = 5
    let marginRight: CGFloat = 0
    let marginTop: CGFloat = 10
    let marginBottom: CGFloat = 10
    
    // 事件回调
    fileprivate var loadMoreClickCallback: CSReplyTapCallback?
    // 设置
    var contentFont: UIFont = UIFont.systemFont(ofSize: 13)
    var model: CSReplyVModel = CSReplyVModel()
    // view
    internal let contentView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        bindEvent()
    }
    
    convenience init(model: CSReplyVModel) {
        self.init()
        self.model = model
        loadModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        contentView.font = contentFont
        contentView.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        contentView.numberOfLines = 0
        contentView.textAlignment = .center
        addSubview(contentView)
    }
    
    func setLoadMoreClickCallback(callback: @escaping CSReplyTapCallback) {
        self.loadMoreClickCallback = callback
    }
    
    fileprivate func bindEvent(){
        contentView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(contentViewClick))
        contentView.addGestureRecognizer(gesture)
    }
    
    @objc fileprivate func contentViewClick(){
        guard let callback = loadMoreClickCallback else {
            return
        }
        callback(model)
    }
    
    fileprivate func loadModel(){
        contentView.text = model.content
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(marginLeft)
            make.right.equalTo(-marginRight)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    // 顶部距离
    func getTopMargin() -> CGFloat {
        return self.marginTop + marginBottom
    }
    
    // 获取宽度
    func getContentWidth(selfWidth: CGFloat) -> CGFloat {
        return selfWidth - marginLeft - marginRight
    }

}
