//
//  CJRecordVC.m
//  XXJR
//
//  Created by xxjr02 on 2018/2/26.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "CJRecordVC.h"

@interface CJRecordVC ()

@end

@implementation CJRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"获奖记录"];
}

-(void)loadData{
    NSString *strUrl = [NSString stringWithFormat:@"%@xxcust/account/member/drawLotteryList", [PDAPI getBaseUrlString]];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[kPage] = @(self.pageIndex);
    param[@"myRecord"] = @(1);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:param HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
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
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count?:1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
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
        cell.backgroundColor = [UIColor whiteColor];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-15 - 160, 20)];
        label1.font = [UIFont systemFontOfSize:16];
        label1.text =  dic[@"lotteryName"];
        label1.textColor = [ResourceManager navgationTitleColor];
        [cell addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 10, 150 , 20)];
        label2.font = [UIFont systemFontOfSize:13];
        label2.text = dic[@"createTime"];
        label2.textColor = [ResourceManager  lightGrayColor];
        label2.textAlignment = NSTextAlignmentRight;

        [cell addSubview:label2];
        
        

    }
    
    
    
    
    //    //自适应图片（大小）
    //    cell.textLabel.text = @"主题";
    //    cell.imageView.image = [UIImage imageNamed:@"关于我们@2x.png"];
    //    cell.detailTextLabel.text = @"副主题";
    return cell;
    
}


@end
