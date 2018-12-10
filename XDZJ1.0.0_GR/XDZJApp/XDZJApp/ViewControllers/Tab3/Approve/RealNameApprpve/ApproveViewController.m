//
//  ApproveViewController.m
//  XXJR
//
//  Created by xxjr03 on 2018/1/5.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "ApproveViewController.h"
#import "FaceScanViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>

@interface ApproveViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate, AipOcrDelegate>
{
    NSInteger _idCardType;
    NSString *_frontImgStr;
    NSString *_reverseImgStr;
    NSString *_idCardLimit;
    NSString *_idCardSignOrg;
    
    UIView *_checkAleartView;
    NSData *lastDataOfCardFrontImg;
    NSData *lastDataOfcardReverseImg;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *cardFrontImg;
@property (weak, nonatomic) IBOutlet UIImageView *cardReverseImg;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTextField;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *cardNumView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardFrontImgLayoutWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardFrontImgLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardReverseImgLayoutWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardReverseImgLayoutHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardFrontBtnLayoutHorWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardReverseBtnLayoutHorWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardFrontBtnLayoutHorTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardReverseBtnLayoutHorTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnLayoutHeight;



@end

@implementation ApproveViewController

#pragma mark - 友盟统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"实名认证"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"实名认证"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isShowJump)
     {
        self.hideBackButton = YES;
     }
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"实名认证"];
    
    
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
    
    self.cardFrontBtnLayoutHorWidth.constant = self.cardReverseBtnLayoutHorWidth.constant = 55 * ScaleSize;
    self.cardFrontImgLayoutWidth.constant = self.cardReverseImgLayoutWidth.constant = 145 * ScaleSize;
    self.cardFrontImgLayoutHeight.constant = self.cardReverseImgLayoutHeight.constant = 95 * ScaleSize;
     self.cardFrontBtnLayoutHorTop.constant = self.cardReverseBtnLayoutHorTop.constant = 24 * ScaleSize;
    self.nextBtnLayoutHeight.constant = 45 * ScaleSize;
    self.nameView.layer.borderWidth = 0.5;
    self.cardNumView.layer.borderWidth = 0.5;
    self.nameView.layer.borderColor = [ResourceManager color_5].CGColor;
    self.cardNumView.layer.borderColor = [ResourceManager color_5].CGColor;
    
    
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

    //授权方法1：请在 http://ai.baidu.com中 新建App, 绑定BundleId后，在此处填写App的Api Key/Secret Key
    //[[AipOcrService shardService] authWithAK:@"u9ArxBmGxiGwPfKByIPSeNCE" andSK:@"liMOceDTAMrIXapsp5Csh9jiAB6Ozkrs"];
    //[[AipOcrService shardService] authWithAK:@"YQGCiGzcvhPrVx9EVHQGl0af" andSK:@"RTAGqy6vkifhkcCnIy4OND0EdyScZ1p5"];
    
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    
    [self getRZInfo];
    


}

-(void) actionJump
{
    NSNotification *notifcation = [[NSNotification alloc]initWithName:DDGAccountEngineDidLoginNotification object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notifcation];
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard{
    [self.view endEditing:YES];
}

//扫描身份证正面
- (IBAction)scanCardFront:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![self scanTime]) {
        [MBProgressHUD showErrorWithStatus:@"每天只有3次识别机会，请明天再试" toView:self.view];
        return;
    }
     _idCardType = 101;
    UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont andDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
}

//扫描身份证反面
- (IBAction)scanCardReverse:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (![self scanBackTime]) {
        [MBProgressHUD showErrorWithStatus:@"每天只有3次识别机会，请明天再试" toView:self.view];
        return;
    }
    _idCardType = 102;
    UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardBack andDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
}

//提交认证
- (IBAction)approveUrl:(id)sender {
    [self.view endEditing:YES];
    if (_frontImgStr.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请扫描身份证正面照" toView:self.view];
        return;
    }else if (_reverseImgStr.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请扫描身份证反面照" toView:self.view];
        return;
    }else if (_nameTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"真实姓名不能为空" toView:self.view];
        return;
    }else if (_cardNumTextField.text.length != 18) {
        [MBProgressHUD showErrorWithStatus:@"身份证号不正确" toView:self.view];
        return;
    }
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"realImage"] = _frontImgStr;
//    params[@"idCardImage"] = _reverseImgStr;
//    params[@"realName"] = _nameTextField.text;
//    params[@"cardNo"] = _cardNumTextField.text;
//    params[@"idCardLimit"] = _idCardLimit;
//    params[@"idCardSignOrg"] = _idCardSignOrg;
//    params[@"fileType"] = @"identify";
//    FaceScanViewController *ctl = [[FaceScanViewController alloc]init];
//    ctl.paramDic  = params;
//    [self.navigationController pushViewController:ctl animated:YES];
    
    [self commitInfo];
}

-(BOOL)scanTime{
    //获取当前时间
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    NSString *timeStr = [NSString stringWithFormat:@"%04ld%02ld%02ld",(long)comp.year,(long)comp.month,(long)comp.day];
    
    if (![CommonInfo getKey:@"scanTime"] || [NSString stringWithFormat:@"%@",[CommonInfo getKey:@"scanTime"]].length == 0) {
        return YES;
    }
    NSString *oldTime = [NSString stringWithFormat:@"%@",[CommonInfo getKey:@"scanTime"]];
    NSString *oldYear = [oldTime substringWithRange:NSMakeRange(0, 4)];
    NSString *oldMonth = [oldTime substringWithRange:NSMakeRange(4, 2)];
    NSString *oldDay = [oldTime substringWithRange:NSMakeRange(6, 2)];
    NSString *newYear = [timeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *newMonth = [timeStr substringWithRange:NSMakeRange(4, 2)];
    NSString *newDay = [timeStr substringWithRange:NSMakeRange(6, 2)];
    if ([newYear intValue] > [oldYear intValue]) {
        [CommonInfo setKey:@"scanCount" withValue:@"0"];
        return YES;
    }else{
        if ([newMonth intValue] > [oldMonth intValue]) {
            [CommonInfo setKey:@"scanCount" withValue:@"0"];
            return YES;
        }else{
            if ([newDay intValue] > [oldDay intValue]) {
                [CommonInfo setKey:@"scanCount" withValue:@"0"];
                return YES;
            }
        }
    }
    if ([[CommonInfo getKey:@"scanCount"] intValue] < 3) {
        return YES;
    }
    return NO;
}



-(void)saveTime{
    //获取当前时间
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    NSString *timeStr = [NSString stringWithFormat:@"%04ld%02ld%02ld",(long)comp.year,(long)comp.month,(long)comp.day];
    
    NSString *scanCount = [NSString stringWithFormat:@"%d",[[CommonInfo getKey:@"scanCount"] intValue] + 1];
    [CommonInfo setKey:@"scanCount" withValue:scanCount];
    NSLog(@"%@----------",[CommonInfo getKey:@"scanCount"]);
    [CommonInfo setKey:@"scanTime" withValue:timeStr];
}


-(BOOL)scanBackTime{
    //获取当前时间
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    NSString *timeStr = [NSString stringWithFormat:@"%04ld%02ld%02ld",(long)comp.year,(long)comp.month,(long)comp.day];
    
    if (![CommonInfo getKey:@"scanBackTime"] || [NSString stringWithFormat:@"%@",[CommonInfo getKey:@"scanBackTime"]].length == 0) {
        return YES;
    }
    NSString *oldTime = [NSString stringWithFormat:@"%@",[CommonInfo getKey:@"scanBackTime"]];
    NSString *oldYear = [oldTime substringWithRange:NSMakeRange(0, 4)];
    NSString *oldMonth = [oldTime substringWithRange:NSMakeRange(4, 2)];
    NSString *oldDay = [oldTime substringWithRange:NSMakeRange(6, 2)];
    NSString *newYear = [timeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *newMonth = [timeStr substringWithRange:NSMakeRange(4, 2)];
    NSString *newDay = [timeStr substringWithRange:NSMakeRange(6, 2)];
    if ([newYear intValue] > [oldYear intValue]) {
        [CommonInfo setKey:@"scanBackCount" withValue:@"0"];
        return YES;
    }else{
        if ([newMonth intValue] > [oldMonth intValue]) {
            [CommonInfo setKey:@"scanBackCount" withValue:@"0"];
            return YES;
        }else{
            if ([newDay intValue] > [oldDay intValue]) {
                [CommonInfo setKey:@"scanBackCount" withValue:@"0"];
                return YES;
            }
        }
    }
    if ([[CommonInfo getKey:@"scanBackCount"] intValue] < 3) {
        return YES;
    }
    return NO;
}

-(void)saveBackTime{
    //获取当前时间
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    NSString *timeStr = [NSString stringWithFormat:@"%04ld%02ld%02ld",(long)comp.year,(long)comp.month,(long)comp.day];
    
    NSString *scanBackCount = [NSString stringWithFormat:@"%d",[[CommonInfo getKey:@"scanBackCount"] intValue] + 1];
    [CommonInfo setKey:@"scanBackCount" withValue:scanBackCount];
    NSLog(@"%@----------",[CommonInfo getKey:@"scanBackCount"]);
    [CommonInfo setKey:@"scanBackTime" withValue:timeStr];
}

#pragma mark AipOcrResultDelegate
- (void)ocrOnIdCardSuccessful:(id)result {
    NSMutableString *message = [NSMutableString string];
    if(((NSDictionary *)result)[@"words_result"]){
        [((NSDictionary *)result)[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [message appendFormat:@"%@: %@\n", key, ((NSDictionary *)obj)[@"words"]];
            NSLog(@"--------%@", message);
        }];
    }
    if (_idCardType == 101) {
        //身份证正面
        [self saveTime];
        if (((NSDictionary *)result)[@"words_result"]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSDictionary *dic = ((NSDictionary *)result)[@"words_result"];
                NSDictionary *dic_Name =[dic objectForKey:@"姓名"];
                NSDictionary *dic_CardNum = [dic objectForKey:@"公民身份号码"];
                if ([NSString stringWithFormat:@"%@",  [dic_Name objectForKey:@"words"]].length > 0 && [NSString stringWithFormat:@"%@",   [dic_CardNum objectForKey:@"words"]].length == 18) {
                    self.nameTextField.text = [NSString stringWithFormat:@"%@",   [dic_Name objectForKey:@"words"]];
                    self.cardNumTextField.text = [NSString stringWithFormat:@"%@",  [dic_CardNum objectForKey:@"words"]];
                    self.nameTextField.enabled = NO;
                    self.cardNumTextField.enabled = NO;
                    if ([self getDocumentImage]) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                        self.imageData = [self getDocumentImage];
                        [self upLoadImageData];
                    }
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"识别失败" message:@"请重新识别身份证" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
    }else if (_idCardType == 102) {
        //身份证反面
        [self saveBackTime];
        if (((NSDictionary *)result)[@"words_result"]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSDictionary *dic = ((NSDictionary *)result)[@"words_result"];
                NSDictionary *dic_loseTime =[dic objectForKey:@"失效日期"];
                NSDictionary *dic_issueTime = [dic objectForKey:@"签发日期"];
                NSDictionary *dic_cardOrgan = [dic objectForKey:@"签发机关"];
                if ([[dic_loseTime objectForKey:@"words"] intValue] > 0 && [[dic_issueTime objectForKey:@"words"] intValue] > 0 && [NSString stringWithFormat:@"%@",[dic_cardOrgan objectForKey:@"words"]].length > 0) {
                    _idCardLimit = [NSString stringWithFormat:@"%@-%@", [dic_issueTime objectForKey:@"words"],[dic_loseTime objectForKey:@"words"]];
                    _idCardSignOrg = [NSString stringWithFormat:@"%@", [dic_cardOrgan objectForKey:@"words"]];
                    if ([self getDocumentImage] ) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                        self.imageData = [self getDocumentImage];
                        [self upLoadImageData];
                    }
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"识别失败" message:@"请重新识别身份证背面" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
    }
}

- (void)ocrOnFail:(NSError *)error {
    NSLog(@"%@", error);
    NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}

// 读取并存贮到相册
-(NSData *)getDocumentImage{
    if (_idCardType == 101) {
        // 读取沙盒路径图片
        NSString *aPath3=[NSString stringWithFormat:@"%@/tmp/%@.png",NSHomeDirectory(),@"Orc"];
        // 拿到沙盒路径图片
        UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
        NSData *imageData = UIImageJPEGRepresentation(imgFromUrl3, 1.0f);
        lastDataOfCardFrontImg = imageData;
        return imageData;
    }else{
        // 读取沙盒路径图片
        NSString *aPath3=[NSString stringWithFormat:@"%@/tmp/%@.png",NSHomeDirectory(),@"Orc2"];
        // 拿到沙盒路径图片
        UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
        NSData *imageData = UIImageJPEGRepresentation(imgFromUrl3, 1.0f);
        lastDataOfcardReverseImg = imageData;
        return imageData;
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (alertView.tag == 1002) {
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)checkAleartViewUI{
    [_checkAleartView  removeFromSuperview];
    
    _checkAleartView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_checkAleartView];
    _checkAleartView.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
    UIView *aleartView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -280 * ScaleSize)/2, 150 * ScaleSize, 280 * ScaleSize, 160 * ScaleSize)];
    [_checkAleartView addSubview:aleartView];
    aleartView.backgroundColor = [UIColor whiteColor];
    aleartView.layer.cornerRadius = 5;
    
    UIView *viewX_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 37.5 * ScaleSize, 280 * ScaleSize, 0.5)];
    [aleartView addSubview:viewX_1];
    viewX_1.backgroundColor = [ResourceManager color_5];
    UILabel *TSLabel = [[UILabel alloc]initWithFrame:CGRectMake((280 * ScaleSize - 180 * ScaleSize)/2, 20 * ScaleSize, 180 * ScaleSize, 35 * ScaleSize)];
    [aleartView addSubview:TSLabel];
    TSLabel.layer.cornerRadius = 35 * ScaleSize/2;
    TSLabel.textColor = [ResourceManager color_9];
    TSLabel.backgroundColor = [UIColor whiteColor];
    TSLabel.font = [UIFont systemFontOfSize:14];
    TSLabel.textAlignment = NSTextAlignmentCenter;
    TSLabel.text = @"请核对您的身份信息";
    TSLabel.layer.borderWidth = 0.5;
    TSLabel.layer.borderColor = [ResourceManager color_9].CGColor;
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70 * ScaleSize, 280 * ScaleSize, 30 * ScaleSize)];
    [aleartView addSubview:textLabel];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = [NSString stringWithFormat:@"%@  %@",_nameTextField.text,_cardNumTextField.text];
    textLabel.textColor = UIColorFromRGB(0x666666);
    
    UIView *viewX_2 = [[UIView alloc]initWithFrame:CGRectMake(0, 120 * ScaleSize, 280 * ScaleSize, 0.5)];
    [aleartView addSubview:viewX_2];
    viewX_2.backgroundColor = [ResourceManager color_5];
    UIView *viewX_3 = [[UIView alloc]initWithFrame:CGRectMake(280 * ScaleSize/3, 120 * ScaleSize, 0.5,  40* ScaleSize)];
    [aleartView addSubview:viewX_3];
    viewX_3.backgroundColor = [ResourceManager color_5];
    UIView *viewX_4 = [[UIView alloc]initWithFrame:CGRectMake(280 * ScaleSize/3 * 2, 120 * ScaleSize, 0.5,  40* ScaleSize)];
    [aleartView addSubview:viewX_4];
    viewX_4.backgroundColor = [ResourceManager color_5];
    NSArray *titleArr = @[@"姓名不正确",@"都不正确",@"确认无误"];
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(280 * ScaleSize/3 * i, 120 * ScaleSize, 280 * ScaleSize/3, 40 * ScaleSize)];
        [aleartView addSubview:btn];
        btn.tag = 100 + i;
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(checkTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)checkTouch:(UIButton *)sender{
     [_checkAleartView removeFromSuperview];
    if (sender.tag == 100) {
        self.nameTextField.text = nil;
        self.nameTextField.enabled  = YES;
        self.nameTextField.placeholder = @"请手动输入真实姓名";
    }else if (sender.tag == 101) {
        self.nameTextField.text = nil;
        self.cardNumTextField.text = nil;
        self.nameTextField.enabled  = YES;
        self.cardNumTextField.enabled  = YES;
        self.nameTextField.placeholder = @"请手动输入真实姓名";
        self.cardNumTextField.placeholder = @"请手动输入正确的身份证号";
    }else if (sender.tag == 102) {
       
    }    
}

#pragma mark ---  网络通讯
-(void) commitInfo
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 请求参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"realImage"] = _frontImgStr;
    params[@"idCardImage"] = _reverseImgStr;
    params[@"realName"] = _nameTextField.text;
    params[@"cardNo"] = _cardNumTextField.text;
    params[@"idCardLimit"] = _idCardLimit;
    params[@"idCardSignOrg"] = _idCardSignOrg;
    params[@"fileType"] = @"identify";
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGmodifyInfo]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];

                                                                                      FaceScanViewController *ctl = [[FaceScanViewController alloc]init];
                                                                                      ctl.isShowJump = _isShowJump;
                                                                                      ctl.paramDic  = params;
                                                                                      [self.navigationController pushViewController:ctl animated:YES];
                                                                                      
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
}


-(void) getRZInfo
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGqueryRZInfo]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      
                                                                                      [self handleData:operation];
//                                                                                      FaceScanViewController *ctl = [[FaceScanViewController alloc]init];
//                                                                                      ctl.paramDic  = params;
//                                                                                      [self.navigationController pushViewController:ctl animated:YES];
                                                                                      
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
//                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (1000 == operation.tag)
     {
        NSDictionary * dic = operation.jsonResult.attr;
        if (dic)
         {
           
            NSDictionary *dicIdentifyInfo = dic[@"identifyInfo"];
            if ([dicIdentifyInfo  count] > 5)
             {
                _frontImgStr =    dicIdentifyInfo[@"realImage"] ;
                _reverseImgStr =  dicIdentifyInfo[@"idCardImage"];
                _nameTextField.text = dicIdentifyInfo[@"realName"];
                _cardNumTextField.text = dicIdentifyInfo[@"cardNo"];
                _idCardLimit = dicIdentifyInfo[@"idCardLimit"];
                _idCardSignOrg = dicIdentifyInfo[@"idCardSignOrg"];
                _reverseImgStr = dicIdentifyInfo[@"idCardImage"];
                _nameTextField.text = dicIdentifyInfo[@"realName"];
                _cardNumTextField.text  =  dicIdentifyInfo[@"cardNo"];
                _idCardLimit = dicIdentifyInfo[@"idCardLimit"] ;
                _idCardSignOrg = dicIdentifyInfo[@"idCardSignOrg"];
                

                [self.cardFrontImg sd_setImageWithURL:[NSURL URLWithString:_frontImgStr]  placeholderImage:[UIImage imageNamed:@"Approve-1"]];
                [self.cardReverseImg sd_setImageWithURL:[NSURL URLWithString:_reverseImgStr] placeholderImage:[UIImage imageNamed:@"Approve-2"]];
             }
            
         }
     }
}


-(void)upLoadImageData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileType"] = @"identify";
    if (_idCardType == 101) {
        params[@"realImage"] = @"1";
    }else if (_idCardType == 102) {
        params[@"idCardImage"] = @"1";
    }
    params[@"signId"] = [DDGSetting sharedSettings].signId;
    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"xxjrIOS%@",currentVersion];
    params[@"appVersion"] = versionStr;
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestManager POST:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGuploadIDCard] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[json objectForKey:@"success"] integerValue] != 0) {
            //把图片添加到视图框内
            NSDictionary *attr = [(NSDictionary *)json objectForKey:@"attr"];
            if ( [attr objectForKey:@"fileId"] && [NSString stringWithFormat:@"%@",[attr objectForKey:@"fileId"] ].length > 0) {
                if (_idCardType == 101) {
                    _frontImgStr = [attr objectForKey:@"fileId"];
                    
                    self.cardFrontImg.image=  [UIImage imageWithData:lastDataOfCardFrontImg];//[UIImage imageWithData:self.imageData];
                }else if (_idCardType == 102) {
                    _reverseImgStr = [attr objectForKey:@"fileId"];
                    self.cardReverseImg.image= [UIImage imageWithData:lastDataOfcardReverseImg]; //[UIImage imageWithData:self.imageData];
                }
                [self handleData];
            }
        }else{
            [MBProgressHUD showErrorWithStatus:@"上传失败" toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        self.imageData = nil;
    }];
}

-(void)handleData{
    [DDGSetting sharedSettings].accountNeedRefresh = YES;
    self.imageData = nil;
    if (_idCardType == 101) {
        //确认身份证信息是否正确
        [self performBlock:^{
            [self checkAleartViewUI];
        } afterDelay:0.5];
    }else{
        [MBProgressHUD showSuccessWithStatus:@"上传图片成功" toView:self.view];
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
