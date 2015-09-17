//
//  CategoryViewController.h
//  LimitFree
//
//  Created by LZXuan on 15-7-24.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^CategoryBlock) (NSString *categoryId);

@interface CategoryViewController : BaseViewController
//传入block 
- (void)setMyBlock:(CategoryBlock)block;
@end
