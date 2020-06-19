//
//  cellSizesContant.swift
//  UnSplashSocket
//
//  Created by AppZoro Technologies on 08/05/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import Foundation
import  UIKit

struct  JobRequestCellHeight
{
    static let cellSize = CGSize(width: (Device.ScreenWidth/2)-40, height: (Device.ScreenWidth/2)-40)
    static let cellSizeForSmallDevice = CGSize(width: (Device.ScreenWidth/2)/1.60, height: (Device.ScreenWidth/2)/1.60)
    static let cellSpacing:CGFloat = 20
    static let cellLineSpacing:CGFloat = 50
}

struct HomeTblSectionHeight
{
    static let cellHeight:CGFloat = 50.0
}

struct FavouriteTblSectionHeight
{
    static let cellHeight:CGFloat = 60
}

struct NotificationTbl
{
    static let cellHeight:CGFloat = UITableViewAutomaticDimension
    static let estimateRowHeight:CGFloat = 100
}

struct HomeTblRooms
{
    static let cellHeight = (Device.ScreenHeight/2)+100
}

