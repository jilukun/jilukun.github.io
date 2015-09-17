//
//  OpenSourceViewController.m
//  OpenSource
//
//  Created by LZXuan on 15-4-9.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "OpenSourceViewController.h"
#import "BaseViewController.h"

@interface OpenSourceViewController ()

@end

@implementation OpenSourceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatViewControllers];
}

- (void) creatViewControllers {
    NSArray *classNames = @[@"InfoViewController",@"AnswerViewController",@"TweetViewController",@"ActiveViewController",@"MoreViewController"];
    NSArray *imageNames = @[@"info",@"answer",@"tweet",@"active",@"more"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < classNames.count; i++) {
        //动态机制
        Class cls = NSClassFromString(classNames[i]);
        BaseViewController *vc = [[cls alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [vc release];
        nav.tabBarItem.title = imageNames[i];
        nav.tabBarItem.image = [UIImage imageNamed:imageNames[i]];
        [arr addObject:nav];
        [nav release];
    }
    self.viewControllers = arr;
    [arr release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
