//
//  NewAddSetupViewController.m
//  XXJR
//
//  Created by xxjr02 on 2017/12/21.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "NewAddSetupViewController.h"
//#import "ManagerApproveViewController.h"
#import "RedactInfoViewController.h"
#import "ServeViewController.h"

@interface NewAddSetupViewController ()<UITextViewDelegate>

@property (strong, nonatomic)  UITextView *comTextView;
@property (strong, nonatomic)  UITextField *shopText;

@end

@implementation NewAddSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"填写机构"];
    
    [self layoutUI];
    
    if (self.comStr.length > 0) {
        _comTextView.text = self.comStr;
        _comTextView.textColor = UIColorFromRGB(0x333333);
    }
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [self.view endEditing:YES];
}

-(void) layoutUI
{
    int iTopY = NavHeight + 10;
    int iLeftX = 10;
    _comTextView = [[UITextView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -20, 80)];
    _comTextView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_comTextView];
    _comTextView.text = @"请输入公司全称";
    _comTextView.font = [UIFont systemFontOfSize:14];
    _comTextView.textColor = [UIColor grayColor];
    _comTextView.delegate = self;
    
    iTopY += 80 + 10;
    _shopText = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -20, 30)];
    _shopText.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_shopText];
    _shopText.placeholder = @"请输入公司简称（不超过8个字）";
    _shopText.font = [UIFont systemFontOfSize:14];
    _shopText.textColor = [UIColor grayColor];
    
    UIButton *_referBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_shopText.frame) + 25, SCREEN_WIDTH - 30, 40 * ScaleSize)];
    [self.view addSubview:_referBtn];
    _referBtn.backgroundColor = [ResourceManager redColor1];
    [_referBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_referBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _referBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _referBtn.layer.cornerRadius = 5;
    [_referBtn addTarget:self action:@selector(refer) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) refer
{
    [self.view endEditing:YES];
    
    if (self.comTextView.text.length == 0 || [self.comTextView.text isEqualToString:@"请输入公司全称"]) {
        [MBProgressHUD showErrorWithStatus:@"公司全称不能为空" toView:self.view];
        return;
    }if (self.shopText.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"公司简称不能为空" toView:self.view];
        return;
    }if (self.shopText.text.length > 8) {
        [MBProgressHUD showErrorWithStatus:@"公司简称不能超过8个字" toView:self.view];
        return;
    }
    [self addComUrl];
}

-(void)addComUrl{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"compName"] = _comTextView.text;
    params[@"shortName"] = _shopText.text;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getAddCompanyAPI]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [super handleData:operation];
    NSDictionary * dic =operation.jsonResult.attr;
    //返回指定界面
//    ManagerApproveViewController *cti = [[ManagerApproveViewController alloc]init];
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[cti class]]) {
//            //反向传值
//            self.blockServe(@[self.comTextView.text,self.shopText.text,[dic objectForKey:@"compId"]?:@""]);
//            [self.navigationController popToViewController:temp animated:YES];
//        }
//    }
    RedactInfoViewController *Redact = [[RedactInfoViewController alloc]init];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[Redact class]]) {
            //反向传值
            self.blockServe(@[self.comTextView.text,self.shopText.text,[dic objectForKey:@"compId"]?:@""]);
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    
    ServeViewController *serve = [[ServeViewController alloc]init];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[serve class]]) {
            //反向传值
            self.blockServe(@[self.comTextView.text,self.shopText.text,[dic objectForKey:@"compId"]?:@""]);
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入公司全称"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}



@end
