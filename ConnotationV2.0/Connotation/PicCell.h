//
//  PicCell.h
//  Connotation
//
//  Created by LZXuan on 15-5-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnotationModel.h"

typedef void (^JumpBlock)(ConnotationModel *model);

@interface PicCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *updateLabel;
@property (retain, nonatomic) IBOutlet UILabel *wbodyLabel;
@property (retain, nonatomic) IBOutlet UIImageView *wpicImageView;
@property (retain, nonatomic) IBOutlet UIButton *likesButton;
@property (retain, nonatomic) IBOutlet UIButton *commentsButton;
//分类
@property (nonatomic,copy) NSString *catetory;
@property (nonatomic, retain) ConnotationModel *model;
//填充cell
- (void)showDataWithModel:(ConnotationModel *)model;

//点赞
- (IBAction)likeClick:(UIButton *)sender;
- (IBAction)commentClick:(UIButton *)sender;

//设置block  用于回调
- (void)setMyBlock:(JumpBlock)block;
- (JumpBlock)myBlock;

@end




