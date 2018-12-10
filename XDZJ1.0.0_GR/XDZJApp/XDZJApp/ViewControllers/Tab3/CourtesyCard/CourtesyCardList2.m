//
//  CourtesyCardList2.m
//  XXJR
//
//  Created by xxjr02 on 2017/10/30.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "CourtesyCardList2.h"

#define CELL_HEIGHT   110

@interface CourtesyCardList2 ()

@end

@implementation CourtesyCardList2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [ResourceManager viewBackgroundColor];
    
}


- (CGRect)tableViewFrame{
    
    return  self.view.frame;
}





-(void)loadData{
    NSString *strUrl = [NSString stringWithFormat:@"%@xxcust/account/coupon/myList", [PDAPI getBaseUrlString]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    currentPage：当前页
    //    everyPage：每页多少条
    //    status:(0-未激活 1-有效 2-使用中 3-已使用 4-过期)
    params[kPage] = @(self.pageIndex);
    params[kPageSize] = @(10);
    params[@"status"] = @(0);
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params  HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
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
    
    [self reloadTableViewWithArray:operation.jsonResult.rows];
    
    NSDictionary *dic = operation.jsonResult.attr;
    if ([dic count]>0)
     {
//        int  iJF = [dic[@"totalScore"] intValue];
//        NSString *strJF = [NSString stringWithFormat:@"%d", iJF];
//        //labelJF.text = strJF;
     }
    
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.backgroundColor = [ResourceManager viewBackgroundColor];
        
        float fTopY = 20;
        float fLeftX = 10;
        float fCellWidth = SCREEN_WIDTH-2*fLeftX;
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(fLeftX, fTopY, fCellWidth, CELL_HEIGHT - fTopY )];
        viewCell.backgroundColor = [UIColor whiteColor];
        [cell addSubview:viewCell];
        
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_HEIGHT - fTopY, CELL_HEIGHT - fTopY)];
        [img setImage:[UIImage imageNamed:@"card_use"]];
        [viewCell addSubview:img];
        
        
        UILabel *imglabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 12.5, CELL_HEIGHT - fTopY, 35)];
        imglabel1.font = [UIFont systemFontOfSize:18];
        imglabel1.textAlignment = NSTextAlignmentCenter;
        imglabel1.textColor = [UIColor whiteColor];
        
        NSString *strMoney = [NSString stringWithFormat:@"%d", [dic[@"amount"] intValue]];
        NSString *strText = [NSString stringWithFormat:@"￥%@", strMoney];
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:strText];
        //获取要调字体的文字位置
        NSRange range1=[[hintString string]rangeOfString:strMoney];
        // 设置字体为粗体
        [hintString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial Rounded MT Bold" size:30.0] range:range1];
        
        imglabel1.attributedText=hintString;
        [img addSubview:imglabel1];
        
        
        UILabel *imglabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 15+ 35, CELL_HEIGHT - fTopY, 15)];
        imglabel2.font = [UIFont systemFontOfSize:11];
        imglabel2.textAlignment = NSTextAlignmentCenter;
        imglabel2.textColor = [UIColor whiteColor];
        imglabel2.text = dic[@"couponTypeText"];
        [img addSubview:imglabel2];
        
        
        fTopY = 10;
        fLeftX = CELL_HEIGHT - fTopY + 10 ;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX,fTopY, fCellWidth - fLeftX, 20)];
        label1.font = [UIFont systemFontOfSize:15];
        label1.text =  dic[@"couponName"];
        label1.textColor = [ResourceManager navgationTitleColor];
        [viewCell addSubview:label1];
        
        fTopY += 20;
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX,fTopY, fCellWidth - fLeftX, 20)];
        label2.font = [UIFont systemFontOfSize:11];
        NSString *strYXQ = [NSString stringWithFormat:@"有效期%@到%@", dic[@"startDate"], dic[@"endDate"]];
        label2.text =  strYXQ;
        label2.textColor = [ResourceManager lightGrayColor];
        [viewCell addSubview:label2];
        
        
        fTopY += 18;
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX,fTopY, fCellWidth - fLeftX, 20)];
        label3.font = [UIFont systemFontOfSize:11];
        label3.textColor = [ResourceManager lightGrayColor];
        label3.text =  dic[@"remark"];
        [viewCell addSubview:label3];
        
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(fCellWidth - 80, fTopY, 65, 18)];
//        btn.cornerRadius = 10;
//        //设置边框的颜色
//        [btn.layer setBorderColor:[UIColor orangeColor].CGColor];
//        //设置边框的粗细
//        [btn.layer setBorderWidth:1.0];
//        [btn setTitle:@"立即使用" forState:UIControlStateNormal];
//        [btn setTitleColor:[ResourceManager orangeColor] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:12];
//        btn.userInteractionEnabled = NO;
//        [viewCell addSubview:btn];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    
    
    return cell;
    
}

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
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary * dic = self.dataArray[indexPath.row];
    //ApplyDetailViewController * detail = [[ApplyDetailViewController alloc]init];
    //detail.applyId = [dic objectForKey:@"applyId"];
    //[self.navigationController pushViewController:detail animated:YES];
}

// 设置分割线缩进为0， 再隐藏分割线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //隐藏分割线
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
}


@end
