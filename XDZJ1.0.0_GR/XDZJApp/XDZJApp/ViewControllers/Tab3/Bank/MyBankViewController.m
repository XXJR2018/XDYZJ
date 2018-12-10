//
//  MyBankViewController.m
//  XXJR
//
//  Created by xxjr02 on 2017/3/27.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "MyBankViewController.h"
#import "AddBankViewController.h"
#import "UIImageView+WebCache.h"

@interface MyBankViewController ()<UIAlertViewDelegate>
{
    UIView *view1;  // 无卡时的view
    UIView *view2;  // 有卡时的view
    
    NSDictionary * cardInfo;
}

@end

@implementation MyBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"我的银行卡"];
    
    [self layoutUI];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [self loadData];
}
-(void)clickNavButton:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"busi/account/baofoo/bindcard/bankCard"]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                             [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                              [MBProgressHUD hideHUDForView:self.view animated:NO];                        [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      view1.hidden = NO;
                                                                                      view2.hidden = YES;
                                                                                  }];
    
    operation.tag = 1000;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    NSArray *rows = operation.jsonResult.rows;
    // 布局UI
    if (rows.count == 0)
    {
        [self layView1];
        view2.hidden = YES;
        view1.hidden = NO;
    }else{
        cardInfo = rows[0];
        [self layView2];
        view2.hidden = NO;
        view1.hidden = YES;
    }
}

-(void) layoutUI
{
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)];
    view1.backgroundColor = UIColorFromRGB(0xf5f5f5); //设置背景为灰色
    [self.view addSubview:view1];
    
    view2 = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)];
    view2.backgroundColor = UIColorFromRGB(0xf5f5f5); //设置背景为灰色
    [self.view addSubview:view2];

    [self layView1];
    
    [self layView2];
    
    view2.hidden = YES;
    view1.hidden = YES;
}

-(void) layView1
{
    UIImageView     *img = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100 *SCREEN_WIDTH/320)/2 ,50 , 100 *SCREEN_WIDTH/320, 70 * SCREEN_WIDTH/320)];
    img.image = [UIImage imageNamed:@"Bank_NO"];
    [view1 addSubview:img];
    
    UILabel   *label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, CGRectGetMaxY(img.frame)+30, 300, 20)];
    label.text = @"您还没有绑定银行卡，请立即绑定吧！";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:label];
    
    
    UIButton  *btnApply = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)+50, SCREEN_WIDTH-20, 45)];
    btnApply.backgroundColor = [UIColor orangeColor];
    [btnApply addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    btnApply.cornerRadius = 3;
    [view1 addSubview:btnApply];
    
    UILabel   *label1 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2 -30, 12.5, 300, 20)];
    label1.text = @"添加银行卡";
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor whiteColor];
    [btnApply addSubview:label1];
    
    UIImageView     *img2 = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2 -55 ,12.5 , 20, 20)];
    img2.image = [UIImage imageNamed:@"Bank_Add"];
    [btnApply addSubview:img2];

}


-(void) layView2
{
    if (!cardInfo)
     {
        return;
     }
    
    UIView  *img = [[UIView alloc]initWithFrame:CGRectMake(10 ,20 , SCREEN_WIDTH-20, 130)];
    //img.image = [UIImage imageNamed:@"Bank_Background"];
    img.userInteractionEnabled = YES;
    img.backgroundColor = [UIColor whiteColor];
    [view2 addSubview:img];
    
    [XXJRUtils addShadowToView:img withOpacity:0.8 shadowRadius:8 andCornerRadius:3];
    
    int iLeftX = 30;
    int iTopY  = 30;
    UIImageView  *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(iLeftX ,iTopY ,40 , 40)];
    img2.backgroundColor = [UIColor clearColor];
    
    NSString* imageUrl = [NSString stringWithFormat:@"%@",[cardInfo objectForKey:@"bankImg"]];
    //头像
    [img2 sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    [img addSubview:img2];
    
    iLeftX += img2.width +10;
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    lable1.font = [UIFont systemFontOfSize:13];
    lable1.text =  cardInfo[@"bankName"];// @"中国交通银行";
    [img addSubview:lable1];
    
    iTopY += 20;
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    lable2.font = [UIFont systemFontOfSize:11];
    lable2.text = @"储蓄卡";
    lable2.textColor = [UIColor grayColor];
    [img addSubview:lable2];
    
    iTopY += 40;
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX , iTopY, 200, 20)];
    //lable3.font = [UIFont systemFontOfSize:15];
    lable3.textColor = [UIColor grayColor];
    lable3.text = cardInfo[@"hideCardCode"];
    [img addSubview:lable3];
    
    iTopY = img.height + 50;
    UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 120, iTopY, 100, 20)];
    lable4.font = [UIFont systemFontOfSize:13];
    lable4.textColor = [UIColor orangeColor];
    lable4.text = @"解除绑定";
    lable4.textAlignment = NSTextAlignmentRight;
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Unbound)];
    lable4.userInteractionEnabled = YES;
    [lable4 addGestureRecognizer:gesture];
    [view2 addSubview:lable4];
    
    iTopY += lable4.height + 30;
    UILabel *labelTS = [[UILabel alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH-30, 50)];
    [view2 addSubview:labelTS];
    labelTS.font = [UIFont systemFontOfSize:13];
    labelTS.textColor = [UIColor grayColor];
    labelTS.text = @"温馨提示\n如需修改银行卡，可解除绑定再添加新银行卡。";
    labelTS.numberOfLines = 0;
    
}


//添加银行卡
-(void)addAction{
    NSDictionary *dicInfo = [DDGAccountManager sharedManager].userInfo;
    // 实名认证后，才能添加银行卡
    if (dicInfo)
    {
        if ( [[dicInfo objectForKey:@"identifyStatus"] integerValue] == 1)
        {
            AddBankViewController *ctl = [[AddBankViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
            return;
        }
    }
    
    //提示
    SIAlertView * alertView = [[SIAlertView alloc]initWithTitle:@"提示" andMessage:@"请先实名认证且通过后，再添加银行卡。"];
    [alertView addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:nil];
    
    alertView.cornerRadius = 5;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
    
    [alertView show];
}

//解除绑定
-(void) Unbound
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"解除绑定" message:@"确定解除绑定该银行卡吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
    
}

#pragma mark === UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        [self UnboundUrl];
    }
}

//解除绑定银行卡
-(void)UnboundUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"busi/account/baofoo/bind/removeBindDeal"]
                                                                               parameters:@{@"bankId":[cardInfo objectForKey:@"bankId"]} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showSuccessWithStatus:@"解除绑定成功" toView:self.view];
                                                                                      [self loadData];
                                                                                  }
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
