//
//  DistrictsViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/8/1.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "DistrictsViewController.h"

#import "CommonInfo.h"


@interface DistrictsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSString * _areaName;
}
@end

@implementation DistrictsViewController
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.districts.count;
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
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 44)];
    [cell.contentView addSubview:label];
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont systemFontOfSize:14];
    label.text = self.districts[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _areaName = self.districts[indexPath.row];
    
    //返回上2级页面
    NSUInteger index = [[self.navigationController viewControllers] indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
