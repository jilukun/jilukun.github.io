//
//  VideoModel.m
//  Connotation
//
//  Created by LZXuan on 15-5-26.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
- (void)dealloc {
    self.wid = nil;
    self.update_time = nil;
    self.wbody = nil;
    self.comments = nil;
    self.likes = nil;
    
    self.vpic_small = nil;
    self.vpic_middle = nil;
    self.vplay_url = nil;
    self.vsource_url = nil;
    [super dealloc];
}
@end
