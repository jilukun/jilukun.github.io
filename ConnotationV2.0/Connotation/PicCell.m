//
//  PicCell.m
//  Connotation
//
//  Created by LZXuan on 15-5-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "PicCell.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

@implementation PicCell
{
    JumpBlock _myBlock;
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showDataWithModel:(ConnotationModel *)model {
    //先保存model
    self.model = model;
    //把一个秒转化为 时间字符串
    self.updateLabel.text = [LZXHelper dateStringFromNumberTimer:model.update_time];
    
    //动态计算出 model.wbody
    self.wbodyLabel.text = model.wbody;
    CGFloat h = [LZXHelper textHeightFromTextString:model.wbody width:kScreenSize.width-40 fontSize:14];
    //更改wbodyLabel高
    CGRect frame = self.wbodyLabel.frame;
    frame.size.height = h;
    self.wbodyLabel.frame = frame;
    
    CGRect imageFrame = self.wpicImageView.frame;
    if (model.wpic_middle.length) {
        //说明有图片
        imageFrame.origin.y = CGRectGetMaxY(self.wbodyLabel.frame)+5;//最好有5像素间隔
        //等比例算出在cell 的高
        //imageH/280 = wpic_m_height/wpic_m_width
        imageFrame.size.height = model.wpic_m_height.doubleValue/model.wpic_m_width.doubleValue*(kScreenSize.width-40);
        //异步下载图片
        [self.wpicImageView sd_setImageWithURL:[NSURL URLWithString:model.wpic_middle] placeholderImage:[[UIImage imageNamed: @"card_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
        
        //图片拉伸方法 5 5  从图片左侧第6像素拉伸 其他像素不拉伸
        //                从图片顶部第6像素拉伸 其他像素不拉伸
        //[[UIImage imageNamed: @"card_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]
        
        /*
         - (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight
         
         这个函数是UIImage的一个实例函数，它的功能是创建一个内容可拉伸，而边角不拉伸的图片，需要两个参数，第一个是左边不拉伸区域的宽度，第二个参数是上面不拉伸的高度。
         
         根据设置的宽度和高度，将接下来的一个像素进行左右扩展和上下拉伸。
         
         注意：可拉伸的范围都是距离leftCapWidth后的1竖排像素，和距离topCapHeight后的1横排像素。
         
         
         参数的意义是，如果参数指定10，5。那么，图片左边10个像素，上边5个像素。不会被拉伸，x坐标为11和一个像素会被横向复制，y坐标为6的一个像素会被纵向复制。注意：只是对一个像素进行复制到一定宽度。而图像后面的剩余像素也不会被拉伸。
         */
        
    }else {
        imageFrame.origin.y = CGRectGetMaxY(self.wbodyLabel.frame);//最好有5像素间隔
        imageFrame.size.height = 0;//没有图片
    }
    self.wpicImageView.frame = imageFrame;
    
    //设置按钮
    CGRect buttonFrame1 = self.likesButton.frame;
    CGRect buttonFrame2 = self.commentsButton.frame;
    
    buttonFrame1.origin.y = CGRectGetMaxY(self.wpicImageView.frame)+5;
    buttonFrame2.origin.y = buttonFrame1.origin.y;
    
    self.likesButton.frame = buttonFrame1;
    self.commentsButton.frame = buttonFrame2;
    
    [self.likesButton setTitle:[NSString stringWithFormat:@"赞:%ld",model.likes.integerValue] forState:UIControlStateNormal];
    
    [self.likesButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    NSString *key = [self.catetory stringByAppendingString:model.wid];
    //weibo_jokes123456
    //获取本地数据看点过赞没有
    BOOL isLike = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    if (isLike) {
        //有数据
        self.likesButton.selected = YES;//选中
    }else {
        self.likesButton.selected = NO;
    }
    
    
    [self.commentsButton setTitle:[NSString stringWithFormat:@"评论:%ld",model.comments.integerValue] forState:UIControlStateNormal];
}


- (void)dealloc {
    self.myBlock = nil;
    self.model = nil;
    self.catetory = nil;
    [_updateLabel release];
    [_wbodyLabel release];
    [_wpicImageView release];
    [_likesButton release];
    [_commentsButton release];
    [super dealloc];
}
//点赞
- (IBAction)likeClick:(UIButton *)sender {
    NSString *key = [self.catetory stringByAppendingString:self.model.wid];
    //weibo_jokes123456
    //获取本地数据看点过赞没有
    //把 分类和wid 拼接构成一个key (唯一)
    BOOL isLike = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    if (isLike) {
        //弹出一个警告框表示已经点过了
        //return;
    }
    
    ////请求体拼接参数是下面的形式参数
    // type=like&category=weibo_girls&fid=30310
    
    
    //点赞
    //本地保存
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    //同步到磁盘
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    sender.selected = YES;//表示选中  点过赞了
    //记录+1
    self.model.likes = [NSString stringWithFormat:@"%ld",self.model.likes.integerValue+1];
    //改标题
    [self.likesButton setTitle:[NSString stringWithFormat:@"赞:%ld",self.model.likes.integerValue+1] forState:UIControlStateNormal];
    
    //作弊 1000次
    for (NSInteger i = 0; i < 1; i++) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSDictionary *dict = @{@"type":@"like",@"category":self.catetory,@"fid":self.model.wid};
        
        [manager POST:kZanUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *downDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"downDict:%@",downDict);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"失败");
        }];

    }

}

//评论按钮
- (IBAction)commentClick:(UIButton *)sender {
    //界面跳转
    //当前cell 可以委托baseViewController进行界面跳转
    //定义 block  调用block
    if (self.myBlock) {
        self.myBlock(self.model);
    }
}

- (void)setMyBlock:(JumpBlock)block {
    if (_myBlock != block) {
        [_myBlock release];
        _myBlock = [block copy];
    }
}
- (JumpBlock)myBlock {
    return _myBlock;
}



@end
