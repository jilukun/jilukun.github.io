//
//  SubjectCell.m
//  LimitFree
//
//  Created by LZXuan on 15-7-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "SubjectCell.h"
#import "SubjectAppView.h"
#import "UIImageView+WebCache.h"

@implementation SubjectCell

- (void)awakeFromNib {
    //取消cell 选中风格
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    //初始化的时候 创建四个AppView
    CGFloat width = self.frame.size.width-self.imgImageView.frame.size.width-self.imgImageView.frame.origin.x;
    CGFloat height = self.imgImageView.frame.size.height/4;
    CGFloat x = self.imgImageView.frame.size.width+self.imgImageView.frame.origin.x;
    CGFloat y = self.imgImageView.frame.origin.y;
    for (NSInteger i = 0; i < 4; i++) {
        //去沙盒中加载 xib SubjectAppView
        SubjectAppView *appView = [[[NSBundle mainBundle] loadNibNamed:@"SubjectAppView" owner:nil options:nil] lastObject];
        appView.frame = CGRectMake(x, y+i*height, width, height);
        //增加事件
        [appView addTarget:self action:@selector(appViewClick:)];
        appView.tag = 101+i;
        [self.contentView addSubview:appView];
    }
}
//点击AppView 触发
- (void)appViewClick:(SubjectAppView *)appView {
    //实现 界面跳转 跳转到详情
    //cell 委托 所在的视图控制器 实现界面跳转
    //需要采用 代理设计模式
    //block 回调的形式实现
    
    //SubjectModel 中有一个数组，数组中存放的四个AppView 的数据
    if (self.myBlock) {
        //传值  appId
        AppModel *appModel = self.model.applications[appView.tag-101];
        //调用block
        self.myBlock(appModel.applicationId);
    }

}
//填充SubjectCell
- (void)showDataWithSubjectModel:(SubjectModel *)subjectModel jumpBlock:(SubjectJumpBlock)myBlock {
    //保存
    self.model = subjectModel;
    self.myBlock = myBlock;
    
    [self.contentView sendSubviewToBack:self.backImageView];
    
    self.name.text = subjectModel.title;
    [self.imgImageView sd_setImageWithURL:[NSURL URLWithString:subjectModel.img] placeholderImage:[UIImage imageNamed: @"topic_TopicImage_Default"]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:subjectModel.desc_img] placeholderImage:[UIImage imageNamed: @"topic_Header"]];
    self.textView.editable = NO;
    self.textView.text = subjectModel.desc;
    
    //对右侧 四个appView 赋值
    for (NSInteger i = 0; i < 4; i++) {
        SubjectAppView *appView = (SubjectAppView *)[self.contentView viewWithTag:101+i];
        if (i < subjectModel.applications.count) {
            appView.hidden = NO;//显示
            //获取AppModel
            AppModel *appModel = subjectModel.applications[i];
            [appView showDataWithAppModel:appModel];
        }else{
            appView.hidden = YES;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
