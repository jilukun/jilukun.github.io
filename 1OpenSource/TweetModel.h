//
//  TweetModel.h
//  OpenSource
//
//  Created by LZXuan on 15-4-9.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "LZXObject.h"

@interface TweetModel : LZXObject
//头像
@property (nonatomic,copy) NSString *portrait;
//昵称
@property (nonatomic,copy) NSString *author;
//发布内容
@property (nonatomic,copy) NSString *body;
//评论
@property (nonatomic,copy) NSString *commentCount;
//发布图片
@property (nonatomic,copy) NSString *imgSmall;
@property (nonatomic,copy) NSString *imgBig;
//发布时间
@property (nonatomic,copy) NSString *pubDate;
@end
