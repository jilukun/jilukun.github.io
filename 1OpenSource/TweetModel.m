//
//  TweetModel.m
//  OpenSource
//
//  Created by LZXuan on 15-4-9.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "TweetModel.h"

@implementation TweetModel
- (void)dealloc {
    //头像
    self.portrait = nil;
    //昵称
    self.author = nil;
    //发布内容
    self.body = nil;
    //评论
    self.commentCount = nil;
    //发布图片
    self.imgSmall = nil;
    self.imgBig = nil;
    //发布时间
    self.pubDate = nil;
    [super dealloc];
}
@end
