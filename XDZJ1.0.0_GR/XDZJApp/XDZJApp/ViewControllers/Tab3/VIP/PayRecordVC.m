//
//  PayRecordVC.m
//  XXJR
//
//  Created by xxjr02 on 2017/10/13.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "PayRecordVC.h"

@interface PayRecordVC ()

@end

@implementation PayRecordVC


-(id)init{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

-(void)loadData{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[kPage] = @(self.pageIndex);
    params[@"everyPage"] = @(10);
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@mjb/account/fund/queryTradeRecord",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    [operation start];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"充值记录"];
    
}



//获取用户信息
-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (operation.jsonResult.rows && operation.jsonResult.rows.count > 0) {
        NSLog(@" operation.jsonResult.rows : %@" ,operation.jsonResult.rows);
        
        [self reloadTableViewWithArray:operation.jsonResult.rows];
    }else{
        self.pageIndex --;
        if (self.pageIndex !=0)
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
    return self.dataArray.count ?: 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || self.dataArray.count <= 0)
        return [self noDataCell:tableView];
    
    NSString * identifier= @"cell";
    
    UITableViewCell *cell = nil;
    
    
    //UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        
        float fTopY = 15;
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, fTopY-2, 24, 24)];
        [img setImage:[UIImage imageNamed:@"jy_jilu"]];
        [cell addSubview:img];
        
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10+28, fTopY, SCREEN_WIDTH-10 - 80, 20)];
        label1.font = [UIFont systemFontOfSize:15];

        
        label1.text =  [NSString stringWithFormat:@"充值%.2f元" , [dic[@"amount"] floatValue ]/100];//dic[@"createDesc"];
        label1.textColor = [ResourceManager navgationTitleColor];
        [cell addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, fTopY, 70 , 20)];
        label2.font = [UIFont systemFontOfSize:15];
        int iStatus = [dic[@"status"] intValue];
        //status    0 未支付  1 成功 2 失败 3交易中  4已退款
        if (0 == iStatus)
         {
            label2.text = @"未支付";
            label2.textColor = UIColorFromRGB(0xd2b576);
         }
        else if (1 == iStatus)
         {
            label2.text = @"充值成功";
            label2.textColor = UIColorFromRGB(0x40c484);
         }
        else if (2 == iStatus)
         {
            label2.text = @"充值失败";
            label2.textColor = UIColorFromRGB(0xde5e31);
         }
        else if (3 == iStatus)
         {
            label2.text = @"交易中";
            label2.textColor = UIColorFromRGB(0x50aae3);
         }
        else if (4 == iStatus)
         {
            label2.text = @"已退款";
            label2.textColor = UIColorFromRGB(0x999999);
         }
        else
         {
            label2.text = @"未支付";
            label2.textColor = UIColorFromRGB(0xd2b576);
         }

        label2.textAlignment = NSTextAlignmentRight;
        [cell addSubview:label2];
        
        
        
        NSString * strCZFS = @"充值方式:宝付";
        NSString * strRechargeChannel = dic[@"rechargeChannel"];
        if ([strRechargeChannel isEqualToString:@"llkj"])
         {
            strCZFS = @"充值方式:连连快捷";
         }
        else if ([strRechargeChannel isEqualToString:@"llrz"])
         {
            strCZFS = @"充值方式:连连认证";
         }
        else if ([strRechargeChannel isEqualToString:@"ddllrz"])
         {
            strCZFS = @"充值方式:连连认证";
         }
        else if ([strRechargeChannel isEqualToString:@"ddllkj"])
         {
            strCZFS = @"充值方式:连连快捷";
         }
        else if ([strRechargeChannel isEqualToString:@"hywx"])
         {
            strCZFS = @"充值方式:微信充值";
         }
        
        fTopY += 25;
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, fTopY, SCREEN_WIDTH-10 - 80, 20)];
        label3.font = [UIFont systemFontOfSize:13];
        label3.textColor = [UIColor grayColor];
        label3.text = strCZFS;
        [cell addSubview:label3];
        
        fTopY += 20;
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, fTopY, SCREEN_WIDTH-10 - 80, 20)];
        label4.font = [UIFont systemFontOfSize:13];
        label4.textColor = [UIColor grayColor];
        label4.text =  dic[@"createTime"];
        [cell addSubview:label4];
    }

    return cell;
}




@end
