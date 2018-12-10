//
//  SelectDZQController.m
//  XXJR
//
//  Created by xxjr02 on 2018/2/7.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "SelectDZQController.h"
#import "CCWebViewController.h"

#define  CELL_HEIGHT  116

@interface SelectDZQController ()
{
    UIButton *btnUnUse;
}
@end

@implementation SelectDZQController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomNavigationBarView *nav = [self layoutWhiteNaviBarViewWithTitle:@"可用的券"];
    
    
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90.f,fRightBtnTopY,90.f, 40.0f)];
    [nav addSubview:rightNavBtn];
    
    [rightNavBtn setTitle:@" 使用说明" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[ResourceManager navgationTitleColor] forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(actionShuoMing) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [ResourceManager font_6];

    [rightNavBtn setImage:[UIImage imageNamed:@"card_sysm"] forState:UIControlStateNormal];

    self.tableView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    // 下拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [MBProgressHUD showErrorWithStatus:@"没有新数据了！" toView:self.view];
        [self endRefresh];
    }];
    
    [self layoutHead];
    

    
}

-(void) actionShuoMing
{
    NSString *url = [NSString stringWithFormat:@"%@xxapp/lend/coupon/explain2.html",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"使用说明"];
}

-(void) layoutHead
{
    UIView *viewHead =  [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight +10, SCREEN_WIDTH, 40)];
    [self.view addSubview:viewHead];
    viewHead.backgroundColor = [UIColor whiteColor];
    
    btnUnUse = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 130, 20)];
    [viewHead addSubview:btnUnUse];
    [btnUnUse setTitle:@"不使用抢单券  " forState:UIControlStateNormal];
    [btnUnUse setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnUnUse.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnUnUse setImage:[UIImage imageNamed:@"light_gou2"] forState:UIControlStateNormal];
    
    [btnUnUse setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [btnUnUse addTarget:self action:@selector(actionUnUse) forControlEvents:UIControlEventTouchUpInside];
}

-(void) actionUnUse
{
    if (_selectBlock)
     {
        [self.navigationController popViewControllerAnimated:NO];
        _selectBlock(nil);
     }
}

// 过滤数组
-(NSArray* ) guoluArr
{
    NSMutableArray  *arrRet = [[NSMutableArray alloc] init];
    int iCount = (int)[_arrDZQ count];
    for (int i = 0; i < iCount; i++)
     {
        NSDictionary *dic = _arrDZQ[i];
        int iMinPrice = [dic[@"minPrice"] intValue];
        
        // 最小订单金额 大于本次订单金额
        if (iMinPrice > _iOrderMoney)
         {
            continue;
         }
        
        [arrRet addObject:dic];
    
     }
    
    return arrRet;
    
}


-(void)clickNavButton:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (_selectBlock)
     {
        _selectBlock(nil);
     }
    
}


- (CGRect)tableViewFrame{
    
    CGRect rectTemp = self.view.frame;
    rectTemp.size.height -= NavHeight + 50;
    rectTemp.origin.y += NavHeight + 50;
    return  rectTemp;
}




-(void)loadData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kDDGgetTicketInfo];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    currentPage：当前页
    //    everyPage：每页多少条
    //    status:(0-未激活 1-有效 2-使用中 3-已使用 4-过期)
    params[kPage] = @(self.pageIndex);
    params[kPageSize] = @(500);
    params[@"status"] = @(1);
    
    params[@"robWay"] = @(_iRobWay);
    
    if(_isTGKH)
     {
        params[@"receiveId"] = _receiveId;
     }
    else
     {
        params[@"borrowId"] = _dicData[@"borrowId"];
     }
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
    
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [super handleData:operation];
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if (operation.jsonResult.rows && operation.jsonResult.rows.count > 0) {
        
        _arrDZQ = operation.jsonResult.rows;
        NSArray *arr = [self guoluArr];
        [self reloadTableViewWithArray:arr];
        
        //[self reloadTableViewWithArray:operation.jsonResult.rows];
    }else{
        [self reloadTableViewWithArray:nil];
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
        UIImageView *viewCell = [[UIImageView alloc] initWithFrame:CGRectMake(fLeftX+5, fCellTopY, fCellWidth, CELL_HEIGHT - fCellTopY )];
        //viewCell.backgroundColor = [UIColor whiteColor];
        [viewCell setImage:[UIImage imageNamed:@"card_shopUse"]];
        [cell addSubview:viewCell];
        

        
        
        int iImgYuanWdith = 15;
        UIImageView *imgYuan = [[UIImageView alloc] initWithFrame:CGRectMake(-10, (CELL_HEIGHT-fCellTopY-iImgYuanWdith)/2 , iImgYuanWdith, iImgYuanWdith)];
        [viewCell addSubview:imgYuan];
        imgYuan.image = [UIImage imageNamed:@"light_gou1"];
        
        NSString *strTicketId = [NSString stringWithFormat:@"%@",  dic[@"ticketId"]];
        if ([strTicketId isEqualToString:_ticketId])
         {
            [btnUnUse setImage:[UIImage imageNamed:@"light_gou1"] forState:UIControlStateNormal];
            imgYuan.image = [UIImage imageNamed:@"light_gou2"];
         }
        
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    
    
    return cell;
    
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (!self.dataArray || self.dataArray.count <= 0)
//        return [self noDataCell:tableView];
//
//
//    NSString * identifier= @"cell";
//    UITableViewCell * cell = nil;
//
//
//
//    if (cell == nil) {
//        NSDictionary *dic = self.dataArray[indexPath.row];
//
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//        cell.backgroundColor = [ResourceManager viewBackgroundColor];
//
//        float fCellTopY = 20;
//
//        float fLeftX = 10;
//        float fCellWidth = SCREEN_WIDTH-2*fLeftX;
//        UIImageView *viewCell = [[UIImageView alloc] initWithFrame:CGRectMake(fLeftX+5, fCellTopY, fCellWidth, CELL_HEIGHT - fCellTopY )];
//        //viewCell.backgroundColor = [UIColor whiteColor];
//        [viewCell setImage:[UIImage imageNamed:@"card_shopUse"]];
//        [cell addSubview:viewCell];
//
//        UIColor *color1 = UIColorFromRGB(0x333333);
//        UIColor *color2 = UIColorFromRGB(0x666666);
//        UIColor *color3 = UIColorFromRGB(0xfe5a1d);
//
//
//        int iImgYuanWdith = 15;
//        UIImageView *imgYuan = [[UIImageView alloc] initWithFrame:CGRectMake(-10, (CELL_HEIGHT-fCellTopY-iImgYuanWdith)/2 , iImgYuanWdith, iImgYuanWdith)];
//        [viewCell addSubview:imgYuan];
//        imgYuan.image = [UIImage imageNamed:@"light_gou1"];
//
//        NSString *strTicketId = [NSString stringWithFormat:@"%@",  dic[@"ticketId"]];
//        if ([strTicketId isEqualToString:_ticketId])
//         {
//            [btnUnUse setImage:[UIImage imageNamed:@"light_gou1"] forState:UIControlStateNormal];
//            imgYuan.image = [UIImage imageNamed:@"light_gou2"];
//         }
//
//        float fTopY = 10;
//        fLeftX = 30 ;
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX,fTopY, fCellWidth - fLeftX, 20)];
//        label1.font = [UIFont systemFontOfSize:15];
//        if (IS_IPHONE_5_OR_LESS)
//         {
//            label1.font = [UIFont systemFontOfSize:14];
//         }
//
//        NSString *strZK = [NSString stringWithFormat:@"%@",dic[@"discount"]];
//        NSString *strZKMoney = [NSString stringWithFormat:@"%@",dic[@"maxDiscountAmount"]];
//        NSString *strDescreption = [NSString stringWithFormat:@"抢单券:最高抵扣%@元",strZKMoney];
//        if( 0 == [strZK intValue])
//         {
//            strZK = [NSString stringWithFormat:@"%@", dic[@"minPrice"]];
//            strDescreption = [NSString stringWithFormat:@"抢单券:满%@元可使用",strZK];
//
//            if ([dic[@"minPrice"] integerValue] == 0 )
//             {
//                strDescreption = @"抢单券:不限金额";
//             }
//         }
//        label1.text =  dic[@"useDesc"];// strDescreption;//dic[@"couponName"];
//        label1.textColor = color1;
//        [viewCell addSubview:label1];
//
//
//        // 打几折 或者多少元抢单券
//        UILabel *imglabel1 = [[UILabel alloc] initWithFrame:CGRectMake(fCellWidth*3/4-10, 0, fCellWidth/4, viewCell.height)];
//        [viewCell addSubview:imglabel1];
//        imglabel1.font = [UIFont systemFontOfSize:18];
//        imglabel1.textAlignment = NSTextAlignmentCenter;
//        imglabel1.textColor = color3;
//
//        int iZKFontSize = 50;
//        if (IS_IPHONE_5_OR_LESS)
//         {
//            iZKFontSize = 40;
//         }
//        strZK = [NSString stringWithFormat:@"%@",dic[@"discount"]];
//        NSString *strAll = [NSString stringWithFormat:@"%@ 折",strZK];
//        if( 0 == [strZK intValue])
//         {
//            strZK = [NSString stringWithFormat:@"%@", dic[@"maxDiscountAmount"]];
//            strAll = [NSString stringWithFormat:@"￥%@",strZK];
//         }
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:strAll];
//        //获取要调整字体的文字位置,调整字体大小
//        NSRange range1=[strAll rangeOfString:strZK];
//        [attrStr addAttribute:NSFontAttributeName
//                        value:[UIFont systemFontOfSize:iZKFontSize]
//                        range:range1];
//
//        imglabel1.attributedText = attrStr;
//
//
//
//
//        fTopY += 20;
//        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX,fTopY, fCellWidth - fLeftX, 20)];
//        label2.font = [UIFont systemFontOfSize:11];
//        label2.text =  dic[@"limitDesc"];//@"(仅限抢单使用)";
//        label2.textColor = color2;
//        [viewCell addSubview:label2];
//
//
//        fTopY = CELL_HEIGHT-62;
//        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX,fTopY, fCellWidth - fLeftX, 20)];
//        label3.font = [UIFont systemFontOfSize:11];
//        label3.textColor = color3;
//        NSString *strYXQ = dic[@"dateDesc"];
//        if (!strYXQ ||
//            strYXQ.length <= 0)
//         {
//            label3.textColor = color2;
//            strYXQ = [NSString stringWithFormat:@"有效期%@到%@", dic[@"startDate"], dic[@"endDate"]];
//         }
//        label3.text =  strYXQ;
//
//        [viewCell addSubview:label3];
//
//        fTopY = CELL_HEIGHT-45;
//        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX,fTopY, fCellWidth - fLeftX, 20)];
//        label4.font = [UIFont systemFontOfSize:11];
//        label4.textColor = color2;
//        NSString *strLY = [NSString stringWithFormat:@"来源：%@",dic[@"type"]];
//        label4.text =  strLY;
//        [viewCell addSubview:label4];
//
//
//        // 券类型（0-抢单券  1-免单券）
//        int  iTicketType = [dic[@"ticketType"] intValue];
//        if (1 == iTicketType)
//         {
//            //label1.text = @"免单券:限50元以下订单使用";
//            //label2.text =  @"(仅限抢单使用，除优质客户)";
//            imglabel1.text = @"免单";
//         }
//
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//
//
//
//
//    return cell;
//
//}

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
//    [btn setTitle:@"立即兑换" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    btn.cornerRadius = 5;
//    btn.layer.borderColor = [UIColor orangeColor].CGColor;
//    btn.layer.borderWidth = 1;
//    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

//-(void) btnClick
//{
//    ExchangeIntegralVC *vc = [[ExchangeIntegralVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArray count ] <= 0)
     {
        return;
     }
    NSDictionary * dicCZQ = self.dataArray[indexPath.row];
    
    if (_selectBlock)
     {
        [self.navigationController popViewControllerAnimated:NO];
        _selectBlock(dicCZQ);
     }
    

    
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
