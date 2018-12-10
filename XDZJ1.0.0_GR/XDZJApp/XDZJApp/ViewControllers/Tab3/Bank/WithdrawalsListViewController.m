//
//  WithdrawalsListViewController.m
//  XXJR
//
//  Created by xxjr02 on 2017/3/27.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "WithdrawalsListViewController.h"

@interface WithdrawalsListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView1; //提现table
    
    NSArray * txList;
}
@end

@implementation WithdrawalsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"提现记录"];
    
    //[self layoutUI];
    [self getTXList];
    
}

-(void) getTXList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"xxcust/account/fund/withdrawList"]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      //[MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    
    operation.tag = 1000;
    
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    NSDictionary *attr =  operation.jsonResult.attr;
    
    NSLog(@"attr:%@" , attr);
    
    if (operation.tag == 1000) {
        
        // 布局UI
        txList = operation.jsonResult.rows;
        [self layoutUI];
        //NSLog(@"operation.jsonResult.rows:%@", operation.jsonResult.rows);
        
    }
    
}

-(void) layoutUI
{
    tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight) style:UITableViewStylePlain];
    //tableView1.contentInset = UIEdgeInsetsMake(NavHeight, 0, 0, 0);
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.tag = 102;
    [self.view addSubview:tableView1];
    
    [self setExtraCellLineHidden:tableView1];
}

// 隐藏多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return txList?[txList count]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellTX";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil)
     {
        
        int iCur = (int)indexPath.row;
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        NSDictionary * dic = txList[iCur];
        UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        lable1.font = [UIFont systemFontOfSize:14];
        NSString *str = [NSString stringWithFormat:@"申请提现%@元", dic[@"amount"]];
        lable1.text = str;
        [cell addSubview:lable1];
        
        UILabel * lable2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 20, 70, 20)];
        lable2.font = [UIFont systemFontOfSize:15];
        NSString * strZT = @"";
        int iZT = [dic[@"status"] intValue];
        if (0 == iZT)
         {
            strZT = @"待审核";
         }
        if (1 == iZT)
         {
            strZT = @"待确定";
         }
        if (2 == iZT)
         {
            strZT = @"完成";
         }
        if (3 == iZT)
         {
            strZT = @"取消";
         }
        lable2.text = strZT;
        lable2.textColor = UIColorFromRGB(0xfc7637); // 橘红
        [cell addSubview:lable2];
        
        UILabel * lable3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 20)];
        lable3.font = [UIFont systemFontOfSize:12];
        lable3.text = dic[@"createTime"];//@"2017-01-01";
        lable3.textColor = [UIColor grayColor];
        [cell addSubview:lable3];

     }

    
    return cell;
    
}


#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    int iCur = (int)indexPath.row;

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
