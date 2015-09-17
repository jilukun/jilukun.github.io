//
//  ConnotationTabBarController.m
//  Connotation
//
//  Created by LZXuan on 15-5-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "ConnotationTabBarController.h"
#import "BaseViewController.h"

@interface ConnotationTabBarController ()

@end

@implementation ConnotationTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatViewControllers];
}
/*
 内涵段子项目
 
 服务器 UI 美工完成 他们的工作之后 接下来就是 iOS程序要按照效果图实现效果
 
 
 1.MVC 的框架设计 （tabController）
 视图控制器的封装
 
 2.查看你接口数据  json/xml
 
 3.设计数据模型
 
 4.cell
 
 下载数据 填充cell

 */

- (void)creatViewControllers {
    NSArray *titles = @[@"段子",@"趣图",@"视频",@"美女"];
    NSArray *imageNames = @[@"圣斗士",@"海贼王",@"火影忍者",@"美女"];
    
    NSArray *classNames = @[@"JokesViewController",@"PicsViewController",@"VideosViewController",@"GirlsViewController"];
    //分类
    NSArray *categorys = @[JOKES,PICS,VIDEOS,GIRLS];
    
    NSMutableArray *vcArr = [NSMutableArray array];
    for (NSInteger i = 0; i < titles.count; i++) {
        //转化为Class
        Class vcClass = NSClassFromString(classNames[i]);
        BaseViewController *vc = [[vcClass alloc] init];
        vc.title = titles[i];
        //传值 把具体分类传入
        //正向传值 把 url 传给每个界面
        vc.category = categorys[i];
        
        //加入到导航
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [vc release];
        
        nav.tabBarItem.image = [[UIImage imageNamed:imageNames[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageNames[i]]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        [vcArr addObject:nav];
        [nav release];
    
    }
    self.viewControllers = vcArr;
    
}

@end





