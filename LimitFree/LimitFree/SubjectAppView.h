//
//  SubjectAppView.h
//  LimitFree
//
//  Created by LZXuan on 15-7-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarLevelView.h"
#import "AppModel.h"
@interface SubjectAppView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet StarLevelView *starLevelView;

//增加点击事件
- (void)addTarget:(id)target action:(SEL)action;
//填充 AppView
- (void)showDataWithAppModel:(AppModel *)appModel;

@end













