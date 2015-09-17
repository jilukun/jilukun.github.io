//
//  SubjectCell.h
//  LimitFree
//
//  Created by LZXuan on 15-7-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectModel.h"

typedef void (^SubjectJumpBlock)(NSString *appId);

@interface SubjectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *imgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

//保存block  和 model
@property (nonatomic, copy) SubjectJumpBlock myBlock;
@property (nonatomic, strong) SubjectModel *model;

//填充cell 传入block
- (void)showDataWithSubjectModel:(SubjectModel *)subjectModel  jumpBlock:(SubjectJumpBlock)myBlock;

@end








