//
//  CSReplyView.swift
//  ReplyDemo
//
//  Created by wong sam on 2021/2/7.
//

import UIKit
import SnapKit

protocol CSReplyNormalViewDelegate: class{
    // 点击加载更多
    func csreplyview(_ replyView: CSReplyView, didClickLoadMoreWithModel:CSReplyVModel)
    // 点击用户名
    func csreplyview(_ replyView: CSReplyView, didClickUserNameWithModel:CSReplyVModel)
    // 点击点赞
    func csreplyview(_ replyView: CSReplyView, didClickLikeWithModel:CSReplyVModel)
    // 点击整个区域
    func csreplyview(_ replyView: CSReplyView, didClickItemWithModel:CSReplyVModel)
}

class CSReplyView: UIView {
    
    var lineWidth: CGFloat = 1
    var lineMargin: CGFloat = 2
    var maxRectCount = 4 // 超过4层就画线段
    var lineColor: UIColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
    var replyFont: UIFont = UIFont.systemFont(ofSize: 13)
    // 计算后的高度
    open var caculatedHeight: CGFloat = 0
    weak var delegate: CSReplyNormalViewDelegate?
    
    
    fileprivate var shouldDraw = false
    fileprivate var models = [CSReplyVModel]()
    fileprivate var maxWidth: CGFloat = 300
    lazy var replyViewArr: [CSReplyTapView] = {
        return [CSReplyTapView]()
    }()
    
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// 传入新的评论，重新绘画
    func reLayoutUI(_with modelArr: [CSReplyVModel]) -> CGFloat {

//        backgroundColor = self.backgroundColor
//        setNeedsDisplay()
        for item in replyViewArr {
            item.removeFromSuperview()
        }
        replyViewArr.removeAll()
        models = modelArr
        for item in models {
            if item.replyViewType == .normal {
                addNormalView(model: item)
            }else{
                addTipView(model: item)
            }
        }
        layoutReplys()
        return caculatedHeight
    }
    
    
//    convenience init(width: CGFloat, test: Int) {
//        self.init()
//        self.maxWidth = width
//        addTipView()
//        for _ in 0..<test {
//            addNormalView()
//        }
//        layoutReplys()
//    }
    
    convenience init(width: CGFloat,
                     models: [CSReplyVModel]) {
        self.init()
        self.models = models
        self.maxWidth = width
        for item in models {
            if item.replyViewType == .normal {
                addNormalView(model: item)
            }else{
                addTipView(model: item)
            }
        }
        layoutReplys()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
//MARK: - 添加一个普通回复层
    func addNormalView(model: CSReplyVModel)  {
        let normalV = CSReplyNormalView(model: model)
        normalV.contentFont = replyFont
        normalV.setItemClickCallback {  [weak self](model) in
            print("item click")
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.csreplyview(strongSelf, didClickItemWithModel: model)
        }
        normalV.setNameViewClickCallback {  [weak self](model) in
            print("name click")
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.csreplyview(strongSelf, didClickUserNameWithModel: model)
        }
        normalV.setLikeButtonClickCallback {  [weak self](model) in
            print("like click")
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.csreplyview(strongSelf, didClickLikeWithModel: model)
        }
        replyViewArr.append(normalV)
        addSubview(normalV)
    }
    
//MARK: - 添加一个“点击展开更多”层
    func addTipView(model: CSReplyVModel)  {
        let tipV = CSReplyTapView(model: model)
        tipV.contentFont = replyFont
        tipV.setLoadMoreClickCallback { [weak self](model) in
            // 点击加载更多
            guard let strongSelf = self else {
                return
            }
            print("user click load more")
            strongSelf.delegate?.csreplyview(strongSelf , didClickLoadMoreWithModel: model)
        }
        replyViewArr.append(tipV)
        addSubview(tipV)
    }
    
//MARK: - 布局subview，计算总高度
    func layoutReplys()  {
        let offsetCount = replyViewArr.count > 5 ? 5 : replyViewArr.count
        let marginBottom: CGFloat = 10
        let marginLeft = CGFloat(offsetCount) * (lineWidth + lineMargin)
        var marginTop = CGFloat(offsetCount) * (lineWidth + lineMargin)
        let replyViewWidth: CGFloat = maxWidth - 2 * marginLeft // replyview宽度
        
        for item in replyViewArr {
            let text = item.model.content
            let constraint = CGSize(width: item.getContentWidth(selfWidth: replyViewWidth),height: 0)
            let attributes:NSDictionary = NSDictionary(object:replyFont,
                                                       forKey: NSAttributedString.Key.font as NSCopying)
            let size = text.boundingRect(with: constraint,
                                         options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                         attributes:attributes as? [NSAttributedString.Key : Any], context: nil)
            item.snp.makeConstraints { (make) in
                make.top.equalTo(marginTop)
                make.height.equalTo(marginBottom + size.height + item.getTopMargin())
                make.right.equalTo(-marginLeft)
                make.left.equalTo(marginLeft)
            }
            marginTop += size.height + item.getTopMargin() + marginBottom
//            item.sizeToFit()
        }
        shouldDraw = true
        caculatedHeight = marginTop
        setNeedsDisplay()
    }
    
//MARK: - 画线，显示出层级
    override func draw(_ rect: CGRect) {
   
        if !shouldDraw {
            return
        }
        shouldDraw = false
        guard let context = UIGraphicsGetCurrentContext() else{
            return
        }
        
        context.setLineCap(CGLineCap.square)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
        
        var index = 0
        
        for item in replyViewArr.reversed() {
            if index >= maxRectCount {
                // 中间画一条线
                let count = CGFloat(maxRectCount)
                let startX = count * (lineWidth + lineMargin) - 2
                let endX = maxWidth - count * (lineWidth + lineMargin) + 2
                let startY = item.frame.maxY
                context.move(to: CGPoint(x: startX, y: startY))
                context.addLine(to: CGPoint(x: endX, y: startY))
                context.strokePath()
            }else{
                let bottom = item.frame.maxY - CGFloat(index) * (lineWidth + lineMargin)
                let x = CGFloat(index) * (lineWidth + lineMargin)
                let y = CGFloat(index) * (lineWidth + lineMargin)
                let width = maxWidth - 2*x
                
                let path = UIBezierPath(rect: CGRect(x: x, y: y, width: width, height: bottom))
                lineColor.setStroke()
                UIColor.clear.setFill()
                path.stroke()
                path.fill()
                context.strokePath();
                index += 1
            }
        }
    }


}
