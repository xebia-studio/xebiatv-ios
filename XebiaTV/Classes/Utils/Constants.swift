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
        static let BaseURL = "https://xebiatv.herokuapp.com/"
        static let YoutubeBaseURL = "https://www.googleapis.com/youtube/v3/"
        static let CategoriesListEndpoint = "categories"
        static let PlaylistItemsEndpoint = "playlistItems"
    }
    
    struct MenuKeys {
        static let CategoriesKey = "categories"
        static let FundationsKey = "fundations"
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
