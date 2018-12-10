//
//  CourtesyCardList1.m
//  XXJR
//
//  Created by xxjr02 on 2017/10/30.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "CourtesyCardList1.h"
#import "VIPViewControllerCtl_2.h"
#import "NewVipViewControllerCtl_2.h"
//#import "ExchangeIntegralVC.h"

#define CELL_HEIGHT   116

@interface CourtesyCardList1 ()
{
    NSArray *_vipDataArr;  // 会员套餐数组
    UITextField *codeField;  // 兑换码
}
@end

@implementation CourtesyCardList1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    //[self layoutPLabelViewWithTitle];
    
    self.tableView.separatorColor = [UIColor clearColor];

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


- (CGRect)tableViewFrame{

    CGRect rectTemp = self.view.frame;
    //rectTemp.size.height -= 60 + 40;
    //rectTemp.origin.y += 60 + 40;
    return  rectTemp;
}


-(void)layoutPLabelViewWithTitle
{

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    bgView.backgroundColor = UIColorFromRGB(0xFDF9EC);
    bgView.userInteractionEnabled = YES;
    bgView.clipsToBounds = YES;
    [self.view addSubview:bgView];
    
    UILabel *_paoma = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, self.view.frame.size.width - 46, 50)];
    [bgView addSubview:_paoma];
    _paoma.font = [UIFont systemFontOfSize:13];
    _paoma.textColor = UIColorFromRGB(0x774311);
    _paoma.text = @"老用户账户余额之前充值赠送的金额使用完，才可以使用抢单券。";
    _paoma.numberOfLines= 0;
    
    UIImage *image = [UIImage imageNamed:@"pr_ts"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 15, 15)];
    imgView.image = image;
    [bgView addSubview:imgView];
    
    int iTop = bgView.height +5;
    
    
    codeField = [[UITextField alloc] initWithFrame:CGRectMake(10.f, iTop, SCREEN_WIDTH - 90.f, 30.f)];
    [self.view addSubview:codeField];
    codeField.placeholder = @" 请输入兑换码";
    codeField.textColor = [ResourceManager color_1];
    codeField.font =  [UIFont systemFontOfSize:14];
    codeField.layer.cornerRadius = 5.f;
    codeField.layer.borderWidth = 0.5f;
    codeField.backgroundColor = [UIColor whiteColor];
    codeField.layer.borderColor = [ResourceManager color_5].CGColor;
    
    UIButton *btnDH = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75, iTop+1, 62, 27)];
    [self.view addSubview:btnDH];
    btnDH.backgroundColor = UIColorFromRGB(0xfe5a1d);
    [btnDH setTitle:@"兑换" forState:UIControlStateNormal];
    btnDH.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnDH addTarget:self action:@selector(acionDH) forControlEvents:UIControlEventTouchUpInside];
    
    

}


-(void) acionDH
{
    if (codeField.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入兑换码" toView:self.view];
        return;
     }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],@"xxcust/account/coupon/getTicket"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    currentPage：当前页
    //    everyPage：每页多少条
    //    status:(0-未激活 1-有效 2-使用中 3-已使用 4-过期)
    params[@"inviteCode"] = codeField.text;

    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self loadData];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    
}

-(void)loadData{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],kDDGqueryTicketList];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    currentPage：当前页
//    everyPage：每页多少条
//    status:(0-未激活 1-有效 2-使用中 3-已使用 4-过期)
    params[kPage] = @(self.pageIndex);
    params[kPageSize] = @(50);
    params[@"status"] = @(1);
    

    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [super handleData:operation];

    
    if (operation.jsonResult.rows && operation.jsonResult.rows.count > 0) {
        [self reloadTableViewWithArray:operation.jsonResult.rows];
        
        if (self.pageIndex == 1 &&
            !_haveAppeared)
         {
            [self setContentOffset:CGPointMake(0,20)];
         }
    }else{
        self.pageIndex --;
        if (self.pageIndex > 0)
         {
            [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
         }
        [self endRefresh];
    }
    

}

/*
 *  结束刷新
 */
-(void)endRefresh{
    _isLoading = NO;
    [_tableView.mj_header endRefreshing]; // 结束刷新
    [_tableView.mj_footer endRefreshing]; // 结束刷新
}


//会员套餐
- (void)vipPackageUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@xxcust/account/fund/getVipConfig",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      _vipDataArr = operation.jsonResult.rows;
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                           [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                  }];
    [operation start];
    operation.tag = 10212;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count?:1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataArray.count?CELL_HEIGHT:500;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || self.dataArray.count <= 0)
        return [self noDataCell:tableView];
    
    
    NSString * identifier= @"cell";
    UITableViewCell * cell = nil;
    
    if (cell == nil) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.backgroundColor = [ResourceManager viewBackgroundColor];
        
        
        
        float fCellTopY = 20;
        float fLeftX = 10;
        float fCellWidth = SCREEN_WIDTH-2*fLeftX;
        UIImageView *viewCell = [[UIImageView alloc] initWithFrame:CGRectMake(fLeftX, fCellTopY, fCellWidth, CELL_HEIGHT - fCellTopY )];
        //viewCell.backgroundColor = [UIColor whiteColor];
        [viewCell setImage:[UIImage imageNamed:@"card_shopUse"]];
        [cell addSubview:viewCell];
        
        UIColor *color1 = [UIColor whiteColor];
        UIColor *color2 = [UIColor whiteColor];
        UIColor *color3 = [UIColor whiteColor];
        
        
        // 打几折 或者多少元抢单券
        UILabel *imglabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, fCellWidth/4, viewCell.height-25)];
        [viewCell addSubview:imglabel1];
        imglabel1.font = [UIFont systemFontOfSize:18];
        imglabel1.textAlignment = NSTextAlignmentCenter;
        imglabel1.textColor = color3;
        
        int iZKFontSize = 50;
        if (IS_IPHONE_5_OR_LESS)
         {
            iZKFontSize = 40;
         }
        NSString *strZK = [NSString stringWithFormat:@"%@",dic[@"discount"]];
        NSString *strAll = [NSString stringWithFormat:@"%@ 折",strZK];
        if( 0 == [strZK intValue])
         {
            strZK = [NSString stringWithFormat:@"%@", dic[@"maxDiscountAmount"]];
            strAll = [NSString stringWithFormat:@"￥%@",strZK];
         }
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:strAll];
        //获取要调整字体的文字位置,调整字体大小
        NSRange range1=[strAll rangeOfString:strZK];
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:iZKFontSize]
                        range:range1];
        
        imglabel1.attributedText = attrStr;
        

        // 分割线
        float fTopY = 15;
        fLeftX = 20 + fCellWidth/4;
        UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(fLeftX, fTopY, 1, 40)];
        [viewCell addSubview:viewFG];
        viewFG.backgroundColor = UIColorFromRGBA(0xffffff, 0.1);  //[UIColor whiteColor];
        
        fLeftX = 20 + fCellWidth/4  + 15;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX,fTopY, fCellWidth - fLeftX, 20)];
        label1.font = [UIFont systemFontOfSize:15];
        if (IS_IPHONE_5_OR_LESS)
         {
            label1.font = [UIFont systemFontOfSize:14];
         }
        

        label1.text =  dic[@"useDesc"]; //strDescreption;//dic[@"couponName"];
        label1.textColor = color1;
        [viewCell addSubview:label1];
        

        

        fTopY += 20;
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX,fTopY, fCellWidth - fLeftX, 20)];
        label2.font = [UIFont systemFontOfSize:12];
        label2.text = dic[@"limitDesc"]; //@"(仅限抢单使用)";
        label2.textColor = color2;
        [viewCell addSubview:label2];


        fTopY = CELL_HEIGHT- 48;
        fLeftX = 20;
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX,fTopY, fCellWidth - fLeftX, 20)];
        label3.font = [UIFont systemFontOfSize:11];
        label3.textColor = color3;
        NSString *strYXQ = dic[@"dateDesc"];
        if (!strYXQ ||
            strYXQ.length <= 0)
         {
            label3.textColor = color2;
            strYXQ = [NSString stringWithFormat:@"有效期%@到%@", dic[@"startDate"], dic[@"endDate"]];
         }
        label3.text =  strYXQ;
        [viewCell addSubview:label3];
        
        
        fTopY = CELL_HEIGHT- 48;
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(fCellWidth-120,fTopY, 105, 20)];
        label4.font = [UIFont systemFontOfSize:11];
        label4.textColor = color2;
        NSString *strLY = [NSString stringWithFormat:@"来源:%@",dic[@"type"]];
        label4.text =  strLY;
        label4.textAlignment = NSTextAlignmentRight;
        [viewCell addSubview:label4];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        // 券类型（0-抢单券  1-免单券）
        int  iTicketType = [dic[@"ticketType"] intValue];
        if (1 == iTicketType)
         {
            //label1.text = @"免单券:限50元以下订单使用";
            //label2.text =  @"(仅限抢单使用，除优质客户)";
            imglabel1.text = @"免单";
         }
    }
    
    
    

    return cell;
    
}

-(void)noDataView:(UIView *)view{
    [view removeAllSubviews];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 120.f)/2, 50.f, 120.f, 120.f)];
    imageView.image = [UIImage imageNamed:@"card_nohave"];
    [view addSubview:imageView];
    
    
    UILabel *imglabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, 15)];
    imglabel2.font = [UIFont systemFontOfSize:14];
    imglabel2.textAlignment = NSTextAlignmentCenter;
    imglabel2.textColor = [ResourceManager lightGrayColor];
    imglabel2.text =@"空空如也，没有任何券";
    [view addSubview:imglabel2];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 205, 200, 30)];
//    [view addSubview:btn];
//    [btn setTitle:@"积分兑换" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    btn.cornerRadius = 5;
//    btn.layer.borderColor = [UIColor orangeColor].CGColor;
//    btn.layer.borderWidth = 1;
//    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) btnClick
{
    //ExchangeIntegralVC *vc = [[ExchangeIntegralVC alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArray count ] <= 0)
     {
        return;
     }
    //NSDictionary * dicCZQ = self.dataArray[indexPath.row];

    
//    NSDictionary *dic = [DDGAccountManager sharedManager].userInfo;
//    NewVipViewControllerCtl_2 *ctl = [[NewVipViewControllerCtl_2 alloc]init];
//    //VIPViewControllerCtl_2 *ctl = [[VIPViewControllerCtl_2 alloc]init];
//    ctl.vipGrade = [[dic objectForKey:@"vipGrade"] integerValue];
//    ctl.usableAmount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usableAmount"]];
//    ctl.vipEndDate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"vipEndDate"]];
//    ctl.vipDataArr = _vipDataArr;
//    ctl.iMoney = [dicCZQ[@"minRechargeAmt"] intValue];
//    //ctl.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realName"]];
//    //ctl.imageUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userImage"]];
//    [self.navigationController pushViewController:ctl animated:YES];
}




@end
