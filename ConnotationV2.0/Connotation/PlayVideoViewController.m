//
//  PlayVideoViewController.m
//  Connotation
//
//  Created by LZXuan on 15-5-26.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "PlayVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayVideoViewController ()
{
    //视频播放器 播放 mp4 avi wom m3u8
    MPMoviePlayerViewController *_mp;
}
@end

@implementation PlayVideoViewController
- (void)dealloc {
    if (_mp) {
        [_mp.moviePlayer stop];
        [_mp release];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatMoviePlayer];
}
- (void)creatMoviePlayer {
    //创建一个视频播放器 内部有一个MPMoviePlayerController
    //真正控制 视频播放要通过MPMoviePlayerController
    _mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.model.vplay_url ]];
    //改变大小
    _mp.view.frame =  CGRectMake(0, 0, kScreenSize.width, 300);
    
    [self.view addSubview:_mp.view];
    //下面对视频播放设置 _mp.moviePlayer
    //是否可以自动 播放
    _mp.moviePlayer.shouldAutoplay = YES;
    //播放
    [_mp.moviePlayer play];
    
    //增加 一个视频的观察者 监听 视频 1。是否自动播放完毕 2.是否点击左上角的Done 3.播放是否异常---》都会播放返回
    //MPMoviePlayerPlaybackDidFinishNotification播放返回的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBack:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
}
- (void)playBack:(NSNotification *)nf{
    NSDictionary *dict = nf.userInfo;
    
    //获取播放返回的原因
    NSInteger type = [dict[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    //type 的值 1.自动播放完毕 2.点击Done 按钮  3.播放有异常
    switch (type) {
        case 1:
        {
            NSLog(@"自动播放完毕");
        }
            break;
        case 2:
        {
            //点击Done
            [_mp.moviePlayer stop];
            //界面跳转
            [self.navigationController popViewControllerAnimated:YES];
            
        }
            break;
        case 3:
        {
            NSLog(@"播放有异常");
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
