//
//  PhotosViewController.h
//  LimitFree
//
//  Created by LZXuan on 15-7-24.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "BaseViewController.h"

@interface PhotosViewController : BaseViewController
//属性传值
@property (nonatomic ,strong) NSArray *photos;
//选中的索引
@property (nonatomic) NSInteger selectedIndex;
@end
