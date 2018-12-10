//
//  MyInfoViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/7/29.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "MyInfoViewController.h"
#import "UIImageView+WebCache.h"

#import "RedactInfoViewController.h"
#import "SelectCityViewController.h"
#import "GaoDeMapViewController.h"
#import "ServeViewController.h"

@interface MyInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIScrollView * _scView;
    UIImageView * _headImg;        // 头像
    UILabel * label_1;            //头像文字1
    UILabel * label_1_2;          //头像未通过原因
    UILabel * _nickLabel;          // 昵称
    UILabel * _nameLabel;          // 姓名
    UILabel * _phoneLabel;         // 电话
    UITextField *_emailTextField;         // 邮箱输入值

    UILabel * _approveLabel;       // 认证
    NSString *strComShort; // 公司简称
    UILabel * _comFullLabel;       // 公司全称
    UILabel * _comTypeLabel;       // 公司类型
    UILabel * _cityLabel;          // 城市
    UITextField * _locusLabel;         // 工作地点
    UILabel * _locationLabel;      // 所在位置
    
    UIView *background;

    NSMutableDictionary * _dataDic;  //用户信息
    
    NSArray *_itemsArray; // 公司类型的数组
    UIView *bgView;  // 公司类型的弹框
    NSString *_compId;  // 公司id
    int _selectedIndex; // 公司类型的Index
    
    // 返回给后台的数据
    NSString *_headImgStr;
    NSString * _longitude;
    NSString * _latitude;
    NSString *_mapAddress;
    
    NSString * _pro;
    NSString * _city;
    NSString * _area;
}

@end

@implementation MyInfoViewController

#pragma mark - 友盟统计
-(void)viewWillAppear:(BOOL)animated{
    _selectedIndex = -1;
    //刷新数据
    if (!_haveAppeared)
     {
        [self InfoURL];
     }
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人信息"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人信息"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"个人信息"];
    
    
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
//    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f,fRightBtnTopY,60.f, 40.0f)];
//    [rightNavBtn setTitle:@"编辑" forState:UIControlStateNormal];
//    [rightNavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
//    [rightNavBtn addTarget:self action:@selector(redactInfo) forControlEvents:UIControlEventTouchUpInside];
//    rightNavBtn.titleLabel.font = [ResourceManager font_6];
//    [nav addSubview:rightNavBtn];
    
    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    _scView.contentSize = CGSizeMake(0, 640);
    
    //关闭翻页效果
    _scView.pagingEnabled = NO;
    //隐藏滚动条
    _scView.showsVerticalScrollIndicator = NO;
    _scView.backgroundColor = [ResourceManager viewBackgroundColor];
    [self.view addSubview:_scView];
    [self laoutUI];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    CGPoint position = CGPointMake(0, 0);
    [_scView setContentOffset:position animated:YES];
    
    [self.view endEditing:YES];
}

-(void)redactInfo{
    RedactInfoViewController *redact = [[RedactInfoViewController alloc]init];
    redact.dataDic = _dataDic;
    [self.navigationController pushViewController:redact animated:YES];
}

-(void)laoutUI{
    UIFont * font = [UIFont systemFontOfSize:14];
    UIColor * color_1 = UIColorFromRGB(0x333333);
    UIColor * color_2 = [ResourceManager color_6];
    
    NSString * strLeftImage = @"com_xinxin";
    
    UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
    [_scView addSubview:viewTitle];
    viewTitle.backgroundColor = UIColorFromRGB(0xFDF9EC);
    
    UILabel *labelT1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 190, 15)];
    [viewTitle addSubview:labelT1];
    labelT1.font = [UIFont systemFontOfSize:13];
    labelT1.textColor = UIColorFromRGB(0x774311);
    labelT1.text = @"请上传本人五官清晰的正装照。";
    
    UILabel *labelT2 = [[UILabel alloc] initWithFrame:CGRectMake(15+ 190, 5, 60, 15)];
    [viewTitle addSubview:labelT2];
    labelT2.font = [UIFont systemFontOfSize:13];
    labelT2.textColor = [UIColor orangeColor];
    labelT2.text = @"【示例】";
    
    //添加手势点击
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    viewTitle.userInteractionEnabled = YES;
    [viewTitle addGestureRecognizer:gesture];
    
    UIView * view_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10+15, SCREEN_WIDTH, 70 + 45)];
    [_scView addSubview:view_1];
    view_1.backgroundColor = [UIColor whiteColor];
    UIView * viewX_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
    [view_1 addSubview:viewX_1];
    viewX_1.backgroundColor = [ResourceManager color_5];
    UIView * viewX_2 = [[UIView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, .5)];
    [view_1 addSubview:viewX_2];
    viewX_2.backgroundColor = [ResourceManager color_5];
    UIView * viewX_3 = [[UIView alloc]initWithFrame:CGRectMake(0, view_1.bounds.size.height - .5, SCREEN_WIDTH, .5)];
    [view_1 addSubview:viewX_3];
    viewX_3.backgroundColor = [ResourceManager color_5];
    label_1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 70)];
    [view_1 addSubview:label_1];
    label_1.font = font;
    label_1.textColor = color_1;
    
    UIImageView *imgLetf1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 8, 8)];
    [view_1 addSubview:imgLetf1];
    imgLetf1.image = [UIImage imageNamed:strLeftImage];
    
    int iStatus = [[_dataDic objectForKey:@"headStatus"] intValue];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"头像（待审核）"];
    if (iStatus == 0)
     {
        label_1.textColor = [UIColor orangeColor];  // 上面状态的底色
        str = [[NSMutableAttributedString alloc] initWithString:@"头像（待审核）"];
     }
    else if (iStatus == 1)
     {
        label_1.textColor = UIColorFromRGB(0x1f83d3);  //  上面状态的底色
        str = [[NSMutableAttributedString alloc] initWithString:@"头像（通过）"];
     }
    else
     {
        label_1.textColor = [UIColor orangeColor];  // 上面状态的底色
        str = [[NSMutableAttributedString alloc] initWithString:@"头像（未通过）"];
     }
    [str addAttribute:NSForegroundColorAttributeName value:color_1 range:NSMakeRange(0,2)];
    label_1.attributedText = str;
    
    
    if (!label_1_2)
     {
        label_1_2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 43, 250, 20)];
        [view_1 addSubview:label_1_2];
        label_1_2.font = [UIFont systemFontOfSize:12];
        label_1_2.textColor = [UIColor orangeColor];
        label_1_2.text = @"原因：上传的照片不符合要求";
     }
    if (iStatus == 2)
     {
        label_1_2.hidden = NO;
     }
    else
     {
        label_1_2.hidden = YES;
     }
    
    
    UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 100, 45)];
    [view_1 addSubview:label_2];
    label_2.font = font;
    label_2.textColor = color_1;
    label_2.text = @"显示名称";
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 5, 60, 60)];
    [view_1 addSubview:_headImg];
    _headImg.image = [UIImage imageNamed:@"my_head2"];
    _headImg.layer.cornerRadius = 60/2;
    // 没这句话倒不了角
    _headImg.layer.masksToBounds = YES;
    
    
    UIButton * upDataImg1 = [[UIButton alloc]initWithFrame:_headImg.frame];
    [view_1 addSubview:upDataImg1];
    [upDataImg1 addTarget:self action:@selector(upDataImg) forControlEvents:UIControlEventTouchUpInside];
    
    _nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 70, 190, 44)];
    [view_1 addSubview:_nickLabel];
    _nickLabel.textAlignment = NSTextAlignmentRight;
    _nickLabel.textColor = color_2;
    _nickLabel.font = font;
    _nickLabel.text = @"未设置";
    
    
    //UIView * view_2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view_1.frame) + 15, SCREEN_WIDTH, 45 * 3)];
    UIView * view_2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view_1.frame) + 15, SCREEN_WIDTH, 45 * 2)];
    [_scView addSubview:view_2];
    view_2.backgroundColor = [UIColor whiteColor];
    UIView * viewX_4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
    [view_2 addSubview:viewX_4];
    viewX_4.backgroundColor = [ResourceManager color_5];
    UIView * viewX_5 = [[UIView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, .5)];
    [view_2 addSubview:viewX_5];
    viewX_5.backgroundColor = [ResourceManager color_5];
    UIView * viewX_6 = [[UIView alloc]initWithFrame:CGRectMake(0, 45 * 2, SCREEN_WIDTH, .5)];
    [view_2 addSubview:viewX_6];
    viewX_6.backgroundColor = [ResourceManager color_5];
    UIView * viewX_7 = [[UIView alloc]initWithFrame:CGRectMake(0, view_2.bounds.size.height - .5, SCREEN_WIDTH, .5)];
    [view_2 addSubview:viewX_7];
    viewX_7.backgroundColor = [ResourceManager color_5];
    UILabel * label_3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 45)];
    [view_2 addSubview:label_3];
    label_3.font = font;
    label_3.textColor = color_1;
    label_3.text = @"真实姓名";
    UILabel * label_4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 100, 45)];
    [view_2 addSubview:label_4];
    label_4.font = font;
    label_4.textColor = color_1;
    label_4.text = @"手机号码";
    UILabel * label_5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 45 * 2, 100, 45)];
    [view_2 addSubview:label_5];
    label_5.font = font;
    label_5.textColor = color_1;
    label_5.text = @"电子邮箱";
    
    UIView * view_3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view_2.frame) + 15, SCREEN_WIDTH, 45 * 6)];
    [_scView addSubview:view_3];
    view_3.backgroundColor = [UIColor whiteColor];
    UIView * viewX_8 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
    [view_3 addSubview:viewX_8];
    viewX_8.backgroundColor = [ResourceManager color_5];
    UIView * viewX_9 = [[UIView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, .5)];
    [view_3 addSubview:viewX_9];
    viewX_9.backgroundColor = [ResourceManager color_5];
    UIView * viewX_10 = [[UIView alloc]initWithFrame:CGRectMake(0, 45 * 2, SCREEN_WIDTH, .5)];
    [view_3 addSubview:viewX_10];
    viewX_10.backgroundColor = [ResourceManager color_5];
    UIView * viewX_12 = [[UIView alloc]initWithFrame:CGRectMake(0, 45 * 3, SCREEN_WIDTH, .5)];
    [view_3 addSubview:viewX_12];
    viewX_12.backgroundColor = [ResourceManager color_5];
    UIView * viewX_13 = [[UIView alloc]initWithFrame:CGRectMake(0, 45 * 4, SCREEN_WIDTH, .5)];
    [view_3 addSubview:viewX_13];
    viewX_13.backgroundColor = [ResourceManager color_5];
    UIView * viewX_14 = [[UIView alloc]initWithFrame:CGRectMake(0, 45 * 5, SCREEN_WIDTH, .5)];
    [view_3 addSubview:viewX_14];
    viewX_14.backgroundColor = [ResourceManager color_5];
    UIView * viewX_15 = [[UIView alloc]initWithFrame:CGRectMake(0, view_3.bounds.size.height - .5, SCREEN_WIDTH, .5)];
    [view_3 addSubview:viewX_15];
    viewX_15.backgroundColor = [ResourceManager color_5];
    UILabel * label_7 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 45)];
    [view_3 addSubview:label_7];
    label_7.font = font;
    label_7.textColor = color_1;
    label_7.text = @"公司简称";
    
    UIImageView *imgLetf_7 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 18, 8, 8)];
    [view_3 addSubview:imgLetf_7];
    imgLetf_7.image = [UIImage imageNamed:strLeftImage];
    

    
    
    UILabel * label_7_1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 45, 100, 45)];
    [view_3 addSubview:label_7_1];
    label_7_1.font = font;
    label_7_1.textColor = color_1;
    label_7_1.text = @"公司全称";
    
    UIImageView *imgLetf_7_1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45 + 18, 8, 8)];
    [view_3 addSubview:imgLetf_7_1];
    imgLetf_7_1.image = [UIImage imageNamed:strLeftImage];
    
    UILabel * label_7_2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 45*2, 100, 45)];
    [view_3 addSubview:label_7_2];
    label_7_2.font = font;
    label_7_2.textColor = color_1;
    label_7_2.text = @"公司类型";
    
    UIImageView *imgLetf7_2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45*2 + 18, 8, 8)];
    [view_3 addSubview:imgLetf7_2];
    imgLetf7_2.image = [UIImage imageNamed:strLeftImage];
    
    UILabel * label_8 = [[UILabel alloc]initWithFrame:CGRectMake(20, 45 * 3 , 100, 45)];
    [view_3 addSubview:label_8];
    label_8.font = font;
    label_8.textColor = color_1;
    label_8.text = @"工作城市";
    
    
    UIImageView *imgLetf8 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45*3 + 18, 8, 8)];
    [view_3 addSubview:imgLetf8];
    imgLetf8.image = [UIImage imageNamed:strLeftImage];
    
    UILabel * label_9 = [[UILabel alloc]initWithFrame:CGRectMake(10, 45 * 4, 100, 45)];
    [view_3 addSubview:label_9];
    label_9.font = font;
    label_9.textColor = color_1;
    label_9.text = @"工作地点";
    UILabel * label_11 = [[UILabel alloc]initWithFrame:CGRectMake(10, 45 * 5, 100, 45)];
    [view_3 addSubview:label_11];
    label_11.font = font;
    label_11.textColor = color_1;
    label_11.text = @"地图位置";
    
    
    NSString * pointStr = @"未填写";
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 220, 0, 210, 45)];
    [view_2 addSubview:_nameLabel];
    _nameLabel.font = font;
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.textColor = color_2;
    _nameLabel.text = @"未认证";
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 220, 45, 210, 45)];
    [view_2 addSubview:_phoneLabel];
    _phoneLabel.font = font;
    _phoneLabel.textAlignment = NSTextAlignmentRight;
    _phoneLabel.textColor = color_2;
    _phoneLabel.text = pointStr;
    _emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 220, 45 * 2, 210, 45)];
    [view_2 addSubview:_emailTextField];
    _emailTextField.font = font;
    _emailTextField.textAlignment = NSTextAlignmentRight;
    _emailTextField.textColor = color_2;
    _emailTextField.text = pointStr;
    _emailTextField.tag = 1000;
    _emailTextField.delegate = self;
    
    
    _approveLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 240, 0 , 230, 45)];
    [view_3 addSubview:_approveLabel];
    _approveLabel.font = font;
    _approveLabel.textAlignment = NSTextAlignmentRight;
    _approveLabel.textColor = color_2;
    _approveLabel.text = @"未认证";
    
    UITapGestureRecognizer * gestureRZ2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionRZ)];
    _approveLabel.userInteractionEnabled = YES;
    [_approveLabel addGestureRecognizer:gestureRZ2];
    
    // 公司全称
    _comFullLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 240, 45 , 230, 45)];
    [view_3 addSubview:_comFullLabel];
    _comFullLabel.font = font;
    _comFullLabel.textAlignment = NSTextAlignmentRight;
    _comFullLabel.textColor = color_2;
    _comFullLabel.text = @"未认证";
    
    UITapGestureRecognizer * gestureRZ1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionRZ)];
    _comFullLabel.userInteractionEnabled = YES;
    [_comFullLabel addGestureRecognizer:gestureRZ1];
    
    // 公司类型
    _comTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 240, 45*2 , 230, 45)];
    [view_3 addSubview:_comTypeLabel];
    _comTypeLabel.font = font;
    _comTypeLabel.textAlignment = NSTextAlignmentRight;
    _comTypeLabel.textColor = color_2;
    _comTypeLabel.text = @"未设置";
    

    
    UITapGestureRecognizer * gestureType = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPickView)];
    _comTypeLabel.userInteractionEnabled = YES;
    [_comTypeLabel addGestureRecognizer:gestureType];
    
    _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 240, 45*3 , 230, 45)];
    [view_3 addSubview:_cityLabel];
    _cityLabel.font = font;
    _cityLabel.textAlignment = NSTextAlignmentRight;
    _cityLabel.textColor = color_2;
    _cityLabel.text = @"未设置";
    
    
    
    UITapGestureRecognizer * gestureCity = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCity)];
    _cityLabel.userInteractionEnabled = YES;
    [_cityLabel addGestureRecognizer:gestureCity];
    
    _locusLabel = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 220, 45 * 4, 210, 45)];
    [view_3 addSubview:_locusLabel];
    _locusLabel.font = font;
    _locusLabel.textAlignment = NSTextAlignmentRight;
    _locusLabel.textColor = color_2;
    _locusLabel.text = @"未设置";
    _locusLabel.tag = 1001;
    _locusLabel.delegate = self;
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 220, 45 * 5, 210, 45)];
    [view_3 addSubview:_locationLabel];
    _locationLabel.font = font;
    _locationLabel.textAlignment = NSTextAlignmentRight;
    _locationLabel.textColor = color_2;
    _locationLabel.text = @"未设置";
    
    
    UITapGestureRecognizer * gestureMap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectMap)];
    _locationLabel.userInteractionEnabled = YES;
    [_locationLabel addGestureRecognizer:gestureMap];
    
    
    UIButton *_logoutBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(view_3.frame) + 15, SCREEN_WIDTH - 30, 40)];
    [_logoutBtn setTitle:@"保存" forState:UIControlStateNormal];
    _logoutBtn.layer.cornerRadius = 3;
    _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _logoutBtn.backgroundColor = [ResourceManager mainColor];
    [_logoutBtn addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    _logoutBtn.tag = 108;
    [_scView addSubview:_logoutBtn];
    

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
    [caseBackBtn setImage:[UIImage imageNamed:@"com_colse"] forState:UIControlStateNormal];
    caseBackBtn.userInteractionEnabled = NO;
    
    
    //创建显示图像的视图
    //初始化要显示的图片内容的imageView
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, 130, 250 , 300)];
    //要显示的图片，即要放大的图片
    [imgView setImage:[UIImage imageNamed:@"my_photo"]];
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

-(void) actionRZ
{
    if ([[_dataDic objectForKey:@"cardStatus"]intValue] == 1)
     {
        [MBProgressHUD showErrorWithStatus:@"工作认证已经通过，请联系客服修改" toView:self.view];
        return;
     }
    
    //服务类型
    ServeViewController *Serve = [[ServeViewController alloc]init];
    //反向传值
    Serve.blockServe = ^(NSArray * arr){
        _approveLabel.text = arr[1];
        strComShort = arr[1];
        _comFullLabel.text= arr[0];
        _compId = [NSString stringWithFormat:@"%@",arr[2]];
    };
    [self.navigationController pushViewController:Serve animated:YES];
    
}

-(void)showPickView{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    background = [[UIView alloc] initWithFrame:window.bounds];
    //    _backGroundView.backgroundColor = [UIColor grayColor];
    [window addSubview:background];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    [background addGestureRecognizer:tap];
    
    UIView *_itemView = [self itemsView];
    [background addSubview:_itemView];
    
    [UIView animateWithDuration:0.2f animations:^{
        //        _backGroundView.alpha = 0.4f;
        float viewHeight = _itemView.height;
        _itemView.frame = CGRectMake(0, window.frame.size.height - viewHeight, window.frame.size.width, viewHeight);
    } completion:^(BOOL finished) {}];
}

-(UIView *)itemsView{
    _itemsArray = @[@"P2P",@"小额贷款",@"网络贷款",@"现金贷款",@"现金贷",@"中介",@"贷款客户",@"银行贷款"];
    if ([PDAPI isTestUser])
     {
        _itemsArray = @[@"公务员事业单位",@"国企单位",@"世界500强",@"上市公司",@"普通企业"];
     }
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 42.0 + 36.0 * _itemsArray.count)];
    bgView.backgroundColor = UIColorFromRGBA(0xffffff, 1);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    titleLabel.center = CGPointMake(bgView.width/2, 20.0);
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.textColor = [ResourceManager color_7];
    titleLabel.text = @"公司类型";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 42.0, bgView.width, 1)];
    line.backgroundColor = [ResourceManager color_5];
    [bgView addSubview:line];
    
    for (int i = 0; i < _itemsArray.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 36)];
        button.center = CGPointMake(bgView.width/2, 60.0 + 36.0 * i);
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitle:_itemsArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = i + 100;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        if (i < _itemsArray.count-1) {
            UIView *subLine = [[UIView alloc] initWithFrame:CGRectMake(30.0, 78.0 + 36.0 * i, bgView.width - 30.0 * 2, 0.6)];
            subLine.backgroundColor = [ResourceManager color_5];
            [bgView addSubview:subLine];
        }
        
        if (i == _selectedIndex) {
            [button setTitleColor:[ResourceManager orangeColor] forState:UIControlStateNormal];
        }
        
    }
    
    return bgView;
}


-(void)buttonClick:(UIButton *)button{
    _selectedIndex = (int)(button.tag - 100);
    [button setTitleColor:[ResourceManager orangeColor] forState:UIControlStateNormal];
    
//    _holderLabel.textColor = [ResourceManager color_7];
     _comTypeLabel.text = _itemsArray[_selectedIndex];
//
//    //重新设置字体颜色
//    if (_colorStyle) {
//        //        _colorStyle = NO;
//        _holderLabel.textColor = UIColorFromRGB(0x268ccf);
//    }
//
//    if (_finishedBlock) {
//        _finishedBlock(_selectedIndex);
//    }
    [self closeView];
}


//选择城市区域
-(void)selectCity{
    [self.view endEditing:YES];
   
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
        _cityLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[dic objectForKey:@"province"],[dic objectForKey:@"areaName"],[dic objectForKey:@"area"]];
    };
    [self.navigationController pushViewController:ctl animated:YES];
    
}

//选择城市区域
-(void)selectMap
{
    if (_cityLabel.text.length == 0 ||
        [_cityLabel.text isEqualToString:@"未选择"] ||
        [_cityLabel.text isEqualToString:@"未设置"] ) {
        [MBProgressHUD showErrorWithStatus:@"请先选择城市区域" toView:self.view];
        return;
    }
    if (_locusLabel.text.length == 0 ||
        [_locusLabel.text isEqualToString:@"未填写"]||
        [_locusLabel.text isEqualToString:@"未设置"]) {
        [MBProgressHUD showErrorWithStatus:@"请先填写工作地点" toView:self.view];
        return;
    }

    //地图位置
    GaoDeMapViewController *cit = [[GaoDeMapViewController alloc]init];
    cit.cityStr = [NSString stringWithFormat:@"%@",_cityLabel.text];
    cit.addressStr = [NSString stringWithFormat:@"%@",_locusLabel.text];
    cit.cityBlock = ^(NSArray * arr){
        _longitude = [NSString stringWithFormat:@"%@",arr[0]];
        _latitude = [NSString stringWithFormat:@"%@",arr[1]];
        _mapAddress = [NSString stringWithFormat:@"%@",arr[2]];
        _locationLabel.text = @"已设置";
    };
    [self.navigationController pushViewController:cit animated:YES];
}

//获取用户信息
-(void)InfoURL
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getUserBaseInfoAPI]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    NSArray *rows=operation.jsonResult.rows;
    if (rows.count > 0) {
        _dataDic = [[NSMutableDictionary alloc]initWithDictionary:rows[0]];
        //避免NULL字段
        for (NSString *key in _dataDic.allKeys) {
            if ([[_dataDic objectForKey:key] isEqual:[NSNull null]]) {
                [_dataDic setValue:@"" forKey:key];
            }
        }
        NSString *headImgUrl=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"headImgUrl"]];
        if(headImgUrl.length > 5)
         {
            _headImgStr = headImgUrl;
         }
        //头像
        [_headImg sd_setImageWithURL:[NSURL URLWithString:headImgUrl] placeholderImage:[UIImage imageNamed:@"my_head2"]];
        _headImg.layer.cornerRadius = 60/2;
        if ([NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"realName"]].length > 0) {
            NSString *name = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"realName"]];
            _nickLabel.text = [NSString stringWithFormat:@"%@经理",[name substringToIndex:1]];
            
        }
        else if ([NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"userName"]].length > 0) {
            NSString *name = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"userName"]];
            _nickLabel.text = name;
            
        }
        
        UIColor * color_1 = UIColorFromRGB(0x333333);
        int iStatus = [[_dataDic objectForKey:@"headStatus"] intValue];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"头像（待审核）"];
        if (iStatus == 0)
         {
            label_1.textColor = [UIColor orangeColor];  // 上面状态的底色
            str = [[NSMutableAttributedString alloc] initWithString:@"头像（待审核）"];
         }
        else if (iStatus == 1)
         {
            label_1.textColor = UIColorFromRGB(0x1f83d3);  //  上面状态的底色
            str = [[NSMutableAttributedString alloc] initWithString:@"头像（通过）"];
         }
        else
         {
            label_1.textColor = [UIColor orangeColor];  // 上面状态的底色
            str = [[NSMutableAttributedString alloc] initWithString:@"头像（未通过）"];
         }
        [str addAttribute:NSForegroundColorAttributeName value:color_1 range:NSMakeRange(0,2)];
        label_1.attributedText = str;
        
        if ([_dataDic objectForKey:@"identifyStatus"] && [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"identifyStatus"]].length > 0) {
        if ([[_dataDic objectForKey:@"identifyStatus"]intValue] == 0) {
            NSString *strRealName = [_dataDic objectForKey:@"realName"];
            NSString *strName= [[NSString alloc]initWithFormat:@"%@(待审核)",strRealName];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strName];
            _nameLabel.textColor = [UIColor orangeColor];
            [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager color_6] range:NSMakeRange(0,strRealName.length)];
            _nameLabel.attributedText = str;
        }else if ([[_dataDic objectForKey:@"identifyStatus"]intValue] == 1){
            NSString *strRealName = [_dataDic objectForKey:@"realName"];
            NSString *strName= [[NSString alloc]initWithFormat:@"%@(通过)",strRealName];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strName];
            _nameLabel.textColor = UIColorFromRGB(0x1f83d3);
            [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager color_6] range:NSMakeRange(0,strRealName.length)];
            _nameLabel.attributedText = str;
        }else if ([[_dataDic objectForKey:@"identifyStatus"]intValue] == 2){
            NSString *strRealName = [_dataDic objectForKey:@"realName"];
            NSString *strName= [[NSString alloc]initWithFormat:@"%@(未通过)",strRealName];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strName];
            _nameLabel.textColor = [UIColor orangeColor];
            [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager color_6] range:NSMakeRange(0,strRealName.length)];
            _nameLabel.attributedText = str;
        }
        }
       _phoneLabel.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"hideTelephone"]];
        if ([NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"email"]].length > 0) {
            _emailTextField.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"email"]];
        }
        if ([_dataDic objectForKey:@"provice"] && [_dataDic objectForKey:@"cityName"] && [_dataDic objectForKey:@"cityArea"] && [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"cityName"]].length > 0) {
            _cityLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[_dataDic objectForKey:@"provice"],[_dataDic objectForKey:@"cityName"],[_dataDic objectForKey:@"cityArea"]];
            _pro = [_dataDic objectForKey:@"provice"];
            _city = [_dataDic objectForKey:@"cityName"];
            _area = [_dataDic objectForKey:@"cityArea"];
            
        }
        
        if ([_dataDic objectForKey:@"cardStatus"] && [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"cardStatus"]].length > 0) {
            if ([[_dataDic objectForKey:@"cardStatus"]intValue] == 0) {
                NSString *strRealName = [_dataDic objectForKey:@"company"];
                NSString *strName= [[NSString alloc]initWithFormat:@"%@(待审核)",strRealName];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strName];
                _approveLabel.textColor = [UIColor orangeColor];
                [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager color_6] range:NSMakeRange(0,strRealName.length)];
                _approveLabel.attributedText = str;
                
                NSString *strComFullName = [_dataDic objectForKey:@"companyDesc"];
                _comFullLabel.text = strComFullName;
                
                NSString *strComType = [_dataDic objectForKey:@"compType"];
                if (!strComType ||
                    strComType.length <= 0)
                 {
                    strComType = @"未设置";
                 }
                _comTypeLabel.text = strComType;
                
            }else if ([[_dataDic objectForKey:@"cardStatus"]intValue] == 1){
                NSString *strRealName = [_dataDic objectForKey:@"company"];
                NSString *strName= [[NSString alloc]initWithFormat:@"%@(通过)",strRealName];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strName];
                _approveLabel.textColor = UIColorFromRGB(0x1f83d3);
                [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager color_6] range:NSMakeRange(0,strRealName.length)];
                _approveLabel.attributedText = str;
                
                
                NSString *strComFullName = [_dataDic objectForKey:@"companyDesc"];
                _comFullLabel.text = strComFullName;
                
                NSString *strComType = [_dataDic objectForKey:@"compType"];
                if (!strComType ||
                    strComType.length <= 0)
                 {
                    strComType = @"未设置";
                 }
                _comTypeLabel.text = strComType;
                
            }else if ([[_dataDic objectForKey:@"cardStatus"]intValue] == 2){
                NSString *strRealName = [_dataDic objectForKey:@"company"];
                NSString *strName= [[NSString alloc]initWithFormat:@"%@(未通过)",strRealName];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strName];
                _approveLabel.textColor = [UIColor orangeColor];
                [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager color_6] range:NSMakeRange(0,strRealName.length)];
                _approveLabel.attributedText = str;
                
                NSString *strComFullName = [_dataDic objectForKey:@"companyDesc"];
                _comFullLabel.text = strComFullName;
                
                NSString *strComType = [_dataDic objectForKey:@"compType"];
                if (!strComType ||
                    strComType.length <= 0)
                 {
                    strComType = @"未设置";
                 }
                _comTypeLabel.text = strComType;
                
                
            }else{
                
                NSString *strComType = [_dataDic objectForKey:@"compType"];
                if (!strComType ||
                    strComType.length <= 0)
                 {
                    strComType = @"未设置";
                 }
                _comTypeLabel.text = strComType;
            }

        }
        
        NSString *straddress = [_dataDic objectForKey:@"address"];
        if (straddress ||
            straddress.length > 0) {
            _locusLabel.text = straddress;
        }
        
        if ([[_dataDic objectForKey:@"longitude"] stringValue].length > 0) {
            _locationLabel.text = @"已设置";
            _longitude = [_dataDic objectForKey:@"longitude"];
            _latitude = [_dataDic objectForKey:@"latitude"];
            _mapAddress = [_dataDic objectForKey:@"mapAddress"];
        }
        
        _compId = [_dataDic objectForKey:@"compId"];
        strComShort = [_dataDic objectForKey:@"company"];
        
        
    }
    if ([_dataDic objectForKey:@"longitude"] && [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"longitude"]].length > 0) {
        _locationLabel.text = @"已设置";
    }
    
    if ([PDAPI isTestUser])
     {
        _comTypeLabel.text = @"国企单位";
     }

}

#pragma mark ==== 保存个人信息
-(void) actionSave
{
    [self.view endEditing:YES];

    if (_headImgStr.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请上传头像" toView:self.view];
        return;
    }
    else if ([_comTypeLabel.text isEqualToString:@"未设置"])
     {
        [MBProgressHUD showErrorWithStatus:@"请选择公司类型" toView:self.view];
        return;
     }
    else if (_cityLabel.text.length == 0 || _pro.length == 0 || _city.length == 0 || _area.length == 0)
     {
        [MBProgressHUD showErrorWithStatus:@"城市区域不能为空" toView:self.view];
        return;
     }
//    else if ( ![_emailTextField.text isEqualToString:@"未填写"] &&
//             ![_emailTextField.text isEmailFormat])
//     {
//        [MBProgressHUD showErrorWithStatus:@"邮箱格式不对" toView:self.view];
//        return;
//     }

    
    [self saveUrl];
}


-(void)saveUrl
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"headImgUrl"]= _headImgStr;
    
    params[@"provice"]= _pro;
    params[@"cityName"]= _city;
    
    // 个人信息里的城市，保存到首页
    if (_city.length > 0)
     {
        [CommonInfo setKey:K_TS_City withValue:_city];
     }
    
    params[@"cityArea"]= _area;
    params[@"address"]=_locusLabel.text;
    if ([_locationLabel.text isEqualToString:@"已设置"])
     {
        params[@"longitude"]=_longitude;
        params[@"latitude"]=_latitude;
        params[@"mapAddress"]= _mapAddress;
     }
//    if ([_emailTextField.text isEmailFormat])
//    {
//       params[@"email"]= _emailTextField.text;
//    }
    params[@"compType"] = _comTypeLabel.text;
    
    params[@"companyDesc"] = _comFullLabel.text;
    params[@"company"] = strComShort;
    params[@"compId"] = _compId;
    

    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userGetModifyInfoAPI]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [[DDGAccountManager sharedManager].userInfo setObject:@(1) forKey:@"infoFlag"];
                                                                                      [MBProgressHUD showSuccessWithStatus:@"保存个人信息成功" toView:self.view];
                                                                                      
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
}

#pragma mark -
#pragma mark UINavigationControllerDelegate
/**
 *  解决取消按钮点击不灵敏问题
 */
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11){
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]){
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
            // iOS 11之后，图片编辑界面最上层会出现一个宽度<42的view，会遮盖住左下方的cancel按钮，使cancel按钮很难被点击到，故改变该view的层级结构
            if (obj.frame.size.width < 42){
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}

#pragma mark === UITextFieldDelegate
//开始编辑时,键盘遮挡文本框，视图上移
-(BOOL)textFieldShouldBeginEditing:(UITextView *)textField
{
    if (textField.tag == 1000 ){
        // 滚动scView
        //textField.text = @"";
        CGPoint position = CGPointMake(0, 100);
        [_scView setContentOffset:position animated:YES];
    }
    if (textField.tag == 1001 ){
        // 滚动scView
        CGPoint position = CGPointMake(0, 370);
        [_scView setContentOffset:position animated:YES];

    }
    
    if ([textField.text isEqualToString:@"未设置"])
     {
        textField.text = @"";
     }
    
    return YES;
}

//上传头像触发函数
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
    //params[@"fileType"] = @"head";
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
        
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[(NSDictionary *)json objectForKey:@"state"] isEqualToString:@"SUCCESS"]) {
            //把图片添加到视图框内
            _headImg.image=[UIImage imageWithData:self.imageData];
            [MBProgressHUD showErrorWithStatus:@"头像验证通过" toView:self.view];
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
