//
//  CSReplyVModel.swift
//  ReplyDemo
//
//  Created by wong sam on 2021/2/7.
//

import UIKit

class CSReplyVModel: NSObject {
    enum CSReplyViewType {
        case normal
        case tip
    }
    var replyViewType: CSReplyViewType = .normal
    var name = "杨幂幂"
    var subtitle = "我jiojio很臭哦～～"
    var content = "我老公呢？我老公呢我老公呢我老公呢我老公呢我老公呢我老公呢我老公呢我老公呢"
    var likeCount = 138
    var isLike = false
    
}
