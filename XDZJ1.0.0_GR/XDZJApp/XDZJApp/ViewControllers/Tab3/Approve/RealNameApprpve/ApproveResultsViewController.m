//
//  ApproveResultsViewController.m
//  XXJR
//
//  Created by xxjr03 on 2018/1/9.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "ApproveResultsViewController.h"
#import "ApproveViewController.h"
#import "WorkProveViewController.h"

@interface ApproveResultsViewController ()
{
    
    NSDictionary *_workDic;
    NSDictionary *_cardDic;
}

@property (weak, nonatomic) IBOutlet UIImageView *cardFrontImg;
@property (weak, nonatomic) IBOutlet UIImageView *cardReverseImg;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIButton *afreshApproveBtn;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardFrontLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardReverseLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImgLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorLabelLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *approveLayoutHeight;


@end

@implementation ApproveResultsViewController
#pragma mark - 友盟统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"认证结果"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"认证结果证"];
}
#pragma mark === viewDidLoad
-(id)init{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGqueryRZInfo]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [super handleData:operation];
    if (operation.jsonResult.attr.count > 0) {
        
        // 状态(-1待认证 0 待审核 1 正确 2 不正确 )
        NSDictionary *identifyDic =[operation.jsonResult.attr objectForKey:@"identifyInfo"];
        if ([[identifyDic objectForKey:@"status"] intValue] == 1) {
            if (self.type == 100) {
                [self.afreshApproveBtn setTitle:@"认证成功" forState:UIControlStateNormal];
                
                if (_isShowJump)
                 {
                    [_afreshApproveBtn setTitle:@"去工作认证" forState:UIControlStateNormal];
                 }
            }
            //self.afreshApproveBtn.hidden = YES;
        }else if ([[identifyDic objectForKey:@"status"] intValue] == 2) {
            //失败原因
            if ([identifyDic objectForKey:@"auditDesc"] && [NSString stringWithFormat:@"%@",[identifyDic objectForKey:@"auditDesc"]].length > 0) {
                self.errorLabel.text = [NSString stringWithFormat:@"  失败原因:%@",[identifyDic objectForKey:@"auditDesc"]];
                self.errorLabel.hidden = NO;
                self.errorLabelLayoutHeight.constant = 40;
            }
        }else if ([[identifyDic objectForKey:@"status"] intValue] == 0) {
            self.errorLabel.text = @"    待审核中，请耐心等待";
            self.errorLabel.hidden = NO;
            self.errorLabelLayoutHeight.constant = 40;
        }
        if ([identifyDic objectForKey:@"realImage"] && [NSString stringWithFormat:@"%@",[identifyDic objectForKey:@"realImage"]].length > 0) {
            [self.cardFrontImg sd_setImageWithURL:[NSURL URLWithString:[identifyDic objectForKey:@"realImage"]]];
        }
        if ([identifyDic objectForKey:@"idCardImage"] && [NSString stringWithFormat:@"%@",[identifyDic objectForKey:@"idCardImage"]].length > 0) {
            [self.cardReverseImg sd_setImageWithURL:[NSURL URLWithString:[identifyDic objectForKey:@"idCardImage"]]];
        }
        if ([identifyDic objectForKey:@"photoUrl"] && [NSString stringWithFormat:@"%@",[identifyDic objectForKey:@"photoUrl"]].length > 0) {
            [self.headImg sd_setImageWithURL:[NSURL URLWithString:[identifyDic objectForKey:@"photoUrl"]]];
        }
   }
}

-(void)getAuthInfo{
    
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        return;
     }
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@",[PDAPI getQueryProfessionListAPI]]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleWorkData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void)handleWorkData:(DDGAFHTTPRequestOperation *)operation
{
    _workDic = [[NSDictionary alloc]initWithDictionary:[operation.jsonResult.attr objectForKey:@"cardInfo"]];
    _cardDic = [[NSDictionary alloc]initWithDictionary:[operation.jsonResult.attr objectForKey:@"identifyInfo"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationBarView *nav =[self layoutNaviBarViewWithTitle:@"认证结果"];
    
    self.cardFrontLayoutHeight.constant = self.cardReverseLayoutHeight.constant = self.headImgLayoutHeight.constant = 95 * ScaleSize;
    self.approveLayoutHeight.constant = 45 * ScaleSize;
    
    self.errorLabel.hidden = YES;
    self.errorLabelLayoutHeight.constant = 1;
    self.errorLabel.textColor = UIColorFromRGB(0xed2e25);
    
    // 加入右边的按钮
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f,fRightBtnTopY,60.f, 35.0f)];
    [rightNavBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [rightNavBtn addTarget:self action:@selector(actionJump) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    if (_isShowJump)
     {
        [nav addSubview:rightNavBtn];
     }
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
    }
    
    if (100 == _type &&
        _isShowJump)
     {
        [self getAuthInfo];
        
        int iCurTopY = SCREEN_HEIGHT - (_afreshApproveBtn.height + 80);
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, iCurTopY, SCREEN_WIDTH, 20)];
        [self.view addSubview:labelTitle];
        labelTitle.font = [UIFont systemFontOfSize:14];
        labelTitle.textColor = UIColorFromRGB(0x9A9A9A);
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.text = @"还差一步，通过工作认证才能抢单";
        
        [_afreshApproveBtn setTitle:@"去工作认证" forState:UIControlStateNormal];
        
     }
    
}


-(void) actionJump
{
    NSNotification *notifcation = [[NSNotification alloc]initWithName:DDGAccountEngineDidLoginNotification object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notifcation];
}



//重新认证
- (IBAction)afreshApprove:(id)sender {
    if (self.type == 100) {
        
        if (_isShowJump)
         {
            WorkProveViewController  *ctl = [[WorkProveViewController alloc] init];
            ctl.isShowJump = _isShowJump;
            ctl.proveBlock = ^{
                [self getAuthInfo];
            };
            if ([_workDic objectForKey:@"status"]) {
                ctl.type = [[_workDic objectForKey:@"status"]intValue];
            }
            ctl.workDic = _workDic;
            [self.navigationController pushViewController:ctl animated:YES];
            return;
         }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    ApproveViewController *ctl = [[ApproveViewController alloc]init];
    ctl.isShowJump = _isShowJump;
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
