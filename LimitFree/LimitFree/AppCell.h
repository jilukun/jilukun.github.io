//
//  AppCell.h
//  LimitFree
//
//  Created by LZXuan on 15-7-23.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarLevelView.h"
#import "AppModel.h"

@interface AppCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet StarLevelView *starLevelView;
@property (weak, nonatomic) IBOutlet UILabel *sharesLabel;
@property (nonatomic, copy) NSString *categoryType;

- (void)showDataWithModel:(AppModel *)model indexPath:(NSIndexPath *)indexpath;


@end










