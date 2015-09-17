//
//  TweetCell.h
//  OpenSource
//
//  Created by LZXuan on 15-4-9.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetModel.h"

@interface TweetCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *portraitImagView;
@property (retain, nonatomic) IBOutlet UILabel *authorLabel;
@property (retain, nonatomic) IBOutlet UILabel *bodyLabel;
@property (retain, nonatomic) IBOutlet UILabel *commentLabel;
@property (retain, nonatomic) IBOutlet UIImageView *imgSmall;
@property (retain, nonatomic) IBOutlet UILabel *pubDateLabel;
//填充cell
- (void)showDataWithModel:(TweetModel *)model;
@end



