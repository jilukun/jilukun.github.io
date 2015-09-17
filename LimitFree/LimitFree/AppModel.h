//
//  AppModel.h
//  LimitFree
//
//  Created by LZXuan on 15-7-23.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "LZXModel.h"
//数据 模型
@interface AppModel : LZXModel
@property (nonatomic, copy) NSString *applicationId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *releaseDate;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *itunesUrl;
@property (nonatomic, copy) NSString *starCurrent;
@property (nonatomic, copy) NSString *starOverall;
@property (nonatomic, copy) NSString *ratingOverall;
@property (nonatomic, copy) NSString *downloads;
@property (nonatomic, copy) NSString *currentPrice;
@property (nonatomic, copy) NSString *lastPrice;
@property (nonatomic, copy) NSString *priceTrend;
@property (nonatomic, copy) NSString *expireDatetime;
@property (nonatomic, copy) NSString *fileSize;
@property (nonatomic, copy) NSString *shares;
@property (nonatomic, copy) NSString *favorites;

@property (nonatomic ,copy) NSString *description;

@end
/*
 "applications": [
 {
 "applicationId": "455680974",
 "slug": "rhythm-repeat",
 "name": "节奏重复",
 "releaseDate": "2014-07-01",
 "version": "2.3",
 "description": "界面清新简单的音乐节奏游戏。游戏的操作非常简单，只需根据提示依次点击相应的图标即可，共有三种乐曲选择。",
 "categoryId": 6014,
 "categoryName": "Game",
 "iconUrl": "http://photo.candou.com/i/114/55b07f3725eae8b3cafc9bce10d16e46",
 "itunesUrl": "http://itunes.apple.com/cn/app/rhythm-repeat/id455680974?mt=8",
 "starCurrent": "4.0",
 "starOverall": "4.0",
 "ratingOverall": "0",
 "downloads": "3625",
 "currentPrice": "0",
 "lastPrice": "12",
 "priceTrend": "limited",
 "expireDatetime": "2015-07-24 05:12:51.0",
 "releaseNotes": "Multi-Touch bug fixed",
 "updateDate": "2014-10-17 15:45:27",
 "fileSize": "16.69",
 "ipa": "1",
 "shares": "390",
 "favorites": "273"
 },
  */
