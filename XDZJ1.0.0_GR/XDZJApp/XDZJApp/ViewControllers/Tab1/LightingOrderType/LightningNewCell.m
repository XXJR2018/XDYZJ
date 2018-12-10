//
//  LightningNewCell.m
//  XXJR
//
//  Created by xxjr02 on 2018/3/28.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "LightningNewCell.h"



NSString *const LightningNewCellID = @"LightningNewCellID"; 

@implementation LightningNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//-(void)layoutSubviews{
//    [super layoutSubviews];
//    
//    if (!_dataDicionary)
//     {
//        return;
//     }
//    
//    if (!_nameLabel)
//     {
//        int iTopY = 15;
//        int iLeftX = 20;
//        UIColor *colorRed = UIColorFromRGB(0xff5e18);
//        
//        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 50, 20)];
//        [self.contentView addSubview:_nameLabel];
//        _nameLabel.textColor = [ResourceManager CellTitleColor];
//        _nameLabel.font = [UIFont systemFontOfSize:16];
//        _nameLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"userName"]];
//        if ([NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"userName"]].length > 4) {
//            NSString *s = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"userName"]];
//            _nameLabel.text = [s substringToIndex:4];
//        }
//        
//        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + _nameLabel.width, iTopY, 150, 20)];
//        [self.contentView addSubview:_cityLabel];
//        _cityLabel.textColor = [ResourceManager CellSubTitleColor];
//        _cityLabel.font = [UIFont systemFontOfSize:14];
//        _cityLabel.text = _dataDicionary[@"locaText"];
//        [_cityLabel sizeToFit];
//        
//        int iAuthStatus = [_dataDicionary[@"authStatus"] intValue];
//        if (1 == iAuthStatus)
//         {
//            int iRZLeft = iLeftX + _nameLabel.width + _cityLabel.width + 10;
//            _rzLabel = [[UILabel alloc] initWithFrame:CGRectMake(iRZLeft , iTopY-5, 68, 22.5)];
//            [self.contentView addSubview:_rzLabel];
//            _rzLabel.layer.borderColor = UIColorFromRGB(0xb99130).CGColor;
//            _rzLabel.layer.borderWidth = 1;
//            _rzLabel.layer.cornerRadius = 5;
//            _rzLabel.textColor = UIColorFromRGB(0xb99130);
//            _rzLabel.font = [UIFont systemFontOfSize:13];
//            _rzLabel.text = @"  信用认证";
//            //[_rzLabel sizeToFit];
//         }
//
//        
//        _lightingButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, iTopY-5, 90, 28)];
//        [self.contentView addSubview:_lightingButton];
//        _lightingButton.layer.cornerRadius = 5;
//        _lightingButton.layer.masksToBounds = YES;
//        _lightingButton.backgroundColor = colorRed;
//        _lightingButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_lightingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_lightingButton addTarget:self action:@selector(lightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        if (_haveFreeRob)
//         {
//            [_lightingButton setTitle:@"免费抢单" forState:UIControlStateNormal];
//         }
//        if (_isNotKQD)
//         {
//            [_lightingButton setTitle:@"已抢单" forState:UIControlStateNormal];
//            //[_lightingButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//             _lightingButton.backgroundColor = [ResourceManager lightGrayColor];
//         }
//        
//        
//
//        
//        iTopY += 40;
//        _amountRCL =  [[RCLabel alloc] initWithFrame:CGRectMake(0, iTopY+10, 100, 30)];
//        [self.contentView  addSubview:_amountRCL];
//        _amountRCL.textAlignment = RTTextAlignmentCenter;
//        _amountRCL.componentsAndPlainText = [RCLabel extractTextStyle:[NSString stringWithFormat:@"<font size = 15 color=#fc6923>%@ </font><font size = 15 color=#9a9a9a>万元</font>",_dataDicionary[@"loanAmount"]]];
//        
//        int iDesLabelLeftX = 0 + _amountRCL.width +20;
//        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(iDesLabelLeftX, iTopY, SCREEN_WIDTH - iDesLabelLeftX, 40)];
//        [self.contentView addSubview:_desLabel];
//        _desLabel.textColor = [ResourceManager CellTitleColor];
//        _desLabel.font = [UIFont systemFontOfSize:15];
//        _desLabel.numberOfLines = 0;
//        if ([NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"loanDesc"]].length > 0 && [_dataDicionary objectForKey:@"loanDesc"]) {
//            _desLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"loanDesc"]];
//        }else{
//            _desLabel.text = @"  无";
//        }
//        
//        // 竖线的分割线
//        UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(iDesLabelLeftX-20, iTopY, 1, 40)];
//        [self.contentView addSubview:viewFG1];
//        viewFG1.backgroundColor = [ResourceManager color_5];
//        
//        // 横的分割线
//        iTopY += _desLabel.height + 20;
//        UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 1)];
//        [self.contentView addSubview:viewFG2];
//        viewFG2.backgroundColor = [ResourceManager color_5];
//        
//        iTopY +=10;
//        _labelTime = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 150, 15)];
//        [self.contentView addSubview:_labelTime];
//        _labelTime.textColor = [ResourceManager CellSubTitleColor];
//        _labelTime.font = [UIFont systemFontOfSize:14];
//        
//        NSString *strWebTime = [_dataDicionary objectForKey:@"applyTimeDesc"];
//
//        NSString *strTime = [NSString stringWithFormat:@"申请时间：%@",strWebTime];
//        _labelTime.text = strTime;
//        
//        
//        _labelLook = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, iTopY, 90, 15)];
//        [self.contentView addSubview:_labelLook];
//        _labelLook.textColor = colorRed;
//        _labelLook.font = [UIFont systemFontOfSize:14];
//        _labelLook.text = @"查看详情>>";
//        
//        
//        iTopY += 25;
//        // 底部的灰色分割条
//        UIView *viewFGTail = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
//        [self.contentView addSubview:viewFGTail];
//        viewFGTail.backgroundColor = [ResourceManager viewBackgroundColor];
//        
//     }
//    
//}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (!_dataDicionary)
     {
        return;
     }
    
    if (!_nameLabel)
     {
        
        int iTopY = 15;
        int iLeftX = 20 +90;
        UIColor *colorMian = [ResourceManager mainColor];
        
        UIView *viewAmoutBG = [[UIView alloc] initWithFrame:CGRectMake(10, iTopY, 90, 90)];
        [self.contentView addSubview:viewAmoutBG];
        viewAmoutBG.backgroundColor = [ResourceManager viewBackgroundColor];
        
        _amountRCL =  [[RCLabel alloc] initWithFrame:CGRectMake(0, 25, 90, 30)];
        [viewAmoutBG  addSubview:_amountRCL];
        //[self.contentView  addSubview:_amountRCL];
        _amountRCL.textAlignment = RTTextAlignmentCenter;
        _amountRCL.componentsAndPlainText = [RCLabel extractTextStyle:[NSString stringWithFormat:@"<font size = 22 color=#F86931>%@</font><font size = 20 color=#F86931>万元</font>",_dataDicionary[@"loanAmount"]]];
        [ResourceManager color_1];
        
        UILabel *labelTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 90, 20)];
        [viewAmoutBG addSubview:labelTemp];
        labelTemp.font = [UIFont systemFontOfSize:13];
        labelTemp.textColor = UIColorFromRGB(0x9a9a9a);
        labelTemp.text = @"申请金额";
        labelTemp.textAlignment = NSTextAlignmentCenter;
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 50, 30)];
        [self.contentView addSubview:_nameLabel];
        _nameLabel.textColor = [ResourceManager CellTitleColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"userName"]];
        if ([NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"userName"]].length > 4) {
            NSString *s = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"userName"]];
            _nameLabel.text = [s substringToIndex:4];
        }
        
        CGRect frameBtn = CGRectMake(SCREEN_WIDTH - 100, iTopY, 90, 30);
        
        UIView *viewBtnBG = [[UIView alloc] initWithFrame:frameBtn];
        [self.contentView addSubview:viewBtnBG];
        
        _lightingButton = [[UIButton alloc] initWithFrame:frameBtn];
        [self.contentView addSubview:_lightingButton];
        //_lightingButton.layer.cornerRadius = 5;
        //_lightingButton.layer.masksToBounds = YES;
        //_lightingButton.backgroundColor = colorRed;
        _lightingButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_lightingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lightingButton addTarget:self action:@selector(lightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGSize finalSize = CGSizeMake(CGRectGetWidth(_lightingButton.bounds), CGRectGetHeight(_lightingButton.bounds));
        CGFloat layerHeight = finalSize.height;
        CAShapeLayer *layer = [CAShapeLayer layer];
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        [bezier moveToPoint:CGPointMake(7, 0)];
        [bezier addLineToPoint:CGPointMake(0, finalSize.height)];
        [bezier addLineToPoint:CGPointMake(finalSize.width, finalSize.height)];
        [bezier addLineToPoint:CGPointMake(finalSize.width, finalSize.height - layerHeight)];
        layer.path = bezier.CGPath;
        layer.fillColor = colorMian.CGColor;
        [viewBtnBG.layer addSublayer:layer];
        
        
//        if ([[_dataDicionary objectForKey:@"status"] intValue])
//         {
//            [_lightingButton setTitle:@"已抢单" forState:UIControlStateNormal];
//            [_lightingButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
//            _lightingButton.backgroundColor = [ResourceManager lightGrayColor];
//            _lightingButton.enabled = NO;
//         }
//        else
//         {
//            int iPrice = [_dataDicionary[@"price"]   intValue] / 100;
//            NSString *strPrice = [NSString stringWithFormat:@"%d元抢单", iPrice];
//            [_lightingButton setTitle:strPrice forState:UIControlStateNormal];
//         }
        
        if (_haveFreeRob)
         {
            [_lightingButton setTitle:@"免费抢单" forState:UIControlStateNormal];
         }
        if (_isNotKQD)
         {
            [_lightingButton setTitle:@"已抢单" forState:UIControlStateNormal];
            //[_lightingButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            //_lightingButton.backgroundColor = [ResourceManager lightGrayColor];
            layer.fillColor = [ResourceManager lightGrayColor].CGColor;
         }

        iTopY += 35;
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 150, 15)];
        [self.contentView addSubview:_cityLabel];
        _cityLabel.textColor = [ResourceManager CellSubTitleColor];
        _cityLabel.font = [UIFont systemFontOfSize:11];
        _cityLabel.text = _dataDicionary[@"locaText"];
        [_cityLabel sizeToFit]; // 自适应， 调整宽度
        
        
        _labelTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, iTopY, 110, 15)];
        [self.contentView addSubview:_labelTime];
        _labelTime.textColor = [ResourceManager CellSubTitleColor];
        _labelTime.font = [UIFont systemFontOfSize:11];
        _labelTime.textAlignment = NSTextAlignmentRight;
        
        NSString *strWebTime = [_dataDicionary objectForKey:@"applyTimeDesc"];
        NSString *strTime = [NSString stringWithFormat:@"申请时间:%@",strWebTime];
        _labelTime.text = strTime;
        
        //        int iAuthStatus = [_dataDicionary[@"authStatus"] intValue];
        //        if (1 == iAuthStatus)
        //         {
        //            int iRZLeft = iLeftX + _nameLabel.width + _cityLabel.width + 10;
        //            _rzLabel = [[UILabel alloc] initWithFrame:CGRectMake(iRZLeft , iTopY-5, 68, 22.5)];
        //            [self.contentView addSubview:_rzLabel];
        //            _rzLabel.layer.borderColor = UIColorFromRGB(0xb99130).CGColor;
        //            _rzLabel.layer.borderWidth = 1;
        //            _rzLabel.layer.cornerRadius = 5;
        //            _rzLabel.textColor = UIColorFromRGB(0xb99130);
        //            _rzLabel.font = [UIFont systemFontOfSize:13];
        //            _rzLabel.text = @"  信用认证";
        //            //[_rzLabel sizeToFit];
        //         }
        
        
        iTopY += 20;
        int iDesLabelLeftX = 0 + 100 +10;
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(iDesLabelLeftX, iTopY, SCREEN_WIDTH - iDesLabelLeftX, 20)];
        [self.contentView addSubview:_desLabel];
        _desLabel.textColor = [ResourceManager CellTitleColor];
        _desLabel.font = [UIFont systemFontOfSize:13];
        _desLabel.numberOfLines = 0;
        if ([NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"loanDesc"]].length > 0 && [_dataDicionary objectForKey:@"loanDesc"]) {
            _desLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"loanDesc"]];
        }else{
            _desLabel.text = @"  无";
        }
        
        _labelLook = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, iTopY + 20, 90, 15)];
        [self.contentView addSubview:_labelLook];
        _labelLook.textColor = colorMian;
        _labelLook.font = [UIFont systemFontOfSize:13];
        _labelLook.text = @"查看详情>>";
        _labelLook.textAlignment = NSTextAlignmentRight;
        if ([_dataDicionary[@"status"] intValue] == 1)
         {
            _labelLook.hidden = YES;
         }
        
        
        
        
        
        
        iTopY += 55;
        // 底部的灰色分割条
        UIView *viewFGTail = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
        [self.contentView addSubview:viewFGTail];
        viewFGTail.backgroundColor = [ResourceManager viewBackgroundColor];
        
     }
    
}

- (void)lightButtonClick:(id)sender {
    if (self.lightedBlock) {
        self.lightedBlock();
    }
}



@end
