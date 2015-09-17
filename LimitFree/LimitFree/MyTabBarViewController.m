//
//  MyTabBarViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-7-23.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "AppListViewController.h"

@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
    [self createLaunchImageAnimation];
}


#pragma mark - 启动动画效果

//系统的LaunchImage  只是加载一张图片 没有动画

//如果要实现动画 就必须自己用代码实现

//自定义的启动动画  必须自己写代码 实现
- (void)createLaunchImageAnimation {
    //增加一个 程序加载时候的启动动画。下面使我们自己实现的一个 隐藏的动画效果
    UIImageView * startView = [MyControl creatImageViewWithFrame:self.view.bounds imageName:[NSString stringWithFormat:@"Defaultretein%u",arc4random()%7+1]];
    //tabr 的视图上
    [self.view addSubview:startView];
    [UIView animateWithDuration:3 animations:^{
        startView.alpha = 0;
    } completion:^(BOOL finished) {
        [startView removeFromSuperview];
    }];
    
}


#pragma mark - 创建子视图
- (void)createViewControllers {
    
    NSArray *urlArr = @[kLimitUrl,kReduceUrl,kFreeUrl,kSubjectUrl,kHotUrl];
    NSArray *categoryArr = @[kLimitType,kReduceType,kFreeType,kSubjectType,kHotType];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Controllers" ofType:@"plist"];
    //解析plist
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *vcArr = [[NSMutableArray alloc] init];
    //遍历数组
    for (NSInteger i = 0; i < arr.count; i++) {
        NSDictionary *dict = arr[i];
        NSString *title = dict[@"title"];
        NSString *iconName = dict[@"iconName"];
        NSString *className = dict[@"className"];
        //动态创建 对象
        Class clsName = NSClassFromString(className);
        AppListViewController *app = [[clsName alloc] init];
        //传值
        app.requestUrl = urlArr[i];
        app.categoryType = categoryArr[i];
        
        //创建导航
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:app];
        //视图控制器的title
        app.title = title;
        
//        app.navigationItem.title = title;
//        nav.tabBarItem.title = title;
        
        nav.tabBarItem.image = [UIImage imageNamed:iconName];
        [vcArr addObject:nav];
    }
    //放入tabBar的子视图控制器数组
    self.viewControllers = vcArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
