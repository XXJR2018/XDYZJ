//
//  BussinessQDKHCell.m
//  XXJR
//
//  Created by xxjr02 on 2018/4/4.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "BussinessQDKHCell.h"

@implementation BussinessQDKHCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (!_dataDicionary)
     {
        return;
     }
    
    if (!_nameLabel)
     {
        
        int iTopY = 0;
        int iLeftX = 0;

        
        
        iTopY = 15;
        iLeftX = 20;
        UIColor *colorRed = UIColorFromRGB(0xff5e18);
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 60, 20)];
        [self.contentView addSubview:_nameLabel];
        _nameLabel.textColor = [ResourceManager CellTitleColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"userName"]];
        if ([NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"userName"]].length > 4) {
            NSString *s = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"userName"]];
            _nameLabel.text = [s substringToIndex:4];
        }
        
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + _nameLabel.width, iTopY+2, 150, 20)];
        [self.contentView addSubview:_cityLabel];
        _cityLabel.textColor = [ResourceManager CellSubTitleColor];
        _cityLabel.font = [UIFont systemFontOfSize:14];
        if ([_dataDicionary objectForKey:@"locaDesc"] != nil  )
         {
            _cityLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"locaDesc"]];
         }
        else
         {
            _cityLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"cityName"]];
         }
        [_cityLabel sizeToFit];
        


        
        
        _labelTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, iTopY+2, 140, 15)];
        [self.contentView addSubview:_labelTime];
        _labelTime.textColor = [ResourceManager CellSubTitleColor];
        _labelTime.font = [UIFont systemFontOfSize:13];
        _labelTime.textAlignment = NSTextAlignmentRight;
        if (IS_IPHONE_5_OR_LESS)
         {
            _labelTime.font = [UIFont systemFontOfSize:12];
         }
        
        NSString *strWebTime = [_dataDicionary objectForKey:@"createTimeDesc"];
        //NSString *strLocalTime =  [XXJRUtils getDateFromTime:strWebTime];
        NSString *strTime = [NSString stringWithFormat:@"抢单时间：%@",strWebTime];
        _labelTime.text = strTime;


        // 横的分割线
        iTopY += 30;
        UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 1)];
        [self.contentView addSubview:viewFG2];
        viewFG2.backgroundColor = [ResourceManager color_5];
        
        iTopY += 12;
        UIImageView *imgMoeny = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 17, 17)];
        [self.contentView  addSubview:imgMoeny];
        imgMoeny.image = [UIImage imageNamed:@"tab2_qian"];
        
        _amountRCL =  [[RCLabel alloc] initWithFrame:CGRectMake(iLeftX + 23, iTopY-2 , 100, 30)];
        [self.contentView  addSubview:_amountRCL];
        //_amountRCL.textAlignment = RTTextAlignmentCenter;
        _amountRCL.componentsAndPlainText = [RCLabel extractTextStyle:[NSString stringWithFormat:@"<font size = 16 color=#fc6923>%@ </font><font size = 15 color=#fc6923>万元</font>",_dataDicionary[@"loanAmount"]]];
       
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, iTopY, 90, 15)];
        [self.contentView addSubview:_statusLabel];
        _statusLabel.font = [UIFont systemFontOfSize:17];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        [self setStatusLabel:_statusLabel];
        
        iTopY += 30;
        UIImageView *imgPhone = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 17, 17)];
        [self.contentView  addSubview:imgPhone];
        imgPhone.image = [UIImage imageNamed:@"tab2_time"];
        
        UILabel *lablePhone  = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX +23, iTopY-2, 150, 20)];
        [self.contentView addSubview:lablePhone];
        lablePhone.textColor = [ResourceManager CellTitleColor];
        lablePhone.font = [UIFont systemFontOfSize:15];
        lablePhone.text = _dataDicionary[@"telephone"];
        [lablePhone sizeToFit];
        
        UIButton *btnPhone = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX + 23 + lablePhone.width + 10, iTopY-10, 30, 30)];
        [self.contentView addSubview:btnPhone];
        [btnPhone setBackgroundImage:[UIImage imageNamed:@"tab2_phone"] forState:UIControlStateNormal];
        [btnPhone addTarget:self action:@selector(callButtonClick) forControlEvents:UIControlEventTouchUpInside];

        
        iTopY += 30;
        UIImageView *imgDes = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 17, 17)];
        [self.contentView  addSubview:imgDes];
        imgDes.image = [UIImage imageNamed:@"tab2_describe"];
        
        int iDesLabelLeftX = iLeftX +23;
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(iDesLabelLeftX, iTopY-2, SCREEN_WIDTH - iDesLabelLeftX, 20)];
        [self.contentView addSubview:_desLabel];
        _desLabel.textColor = [ResourceManager CellTitleColor];
        _desLabel.font = [UIFont systemFontOfSize:15];
        if ([NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"loanDesc"]].length > 0 && [_dataDicionary objectForKey:@"loanDesc"]) {
            _desLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"loanDesc"]];
        }else{
            _desLabel.text = @"  无";
        }
        

        
        
        
        _ireceiveStatus  = [[_dataDicionary objectForKey:@"receiveStatus"] intValue];
        // 除开新订单状态，其他的都有描述
        if (1 != _ireceiveStatus)
         {
            iTopY += _desLabel.height +10 ;
            //  成功放款
            if (2 == _ireceiveStatus)
             {
                NSString *strAmount = [NSString stringWithFormat:@"%@", [_dataDicionary objectForKey:@"actualLoanAmount"] ];
                NSString *strPeriod = [NSString stringWithFormat:@"%@", [_dataDicionary objectForKey:@"actualLoanPeriod"]];
                NSString *strAll = [NSString stringWithFormat:@"     放款金额：%@万      放款期限：%@个月", strAmount,strPeriod];
                
                _fangkuanLable = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, SCREEN_WIDTH - 20, 25)];
                [self.contentView  addSubview:_fangkuanLable];
                _fangkuanLable.backgroundColor = UIColorFromRGB(0xFDF9EC);
                _fangkuanLable.font = [UIFont systemFontOfSize:14];
                _fangkuanLable.textColor = [ResourceManager CellTitleColor];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strAll];
                // 获取范围
                NSRange range = [strAll rangeOfString:strAmount];//判断字符串是否包含
                
                //设置颜色
                [str addAttribute:NSForegroundColorAttributeName
                            value:UIColorFromRGB(0xF86931)
                            range:range];
                // 获取范围
                range = [strAll rangeOfString:strPeriod options:NSBackwardsSearch];//判断字符串是否包含
                                                         //设置颜色
                [str addAttribute:NSForegroundColorAttributeName
                            value:UIColorFromRGB(0xF86931)
                            range:range];
                _fangkuanLable.attributedText = str;
                
                
                iTopY += _fangkuanLable.height;
               
             }
           
            
            _handleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, SCREEN_WIDTH - 20, 25)];
            [self.contentView  addSubview:_handleLabel];
            _handleLabel.backgroundColor = UIColorFromRGB(0xFDF9EC);
            _handleLabel.textColor = [ResourceManager CellTitleColor];
            NSString *strMiaoShu = [NSString stringWithFormat:@"     处理描述：%@", _dataDicionary[@"receiveDesc"]];
            _handleLabel.text = strMiaoShu;
            _handleLabel.font = [UIFont systemFontOfSize:14];
        
            
            iTopY += _handleLabel.height +10;
            
            // 退单处理中
            if (5 == _ireceiveStatus)
             {
                int iserviceStatus = [_dataDicionary[@"serviceStatus"] intValue];
                
                if (1 == iserviceStatus ||
                    2 == iserviceStatus)
                 {
                    iTopY -= 10;
                    //strTitle = @"退单成功";
                    //strTitle = @"退单失败";
                    UILabel * _tkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, SCREEN_WIDTH - 20, 25)];
                    [self.contentView  addSubview:_tkLabel];
                    _tkLabel.backgroundColor = UIColorFromRGB(0xFDF9EC);
                    _tkLabel.textColor = [ResourceManager CellTitleColor];
                    NSString *strMiaoShu = [NSString stringWithFormat:@"     客服描述：%@", _dataDicionary[@"serviceDesc"]];
                    _tkLabel.text = strMiaoShu;
                    _tkLabel.font = [UIFont systemFontOfSize:14];
                    
                    iTopY += _tkLabel.height +10;
                 }
             }
            
         }
        else
         {
            iTopY += _desLabel.height + 10;
         }
        

        
        iTopY +=15;


        int ibtnHeight = 40;
        _lightingButton = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY-8, SCREEN_WIDTH - 2*iLeftX, ibtnHeight)];
        [self.contentView addSubview:_lightingButton];
        _lightingButton.layer.cornerRadius = 15;
        _lightingButton.layer.masksToBounds = YES;
        _lightingButton.backgroundColor = [ResourceManager mainColor];
        _lightingButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_lightingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lightingButton addTarget:self action:@selector(lightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_lightingButton setTitle:@"立即处理" forState:UIControlStateNormal];
        [_lightingButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];

        int iCallBtnLeft =  SCREEN_WIDTH - 180;
        if (1 == _ireceiveStatus ||
            7 == _ireceiveStatus ||
            8 == _ireceiveStatus ||
            9 == _ireceiveStatus ||
            10 == _ireceiveStatus )
         {
            //_statusLabel.text = @"新订单";
            //_statusLabel.text = @"跟进中";
            iCallBtnLeft =  SCREEN_WIDTH - 180;
         }
        else if (2 == _ireceiveStatus)
         {
            //_statusLabel.text = @"成功放款";
            _lightingButton.hidden = YES;
            iCallBtnLeft = SCREEN_WIDTH - 90;
            iTopY -= ibtnHeight;

         }
        else
         {
            //_statusLabel.text = @"无效客户";
            //_statusLabel.text = @"退单审核中";
            _lightingButton.hidden = YES;
            iCallBtnLeft = SCREEN_WIDTH - 90;
            iTopY -= ibtnHeight;

         }
//
//
//        _callButton =  [[UIButton alloc] initWithFrame:CGRectMake(iCallBtnLeft, iTopY-8, 80, 28)];
//        [self.contentView addSubview:_callButton];
//        _callButton.layer.cornerRadius = 5;
//        _callButton.layer.masksToBounds = YES;
//        _callButton.layer.borderColor = colorRed.CGColor;
//        _callButton.layer.borderWidth = 1;
//
//        // 按钮上加图片和文字
//        UIImageView *imgCall = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 13, 13)];
//        [_callButton addSubview:imgCall];
//        imgCall.image = [UIImage imageNamed:@"qdkh_dh"];
//        UILabel *labelCall = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 60, 28)];
//        [_callButton addSubview:labelCall];
//        labelCall.font = [UIFont systemFontOfSize:14];
//        labelCall.textColor = colorRed;
//        labelCall.text = @"拨打电话";
//        [_callButton addTarget:self action:@selector(callButtonClick) forControlEvents:UIControlEventTouchUpInside];
        

//        int iDellBtnLeft =  SCREEN_WIDTH - 180;
//        _delButton =  [[UIButton alloc] initWithFrame:CGRectMake(iDellBtnLeft, iTopY-8, 80, 28)];
//        [self.contentView addSubview:_delButton];
//        _delButton.layer.cornerRadius = 5;
//        _delButton.layer.masksToBounds = YES;
//        _delButton.layer.borderColor = [ResourceManager CellSubTitleColor].CGColor;
//        _delButton.layer.borderWidth = 1;
//        _delButton.hidden = YES;
//        [_delButton addTarget:self action:@selector(delButtonClick) forControlEvents:UIControlEventTouchUpInside];
//
//        if (_ireceiveStatus == 3||
//            _ireceiveStatus == 4||
//            _ireceiveStatus == 5)
//         {
//            //_statusLabel.text = @"无效客户";
//            //_statusLabel.text = @"退单审核中";
//            // 按钮上加图片和文字
//            _delButton.hidden = NO;
//            UIImageView *imgDel = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 13, 13)];
//            [_delButton addSubview:imgDel];
//            imgDel.image = [UIImage imageNamed:@"new_del"];
//            UILabel *labelDel = [[UILabel alloc] initWithFrame:CGRectMake(16+15, 0, 60, 28)];
//            [_delButton addSubview:labelDel];
//            labelDel.font = [UIFont systemFontOfSize:14];
//            labelDel.textColor = [ResourceManager CellSubTitleColor];
//            labelDel.text = @"删除";
//
//            if (_ireceiveStatus == 3||
//                _ireceiveStatus == 4 )
//             {
//                _lightingButton.hidden = NO;
//                _callButton.hidden = YES;
//             }
//
//            if (5 == _ireceiveStatus)
//             {
//                int iserviceStatus = [_dataDicionary[@"serviceStatus"] intValue];
//                //只有退单失败，才能删除订单
//                if (2 != iserviceStatus)
//                 {
//                    _delButton.hidden = YES;
//                    //strTitle = @"退单失败";
//                 }
//             }
//         }
        
        
        iTopY += ibtnHeight +10;
        // 底部的灰色分割条
        UIView *viewFGTail = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
        [self.contentView addSubview:viewFGTail];
        viewFGTail.backgroundColor = [ResourceManager viewBackgroundColor];
        
     }
    
}
-(void) setStatusLabel:(UILabel *)statusLabel
{
    
    int ireceiveStatus  = [[_dataDicionary objectForKey:@"receiveStatus"] intValue];

    if (1 == ireceiveStatus)
     {
        _statusLabel.text = @"新订单";
        _statusLabel.textColor = UIColorFromRGB(0xff5e18);
     }
    else if (2 == ireceiveStatus)
     {
        _statusLabel.text = @"成功放款";
        _statusLabel.textColor = UIColorFromRGB(0x01b448);
        
     }
    else if (3 == ireceiveStatus ||
             4 == ireceiveStatus)
     {
        _statusLabel.text = @"无效客户";
        _statusLabel.textColor = UIColorFromRGB(0xafafaf);
     }
    else if (5 == ireceiveStatus)
     {
        _statusLabel.textColor = UIColorFromRGB(0xfa0813);
        
        int iserviceStatus = [_dataDicionary[@"serviceStatus"] intValue];
        NSString *strTitle = @"退单处理中";
        
        if (0 == iserviceStatus)
         {
            strTitle = @"退单处理中";
         }
        if (1 == iserviceStatus)
         {
            strTitle = @"退单成功";
         }
        if (2 == iserviceStatus)
         {
            strTitle = @"退单失败";
         }
        _statusLabel.text = strTitle;
     }
    else if (7 == ireceiveStatus)
     {
        _statusLabel.text = @"跟进中";
        _statusLabel.textColor = UIColorFromRGB(0x3196ff);
     }
    else if (8 == ireceiveStatus)
     {
        _statusLabel.text = @"继续跟进";
        _statusLabel.textColor = UIColorFromRGB(0x3196ff);
     }
    else if (9 == ireceiveStatus)
     {
        _statusLabel.text = @"审批中";
        _statusLabel.textColor = UIColorFromRGB(0x3196ff);
     }
    else if (10 == ireceiveStatus)
     {
        _statusLabel.text = @"审批通过";
        _statusLabel.textColor = UIColorFromRGB(0x3196ff);
     }
    
    _statusLabel.textColor = [ResourceManager mainColor];
}


#pragma mark --- action
- (void)lightButtonClick{
    if (self.handleBlock) {
        self.handleBlock();
    }
}

-(void) callButtonClick
{
    if (self.callBlock)
     {
        self.callBlock();
     }
    
}

-(void) delButtonClick
{
    if (self.delBlock)
     {
        self.delBlock();
     }
}

-(void) payButtonClick
{
    if (self.payBlock)
     {
        self.payBlock();
     }
}

@end
