//
//  Constant.swift
//  MelbourneDining
//
//  Created by Duy Thuc Pham on 4/19/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import Foundation
import UIKit

struct Constant {
    static let baseURL = "https://data.melbourne.vic.gov.au/resource/q8hp-qgps.json?"
    static let appToken = "GxusT0nELv09s1GmHnb1osV1d"
    
    static let SCALE_VALUE_HEIGHT_DEVICE = (DeviceType.IS_IPAD ? 1.8 : (DeviceType.IS_IPHONE_6 ? 1.174 : (DeviceType.IS_IPHONE_6P ? 1.295 : 1.0))) as CGFloat
    
    static let SCALE_VALUE_WIDTH_DEVICE  = (DeviceType.IS_IPAD ? 2.4 : (DeviceType.IS_IPHONE_6 ? 1.171 : (DeviceType.IS_IPHONE_6P ? 1.293 : 1.0))) as CGFloat
    
    static let FONT_SCALE_VALUE          = (DeviceType.IS_IPAD ? 1.5 : (DeviceType.IS_IPHONE_6P ? 1.2 : (DeviceType.IS_IPHONE_6 ? 1.1 : 1.0))) as CGFloat
    
    static let RATIO_WIDTH               = (DeviceType.IS_IPHONE_6 ? 1.0 : ScreenSize.SCREEN_WIDTH / 375.0)
    
    static let RATIO_HEIGHT              = (DeviceType.IS_IPHONE_6 ? 1.0 : ScreenSize.SCREEN_HEIGHT / 667.0)
}


// get screen size
struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

// get device type
struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}
