//
//  ServeViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/8/1.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "ServeViewController.h"
#import "NewAddSetupViewController.h"
@interface ServeViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITableView *_tableView;
    UISearchBar *_searchBar;
    NSArray *_dataArr;
    UIView *_addView;
    
}
@end

@implementation ServeViewController
-(void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    if (_searchBar.text.length > 0) {
        params[@"compName"] = _searchBar.text;
    }
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getqueryCompanyListAPI]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"选择机构"];
    
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 46;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60,fRightBtnTopY,60, 35)];
    [rightNavBtn setTitle:@"  +" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(addCom) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:27];
    [nav addSubview:rightNavBtn];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
 
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [_tableView setTableHeaderView:_searchBar];
    
    _searchBar.placeholder = @"搜索机构";
    _searchBar.returnKeyType = UIReturnKeySearch;
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor whiteColor];

    _addView = [[UIView alloc]initWithFrame:CGRectMake(0,130, SCREEN_WIDTH , 200)];
    [self.view addSubview:_addView];
    _addView.backgroundColor = [ResourceManager viewBackgroundColor];
    _addView.hidden = YES;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, _addView.bounds.size.width, 40)];
    [_addView addSubview:label];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x333333);
    label.numberOfLines = 0;
    label.text = @"列表中没有该公司，请点击按钮手动输入";
    label.textAlignment = NSTextAlignmentCenter;
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 40, 40)];
    [_addView addSubview:btn];
    btn.backgroundColor = [ResourceManager redColor1];
    [btn setTitle:@"添加公司" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addCom) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
}
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [super handleData:operation];
    
    _dataArr  = operation.jsonResult.rows;
    [_tableView reloadData];
    if (_dataArr.count == 0) {
        _addView.hidden = NO;
    }if (_dataArr.count > 0) {
        _addView.hidden = YES;
    }
}
//添加公司
-(void)addCom{
    _addView.hidden = YES;
    //AddSetupViewController *cti = [[AddSetupViewController alloc]init];
    NewAddSetupViewController *cti = [[NewAddSetupViewController alloc]init];
    cti.blockServe = self.blockServe;
    if (_searchBar.text.length > 0) {
        cti.comStr = _searchBar.text;
    }
    [self.navigationController pushViewController:cti animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ldcell",(long)indexPath.row]];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dic = _dataArr[indexPath.row];
    UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, SCREEN_WIDTH - 20, 20)];
    [cell.contentView addSubview:label_1];
    label_1.textColor = UIColorFromRGB(0x333333);
    label_1.font = [UIFont systemFontOfSize:14];
    label_1.text = [dic objectForKey:@"compName"];
    UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 24, SCREEN_WIDTH - 20, 20)];
    [cell.contentView addSubview:label_2];
    label_2.textColor = [ResourceManager color_6];
    label_2.font = [UIFont systemFontOfSize:12];
    label_2.text = [dic objectForKey:@"shortName"]?[NSString stringWithFormat:@"简称：%@",[dic objectForKey:@"shortName"]]:@"简称：";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = _dataArr[indexPath.row];
   
    //反向传值
    self.blockServe(@[[dic objectForKey:@"compName"]?:@"",[dic objectForKey:@"shortName"]?:@"",[dic objectForKey:@"compId"]?:@""]);
    [self.navigationController popViewControllerAnimated:YES];
}

// UISearchBarDelegate定义的方法，当搜索文本框内文本改变时激发该方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"----textDidChange------");
    // 调用filterBySubstring:方法执行搜索
    [self loadData];
    
}

// UISearchBarDelegate定义的方法，用户单击虚拟键盘上Search按键时激发该方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSLog(@"----searchBarSearchButtonClicked------");
    // 调用filterBySubstring:方法执行搜索
    _addView.hidden = YES;
    [self loadData];
    // 放弃作为第一个响应者，关闭键盘
    [searchBar resignFirstResponder];
}


@end
