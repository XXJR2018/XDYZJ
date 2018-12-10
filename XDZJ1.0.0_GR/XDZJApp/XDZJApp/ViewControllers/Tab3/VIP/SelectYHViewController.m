//
//  SelectYHViewController.m
//  XXJR
//
//  Created by xxjr03 on 2017/5/22.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "SelectYHViewController.h"

@interface SelectYHViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation SelectYHViewController

-(void)loadData{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"busi/account/baofoo/querybank/bankInfo"]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){                                                                                    
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    [operation start];
}

//数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    
    [super handleData:operation];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    if (operation.jsonResult.attr.count > 0) {
        NSArray *arr = [operation.jsonResult.attr objectForKey:@"bankList"];
        if (arr.count > 0) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:arr];
            [_tableView reloadData];
        }
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"选择银行"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cell_id = [NSString stringWithFormat:@"%ld_cell",(long)indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic = self.dataArray[indexPath.row];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 250, 45)];
    [cell.contentView addSubview:label];
    label.text = [dic objectForKey:@"bankName"];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [ResourceManager color_1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArray[indexPath.row];
   
    self.YHBlock(@{@"bankName":[dic objectForKey:@"bankName"],@"bankCode":[dic objectForKey:@"bankCode"]});
    [self.navigationController popViewControllerAnimated:YES];
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
