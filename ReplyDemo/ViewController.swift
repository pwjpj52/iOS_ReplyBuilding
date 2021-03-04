//
//  ViewController.swift
//  ReplyDemo
//
//  Created by wong sam on 2021/2/7.
//

import UIKit

class ViewController: UIViewController {
  

    var rpview: CSReplyView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.yellow
        addReplyView()
    }
    
    func addReplyView()  {
        var modelArr = [CSReplyVModel]()
        for _ in 0..<4 {
            let model = CSReplyVModel()
            model.content = "箭头符号怎么打出来↗,看到有些人写的经验在介绍的时候会打上个向右的箭头(→),提醒用户往下一步操作,感觉比单纯的横岗(——)要美观,然后就找"
            modelArr.append(model)
        }
        let model = CSReplyVModel()
        model.content = "点击展开更多 ↓ "
        model.replyViewType = .tip
        modelArr.insert(model, at: 2)
        
        let rpview = CSReplyView(width: 300, models: modelArr)
        // 设置项目
        rpview.maxRectCount = 4
        rpview.backgroundColor = UIColor.white
//        rpview.lineWidth =
        rpview.lineColor =  UIColor.orange
//        rpview.lineMargin = 
        
        rpview.frame = CGRect(x: 100, y: 100, width: 300, height: rpview.caculatedHeight)
        view.addSubview(rpview)
        self.rpview = rpview
        rpview.delegate = self
    }

    @IBAction func jumpClick(_ sender: Any) {
        let vc = CSTableController(style: .grouped)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: CSReplyNormalViewDelegate{
    func csreplyview(_ replyView: CSReplyView, didClickLoadMoreWithModel: CSReplyVModel) {
        var modelArr = [CSReplyVModel]()
        for _ in 0..<4 {
            let model = CSReplyVModel()
            modelArr.append(model)
        }
        let height = replyView.reLayoutUI(_with: modelArr)
        rpview?.frame = CGRect(x: 100, y: 100, width: 300, height: height)
    }
    
    func csreplyview(_ replyView: CSReplyView, didClickUserNameWithModel: CSReplyVModel) {
        
    }
    
    func csreplyview(_ replyView: CSReplyView, didClickLikeWithModel: CSReplyVModel) {
        
    }
    
    func csreplyview(_ replyView: CSReplyView, didClickItemWithModel: CSReplyVModel) {
        
    }
    
}
