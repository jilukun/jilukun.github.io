//
//  SubjectAppView.m
//  LimitFree
//
//  Created by LZXuan on 15-7-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "SubjectAppView.h"
#import "UIImageView+WebCache.h"

@interface SubjectAppView()
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@end

@implementation SubjectAppView
- (void)addTarget:(id)target action:(SEL)action{
    //保存
    self.target = target;
    self.action = action;
}

//点击屏幕 手指离开触发
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //点击 AppView  处理事件
    if ([self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action withObject:self];
    }
}
- (void)awakeFromNib {
   //xib 初始化对象的时候调用
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 5;
}
//填充 view
- (void)showDataWithAppModel:(AppModel *)appModel {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:appModel.iconUrl] placeholderImage:[UIImage imageNamed: @"topic_Header"]];
    self.nameLabel.text = appModel.name;
    self.downloadLabel.text = appModel.downloads;
    self.commentLabel.text = @"0";//服务器没给数据
    //星级
    [self.starLevelView setStarLevel:appModel.starOverall.doubleValue];
}



@end










