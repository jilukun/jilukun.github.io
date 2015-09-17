//
//  DetailViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-7-24.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "DetailViewController.h"
#import "AFNetworking.h"
#import "DetailModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "PhotosViewController.h"

//导入头文件 内部 有两个视图控制器 具有短信/邮箱模块功能
#import <MessageUI/MessageUI.h>

#import "UMSocial.h"

@interface DetailViewController () <UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UMSocialUIDelegate>

{
    AFHTTPRequestOperationManager *_manager;
    //存放附近的人信息
    NSMutableArray *_modelsArr;
}
//附近的人使用
@property (nonatomic,strong) NSMutableArray *modelsArr;

//详情模型
@property (nonatomic, strong) DetailModel *detailModel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
- (IBAction)sharedClick:(UIButton *)sender;
- (IBAction)favariteClick:(UIButton *)sender;
- (IBAction)downloadClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *favariteButton;
@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIScrollView *nearScrollView;

@end

@implementation DetailViewController
/*
 详情界面 需要下载数据
 通过xib 先把空的界面显示出来 等下载完数据之后再重新对界面赋值就可以
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addTitleViewWithName:@"应用详情"];
    
    //加载界面的时候 获取 收藏记录
    BOOL isExist = [[DBManager sharedManager] isExistAppForAppId:self.applicationId recordType:kLZXFavorite];
    if (isExist) {
        //已经收藏过
        self.favariteButton.enabled = NO;
    }else{
        self.favariteButton.enabled = YES;
    }
    //正常状态
    [self.favariteButton setTitle:@"收藏" forState:UIControlStateNormal];
    //禁用状态
    [self.favariteButton setTitle:@"已收藏" forState:UIControlStateDisabled];
    
    
    //设置下载
    _manager = [AFHTTPRequestOperationManager manager];
    //设置只下载不解析
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [self loadDetailData];
    [self loadNearData];
    
}

#pragma mark - 详情界面下载
- (void)loadDetailData {
    __weak typeof(self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:kDetailUrl,self.applicationId];
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //下载成功
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            //kvc 赋值
            weakSelf.detailModel = [[DetailModel alloc] init];
            [weakSelf.detailModel setValuesForKeysWithDictionary:dict];
            //刷新填充界面
            [weakSelf showDetailDataWithModel:weakSelf.detailModel];
            NSLog(@"详情下载完成");
            //本地保存 浏览记录 (下载完成之后表示浏览过)
            //保存到 数据库
            [[DBManager sharedManager] insertModel:weakSelf.detailModel recordType:kLZXBrowses];
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
    }];
}
- (void)showDetailDataWithModel:(DetailModel *)detailModel {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.iconUrl] placeholderImage:[UIImage imageNamed: @"topic_Header"]];
    self.name.text = detailModel.name;
    self.priceLabel.text = [NSString stringWithFormat:@"原价:￥%.2f 限免中 文件大小%@MB",detailModel.currentPrice.doubleValue,detailModel.fileSize];
    self.typeLabel.text = [NSString stringWithFormat:@"类型:%@ 评分:%@",detailModel.categoryName,detailModel.starCurrent];
    self.textView.editable = NO;
    self.textView.text = detailModel.description;
    //填充滚动视图
    CGFloat space = 5;
    CGFloat height = self.photoScrollView.bounds.size.height;
    CGFloat width = (self.photoScrollView.bounds.size.width - 4*space)/5;
    for (NSInteger i = 0; i < detailModel.photos.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((width+space)*i, 0, width, height);
        //异步下载 网络图片
        NSDictionary *dict = detailModel.photos[i];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:dict[@"smallUrl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed: @"topic_Header"]];
        button.tag = 101+i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoScrollView addSubview:button];
    }
    //设置滚动视图 滚动区域范围
    self.photoScrollView.contentSize = CGSizeMake((width+space)*self.detailModel.photos.count, height);
    
}
- (void)btnClick:(UIButton *)button {
    PhotosViewController *photo = [[PhotosViewController alloc] init];
    //传值
    photo.selectedIndex = button.tag-101;
    photo.photos = self.detailModel.photos;
    //push 的时候隐藏 tabBar
    photo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:photo animated:YES];
}


#pragma mark - 附近人下载
- (void)loadNearData {
    
    double longitude =  116.344539;
    double latitude = 40.034346;
    NSString *nearUrl = [NSString stringWithFormat:kNearAppUrl,longitude,latitude];
    
    
    __weak typeof(self) weakSelf = self;
    [_manager GET:nearUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr = dict[@"applications"];
            weakSelf.modelsArr = [[NSMutableArray alloc] init];
            
            NSInteger width = (weakSelf.nearScrollView.bounds.size.width - 5*6)/5;
            NSInteger height = weakSelf.nearScrollView.bounds.size.height;
            for (NSInteger i = 0; i < arr.count; i++) {
                AppModel *model = [[AppModel alloc] init];
                //kvc 赋值
                [model setValuesForKeysWithDictionary:arr[i]];
                [weakSelf.modelsArr addObject:model];
                
                //创建里面的button
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame =CGRectMake(5+(width+5)*i, 0, width, height);
                [button addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 301+i;
                //异步加载网络图片
                [button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed: @"topic_Header"]];
                button.layer.masksToBounds = YES;
                button.layer.cornerRadius = 8;
                
                [weakSelf.nearScrollView addSubview:button];
            }
            //设置 滚动区域范围
            weakSelf.nearScrollView.contentSize = CGSizeMake(weakSelf.nearScrollView.bounds.size.width+20, height);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"附近的人下载失败");
    }];
    
}
#pragma mark - 附近的人按钮
- (void)iconClick:(UIButton *)button {
    //获取选中的 应用model
    AppModel *model = _modelsArr[button.tag-301];
    //详情跳转
    DetailViewController *detail = [[DetailViewController alloc] init];
    //传值
    detail.applicationId = model.applicationId;
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - 三个按钮

- (IBAction)sharedClick:(UIButton *)sender {
    //短信分享  邮箱分享
#if 0
    //方法1:系统的 短信 模块和 邮箱 模块分享
    UIActionSheet *sheet =[[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"短信",@"邮箱", nil];
    [sheet showInView:self.view];
#else
    //方法2使用UM 友盟分享
    
#pragma mark - UM
    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
    
    NSString *str = [NSString stringWithFormat:@"我在讲爱限免,这里有惊喜:%@",self.detailModel.itunesUrl];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"507fcab25270157b37000010" shareText:str  shareImage:[UIImage imageNamed: @"account_candou"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToSms,UMShareToEmail,UMShareToWechatTimeline,nil] delegate:self];
    //微信 分享 还要 设置  scheme 和进行微信的初始化
    
#endif
}
//UM 分享 回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


#pragma mark - UIActionSheetDelegate
//点击操作表单按钮的时候调用
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"index:%ld",buttonIndex);
    switch (buttonIndex) {
        case 0://短信按钮
        {
            //方法1:如果要想调用系统的短信app(真机下才有效果)
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://10086"]];
            
            //点击短信之后 进行界面跳转到一个界面可以发短信
            //方法2:跳转到一个具有短信功能的界面
            if ([MFMessageComposeViewController canSendText]) {
                //检测 当前应用 是否支持短信功能
                //支持的话 创建  具有短信模块的界面
                MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc] init];
                //设置联系人 (可以群发)
                message.recipients = @[@"10086",@"10011"];
                //设置短信的内容
                message.body = [NSString stringWithFormat:@"快来下载，这里有惊喜:%@",self.detailModel.itunesUrl];
                
                
                //如果要处理发送的状态 要设置代理
                message.messageComposeDelegate = self;
                
                
                //模态跳转(内部有导航)
                [self presentViewController:message animated:YES completion:nil];
                
            }else {
                NSLog(@"不支持短信功能");
            }
        }
            break;
        case 1://邮箱按钮
        {
            //方法1:可以调用系统邮箱app
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://421051332@qq.com"]];
            //方法2: 跳转到具有邮箱功能的界面
            if ([MFMailComposeViewController canSendMail]) {
                //检测是否支持邮箱功能
                //如果支持 创建界面
                MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
                //设置联系人
                [mail setToRecipients:@[@"421051332@qq.com",@"zhengzhou1507@163.com"]];
                //设置抄送
                [mail setCcRecipients:@[@"xxx@sina.com"]];
                //设置标题
                [mail setSubject:@"分享爱限免应用"];
                //设置内容
                NSString *str = [NSString stringWithFormat:@"点击有惊喜:%@",self.detailModel.itunesUrl];
                //第二个参数 是否以HTML格式
                [mail setMessageBody:str isHTML:YES];
                
                //添加附件
                NSData *data = UIImagePNGRepresentation([UIImage  imageNamed: @"account_candou"]);
                //第一个参数 文件二进制  2 文件的类型 3  文件的名字
                [mail addAttachmentData:data mimeType:@"image/png" fileName:@"account_candou"];
                
                //设置代理
                mail.mailComposeDelegate = self;
                //模态跳转
                [self presentViewController:mail animated:YES completion:nil];
            }
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 邮箱协议
/*
 MFMailComposeResultCancelled,
 MFMailComposeResultSaved,
 MFMailComposeResultSent,
 MFMailComposeResultFailed
 */
//发送邮件之后的状态 回调
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"邮件取消");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"邮件保存");
            break;
        case MFMailComposeResultSent:
            NSLog(@"邮件发送");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"邮件失败");
            break;
            
        default:
            break;
    }
    //模态跳转返回
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 短信界面的协议
//完成短信之后回调这个方法
/*
 MessageComposeResultCancelled,
 MessageComposeResultSent,
 MessageComposeResultFailed
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
        {
            NSLog(@"取消");
        }
            break;
        case MessageComposeResultSent:
        {
            NSLog(@"短信已发送");
        }
            break;
        case MessageComposeResultFailed:
        {
            NSLog(@"短信失败");
        }
            break;
            
        default:
            break;
    }
    //最后要模态跳转返回
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)favariteClick:(UIButton *)sender {
    //禁用button
    sender.enabled = NO;//禁用状态
    //保存 收藏记录
    [[DBManager sharedManager] insertModel:self.detailModel recordType:kLZXFavorite];
}

- (IBAction)downloadClick:(UIButton *)sender {
    //保存下载记录
    if (!self.detailModel) {
        return;
    }
    //有 才 保存
    [[DBManager sharedManager] insertModel:self.detailModel recordType:kLZXDownloads];
    //调用 系统的app
    //点击下载 调用 AppStore
    //- openURL:
    //
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.detailModel.itunesUrl]];
}
@end





