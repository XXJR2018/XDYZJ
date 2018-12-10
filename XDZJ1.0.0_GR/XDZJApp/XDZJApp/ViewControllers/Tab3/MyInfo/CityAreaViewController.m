//
//  CityAreaViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/8/1.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "CityAreaViewController.h"
#import "DistrictsViewController.h"

@interface CityAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSString * _provinceName;
    NSString * _cityName;
}
@end

@implementation CityAreaViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"城市区域"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"城市区域"];
}
-(void)loadData{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getAllAreaInfoAPI]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                    
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}

-(id)init{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"城市区域"];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f,NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    //隐藏tableView突出的空白部分
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [super handleData:operation];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    self.dataArray = [operation.jsonResult.attr objectForKey:@"allArea"];
    [_tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellId = [NSString stringWithFormat:@"%ld_cell",(long)indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary * dic = self.dataArray[indexPath.row];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 44)];
    [cell.contentView addSubview:label];
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont systemFontOfSize:14];
    for (NSString * key in [dic allKeys]) {
        if ([key isEqualToString:@"provinceName"]) {
            label.text = [dic objectForKey:key];
        }else if ([key isEqualToString:@"cityName"]) {
            label.text = [dic objectForKey:key];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArray[indexPath.row];
    for (NSString * key in [dic allKeys]) {
        if ([key isEqualToString:@"provinceName"]) {
            _provinceName = [dic objectForKey:key];
            self.dataArray = [dic objectForKey:@"citys"];
            [_tableView reloadData];
        }else if ([key isEqualToString:@"cityName"]) {
            _cityName = [dic objectForKey:key];
            DistrictsViewController * Districts = [[DistrictsViewController alloc]init];
            Districts.provinceName = _provinceName;
            Districts.cityName = _cityName;
            Districts.districts = [dic objectForKey:@"districts"];
            [self.navigationController pushViewController:Districts animated:YES];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
