//
//  BaseViewController.h
//  LimitFree
//
//  Created by LZXuan on 15-7-23.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
//导航的标题视图
- (void)addTitleViewWithName:(NSString *)name;
//增加左右按钮
- (void)addItemWithName:(NSString *)name
                 target:(id)target
                 action:(SEL)action
                 isLeft:(BOOL)isLeft;

@end


