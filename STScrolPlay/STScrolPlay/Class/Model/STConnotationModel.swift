//
//  STConnotationModel.swift
//  STScrolPlay
//
//  Created by xiudou on 2017/7/27.
//  Copyright © 2017年 CoderST. All rights reserved.
//

import UIKit

class STConnotationModel: BaseModel {

    var message: String = ""
    
    var data: DataDict?
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "data" {
            guard let valueDict = value as? [String : Any] else { return }
            data = DataDict(dict: valueDict)
        }else{
            
            super.setValue(value, forUndefinedKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
class DataDict: BaseModel {
    
    var has_more: Bool = false
    
    var min_time: Int = 0
    
    var has_new_message: Bool = false
    
    var max_time: Double = 0
    
    var data: [DataArray] = [DataArray]()
    
    var tip: String = ""
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "data" {
            guard let valueDict = value as? [[String : Any]] else { return }
            for dict in valueDict{
                let model = DataArray(dict: dict)
                if model.group?.mp4_url != nil && model.group!.mp4_url.characters.count > 0{
                    
                    data.append(model)
                }else{
                    print("没有mp4_url-----")
                }
                
            }
            
        }else{
            
            super.setValue(value, forUndefinedKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class DataArray: BaseModel {
    
    var group: Group?
    
    var display_time: Int = 0
    
    var type: Int = 0
    
    var online_time: Int = 0
    
    var comments: [String]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "group" {
            guard let valueDict = value as? [String : Any] else { return }
            group = Group(dict: valueDict)
        }else{
            
            super.setValue(value, forUndefinedKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}

class Group: BaseModel {
    
    var user_favorite: Int = 0
    
    var user: User?
    
    var publish_time: String = ""
    
    var uri: String = ""
    
    var ID: Int = 0
    
    var origin_video: Origin_Video?
    
    var play_count: Int = 0
    
    var display_type: Int = 0
    
    var group_id: Int = 0
    
    var category_visible: Bool = false
    
    var title: String = ""
    
    var flash_url: String = ""
    
    var user_repin: Int = 0
    
    var cover_image_uri: String = ""
    
    var status_desc: String = ""
    
    var status: Int = 0
    
    var dislike_reason: [Dislike_Reason]?
    
    var repin_count: Int = 0
    
    var cover_image_url: String = ""
    
    var digg_count: Int = 0
    
    var share_count: Int = 0
    
    var type: Int = 0
    
    var video_width: Int = 0
    
    var neihan_hot_start_time: String = ""
    
    var is_video: Int = 0
    
    var has_hot_comments: Int = 0
    
    var comment_count: Int = 0
    
    var go_detail_count: Int = 0
    
    var favorite_count: Int = 0
    
    var large_cover: Large_Cover?
    
    var text: String = ""
    
    var online_time: Int = 0
    
    var category_name: String = ""
    
    var download_url: String = ""
    
    var create_time: Int = 0
    
    var category_id: Int = 0
    
    var user_digg: Int = 0
    
    var category_type: Int = 0
    
    var share_url: String = ""
    
    var is_anonymous: Bool = false
    
    var quick_comment: Bool = false
    
    var bury_count: Int = 0
    
    var media_type: Int = 0
    
    var user_bury: Int = 0
    
    var medium_cover: Medium_Cover?
    
    var share_type: Int = 0
    
    var duration: Double = 0
    
    var video480p : Video_480P?
    
    var video360p: Video_360P?
    
    var video720p: Video_720P?
    
    var video_height: Int = 0
    
    var is_public_url: Int = 0
    
    var content: String = ""
    
    var video_id: String = ""
    
    var neihan_hot_end_time: String = ""
    
    var is_can_share: Int = 0
    
    var is_neihan_hot: Bool = false
    
    var mp4_url: String = ""
    
    var has_comments: Int = 0
    
    var keywords: String = ""
    
    var m3u8_url: String = ""
    
    var label: Int = 0
    
    var id_str: String = ""
    
    var allow_dislike: Bool = false
    
    var danmaku_attrs: Danmaku_Attrs?
    
}

class Large_Cover: BaseModel {
    
    var url_list: [UrlList]?
    
    var uri: String?
    
}

class UrlList: BaseModel {
    
    var url: String?
    
}

class Video_480P: NSObject {
    
    var url_list: [UrlList]?
    
    var width: Int = 0
    
    var uri: String?
    
    var height: Int = 0
    
}

class Danmaku_Attrs: BaseModel {
    
    var allow_send_danmaku: Int = 0
    
    var allow_show_danmaku: Int = 0
    
}

class Origin_Video: BaseModel {
    
    var url_list: [UrlList]?
    
    var width: Int = 0
    
    var uri: String?
    
    var height: Int = 0
    
}


class Video_720P: BaseModel {
    
    var url_list: [UrlList]?
    
    var width: Int = 0
    
    var uri: String?
    
    var height: Int = 0
    
}



class Video_360P: BaseModel {
    
    var url_list: [UrlList]?
    
    var width: Int = 0
    
    var uri: String?
    
    var height: Int = 0
    
}



class Medium_Cover: BaseModel {
    
    var url_list: [UrlList]?
    
    var uri: String?
    
}



class User: BaseModel {
    
    var user_verified: Bool = false
    
    var ugc_count: Int = 0
    
    var is_following: Bool = false
    
    var followers: Int = 0
    
    var user_id: Int = 0
    
    var followings: Int = 0
    
    var is_pro_user: Bool = false
    
    var name: String?
    
    var avatar_url: String?
    
}

class Dislike_Reason: BaseModel {
    
    var type: Int = 0
    
    var ID: Int = 0
    
    var title: String?
    
}


