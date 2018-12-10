//
//  RedactInfoViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/8/18.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "RedactInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "SelectCityViewController.h"
#import "DistrictsViewController.h"
#import "MapLocationViewController.h"
//#import "GaoDeMapViewController.h"
#import "ServeViewController.h"

#import "MapLocationViewController.h"
@interface RedactInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UIScrollView * _scView;
    UIImageView *_headImg;
    NSString *_headImgStr;
    
    UILabel * label_2;
    
    UILabel *_cityLabel;                  // 城市
    UITextField *_locusTextField;         // 工作地点
    UILabel * _locationLabel;             // 所在位置
    UITextField *_emailTextField;         // 邮箱
    UITextView *_synopsisTextView;        // 简介
    
    NSString * _longitude;
    NSString * _latitude;
    NSString *_mapAddress;
    
    NSString * _pro;
    NSString * _city;
    NSString * _area;
    
    UIView *background;
    
   
}

@end

@implementation RedactInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"编辑个人信息"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"编辑个人信息"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"个人信息"];
    
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f,fRightBtnTopY,60.f, 40)];
    [rightNavBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [ResourceManager font_6];
    [nav addSubview:rightNavBtn];
    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    _scView.contentSize = CGSizeMake(0, 620);
    
    //关闭翻页效果
    _scView.pagingEnabled = NO;
    _scView.showsVerticalScrollIndicator = NO;
    _scView.backgroundColor = [ResourceManager viewBackgroundColor];
    [self.view addSubview:_scView];
    
    [self laoutUI];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}



- (void) tapAction{
    //创建一个黑色背景
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background = bgView;
    bgView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.6];//[UIColor clearColor];
    [self.view addSubview:bgView];
    
    // 创建按钮的背景框
    UIView *viewKuang = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-330)/2, 85, 300 + 30 , 350 +30  ) ];
    viewKuang.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [bgView addSubview:viewKuang];
    
    
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 300+30, 15)];
    label1.text = @"示例照";
    label1.textAlignment = NSTextAlignmentCenter;
    [viewKuang addSubview:label1];
    
    
    UIButton * caseBackBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-330)/2 + 300, 55,46 * SCREEN_WIDTH/320, 46 * SCREEN_WIDTH/320)];
    [bgView addSubview:caseBackBtn];
    [caseBackBtn setImage:[UIImage imageNamed:@"privatism-45"] forState:UIControlStateNormal];
    caseBackBtn.userInteractionEnabled = NO;
    
    
    //创建显示图像的视图
    //初始化要显示的图片内容的imageView
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, 130, 250 , 300)];
    //要显示的图片，即要放大的图片
    [imgView setImage:[UIImage imageNamed:@"xdjl_zp"]];
    //imgView.backgroundColor = [UIColor yellowColor];
    [bgView addSubview:imgView];
    
    
    
    

    background.userInteractionEnabled = YES;
    //添加点击手势（点击任意地方，退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [bgView addGestureRecognizer:tapGesture];
    
    //[self shakeToShow:bgView];//放大过程中的动画
}

-(void)closeView{
    [background removeFromSuperview];
}

-(void)clickNavButton:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//Return 键回收键盘
- (BOOL)textViewShouldReturn:(UITextField *)textView
{
    //  回收键盘,取消第一响应者
    [_emailTextField resignFirstResponder];
    [_locusTextField resignFirstResponder];
    [_synopsisTextView resignFirstResponder];
    return YES;
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard{
    //[self tapAction];
    [self closeView];
    
    [self.view endEditing:YES];
    _scView.contentSize = CGSizeMake(10, SCREEN_HEIGHT - NavHeight);
}

-(void)laoutUI{
    UIFont * font = [UIFont systemFontOfSize:14];
    UIColor * color_1 = UIColorFromRGB(0x333333);
    UIColor * color_2 = [ResourceManager color_6];
    UIView * view_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 70)];
    [_scView addSubview:view_1];
    view_1.backgroundColor = [UIColor whiteColor];
    UIView * viewX_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
    [view_1 addSubview:viewX_1];
    viewX_1.backgroundColor = [ResourceManager color_5];
    UIView * viewX_2 = [[UIView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, .5)];
    [view_1 addSubview:viewX_2];
    viewX_2.backgroundColor = [ResourceManager color_5];
    
    UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 100, 20)];
    [view_1 addSubview:label_1];
    label_1.font = font;
    
    int iStatus = [[_dataDic objectForKey:@"headStatus"] intValue];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"头像（待审核）"];
    if (iStatus == 0)
     {
        label_1.textColor = [UIColor orangeColor];  // 上面状态的底色
        str = [[NSMutableAttributedString alloc] initWithString:@"头像（待审核）"];
     }
    else if (iStatus == 1)
     {
        label_1.textColor = UIColorFromRGB(0x1f83d3);  // 上面状态的底色
        str = [[NSMutableAttributedString alloc] initWithString:@"头像（通过）"];
     }
    else
     {
        label_1.textColor = [UIColor orangeColor];  // 上面状态的底色
        str = [[NSMutableAttributedString alloc] initWithString:@"头像（未通过）"];
     }
    [str addAttribute:NSForegroundColorAttributeName value:color_1 range:NSMakeRange(0,2)];
    label_1.attributedText = str;
    
    if (!label_2)
     {
        label_2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 250, 20)];
        [view_1 addSubview:label_2];
        label_2.font = font;
        label_2.textColor = [UIColor blueColor];
        str = [[NSMutableAttributedString alloc] initWithString:@"请上传本人五官清晰的正装照。[示例]"];
        //设置字体和设置字体的范围
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 14)];
        //添加文字颜色
        [str addAttribute:NSForegroundColorAttributeName value:color_1 range:NSMakeRange(0,14)];
        label_2.attributedText = str;
        
        //添加手势点击
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        label_2.userInteractionEnabled = YES;
        [label_2 addGestureRecognizer:gesture];
     }
    
    //  通过
    if (iStatus == 1)
     {
        CGRect rectTemp = label_1.frame;
        rectTemp.origin.y = 25;
        label_1.frame = rectTemp;
        label_2.hidden = YES;
        label_2.userInteractionEnabled = NO;
     }
    else
     {
        label_2.hidden = NO;
        label_2.userInteractionEnabled = YES;
     }
    
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 5, 60, 60)];
    [view_1 addSubview:_headImg];
    _headImg.image = [UIImage imageNamed:@"privatism-7"];
    _headImg.layer.cornerRadius = 60/2;
    // 没这句话倒不了角
    _headImg.layer.masksToBounds = YES;
    UIButton * upDataImg = [[UIButton alloc]initWithFrame:CGRectMake(250, 0, SCREEN_WIDTH-250, 55)];
    [view_1 addSubview:upDataImg];
    [upDataImg addTarget:self action:@selector(upDataImg) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * upDataImg1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 170, 55)];
    [view_1 addSubview:upDataImg1];
    [upDataImg1 addTarget:self action:@selector(upDataImg) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * view_2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view_1.frame) + 15, SCREEN_WIDTH, 45 * 3)];
    [_scView addSubview:view_2];
    view_2.backgroundColor = [UIColor whiteColor];
    UIView * viewX_4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
    [view_2 addSubview:viewX_4];
    viewX_4.backgroundColor = [ResourceManager color_5];
    NSArray *titleArr = @[@"城市区域",@"工作地点",@"地图位置"];
    for (int i = 0; i < titleArr.count; i++) {
        //        UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45 * i, 10, 45)];
        //        [view_3 addSubview:starLabel];
        //        starLabel.font = font;
        //        starLabel.textColor = [ResourceManager anjianColor];
        //        starLabel.textAlignment = NSTextAlignmentRight;
        //        starLabel.text = @"*";
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0, 45 * (i + 1) - .5, SCREEN_WIDTH, .5)];
        [view_2 addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 45 * i, 80, 45)];
        [view_2 addSubview:label];
        label.font = font;
        label.textColor = color_1;
        label.text = titleArr[i];
        if (i == 0) {
            _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 45 * i, SCREEN_WIDTH - 95, 45)];
            [view_2 addSubview:_cityLabel];
            _cityLabel.font = font;
            _cityLabel.textColor = color_2;
            _cityLabel.text = @"未选择";
            _cityLabel.textAlignment = NSTextAlignmentRight;
            UIImageView * arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 13,45 * i + 45/2 - 5, 7.5, 12)];
            arrowImg.image=[UIImage imageNamed:@"jiantou"];
            [view_2 addSubview:arrowImg];
            UIButton * cityBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 45 * i, SCREEN_WIDTH, 45)];
            [view_2 addSubview:cityBtn];
            cityBtn.tag = 1;
            [cityBtn addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
        }if (i == 1) {
            _locusTextField= [[UITextField alloc]initWithFrame:CGRectMake(80, 45 * i, SCREEN_WIDTH - 95, 45)];
            [view_2 addSubview:_locusTextField];
            _locusTextField.placeholder = @"请输入县(区)级以下的详细地址";
            _locusTextField.textColor = color_2;
            _locusTextField.font = font;
            _locusTextField.delegate = self;
            _locusTextField.textAlignment = NSTextAlignmentRight;
            _locusTextField.keyboardType = UIKeyboardTypeDefault;
        }if (i == 2) {
            _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 45 * i, SCREEN_WIDTH - 95, 45)];
            [view_2 addSubview:_locationLabel];
            _locationLabel.font = font;
            _locationLabel.textColor = color_2;
            _locationLabel.text = @"未设置";
            _locationLabel.textAlignment = NSTextAlignmentRight;
            UIImageView * arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 13,45 * i + 45/2 - 5, 7.5, 12)];
            arrowImg.image=[UIImage imageNamed:@"jiantou"];
            [view_2 addSubview:arrowImg];
            UIButton * locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 45 * i, SCREEN_WIDTH, 45)];
            [view_2 addSubview:locationBtn];
            locationBtn.tag = 2;
            [locationBtn addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    UIView * view_3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view_2.frame) + 15, SCREEN_WIDTH, 45)];
    [_scView addSubview:view_3];
    view_3.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
    [view_3 addSubview:label];
    label.font = font;
    label.textColor = color_1;
    label.text = @"电子邮箱";
    _emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 110, 45)];
    [view_3 addSubview:_emailTextField];
    _emailTextField.placeholder = @"请输入电子邮箱";
    _emailTextField.textColor = color_2;
    _emailTextField.font = font;
    _emailTextField.delegate = self;
    _emailTextField.tag = 1000;
    _emailTextField.textAlignment = NSTextAlignmentRight;
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
 
    UILabel * synopsisLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(view_3.frame) + 10, 90, 20)];
    [_scView addSubview:synopsisLabel];
    synopsisLabel.font = font;
    synopsisLabel.textColor = color_1;
    synopsisLabel.text = @"个人简介";
    UIView * view_4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(synopsisLabel.frame) + 10, SCREEN_WIDTH, 90)];
    [_scView addSubview:view_4];
    view_4.backgroundColor = [UIColor whiteColor];
    UIView * viewX_5 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
    [view_4 addSubview:viewX_5];
    viewX_5.backgroundColor = [ResourceManager color_5];
    UIView * viewX_6 = [[UIView alloc]initWithFrame:CGRectMake(0, view_4.bounds.size.height - .5, SCREEN_WIDTH, .5)];
    [view_4 addSubview:viewX_6];
    viewX_6.backgroundColor = [ResourceManager color_5];
    
    _synopsisTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 90)];
    [view_4 addSubview:_synopsisTextView];
    _synopsisTextView.textColor = color_2;
    _synopsisTextView.font = font;
    _synopsisTextView.delegate = self;
    _synopsisTextView.text = @"请输入您的个人说明(100字以内)";
    
    [self dataUI];
}

-(void)dataUI{
    if (self.dataDic.count > 0) {
        _headImgStr=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"userImage"]];
        //头像
        [_headImg sd_setImageWithURL:[NSURL URLWithString:_headImgStr] placeholderImage:[UIImage imageNamed:@"privatism-7"]];
        _headImg.layer.cornerRadius = 60/2;
        
        if ([NSString stringWithFormat:@"%@%@%@",[_dataDic objectForKey:@"provice"],[_dataDic objectForKey:@"cityName"],[_dataDic objectForKey:@"cityArea"]].length > 0) {
            _cityLabel.text = [NSString stringWithFormat:@"%@%@%@",[_dataDic objectForKey:@"provice"],[_dataDic objectForKey:@"cityName"],[_dataDic objectForKey:@"cityArea"]];
            _pro = [_dataDic objectForKey:@"provice"];
            _city = [_dataDic objectForKey:@"cityName"];
            _area = [_dataDic objectForKey:@"cityArea"];
        }
        if ([[_dataDic objectForKey:@"longitude"] stringValue].length > 0) {
            _locationLabel.text = @"已设置";
            _longitude = [_dataDic objectForKey:@"longitude"];
            _latitude = [_dataDic objectForKey:@"latitude"];
            _mapAddress = [_dataDic objectForKey:@"mapAddress"];
        }
        _locusTextField.text = [_dataDic objectForKey:@"address"]?:[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"address"]];
        _emailTextField.text = [_dataDic objectForKey:@"email"]?:[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"email"]];
        if ([NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"custDesc"]].length > 0) {
            _synopsisTextView.text = [_dataDic objectForKey:@"custDesc"];
        }
      

    }
}

//保存信息
-(void)saveInfo{
    [self.view endEditing:YES];
    _scView.contentSize = CGSizeMake(10, SCREEN_HEIGHT - NavHeight);
    if (_headImgStr.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请上传头像" toView:self.view];
        return;
    }else if (_cityLabel.text.length == 0 || _pro.length == 0 || _city.length == 0 || _area.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"城市区域不能为空" toView:self.view];
        return;
    }else if (_locusTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"工作地点不能为空" toView:self.view];
        return;
    }else if (_emailTextField.text.length == 0) {
       [MBProgressHUD showErrorWithStatus:@"请填写电子邮箱" toView:self.view];
       return;
    }else if (_synopsisTextView.text.length == 0 || [_synopsisTextView.text isEqualToString:@"请输入您的个人说明(100字以内)"]) {
        [MBProgressHUD showErrorWithStatus:@"请填写个人简介" toView:self.view];
        return;
    }
    [self saveUrl];
}

-(void)saveUrl
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"headImgUrl"]= _headImgStr;
    params[@"provice"]= _pro;
    params[@"cityName"]= _city;
    params[@"cityArea"]= _area;
    params[@"address"]=_locusTextField.text;
    params[@"longitude"]=_longitude;
    params[@"latitude"]=_latitude;
    params[@"mapAddress"]= _mapAddress;
    
    params[@"email"]=_emailTextField.text;
    params[@"custDesc"]=_synopsisTextView.text;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userGetModifyInfoAPI]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [[DDGAccountManager sharedManager].userInfo setObject:@(1) forKey:@"infoFlag"];
                                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                                      
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
}

//选择城市区域
-(void)selectCity:(UIButton *)sender{
    [self.view endEditing:YES];
    if (sender.tag == 1) {
        //选择城市区域
        SelectCityViewController *ctl = [[SelectCityViewController alloc] init];
        ctl.rootVC = self;
        //选择区域
        ctl.area = YES;
        ctl.block = ^(id city){
            NSDictionary * dic = city;
            _pro = [dic objectForKey:@"province"];
            _city = [dic objectForKey:@"areaName"];
            _area = [dic objectForKey:@"area"];
            _cityLabel.text = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"areaName"],[dic objectForKey:@"area"]];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }if (sender.tag == 2) {
        if (_cityLabel.text.length == 0 || [_cityLabel.text isEqualToString:@"未选择"]) {
            [MBProgressHUD showErrorWithStatus:@"请先选择城市区域" toView:self.view];
            return;
        }if (_locusTextField.text.length == 0 || [_locusTextField.text isEqualToString:@"请输入县(区)级以下的详细地址"]) {
            [MBProgressHUD showErrorWithStatus:@"请先填写工作地点" toView:self.view];
            return;
        }
        
        //地图位置
//        GaoDeMapViewController *cit = [[GaoDeMapViewController alloc]init];
//        cit.cityStr = [NSString stringWithFormat:@"%@",_cityLabel.text];
//        cit.addressStr = [NSString stringWithFormat:@"%@",_locusTextField.text];
//        cit.cityBlock = ^(NSArray * arr){
//            _longitude = [NSString stringWithFormat:@"%@",arr[0]];
//            _latitude = [NSString stringWithFormat:@"%@",arr[1]];
//            _mapAddress = [NSString stringWithFormat:@"%@",arr[2]];
//            _locationLabel.text = @"已设置";
//        };
//        [self.navigationController pushViewController:cit animated:YES];
    }
    
}

#pragma mark === UITextFieldDelegate
//开始编辑时,键盘遮挡文本框，视图上移
-(BOOL)textFieldShouldBeginEditing:(UITextView *)textField
{
    if (textField.tag == 1000 ){
        _scView.contentSize = CGSizeMake(10, SCREEN_HEIGHT - NavHeight + 200);
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_scView scrollRectToVisible:CGRectMake(0, _scView.contentSize.height - 200, 10, SCREEN_HEIGHT - NavHeight + 200) animated:YES];
}
//键盘落下事件
- (void)textFieldDidEndEditing:(UITextView *)textField{
    if (textField.tag == 1000 ){
        _scView.contentSize = CGSizeMake(10, SCREEN_HEIGHT - NavHeight + 200);
    }
}
#pragma mark === UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""] && textView.text.length > 100) {
        [MBProgressHUD showErrorWithStatus:@"不能超过100字" toView:self.view];
        return NO;
    }
    
    //禁止输入表情
    NSString *textNot = [self disable_emoji:text];
    if (![text isEqualToString:textNot]) {
        return NO;
    }
    return YES;
}


- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == _synopsisTextView) {
        _scView.contentSize = CGSizeMake(10, SCREEN_HEIGHT - NavHeight + 200);
        [_scView scrollRectToVisible:CGRectMake(0, _scView.contentSize.height - 200, 10, SCREEN_HEIGHT - NavHeight + 200) animated:YES];
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (_synopsisTextView.text == nil || _synopsisTextView.text.length < 1) {
        _synopsisTextView.text = @"请输入您的个人说明(100字以内)";
    }
    _scView.contentSize = CGSizeMake(10, SCREEN_HEIGHT - NavHeight);
}

//上传头像
-(void)upDataImg{
    [self.view endEditing:YES];
    UIActionSheet *sheet =  [[UIActionSheet alloc] initWithTitle:@"选择"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照",@"从相册选择", nil];
    [sheet showInView:self.view];
}
//上传头像
#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if (buttonIndex == 0 || buttonIndex == 1)//从相册中获取照片
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                return;
            }
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.allowsEditing = YES;
            
            [self.navigationController presentViewController:pickerController animated:YES completion:nil];
        }
    }
    else {
        if (buttonIndex == 0) //拍摄
        {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                                           UIImagePickerControllerSourceTypeCamera];
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.allowsEditing = YES;
            
            [self.navigationController presentViewController:pickerController animated:YES completion:nil];
        } else if (buttonIndex == 1) //从相册中获取照片
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                return;
            }
            
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.allowsEditing = YES;
            if (iOS7) {
                pickerController.navigationBar.barTintColor = [ResourceManager redColor2];
            }else{
                pickerController.navigationBar.tintColor = [ResourceManager redColor2];
            }
            
            [self.navigationController presentViewController:pickerController animated:YES completion:nil];
        }
    }
}
#pragma mark -
#pragma mark UIImagePickerViewControllerDelegate
/**
 *  Tells the delegate that the user picked a still image or movie.
 *
 *  @param picker
 *  @param info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
#define dataSize 1024.0f
#define imageSize CGSizeMake(600.0f, 600.0f)
    //先把原图保存到图片库
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
    }
    //获取用户选取的图片并转换成NSData
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //缩小图片的size
    image = [self imageByRedraw:image];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2f);
    if (imageData){
        self.imageData = imageData;
        // 上传
        [self upLoadImageData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *  截图
 *
 *  @param image
 *
 *  @return UIImage
 */
- (UIImage *)imageByRedraw:(UIImage *)image
{
    if (image.size.width == image.size.height)
    {
        UIGraphicsBeginImageContext(imageSize);
        CGRect rect = CGRectZero;
        rect.size = imageSize;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextFillRect(ctx, rect);
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
        CGFloat ratio = image.size.width / image.size.height;
        CGSize size = CGSizeZero;
        
        if (image.size.width > imageSize.width)
        {
            size.width = imageSize.width;
            size.height = size.width / ratio;
        }
        else if (image.size.height > imageSize.height)
        {
            size.height = imageSize.height;
            size.width = size.height * ratio;
        }
        else
        {
            size.width = image.size.width;
            size.height = image.size.height;
        }
        //这里的size是最终获取到的图片的大小
        UIGraphicsBeginImageContext(imageSize);
        CGRect rect = CGRectZero;
        rect.size = imageSize;
        //先填充整个图片区域的颜色为黑色
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextFillRect(ctx, rect);
        rect.origin = CGPointMake((imageSize.width - size.width)/2, (imageSize.height - size.height)/2);
        rect.size = size;
        //画图
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}
-(void)upLoadImageData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileType"] = @"mjbHead";
    params[@"signId"] = [DDGSetting sharedSettings].signId;
    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"xdjlIOS%@",currentVersion];
    params[@"appVersion"] = versionStr;
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestManager POST:[PDAPI getSendFileAPI] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        //把图片添加到视图框内
        _headImg.image=[UIImage imageWithData:self.imageData];
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[(NSDictionary *)json objectForKey:@"state"] isEqualToString:@"SUCCESS"]) {
            [MBProgressHUD showErrorWithStatus:@"上传成功" toView:self.view];
            [self handleData];
            _headImgStr = [(NSDictionary *)json objectForKey:@"fileId"];
        }else{
            [MBProgressHUD showErrorWithStatus:[(NSDictionary *)json objectForKey:@"statusText"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        self.imageData = nil;
    }];
}
-(void)handleData{
    [DDGSetting sharedSettings].accountNeedRefresh = YES;
}


@end
