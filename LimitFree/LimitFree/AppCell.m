//
//  AppCell.m
//  LimitFree
//
//  Created by LZXuan on 15-7-23.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "AppCell.h"
#import "UIImageView+WebCache.h"

@implementation AppCell

- (void)awakeFromNib {
    // Initialization code
    //xib 初始化对象的时候 调用
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 8;
    //设置 选中背景
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"appproduct_loadingviewcell_ligh_2t"]];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.priceLabel.frame.size.height/2-1, self.priceLabel.frame.size.width, 2)];
    line.backgroundColor = [UIColor grayColor];
    [self.priceLabel addSubview:line];
    
}
//填充cell
- (void)showDataWithModel:(AppModel *)model indexPath:(NSIndexPath *)indexpath {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed: @"topic_Header"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%ld.%@",indexpath.row,model.name];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.1f",model.lastPrice.doubleValue];
    //设置星级
    [self.starLevelView setStarLevel:model.starCurrent.doubleValue];
    self.categoryLabel.text = model.categoryName;
    self.sharesLabel.text = [NSString stringWithFormat:@"分享:%@ 收藏:%@ 下载:%@",model.shares,model.favorites,model.downloads];
    //根据 不同界面类型 显示 不一样
    if ([self.categoryType isEqualToString:kLimitType]) {
        //计算时间差  传入一个时间格式
        self.typeLabel.text = [NSString stringWithFormat:@"剩余:%@",[LZXHelper stringNowToDate:model.expireDatetime formater:@"yyyy-MM-dd HH:mm:ss.0"]];
    }else if ([self.categoryType isEqualToString:kReduceType]) {
        self.typeLabel.text = [NSString stringWithFormat:@"现价:%@",model.currentPrice];
    }else  {
        self.typeLabel.text = [NSString stringWithFormat:@"评分:%@",model.starCurrent];
    }
    
    if (indexpath.row%2 == 0) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed: @"cate_list_bg1"] stretchableImageWithLeftCapWidth:100 topCapHeight:75]];
    }else {
        self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed: @"cate_list_bg2"] stretchableImageWithLeftCapWidth:100 topCapHeight:75]];
    }
}

/*
 Cell 被选中/被点击(高亮) cell 会把contentView 上面的所有子视图的背景颜色设置为 clearColor
 如果我们不想要这种效果那么需要重写 选中 和 高亮状态的方法 重新设置颜色
 
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    UIView *line = self.priceLabel.subviews[0];//获取线
    line.backgroundColor = [UIColor grayColor];
}
//点击cell 会被调用 (高亮状态)
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    UIView *line = self.priceLabel.subviews[0];//获取线
    line.backgroundColor = [UIColor grayColor];

}

@end
