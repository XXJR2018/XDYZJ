//
//  AddBankViewController.m
//  XXJR
//
//  Created by xxjr03 on 2017/5/25.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "AddBankViewController.h"
#import "SelectYHViewController.h"
#import "CDWAlertView.h"

@interface AddBankViewController ()
{
    NSString *_bankCode;
    UILabel *_hideName;
    BOOL   _isFirstChangeName;
    UILabel *_hideIdentity;
    BOOL  _isFirstChangeIdentity;
    UILabel *_hidecardNum;
    BOOL  _isFirstChangeCardNum;
    UILabel * _hidePhone;
    BOOL  _isFirstChangePhone;
    
    NSString *_bankId;
}
@property (weak, nonatomic) IBOutlet UIButton *verifBtn;            //验证码按钮
@property (weak, nonatomic) IBOutlet UILabel *YHlabel;              //所选银行
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;     //姓名
@property (weak, nonatomic) IBOutlet UITextField *identityTextField; //身份证号
@property (weak, nonatomic) IBOutlet UITextField *cardNumTextField;  //银行卡号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;    //手机号
@property (weak, nonatomic) IBOutlet UITextField *verifTextField;    //验证码

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NavConstraint;
@end

@implementation AddBankViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"添加银行卡"];
    
    _NavConstraint.constant = NavHeight + 10;
    
    self.verifBtn.layer.borderWidth = .5;
    self.verifBtn.layer.borderColor = UIColorFromRGB(0xfc6820).CGColor;
    
    if (self.dataDic.count > 0) {
        [self dataSource:self.dataDic];
    }
    else
    {
        // 姓名和身份证号、电话号码，从用户信息里拿
        NSDictionary *dicInfo = [DDGAccountManager sharedManager].userInfo;
        if (dicInfo != nil)
         {
            NSLog(@"dicInfo:%@",dicInfo);
            
            NSString *strName = [dicInfo objectForKey:@"realName"];
            if (strName &&
                ![strName isEqualToString:@""] )
             {
                self.nameTextField.text = strName;
                
                float fHideLeftX =  CGRectGetMinX(self.identityTextField.frame);
                float fHideTopY =   NavHeight + 10;
                float fHidtWidth = SCREEN_WIDTH - fHideLeftX;
                _hideName = [[UILabel alloc] initWithFrame:CGRectMake(fHideLeftX, fHideTopY+1, fHidtWidth, self.identityTextField.frame.size.height-2)];
                _hideName.backgroundColor = [UIColor whiteColor];
                _hideName.font = [UIFont systemFontOfSize:14];
                // 姓名不使用隐藏姓名，使用真实姓名
                _hideName.text = strName;//dicInfo[@"hideName"];
                [self.view addSubview:_hideName];
                _hideName.backgroundColor = [ResourceManager viewBackgroundColor];
                
                _isFirstChangeName = YES;
                [self.nameTextField addTarget:self  action:@selector(nameChanged)  forControlEvents:UIControlEventEditingChanged];
             }
            
            NSString *strCardNo = [dicInfo objectForKey:@"cardNo"];
            if (strCardNo&&
                ![strCardNo isEqualToString:@""])
             {
                self.identityTextField.text = strCardNo;
                
                float fHideLeftX =  CGRectGetMinX(self.identityTextField.frame);
                float fHideTopY =   NavHeight + 10;
                float fHidtWidth = SCREEN_WIDTH - fHideLeftX;
                fHideTopY  +=   self.nameTextField.frame.size.height;
                _hideIdentity = [[UILabel alloc] initWithFrame:CGRectMake(fHideLeftX, fHideTopY+1, fHidtWidth, self.identityTextField.frame.size.height-2)];
                _hideIdentity.backgroundColor = [UIColor whiteColor];
                _hideIdentity.font = [UIFont systemFontOfSize:14];
                _hideIdentity.text = dicInfo[@"hideCardNo"];
                if (![_hideIdentity.text isEqualToString:@""])
                 {
                    [self.view addSubview:_hideIdentity];
                    _hideIdentity.backgroundColor = [ResourceManager viewBackgroundColor];
                 }
                _isFirstChangeIdentity = YES;
                [self.identityTextField addTarget:self  action:@selector(identityChanged)  forControlEvents:UIControlEventEditingChanged];
             }
            
            NSString *strTelephone = [dicInfo objectForKey:@"telephone"];
            if (strTelephone&&
                ![strTelephone isEqualToString:@""])
             {
                self.phoneTextField.text = strTelephone;
                
                float fHideLeftX =  CGRectGetMinX(self.identityTextField.frame);
                float fHideTopY =   NavHeight + 10;
                float fHidtWidth = SCREEN_WIDTH - fHideLeftX;
                fHideTopY  +=   self.nameTextField.frame.size.height;
                fHideTopY  +=   self.cardNumTextField.frame.size.height + self.cardNumTextField.frame.size.height  + self.YHlabel.frame.size.height;
                _hidePhone = [[UILabel alloc] initWithFrame:CGRectMake(fHideLeftX, fHideTopY+1, fHidtWidth, self.identityTextField.frame.size.height-2)];
                _hidePhone.backgroundColor = [UIColor whiteColor];
                _hidePhone.font = [UIFont systemFontOfSize:14];
                _hidePhone.text = [dicInfo objectForKey:@"hideTelephone"];
                [self.view addSubview:_hidePhone];
                _isFirstChangePhone = YES;
                self.phoneTextField.tag = 101;
                [self.phoneTextField addTarget:self  action:@selector(phoneChanged)  forControlEvents:UIControlEventEditingChanged];
             }
            
            

            
         }
     }
    
    NSDictionary *dicInfo = [DDGAccountManager sharedManager].userInfo;
    // 实名认证后，姓名和身份证不让修改
    if (dicInfo)
     {
        if ( [[dicInfo objectForKey:@"identifyStatus"] integerValue] == 1)
         {
            self.nameTextField.enabled = NO;
            self.identityTextField.enabled = NO;
         }
     }
    
    int iBtnTopY = self.phoneTextField.top + NavHeight;
    UIButton *btnTS = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, iBtnTopY + 20, 25, 25)];
    [self.view addSubview:btnTS];
    //btnTS.backgroundColor = [UIColor yellowColor];
    [btnTS addTarget:self action:@selector(actionTS) forControlEvents:UIControlEventTouchUpInside];
    [btnTS setImage:[UIImage imageNamed:@"com_ts"] forState:UIControlStateNormal];
    

    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard{
    [self.view endEditing:YES];
}

-(void) actionTS
{
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    
    //降低当前高度
    [alertView subAlertCurHeight:25];
    
    alertView.textAlignment = RTTextAlignmentCenter;
    
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 17 color=#333333>手机号说明</font>"]];
    
    [alertView addAlertCurHeight:10];
    
    
    UIView *viewMid = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 220)];
    [alertView addView:viewMid leftX:0];
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake((260 - 200)/2, 0, 200, 100)];
    view.image = [UIImage imageNamed:@"tjdk_iphone"];
    [viewMid addSubview:view];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 260, 50)];
    [viewMid addSubview:label1];
    label1.font = [UIFont systemFontOfSize:16];
    label1.textColor = [UIColor grayColor];
    label1.numberOfLines = 0;
    label1.text = @"银行预留手机号码是办理该银行卡时所填写的手机号码";
    [label1 sizeToFit];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 120 + label1.height + 10, 260, 50)];
    [viewMid addSubview:label2];
    label2.font = [UIFont systemFontOfSize:16];
    label2.textColor = [UIColor grayColor];
    label2.numberOfLines = 0;
    label2.text = @"没有预留、手机号忘记或者已停用，请联系银行客服更新处理";
    [label1 sizeToFit];
    
    
    
    
    
    alertView.isBtnCenter = YES;
    
    [alertView addButton:@"我知道了" red:YES actionBlock:^{
        

        
    }];
    
    [alertView showAlertView:self.parentViewController  duration:0.0];
    
    
}

//选择银行
- (IBAction)selectYH:(UIButton *)sender {
    if (!self.phoneTextField.enabled) {
        return;
    }
    SelectYHViewController *ctl = [[SelectYHViewController alloc]init];
    ctl.YHBlock = ^(NSDictionary *dic){
        if (dic.count == 2) {
            self.YHlabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankName"]];
            self.YHlabel.textColor = [ResourceManager color_1];
            _bankCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankCode"]];
        }
        
    };
    [self.navigationController pushViewController:ctl animated:YES];
    
}

//获取验证码
- (IBAction)verifBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.nameTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入真实姓名" toView:self.view];
        return;
    }else if (self.identityTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入身份证号" toView:self.view];
        return;
    }else if (self.cardNumTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入银行卡号" toView:self.view];
        return;
    }else if (self.YHlabel.text.length == 0 || [self.YHlabel.text isEqualToString:@"请选择开户银行"]) {
        [MBProgressHUD showErrorWithStatus:@"请选择开户银行" toView:self.view];
        return;
    }else if (self.phoneTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入银行预留手机号" toView:self.view];
        return;
    }else if (![self.phoneTextField.text isMobileNumber]) {
        [MBProgressHUD showErrorWithStatus:@"请输入正确的手机号码" toView:self.view];
        return;
    }
   [self verifUrl];
    
}

//申请绑定
- (IBAction)addBack:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (self.nameTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入真实姓名" toView:self.view];
        return;
    }else if (self.identityTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入身份证号" toView:self.view];
        return;
    }else if (self.cardNumTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入银行卡号" toView:self.view];
        return;
    }else if (self.YHlabel.text.length == 0 || [self.YHlabel.text isEqualToString:@"请选择开户银行"]) {
        [MBProgressHUD showErrorWithStatus:@"请选择开户银行" toView:self.view];
        return;
    }else if (self.phoneTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入银行预留手机号" toView:self.view];
        return;
    }else if (![self.phoneTextField.text isMobileNumber]) {
        [MBProgressHUD showErrorWithStatus:@"请输入正确的手机号码" toView:self.view];
        return;
    }else if (self.phoneTextField.text.length >11) {
        [MBProgressHUD showErrorWithStatus:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    
    
    if (self.verifTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请先获取并输入验证码" toView:self.view];
        return;
    }
    [self addBackUrl];
}

//发送验证码
-(void)verifUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id_holder"] = self.nameTextField.text;
    params[@"id_card"] = self.identityTextField.text;
    params[@"acc_no"] = self.cardNumTextField.text;
    params[@"bank_name"] = self.YHlabel.text;
    params[@"pay_code"] = _bankCode;
    params[@"mobile"] = self.phoneTextField.text;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"busi/account/baofoo/pre/newPreBind"]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    
    operation.tag = 1001;
    [operation start];
}

-(void)addBackUrl
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id_holder"] = self.nameTextField.text;
    params[@"id_card"] = self.identityTextField.text;
    params[@"acc_no"] = self.cardNumTextField.text;
    params[@"pay_code"] = _bankCode;
    params[@"mobile"] = self.phoneTextField.text;
    params[@"sms_code"] = self.verifTextField.text;
    params[@"bankId"] = _bankId;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"busi/account/baofoo/bind/newBindDeal"]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    
    operation.tag = 1002;
    [operation start];

}

//数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = operation.jsonResult.attr;
    if (operation.tag == 1001) {
        if ([[dic objectForKey:@"resp_code"] intValue] == 0000) {
            //不能再修改上面信息
            self.nameTextField.enabled = NO;
            self.identityTextField.enabled = NO;
            self.cardNumTextField.enabled = NO;
            self.phoneTextField.enabled = NO;
            _bankId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankId"]];
            [MBProgressHUD showSuccessWithStatus:@"验证码即将发送到您的手机，请耐心等待" toView:self.view];
            __block int timeout=59; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.verifBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                        self.verifBtn.userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.verifBtn setTitle:[NSString stringWithFormat:@"重发(%@秒)",strTime] forState:UIControlStateNormal];
                        self.verifBtn.userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);

        }
        
    }else if (operation.tag == 1002) {
        [MBProgressHUD showSuccessWithStatus:@"您已成功绑定银行卡" toView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//更改重新赋值
-(void)dataSource:(NSDictionary *)dic{
    self.nameTextField.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"holderName"]];

    
    float fHideLeftX =  CGRectGetMinX(self.identityTextField.frame);
    float fHideTopY =   NavHeight + 10;
    float fHidtWidth = SCREEN_WIDTH - fHideLeftX;
    _hideName = [[UILabel alloc] initWithFrame:CGRectMake(fHideLeftX, fHideTopY+1, fHidtWidth, self.identityTextField.frame.size.height-2)];
    _hideName.backgroundColor = [UIColor whiteColor];
    _hideName.font = [UIFont systemFontOfSize:14];
    _hideName.text = [dic objectForKey:@"hideName"];
    _hideName.backgroundColor = [ResourceManager viewBackgroundColor];
    [self.view addSubview:_hideName];
    _isFirstChangeName = YES;
    [self.nameTextField addTarget:self  action:@selector(nameChanged)  forControlEvents:UIControlEventEditingChanged];

    
    self.identityTextField.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"certificateNo"]];
    fHideTopY  +=   self.nameTextField.frame.size.height;
    _hideIdentity = [[UILabel alloc] initWithFrame:CGRectMake(fHideLeftX, fHideTopY+1, fHidtWidth, self.identityTextField.frame.size.height-2)];
    _hideIdentity.backgroundColor = [UIColor whiteColor];
    _hideIdentity.font = [UIFont systemFontOfSize:14];
    _hideIdentity.text = [dic objectForKey:@"hideCertificateNo"];
    _hideIdentity.backgroundColor = [ResourceManager viewBackgroundColor];
    [self.view addSubview:_hideIdentity];
    _isFirstChangeIdentity = YES;
    [self.identityTextField addTarget:self  action:@selector(identityChanged)  forControlEvents:UIControlEventEditingChanged];
    
    
    self.cardNumTextField.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankCardNo"]];
    fHideTopY  +=   self.identityTextField.frame.size.height;
    _hidecardNum = [[UILabel alloc] initWithFrame:CGRectMake(fHideLeftX, fHideTopY+1, fHidtWidth, self.identityTextField.frame.size.height-2)];
    _hidecardNum.backgroundColor = [UIColor whiteColor];
    _hidecardNum.font = [UIFont systemFontOfSize:14];
    _hidecardNum.text = [dic objectForKey:@"hideCardCode"];
    [self.view addSubview:_hidecardNum];
    _isFirstChangeCardNum = YES;
    [self.cardNumTextField addTarget:self  action:@selector(carNumChanged)  forControlEvents:UIControlEventEditingChanged];
    
    self.YHlabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankName"]];
    self.YHlabel.textColor = [ResourceManager color_1];
    
    self.phoneTextField.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"telephone"]];
    fHideTopY  +=   self.cardNumTextField.frame.size.height  + self.YHlabel.frame.size.height;
    _hidePhone = [[UILabel alloc] initWithFrame:CGRectMake(fHideLeftX, fHideTopY+1, fHidtWidth, self.identityTextField.frame.size.height-2)];
    _hidePhone.backgroundColor = [UIColor whiteColor];
    _hidePhone.font = [UIFont systemFontOfSize:14];
    _hidePhone.text = [dic objectForKey:@"hideTelephone"];
    [self.view addSubview:_hidePhone];
    _isFirstChangePhone = YES;
    self.phoneTextField.tag = 101;
    [self.phoneTextField addTarget:self  action:@selector(phoneChanged)  forControlEvents:UIControlEventEditingChanged];
    

    _bankCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankCode"]];
    
    
}

#pragma mark ===  监听textFiled文字变化
-(void) nameChanged
{
    _hideName.hidden = YES;
    if (_isFirstChangeName)
     {
        _isFirstChangeName = NO;
        self.nameTextField.text =@"";
     }
}

-(void) identityChanged
{
    _hideIdentity.hidden = YES;
    if (_isFirstChangeIdentity)
     {
        _isFirstChangeIdentity = NO;
        self.identityTextField.text =@"";
     }
}

-(void) carNumChanged
{
    _hidecardNum.hidden = YES;
    if (_isFirstChangeCardNum)
     {
        _isFirstChangeCardNum = NO;
        self.cardNumTextField.text =@"";
     }
}

-(void) phoneChanged
{
    _hidePhone.hidden = YES;
    if (_isFirstChangePhone)
     {
        _isFirstChangePhone = NO;
        //self.phoneTextField.text =@"";
     }
}

#pragma mark === UITextFieldDelegate
//开始编辑时,键盘遮挡文本框，视图上移
-(BOOL)textFieldShouldBeginEditing:(UITextView *)textField
{
    CGRect  rectTemp = self.view.frame;
    rectTemp.origin.y = -100;
    self.view.frame = rectTemp;
    if (textField.tag == 101)
     {
        _hidePhone.hidden = YES;
     }
    return YES;
}

//键盘落下事件
- (void)textFieldDidEndEditing:(UITextView *)textField{
    CGRect  rectTemp = self.view.frame;
    rectTemp.origin.y = 0;
    self.view.frame = rectTemp;
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
