//
//  MyHelpViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-4-15.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "MyHelpViewController.h"

@interface MyHelpViewController ()
{
    UIScrollView *_scrollView;
}
@end

@implementation MyHelpViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showUI];
}
- (void)showUI{
    self.view.backgroundColor = [UIColor blackColor];
    NSArray *arr = @[@"helpphoto_one",@"helpphoto_two",@"helpphoto_three",@"helpphoto_four",@"helpphoto_five"];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width , [LZXHelper getScreenSize].height-49-64)];
    for (int i = 0; i < 4; i++) {
        UIImageView *image = [MyControl creatImageViewWithFrame:CGRectMake(_scrollView.bounds.size.width*i, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height) imageName:[NSString stringWithString:arr[i]]];
        [_scrollView addSubview:image];
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*4, _scrollView.bounds.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    
}


@end
