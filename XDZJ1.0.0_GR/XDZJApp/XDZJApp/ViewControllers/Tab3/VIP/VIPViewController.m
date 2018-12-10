//
//  VIPViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/10/26.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "VIPViewController.h"
#import "VIPViewControllerCtl_2.h"
#import "NewVipViewControllerCtl_2.h"
#import "PayRecordVC.h"
#import "CCWebViewController.h"
#import "VipHytqVC.h"

@interface VIPViewController ()
{
    UIScrollView *_scView;
    UIImageView *_headImage;
    UIImageView *_vipImage;
    UILabel *_nameLabel;       //姓名
    UILabel *_timeLabel;       //到期时间
    UILabel *_balanceLabel;    //余额
    
    UILabel *_vipLabel;
    UIButton *_dredgeBtn;
    
    NSArray *_vipDataArr;
    
    CGFloat _currantHeight;
}
@property (strong, nonatomic) IBOutlet UIView *freedomViwe_1;


@end

@implementation VIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"VIP会员"];
    
    float fRightBtnTopY = NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80.f,fRightBtnTopY,80.f, 35.0f)];
    [rightNavBtn setTitle:@"充值记录" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(actionRecord) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [nav addSubview:rightNavBtn];
    
    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    //关闭翻页效果
    _scView.pagingEnabled = NO;
    //隐藏滚动条
    _scView.showsVerticalScrollIndicator = NO;
    _scView.backgroundColor = [ResourceManager viewBackgroundColor];
    [self.view addSubview:_scView];
    [self layoutUI_1];
    [self layoutUI_2];
    
    [self vipPackageUrl];
}

-(void) actionRecord
{
    PayRecordVC  *vc = [[PayRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)layoutUI_1{
    //头像余额等信息
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 105)];
    [_scView addSubview:headView];
    headView.backgroundColor = [UIColor whiteColor];
    
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 25, 60, 60)];
    [headView addSubview:_headImage];
    _headImage.image = [UIImage imageNamed:@"privatism-7"];
    // 没这句话倒不了角
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = 60/2;
    _headImage.layer.borderWidth = .5;
    _headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if (self.imageUrl.length > 0) {
        [_headImage setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"privatism-7"]];
    }
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame) + 10, 25, 55,21)];
    _nameLabel.textColor = [ResourceManager color_1];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.text = self.name;
    [headView addSubview:_nameLabel];
    //自适应label
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(55, 21);//labelsize的最大值
    //关键语句
    CGSize expectSize = [_nameLabel sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headImage.frame) + 10, 25, expectSize.width,30);
    //
    _vipImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 5,CGRectGetMinY(_nameLabel.frame) + (30 - 12.5)/2, 22, 12.5)];
    [headView addSubview:_vipImage];
    _vipImage.image = [UIImage imageNamed:@"VIP-11"];
    
    _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame) + 10, CGRectGetMaxY(_nameLabel.frame), 150,30)];
    _balanceLabel.textColor = [ResourceManager color_6];
    _balanceLabel.font = [UIFont systemFontOfSize:13];
    _balanceLabel.text = [NSString stringWithFormat:@"账户余额 %@ 元",self.usableAmount];
    [headView addSubview:_balanceLabel];
    
    
    UIView *dredgeViwe = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame) + 15, SCREEN_WIDTH, 45)];
    [_scView addSubview:dredgeViwe];
    dredgeViwe.backgroundColor = [UIColor whiteColor];
    
    _currantHeight = CGRectGetMaxY(dredgeViwe.frame);
    
    UIImageView *vipImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (45 - 19)/2, 22 , 19)];
    [dredgeViwe addSubview:vipImgView];
    vipImgView.image = [UIImage imageNamed:@"privatism-4"];
    _vipLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(vipImgView.frame) + 10,0, 75, 45)];
    _vipLabel.textColor = UIColorFromRGB(0x333333);
    _vipLabel.font = [UIFont systemFontOfSize:14];
    _vipLabel.text = @"未开通会员";
    [dredgeViwe addSubview:_vipLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_vipLabel.frame),0, 150,45)];
    _timeLabel.textColor = [ResourceManager color_6];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.text = @"您还没有开通会员哦";
    [dredgeViwe addSubview:_timeLabel];
    
    _dredgeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 7.5, 70, 30)];
    [dredgeViwe addSubview:_dredgeBtn];
    _dredgeBtn.backgroundColor = UIColorFromRGB(0xC69548);
    [_dredgeBtn setTitle:@"立即开通" forState:UIControlStateNormal];
    _dredgeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_dredgeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _dredgeBtn.layer.cornerRadius = 3;
    [_dredgeBtn addTarget:self action:@selector(dredge) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.vipGrade == 1 && self.vipEndDate.length > 0) {
        _vipLabel.text = @"VIP会员";
        [_dredgeBtn setTitle:@"续费" forState:UIControlStateNormal];
        _vipImage.image = [UIImage imageNamed:@"VIP-12"];
        _timeLabel.text = [NSString stringWithFormat:@"%@到期",self.vipEndDate];
    }else if (self.vipGrade == 0) {
        _vipLabel.text = @"未开通会员";
        [_dredgeBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        _timeLabel.text = @"您还没有开通会员哦";
        _vipImage.image = [UIImage imageNamed:@"VIP-11"];
    }
    
}

//开通VIP或充值
- (void)dredge{
    
    NewVipViewControllerCtl_2 *ctl = [[NewVipViewControllerCtl_2 alloc]init];
    ctl.usableAmount = self.usableAmount;
    ctl.vipGrade = self.vipGrade;
    ctl.vipEndDate = self.vipEndDate;
    if (_vipDataArr.count > 0) {
        ctl.vipDataArr = _vipDataArr;
    }
    [self.navigationController pushViewController:ctl animated:YES];
}



//会员特权
-(void)layoutUI_2{

    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:13];
    
    UIView *freedomViwe = [[UIView alloc]initWithFrame:CGRectMake(0, _currantHeight + 10, SCREEN_WIDTH, 57.5 * SCREEN_WIDTH/320)];
    [_scView addSubview:freedomViwe];
    freedomViwe.backgroundColor = [UIColor whiteColor];
    
    UIImageView *freedomImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 57.5 * SCREEN_WIDTH/320)];
    [freedomViwe addSubview:freedomImg];
    freedomImg.image = [UIImage imageNamed:@"VIP-13"];
    freedomViwe.userInteractionEnabled = YES;
    
    UIButton *btnHYTQ = [[UIButton alloc] initWithFrame:freedomViwe.frame];
    [_scView addSubview:btnHYTQ];
    [btnHYTQ addTarget:self action:@selector(actionHYTQ) forControlEvents:UIControlEventTouchUpInside];

    
    
    
    
    UIView *noticeViwe = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(freedomViwe.frame), SCREEN_WIDTH,250)];
    [_scView addSubview:noticeViwe];
    noticeViwe.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *noticeLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 35)];
    [noticeViwe addSubview:noticeLabel_1];
    noticeLabel_1.numberOfLines = 1;
    noticeLabel_1.textColor = [ResourceManager color_1];
    noticeLabel_1.font = [UIFont systemFontOfSize:14];
    noticeLabel_1.text = @"注意事项：";
    UILabel *noticeLabel_2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 235)];
    [noticeViwe addSubview:noticeLabel_2];
    noticeLabel_2.numberOfLines = 0;
    noticeLabel_2.textColor = color_2;
    noticeLabel_2.font = font_1;
    noticeLabel_2.text = @"\n1.信贷经理通过实名认证和工作认证后方可享受会员权益，如您尚未通过实名或工作认证，请先提交相应资料。\n\n2.会员权限通过实名认证的信贷经理本人使用，若发现转让他人或以他人身份使用接待客户，小小金融有权终止会员权力，并追究相应责任。\n\n3.充值金额不能提现，只能抢单。\n\n4.如有任何疑问，请拨打客服热线:0755-83254087";
    
   _scView.contentSize = CGSizeMake(0, CGRectGetMaxY(noticeViwe.frame));
}

-(void) actionHYTQ
{
    NSString *url = [NSString stringWithFormat:@"%@xxapp/lend/vip/desc.html",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"会员特权"];
    //VipHytqVC *vc = [[VipHytqVC alloc] init];
    //[self.navigationController pushViewController:vc animated:NO];
}

//会员套餐
- (void)vipPackageUrl{
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@xxcust/account/fund/getVipConfig",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      _vipDataArr = operation.jsonResult.rows;
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      
                                                                                  }];
    [operation start];
    operation.tag = 10212;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickNavButton:(UIButton *)button{
    
    if (_isPopRoot)
     {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
     }
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
