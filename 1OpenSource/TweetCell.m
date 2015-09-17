//
//  TweetCell.m
//  OpenSource
//
//  Created by LZXuan on 15-4-9.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+WebCache.h"

@implementation TweetCell

- (void)awakeFromNib
{
    // Initialization code
    //行数  初始化 圆角
    self.bodyLabel.numberOfLines = 0;
    self.portraitImagView.layer.masksToBounds = YES;
    self.portraitImagView.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDataWithModel:(TweetModel *)model {
    //头像
    [self.portraitImagView sd_setImageWithURL:[NSURL URLWithString:model.portrait]];
    self.authorLabel.text = model.author;
    self.commentLabel.text = model.commentCount;
    
    //发布的内容
    self.bodyLabel.text = model.body;
    //修改label 的高
    CGRect bodyFrame = self.bodyLabel.frame;
    //动态计算高度
    bodyFrame.size.height = [LZXHelper textHeightFromTextString:self.bodyLabel.text width:235 fontSize:14];
    self.bodyLabel.frame = bodyFrame;
    
    if (model.imgSmall.length) {
        //有图片
        self.imgSmall.hidden = NO;
        CGFloat imageY = CGRectGetMaxY(bodyFrame);
        
        CGRect imageFrame = self.imgSmall.frame;
        imageFrame.origin.y = 5+imageY;//和body 有 5像素间隔
        self.imgSmall.frame = imageFrame;
        [self.imgSmall sd_setImageWithURL:[NSURL URLWithString:model.imgSmall]];
        //修改发布日期位置
        
        CGRect dateFrame = self.pubDateLabel.frame;
        dateFrame.origin.y = 5 + CGRectGetMaxY(imageFrame);
        self.pubDateLabel.frame = dateFrame;
        self.pubDateLabel.text = model.pubDate;
    
    }else {
        //没有图片
        self.imgSmall.hidden = YES;
        
        CGRect dateFrame = self.pubDateLabel.frame;
        dateFrame.origin.y = 5 + CGRectGetMaxY(bodyFrame);
        self.pubDateLabel.frame = dateFrame;
        self.pubDateLabel.text = model.pubDate;
    }
}

- (void)dealloc {
    [_portraitImagView release];
    [_authorLabel release];
    [_bodyLabel release];
    [_commentLabel release];
    [_imgSmall release];
    [_pubDateLabel release];
    [super dealloc];
}
@end
