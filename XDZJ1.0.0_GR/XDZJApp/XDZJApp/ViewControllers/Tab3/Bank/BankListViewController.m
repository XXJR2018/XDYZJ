//
//  BankListViewController.m
//  XXJR
//
//  Created by xxjr02 on 2017/3/29.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "BankListViewController.h"

@interface BankListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView1; //银行table
    
    NSArray * bankList;
}

@end

@implementation BankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"银行列表"];
    
    [self getBankList];
    
    //[self layoutUI];
}

-(void) getBankList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"xxcust/account/fund/bankList"]
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


-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    NSDictionary *attr =  operation.jsonResult.attr;
    
    NSLog(@"attr:%@" , attr);
    
    if (operation.tag == 1000) {
        
        // 布局UI
        NSDictionary *attr1 =  operation.jsonResult.attr;
        if (attr1)
         {
            bankList = attr1[@"bankList"];
         }
        [self layoutUI];
        //NSLog(@"operation.jsonResult.rows:%@", operation.jsonResult.rows);
        
    }
    
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
    return bankList? [bankList count]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellBank";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil)
     {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        int iCur = (int)indexPath.row;
        NSDictionary *dic = bankList[iCur];
        
        UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH - 25, 20)];
        lable1.font = [UIFont systemFontOfSize:15];
        NSString *str = [NSString stringWithFormat:@"%@", dic[@"bankName"]];
        lable1.text = str;
        [cell addSubview:lable1];
        
//        UILabel * lable2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 20, 70, 20)];
//        lable2.font = [UIFont systemFontOfSize:15];
//        lable2.text = @"申请失败";
//        lable2.textColor = UIColorFromRGB(0xfc7637); // 橘红
//        [cell addSubview:lable2];
//        
//        UILabel * lable3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 100, 20)];
//        lable3.font = [UIFont systemFontOfSize:12];
//        lable3.text = @"2017-01-01";
//        lable3.textColor = [UIColor grayColor];
//        [cell addSubview:lable3];
        
     }
    
    
    return cell;
    
}


#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int iCur = (int)indexPath.row;
    NSLog(@"%d 行被点击", iCur);
    NSDictionary *dic = bankList[iCur];

    //弹框选择
    NSString *s = [NSString stringWithFormat:@"确定选择%@?",dic[@"bankName"]];
    SIAlertView * alertView = [[SIAlertView alloc]initWithTitle:@"提示" andMessage:s];
    [alertView addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeDefault handler:nil];
    [alertView addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView){
        if (_block) {
            _block(dic);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    alertView.cornerRadius = 5;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
    
    [alertView show];
    

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
