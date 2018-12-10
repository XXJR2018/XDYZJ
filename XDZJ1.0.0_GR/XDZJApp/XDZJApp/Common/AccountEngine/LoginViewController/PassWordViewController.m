//
//  PassWordViewController.m
//  XXJR
//
//  Created by xxjr03 on 17/3/27.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "PassWordViewController.h"

@interface PassWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NavConstraint;

@end

@implementation PassWordViewController

-(NSMutableDictionary *)paramDictionary{
    if (!_paramDictionary) {
        _paramDictionary = [NSMutableDictionary dictionary];
    }
    return _paramDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"设置密码"];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    if (self.userName.length > 0) {
        self.nameTextField.text = self.userName;
        self.nameTextField.userInteractionEnabled = NO;
    }
    self.passWordTextField.secureTextEntry = YES;
    
    if (IS_IPHONE_X_MORE)
    {
        _NavConstraint.constant = 100;
    }
    
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [self.view endEditing:YES];
}

//返回按钮
-(void)clickNavButton:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//是否密文
- (IBAction)passWord:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.passWordTextField.secureTextEntry = NO;
    }else{
        self.passWordTextField.secureTextEntry = YES;
    }
    
}




//完成
- (IBAction)next:(id)sender {
    if (_nameTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入您的姓名" toView:self.view];
        return;
    }else if (_passWordTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入您的密码" toView:self.view];
        return;
    }else if (![_passWordTextField.text isPassWordLegal]) {
        [MBProgressHUD showErrorWithStatus:@"密码格式:数字和字母组合6~12位" toView:self.view];
        return;
    }else {
        [self passWordUrl];
    }
    
}

//设置密码
-(void)passWordUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userSetLoginPwdInfoAPI]
                                                                               parameters:@{@"userName":_nameTextField.text,@"password":_passWordTextField.text,kUUID:[DDGSetting sharedSettings].UUID_MD5} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
    operation.tag = 1000;
}

//获取用户信息
-(void)InfoURL
{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getUserBaseInfoAPI]
                                                                               parameters:@{kUUID:[DDGSetting sharedSettings].UUID_MD5} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    if (operation.tag == 1000) {
        //获取用户信息
        [self InfoURL];
        
    }else if (operation.tag == 1001){
        //快速登陆
        [MBProgressHUD showSuccessWithStatus:@"登录成功" toView:self.view];
        // 保存数据 /////////////////////////////////////////////////
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:operation.jsonResult.rows[0]];
        for (NSString *key in dic.allKeys) {   //避免NULL字段
            if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                [dic setValue:@"" forKey:key];
            }
        }
        // 1. 账号相关 mobile、 密码、真实姓名、用户信息
        self.paramDictionary[kRealName] = [dic objectForKey:kRealName];
        self.paramDictionary[kMobile] = [dic objectForKey:kMobile];
        [DDGAccountManager sharedManager].userInfo = dic;
        
        [[DDGAccountManager sharedManager] setUserInfoWithDictionary:self.paramDictionary];
        [[DDGAccountManager sharedManager] saveUserData];        
        //跳转首页
        [[DDGUserInfoEngine engine] finishDoBlock];
        [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
        
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
