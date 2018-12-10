//
//  ApplyProveViewController.m
//  XXJR
//
//  Created by xxjr03 on 2017/8/1.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "ApplyProveViewController.h"

#import "RNApproveViewController.h"
#import "WorkProveViewController.h"

#import "ApproveViewController.h"
#import "ApproveResultsViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface ApplyProveViewController ()
{
    NSDictionary *_workDic;
    NSDictionary *_cardDic;
    

}

@property (weak, nonatomic) IBOutlet UILabel *cardStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *workStatusLabel;

@property (weak, nonatomic) IBOutlet UIButton *workProveBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutSafeAreaTopHeight;

@end

@implementation ApplyProveViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"申请认证"];
    [self loadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"申请认证"];
}

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@",[PDAPI getQueryProfessionListAPI]]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [super handleData:operation];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    
    _workDic = [[NSDictionary alloc]initWithDictionary:[operation.jsonResult.attr objectForKey:@"cardInfo"]];
    _cardDic = [[NSDictionary alloc]initWithDictionary:[operation.jsonResult.attr objectForKey:@"identifyInfo"]];
    if ([_cardDic objectForKey:@"status"] && [[_cardDic objectForKey:@"status"] intValue] != -1) {
        self.workProveBtn.selected = YES;
    }
    
    if ([_cardDic objectForKey:@"status"]) {
        self.cardStatusLabel.textColor = [ResourceManager color_6];
        if ([[_cardDic objectForKey:@"status"] intValue] == -1) {
            self.cardStatusLabel.text = @"未认证";
        }else if ([[_cardDic objectForKey:@"status"] intValue] == 0) {
            self.cardStatusLabel.text = @"认证待审核";
        }else if ([[_cardDic objectForKey:@"status"] intValue] == 1) {
            self.cardStatusLabel.textColor = UIColorFromRGB(0x00AC61);
            self.cardStatusLabel.text = @"认证成功";
        }else if ([[_cardDic objectForKey:@"status"] intValue] == 2) {
            self.cardStatusLabel.textColor = UIColorFromRGB(0xED0000);
            self.cardStatusLabel.text = @"认证失败";
        }
    }
    if ([_workDic objectForKey:@"status"]) {
        self.workStatusLabel.textColor = [ResourceManager color_6];
        if ([[_workDic objectForKey:@"status"] intValue] == -1) {
            self.workStatusLabel.text = @"未认证";
        }else if ([[_workDic objectForKey:@"status"] intValue] == 0) {
            self.workStatusLabel.text = @"认证待审核";
        }else if ([[_workDic objectForKey:@"status"] intValue] == 1) {
            self.workStatusLabel.textColor = UIColorFromRGB(0x00AC61);
            self.workStatusLabel.text = @"认证成功";
        }else if ([[_workDic objectForKey:@"status"] intValue] == 2) {
            self.workStatusLabel.textColor = UIColorFromRGB(0xED0000);
            self.workStatusLabel.text = @"认证失败";
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"申请认证"];
    
    self.layoutSafeAreaTopHeight.constant = IS_IPHONE_X_MORE ? 90 : 74;
    
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied)
     {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"请在设置中打开相机权限。"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action){
                                                    // 退到上一层
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }]];
        
        
        [self presentViewController:alert animated:YES completion:nil];
     }
}

-(void)clickNavButton:(UIButton *)button{
    
    if (_isPopRoot)
     {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
     }
    [self.navigationController popViewControllerAnimated:YES];
}

//身份认证
- (IBAction)cardProve:(id)sender {
    if ([[_cardDic objectForKey:@"status"] intValue] == 1) {
        [MBProgressHUD showOnlyText:@"身份认证已成功" toView:self.view];
        return;
    }
    int approveStatus =  [[_cardDic objectForKey:@"status"] intValue];
    if (approveStatus == 0 ||
        approveStatus == 1 ||
        approveStatus == 2) {
        ApproveResultsViewController *ctl = [[ApproveResultsViewController alloc]init];
        [self.navigationController pushViewController: ctl animated:YES];
    }else{
        ApproveViewController *ctl = [[ApproveViewController alloc]init];
        [self.navigationController pushViewController:ctl animated:YES];
    }

}

//工作认证
- (IBAction)workProve:(id)sender {
    if (self.workProveBtn.selected) {        
        WorkProveViewController *ctl = [[WorkProveViewController alloc]init];
        ctl.proveBlock = ^{
            [self loadData];
        };
        if ([_workDic objectForKey:@"status"]) {
            ctl.type = [[_workDic objectForKey:@"status"]intValue];
        }
        ctl.workDic = _workDic;
        [self.navigationController pushViewController:ctl animated:YES];        
    }else{
        [MBProgressHUD showErrorWithStatus:@"请先进行身份认证" toView:self.view];
    }
    
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
