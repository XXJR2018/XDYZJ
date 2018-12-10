//
//  ForgetPayPs_WdViewController_1.m
//  XXJR
//
//  Created by xxjr03 on 2017/8/24.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "ForgetPayPs_WdViewController_1.h"
#import "ForgetPayPs_WdViewController_2.h"
#import "AmendPassWordViewController.h"
@interface ForgetPayPs_WdViewController_1 ()
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnLayoutWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dlmmConstraint;

@end

@implementation ForgetPayPs_WdViewController_1

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"忘记支付密码"];
    self.nextBtnLayoutHeight.constant = 40 * ScaleSize;
    self.nextBtnLayoutWidth.constant = 290 * ScaleSize;
    if (IS_IPHONE_X_MORE)
     {
        self.dlmmConstraint.constant = 50 + 34+5;
     }

}

- (IBAction)forgetPassWord:(id)sender {
    [self.view endEditing:YES];
    AmendPassWordViewController *ctl = [[AmendPassWordViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}


- (IBAction)next:(id)sender {
    [self.view endEditing:YES];
    if (self.passWord.text.length == 0) {
        [MBProgressHUD showSuccessWithStatus:@"请输入登录密码" toView:self.view];
        return;
    }
    [self loginPwdUrl];
}

-(void)loginPwdUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"xxcust/account/info/validateLoginPwd"]
                                                                               parameters:@{@"password":self.passWord.text} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      ForgetPayPs_WdViewController_2 *ctl = [[ForgetPayPs_WdViewController_2 alloc]init];
                                                                                      [self.navigationController pushViewController:ctl animated:YES];                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
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
