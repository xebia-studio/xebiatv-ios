//
//  Constants.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

public typealias GenericJSON = [String: AnyObject]

struct Constants {
    
    struct Segues {
        static let ShowVideoPlayer = "ShowVideoPlayer"
    }
    
    struct StoryboardViewControllerIds {
        static let StoryboardName = NSBundle.mainBundle().objectForInfoDictionaryKey("UIMainStoryboardFile") as! String
        
        static let VideoPlayerViewController = "VideoPlayerViewController"
    }
    
    struct Endpoints {
        
#if DEBUG_ENVIRONMENT
        static let BaseURL = "http://10.7.1.38:9000/"
#elseif DEV_ENVIRONMENT
        static let BaseURL = "https://lv-live-dev.xebia.fr/"
        //static let BaseURL = "https://lv-live-dev.xebia.fr/"
#elseif PREPROD_ENVIRONMENT
        static let BaseURL = "https://lv-live-prp.xebia.fr/"
#elseif RELEASE_ENVIRONMENT
        static let BaseURL = "https://lv-live.xebia.fr/"
#endif
        
        static let ApiBaseEndpoint = "api/"
        static let ActivitiesEndpoint = ApiBaseEndpoint + "activities"
    }
    
    struct ScreenSize {
        static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct Tags {
        struct Page {
            static let Home = "Home"
            static let Video = "Video"
        }
        
        struct Category {

        }
        
        struct Actions {
            static let SelectVideo = "SelectVideo"
        }
    }
}
