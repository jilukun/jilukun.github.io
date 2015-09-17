//
//  ConnotationModel.m
//  Connotation
//
//  Created by LZXuan on 15-5-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "ConnotationModel.h"

@implementation ConnotationModel
- (void)dealloc {
    self.wid= nil;
    self.update_time= nil;
    self.wbody= nil;
    self.comments= nil;
    self.likes= nil;
    self.wpic_m_width= nil;
    self.wpic_m_height= nil;
    self.is_gif= nil;
    self.wpic_small= nil;
    self.wpic_middle= nil;
    self.wpic_large= nil;
    [super dealloc];
}
@end
