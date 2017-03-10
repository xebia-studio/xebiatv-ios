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
        static let ShowDetails = "ShowDetails"
        static let ShowVideoPlayer = "ShowVideoPlayer"
    }
    
    struct StoryboardViewControllerIds {
        static let StoryboardName = Bundle.main.object(forInfoDictionaryKey: "UIMainStoryboardFile") as! String
        
        static let VideoPlayerViewController = "VideoPlayerViewController"
    }
    
    struct Configuration {
        static let YoutubeAPIKey = "AIzaSyBYP5QWmQAEJxva6dD55jDbJSJGfMX2Row"
        static let PrivateVideoKey = "Private video"
        static let NumCellsVisible = 3
    }
    
    struct Endpoints {
        static let BaseURL = "https://xebiatv.herokuapp.com/"
        static let YoutubeBaseURL = "https://www.googleapis.com/youtube/v3/"
        static let CategoriesListEndpoint = "categories/"
        static let PlaylistItemsEndpoint = "playlistItems/"
        static let VideoEndpoint = "video/"
    }
    
    struct MenuKeys {
        static let CategoriesKey = "categories"
        static let FundationsKey = "fundations"
    }
    
    struct ScreenSize {
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
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
