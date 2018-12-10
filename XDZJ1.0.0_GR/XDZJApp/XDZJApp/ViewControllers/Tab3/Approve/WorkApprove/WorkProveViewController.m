//
//  WorkProveViewController.m
//  XXJR
//
//  Created by xxjr03 on 2017/8/1.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "WorkProveViewController.h"

#import "TextFieldView.h"
#import "PickerView.h"
#import "SelectCityViewController.h"
#import "ServeViewController.h"
#import "MapLocationViewController.h"
#import "GaoDeMapViewController.h"

#import "UpLoadWorkViewController.h"

@interface WorkProveViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    UIScrollView *_scView;
    UIView *_fristView;
    UIView *_secondView;
    UIView *_thirdView;
    UIButton *_referBtn;
    
    PickerView *_pickViewComFull;       //公司全称
    PickerView *_pickViewComType;       //公司类型
    PickerView *_pickViewCity;          //城市区域
    PickerView *_pickViewLocation;      //地理位置
    PickerView *_pickViewComPhoto;      //工牌照
    
    TextFieldView *_ComShortFieldView;   //公司简称
    TextFieldView *_jobNameFieldView;    //职位名称
    TextFieldView *_jobLocatFieldView;   //工作地点

    
    NSString *_compId;
    NSString *_pro;
    NSString *_city;
    NSString *_area;
    NSString *_longitude;
    NSString *_latitude;
    NSString *_mapAddress;
    NSString *_jobImage;
    NSArray   *arrayCompanyType; // 公司类型数组
    int iSelComType;
    
}

@end

@implementation WorkProveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"工作认证"];

    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:_scView];
    _scView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    //关闭翻页效果
    _scView.pagingEnabled = NO;
    //隐藏滚动条
    _scView.showsVerticalScrollIndicator = NO;

    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    
    [self layoutUI];
    [self dataSource];
    
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
}

-(void) actionJump
{
    NSNotification *notifcation = [[NSNotification alloc]initWithName:DDGAccountEngineDidLoginNotification object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notifcation];
}
//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [self.view endEditing:YES];
}


//初始化数据
-(void)dataSource{
    if (self.workDic.count == 0) {
        return;
    }
    
    if ([self.workDic objectForKey:@"status"]) {
        self.type = [[self.workDic objectForKey:@"status"] intValue];
        
        UILabel *lalbel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 85, 44)];
        [_fristView addSubview:lalbel];
        lalbel.text = @"认证失败";
        lalbel.textAlignment = NSTextAlignmentRight;
        lalbel.font = [UIFont systemFontOfSize:14];
        lalbel.textColor = [ResourceManager color_1];
        
        if ([[_workDic objectForKey:@"status"] intValue] == -1) {
            lalbel.text = @"未认证";
        }else if ([[_workDic objectForKey:@"status"] intValue] == 0) {
            lalbel.text = @"认证待审核";
        }else if ([[_workDic objectForKey:@"status"] intValue] == 1) {
            lalbel.textColor = UIColorFromRGB(0x00AC61);
            lalbel.text = @"认证成功";
        }else if ([[_workDic objectForKey:@"status"] intValue] == 2) {
            lalbel.textColor = UIColorFromRGB(0xE52228);
            lalbel.text = @"认证失败";
        }
    }

    if ([self.workDic objectForKey:@"cardImage"] && [NSString stringWithFormat:@"%@",[self.workDic objectForKey:@"cardImage"]].length > 0)
    {
        _jobImage = [self.workDic objectForKey:@"cardImage"];
    }
    // 公司名字不为空，则赋值
    if ([self.workDic objectForKey:@"company"] && [NSString stringWithFormat:@"%@",[self.workDic objectForKey:@"company"]].length > 0 &&
        [self.workDic objectForKey:@"companyDesc"] && [NSString stringWithFormat:@"%@",[self.workDic objectForKey:@"companyDesc"]].length > 0)
    {
        _pickViewComFull.placeHolder = [self.workDic objectForKey:@"companyDesc"]?:@"";
        _ComShortFieldView.textField.text = [self.workDic objectForKey:@"company"]?:@"";
        _compId = [self.workDic objectForKey:@"compId"];
    }
    if ([self.workDic objectForKey:@"workName"] && [NSString stringWithFormat:@"%@",[self.workDic objectForKey:@"workName"]].length > 0){
        _jobNameFieldView.textField.text = [self.workDic objectForKey:@"workName"]?:@"";
    }
    
    if ([self.workDic objectForKey:@"compType"] && [NSString stringWithFormat:@"%@",[self.workDic objectForKey:@"compType"]].length > 0){
        _pickViewComType.holderLabel.text = [self.workDic objectForKey:@"compType"]?:@"未知";
        _pickViewComType.holderLabel.textColor = [ResourceManager color_1];
    }
    
    if([PDAPI isTestUser])
     {
        _pickViewComType.holderLabel.textColor = [ResourceManager color_1];
        _pickViewComType.holderLabel.text = @"国企单位";
     }
    
    if ([self.workDic objectForKey:@"provice"] && [NSString stringWithFormat:@"%@",[self.workDic objectForKey:@"provice"]].length > 0){
        _pro = [self.workDic objectForKey:@"provice"];
        _city = [self.workDic objectForKey:@"cityName"];
        _area = [self.workDic objectForKey:@"cityArea"];
        _pickViewCity.placeHolder = [NSString stringWithFormat:@"%@%@%@",_pro,_city,_area];
    }
    if ([self.workDic objectForKey:@"address"] && [NSString stringWithFormat:@"%@",[self.workDic objectForKey:@"address"]].length > 0){
        _jobLocatFieldView.textField.text = [self.workDic objectForKey:@"address"]?:@"";
    }
    if ([self.workDic objectForKey:@"longitude"] && [NSString stringWithFormat:@"%@",[self.workDic objectForKey:@"longitude"]].length > 0) {
        _longitude = [self.workDic objectForKey:@"longitude"];
        _latitude = [self.workDic objectForKey:@"latitude"];
        _mapAddress = [self.workDic objectForKey:@"mapAddress"];
        _pickViewLocation.placeHolder = @"已设置";        
    }    
    if ([self.workDic objectForKey:@"cardImage"] && [NSString stringWithFormat:@"%@",[self.workDic objectForKey:@"cardImage"]].length > 0) {
        _jobImage = [self.workDic objectForKey:@"cardImage"];
        _pickViewComPhoto.placeHolder = @"已上传";
    }
    if (self.type == 2 && [self.workDic objectForKey:@"auditDesc"] && [NSString stringWithFormat:@"%@",[self.workDic objectForKey:@"auditDesc"]].length > 0) {
        _secondView.frame = CGRectMake(0, CGRectGetMaxY(_fristView.frame), SCREEN_WIDTH, 35);
        UILabel *errorLalbel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 35)];
        [_secondView addSubview:errorLalbel];
        errorLalbel.backgroundColor = UIColorFromRGB(0xFCEDE8);
        errorLalbel.numberOfLines = 2;
        errorLalbel.text = [NSString stringWithFormat:@"失败原因:%@",[self.workDic objectForKey:@"auditDesc"]];
        errorLalbel.font = [UIFont systemFontOfSize:12];
        errorLalbel.textColor = UIColorFromRGB(0xE52228);
        _thirdView.frame = CGRectMake(0, CGRectGetMaxY(_secondView.frame), SCREEN_WIDTH, 44 * 8);
        _referBtn.frame = CGRectMake(15, CGRectGetMaxY(_thirdView.frame) + 25, SCREEN_WIDTH - 30, 40 * ScaleSize);
    }else{
        [_secondView removeFromSuperview];
        _secondView.frame = CGRectMake(0, CGRectGetMaxY(_fristView.frame), SCREEN_WIDTH, 0.5);
        UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(0, _secondView.bounds.size.height - 0.5, SCREEN_WIDTH, 0.5)];
        [_secondView addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        _thirdView.frame = CGRectMake(0, CGRectGetMaxY(_secondView.frame), SCREEN_WIDTH, 44 * 8);
        _referBtn.frame = CGRectMake(15, CGRectGetMaxY(_thirdView.frame) + 25, SCREEN_WIDTH - 30, 40 * ScaleSize);
    }
}

-(void)layoutUI
{

    _fristView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
    [_scView addSubview:_fristView];
    _fristView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 44)];
    [_fristView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"工作认证";
    _secondView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_fristView.frame), SCREEN_WIDTH, 0.5)];
    [_scView addSubview:_secondView];
    _secondView.backgroundColor = [UIColor whiteColor];
    
    UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(0, _secondView.bounds.size.height - 0.5, SCREEN_WIDTH, 0.5)];
    [_secondView addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
    
    _thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_secondView.frame), SCREEN_WIDTH, 44 * 7)];
    [_scView addSubview:_thirdView];
    _thirdView.backgroundColor = [UIColor whiteColor];
    
    [self thirdViewUI];
}

//工作认证布局
-(void)thirdViewUI{
   
    __weak typeof(self) weakSelf = self;
    NSString * strLeftImage = @"com_xinxin";
    _pickViewComFull = [[PickerView alloc]initWithTitle:@"公司全称"  imageName:strLeftImage  placeHolder:@"请选择" itemArray:nil origin_Y:0];
    [_thirdView addSubview:_pickViewComFull];
    __block typeof(_pickViewComFull) weakComFull = _pickViewComFull;
    _pickViewComFull.showPicker = NO;
    _pickViewComFull.beginBlock = ^{
         [weakSelf.view endEditing:YES];
        if (self.type != 1)
         {
            //服务类型
            ServeViewController *Serve = [[ServeViewController alloc]init];
            //反向传值
            Serve.blockServe = ^(NSArray * arr){
                weakComFull.placeHolder = arr[0];
                _ComShortFieldView.textField.text = arr[1];
                _compId = [NSString stringWithFormat:@"%@",arr[2]];
            };
            [weakSelf.navigationController pushViewController:Serve animated:YES];
        }
    };
    
    


    _ComShortFieldView = [[TextFieldView alloc] initWithImageName:strLeftImage withTitle:@"公司简称" placeHolder:@"请输入公司简称" originY:CGRectGetMaxY(_pickViewComFull.frame) fieldViewType:TextFieldViewDefault];
    [_thirdView addSubview:_ComShortFieldView];
    [_ComShortFieldView.textField setEnabled:NO];
    
    arrayCompanyType =@[@"P2P",@"小额贷款",@"网络贷款",@"现金贷款",@"现金贷",@"中介",@"贷款客户",@"银行贷款"];
    if ([PDAPI isTestUser])
     {
        arrayCompanyType =@[@"国企单位",@"事业单位",@"世界500强",@"上市公司",@"普通公司"];
     }
    iSelComType = -1;
    _pickViewComType = [[PickerView alloc] initWithTitle:@"公司类型" imageName:strLeftImage placeHolder:@"请选择" itemArray:arrayCompanyType origin_Y:CGRectGetMaxY(_ComShortFieldView.frame) ];
    [_thirdView addSubview:_pickViewComType];
    _pickViewComType.finishedBlock = ^(int index){
        iSelComType = index;
    };
    
    _jobNameFieldView = [[TextFieldView alloc] initWithImageName:strLeftImage withTitle:@"职位名称" placeHolder:@"请输入您的职位名称" originY:CGRectGetMaxY(_pickViewComType.frame) fieldViewType:TextFieldViewDefault];
    [_thirdView addSubview:_jobNameFieldView];
    
    //_pickViewCity = [[PickerView alloc]initWithTitle:@"所在城市" placeHolder:@"请选择" origin_Y:CGRectGetMaxY(_jobNameFieldView.frame)];
    _pickViewCity = [[PickerView alloc]initWithTitle:@"城市区域" imageName:strLeftImage  placeHolder:@"请选择"  itemArray:nil origin_Y:CGRectGetMaxY(_jobNameFieldView.frame)];
    [_thirdView addSubview:_pickViewCity];
    _pickViewCity.showPicker = NO;
    __block typeof(_pickViewCity) weakCity = _pickViewCity;
    _pickViewCity.beginBlock = ^{
         [weakSelf.view endEditing:YES];
         //if (self.type != 1)
         {
            //选择城市区域
            SelectCityViewController *ctl = [[SelectCityViewController alloc] init];
            ctl.rootVC = weakSelf;
            //选择区域
            ctl.area = YES;
            ctl.block = ^(id city){
                 NSDictionary * dic = city;
                _pro = [dic objectForKey:@"province"];
                _city = [dic objectForKey:@"areaName"];
                _area = [dic objectForKey:@"area"];
                weakCity.placeHolder = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"areaName"],[dic objectForKey:@"area"]];
            };
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        }
        
    };
    
    _jobLocatFieldView = [[TextFieldView alloc]initWithTitle:@"工作地点" placeHolder:@"请输入县(区)以下详细地址" originY:CGRectGetMaxY(_pickViewCity.frame) fieldViewType:TextFieldViewDefault];
    [_thirdView addSubview:_jobLocatFieldView];
    __block typeof(_jobLocatFieldView) weakjobLocat = _jobLocatFieldView;
    
    _pickViewLocation = [[PickerView alloc]initWithTitle:@"地理位置" placeHolder:@"未设置" origin_Y:CGRectGetMaxY(_jobLocatFieldView.frame)];
    [_thirdView addSubview:_pickViewLocation];
    __block typeof(_pickViewLocation) weakLocation = _pickViewLocation;
    _pickViewLocation.showPicker = NO;
    _pickViewLocation.beginBlock = ^{
         [weakSelf.view endEditing:YES];
        
        if (_pickViewCity.placeHolder.length == 0) {
            [MBProgressHUD showErrorWithStatus:@"请先选择城市区域" toView:weakSelf.view];
            return;
        }if (_jobLocatFieldView.textField.text.length == 0) {
            [MBProgressHUD showErrorWithStatus:@"请先填写工作地点" toView:weakSelf.view];
            return;
        }
        //地图位置
        GaoDeMapViewController *cit = [[GaoDeMapViewController alloc]init];
        cit.cityStr = [NSString stringWithFormat:@"%@",weakCity.placeHolder];
        cit.addressStr = [NSString stringWithFormat:@"%@",weakjobLocat.textField.text];
        cit.cityBlock = ^(NSArray * arr){
            _longitude = [NSString stringWithFormat:@"%@",arr[0]];
            _latitude = [NSString stringWithFormat:@"%@",arr[1]];
            _mapAddress = [NSString stringWithFormat:@"%@",arr[2]];
            weakLocation.placeHolder = @"已设置";
        };
        [weakSelf.navigationController pushViewController:cit animated:YES];
        
        
    };
    
    
    _pickViewComPhoto = [[PickerView alloc] initWithTitle:@"工牌照" imageName:strLeftImage placeHolder:@"未上传"  itemArray:nil origin_Y:CGRectGetMaxY(_pickViewLocation.frame)];
    [_thirdView addSubview:_pickViewComPhoto];
    _pickViewComPhoto.showPicker = NO;
    __block typeof(_pickViewComPhoto) weakPhoto = _pickViewComPhoto;
    _pickViewComPhoto.beginBlock = ^{
        [weakSelf.view endEditing:YES];
        
        UpLoadWorkViewController *ctl = [[UpLoadWorkViewController alloc]init];
        ctl.statusType = weakSelf.type;
        ctl.jobImage = _jobImage;
        ctl.workBlock = ^(NSString *str){
            _jobImage = str;
            weakPhoto.placeHolder = @"已上传";
        };
        [weakSelf.navigationController pushViewController:ctl animated:YES];
    };

    _referBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_thirdView.frame) + 25, SCREEN_WIDTH - 30, 40 * ScaleSize)];
    [_scView addSubview:_referBtn];
    _referBtn.backgroundColor = [ResourceManager mainColor];
    [_referBtn setTitle:@"提交认证" forState:UIControlStateNormal];
    [_referBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _referBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _referBtn.layer.cornerRadius = 5;
    [_referBtn addTarget:self action:@selector(refer) forControlEvents:UIControlEventTouchUpInside];
}

-(void)refer{
     [self.view endEditing:YES];
   if (_pickViewComFull.placeHolder == 0 || _ComShortFieldView.textField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"公司名称不能为空" toView:self.view];
        return;
   }else if (_pickViewComType.holderLabel.text.length == 0) {
       [MBProgressHUD showErrorWithStatus:@"公司类型不能为空" toView:self.view];
       return;
   }else if (_jobNameFieldView.textField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"职位名称不能为空" toView:self.view];
        return;
    }else if (_pickViewCity.placeHolder == 0) {
        [MBProgressHUD showErrorWithStatus:@"请选择城市区域" toView:self.view];
        return;
    }
//    else if (_jobLocatFieldView.textField.text.length == 0) {
//        [MBProgressHUD showErrorWithStatus:@"请填写工作地点" toView:self.view];
//        return;
//    }
    else if (_pickViewComPhoto.placeHolder == 0) {
        [MBProgressHUD showErrorWithStatus:@"请上传工牌照" toView:self.view];
        return;
    }
    [self proveUrl];
}

//认证按钮
-(void)proveUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"companyDesc"] = _pickViewComFull.placeHolder;
    params[@"company"] = _ComShortFieldView.textField.text;
    params[@"workName"] = _jobNameFieldView.textField.text;
    params[@"compType"] = _pickViewComType.holderLabel.text;
    params[@"cardImage"] = _jobImage;
    params[@"compId"] = _compId;
    params[@"provice"]= _pro;
    params[@"cityName"]= _city;
    params[@"cityArea"]= _area;
    params[@"address"]=_jobLocatFieldView.textField.text;
    params[@"longitude"]=_longitude;
    params[@"latitude"]=_latitude;
    params[@"mapAddress"]= _mapAddress;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"mjb/account/auth/addWorkInfo"]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD showSuccessWithStatus:@"提交成功" toView:self.view];
                                                                                      //延时操作
                                                                                      [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
}

-(void)delayMethod
{
    if (_isShowJump)
     {
        [self actionJump];
        return;
     }
    
    self.proveBlock();
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark === UITextFieldDelegate
//开始编辑时,键盘遮挡文本框，视图上移
-(BOOL)textFieldShouldBeginEditing:(UITextView *)textField
{
    _scView.contentSize = CGSizeMake(10, SCREEN_HEIGHT - NavHeight - 40 + 200);
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_scView scrollRectToVisible:CGRectMake(0, _scView.contentSize.height - 200, 10, SCREEN_HEIGHT - NavHeight - 40 + 200) animated:YES];
}
//键盘落下事件
- (void)textFieldDidEndEditing:(UITextView *)textField{
    _scView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - NavHeight);
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
