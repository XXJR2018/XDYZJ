//
//  ShareWebViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/1/26.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "ShareWebViewController.h"
//#import "ShareView.h"
#import "UIImageView+WebCache.h"

@interface ShareWebViewController ()<UIWebViewDelegate>

@end

@implementation ShareWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"资讯详情"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"资讯详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"我的资讯"];
    
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
    //导航右边按钮
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f,fRightBtnTopY,60.f, 35.0f)];
    [rightNavBtn setTitle:@"分享" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[ResourceManager redColor1] forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(shares) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [ResourceManager font_7];
    //[nav addSubview:rightNavBtn];
    UIWebView *web=[[UIWebView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.ShareUrl]]];
    web.delegate = self;
    web.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:web];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        NSURL *url = [request URL];
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            ShareWebViewController *Resource = [[ShareWebViewController alloc] init];
            Resource.ShareUrl = [url absoluteString];
            [self.navigationController pushViewController:Resource animated:YES];
        }
        return NO;
    }
    return YES;
}

-(void)shares
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[ResourceManager logo]];
    UIImage *image = imageView.image;
    if (image && (image.size.width > 100  || image.size.height > 100)) {
        image = [image scaledToSize:CGSizeMake(100, 100*image.size.height/image.size.width)];
    }
    
    NSDictionary *dic = [DDGAccountManager sharedManager].userInfo;;
    // 使用个人头像
    if (dic)
     {
        NSURL *urlIMG = [NSURL URLWithString:dic[@"userImage"]];
        UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:urlIMG]];
        if (imagea)
         {
            image = imagea;
            if ( (image.size.width > 100  || image.size.height > 100)) {
                image = [image scaledToSize:CGSizeMake(100, 100*image.size.height/image.size.width)];
            }
         }
     }
    
    [[DDGShareManager shareManager] share:ShareContentTypeNews items:@{@"title":self.Title, @"subTitle":self.subTitle, @"image":UIImageJPEGRepresentation(image,1.0), @"url": self.ShareUrl} types:@[DDGShareTypeWeChat_haoyou,DDGShareTypeWeChat_pengyouquan,DDGShareTypeQQ,DDGShareTypeQQqzone,DDGShareTypeCopyUrl] showIn:self block:^(id result){
        NSDictionary *dic = (NSDictionary *)result;
        if ([[dic objectForKey:@"success"] boolValue]) {
            [self url];
            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
}

/**
 *  分享成功修改积分
 *
 *  @param shareType(1 分享名片  2 分享资讯） novelId(资讯id)
 */
-(void)url
{
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"shareType"] =@"2";
    params[@"novelId"] = self.novelId;
    // 发送请求POST
    [[NSOperationQueue mainQueue] addOperation:[[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userGetRewardShareInfoAPI] parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray success:^(DDGAFHTTPRequestOperation *operation, id responseObject) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
       
    } failure:^(DDGAFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    }
     ]];
    
}



@end
