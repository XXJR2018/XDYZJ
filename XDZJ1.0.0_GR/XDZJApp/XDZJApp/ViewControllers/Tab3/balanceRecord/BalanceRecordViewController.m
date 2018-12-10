//
//  BalanceRecordViewController.m
//  XXJR
//
//  Created by xxjr03 on 17/4/14.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "BalanceRecordViewController.h"

#import "BalanceRecordCell.h"

@interface BalanceRecordViewController ()

@end

@implementation BalanceRecordViewController

-(void)loadData{
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@mjb/account/fund/fundRecord",[PDAPI getBaseUrlString]]
                                                                               parameters:@{kPage:@(self.pageIndex)} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    [operation start];    
}

#pragma pram === Init
-(id)init{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"余额明细"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BalanceRecordCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //去掉分割线
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}



//获取用户信息
-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (operation.jsonResult.rows && operation.jsonResult.rows.count > 0) {
        [self reloadTableViewWithArray:operation.jsonResult.rows];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count ?: 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || self.dataArray.count <= 0)
        return [self noDataCell:tableView];
    
    BalanceRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[BalanceRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataDic=self.dataArray[indexPath.row];
    return cell;
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
