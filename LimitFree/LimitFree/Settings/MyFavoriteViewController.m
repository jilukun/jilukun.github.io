//
//  MyFavoriteViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-4-15.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "AppModel.h"
#import "DetailViewController.h"
#import "UIButton+WebCache.h"
#import "DBManager.h"


@interface MyFavoriteViewController ()
{
    NSMutableArray *_favoriteArr;
}
@end

@implementation MyFavoriteViewController

//根据存储的记录类型 和app 应用的价格类型 查找
//价格类型: 免费 限免  降价
/*
 已经定义过
 #define kLimitType   @"limited"
 #define kReduceType   @"sales"
 #define kFreeType    @"free"
 #define kHotType     @"hot"
 #define kSubjectType @"subject"
 */
/*
 设置界面中的 我的收藏界面和我的关注界面 需要 根据价格类型来查找收藏的记录
 
 我的 关注 查找的是 收藏的价格类型是降价app
 我的 收藏 查找的是 收藏的价格类型是限免和免费app
 
 
 我的下载  不需要关心价格类型
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showUI];
}
- (void)showUI {
    self.view.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    //我的收藏界面 从本地数据库中 得到一个数组，然后再根据价格类型 筛选出 免费 限免  这是收藏界面需要的
    
    //我的关注界面 要筛选出价格类型 降价 的 数据
    
    //从数据库找出多有的收藏 (收藏中 价格类型又分为 免费 限免 降价)
    NSArray *arr = [[DBManager sharedManager] readModelsWithRecordType:kLZXFavorite];
    //存储收藏的
    _favoriteArr = [[NSMutableArray alloc] init];
    
    
    for (AppModel *model in arr) {
        //@"limited" @"free"
        if ([model.priceTrend isEqualToString:kLimitType]||[model.priceTrend isEqualToString:kFreeType]) {
            //筛选出价格类型是 免费 限免  这是收藏界面需要的
            [_favoriteArr addObject:model];
        }
    }
    NSLog(@"count:%ld",_favoriteArr.count);
    
    //横向的间隔
    CGFloat wSpace = ([LZXHelper getScreenSize].width - 3*57)/4;
    
    //纵向的间隔
    CGFloat hSpace = ([LZXHelper getScreenSize].height-64-49 - 3*57)/4;
    for (int i = 0; i<_favoriteArr.count; i++) {
        //先获取model
        AppModel *model = _favoriteArr[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 101+i;
        
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 8;
        
        //从网络下载图片
        [btn sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed: @"account_candou"]];
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //九宫格坐标的小算法:(横坐标:i%横向显示个数的最大值;纵坐标:i/纵向的个数的最大值)
        [btn setFrame:CGRectMake(wSpace +(i%3)*(57+wSpace),hSpace +(i/3)*(hSpace+57), 57,57)];
        [self.view addSubview:btn];
        
        //创建label
        UILabel *label = [MyControl creatLabelWithFrame:CGRectMake(wSpace+(i%3)*(57+wSpace),hSpace+57 + (i/3)*(hSpace+57), 57, 20) text:model.name];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
}
- (void)btnClicked:(UIButton *)btn {
    AppModel *model = _favoriteArr[btn.tag - 101];
    
    DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.applicationId = model.applicationId;
    [self.navigationController pushViewController:dvc  animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
