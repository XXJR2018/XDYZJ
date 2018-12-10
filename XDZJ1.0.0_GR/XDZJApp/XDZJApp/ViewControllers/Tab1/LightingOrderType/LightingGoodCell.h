//
//  LightingGoodCell.h
//  XXJR
//
//  Created by xxjr02 on 2018/3/29.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightingGoodCell : UITableViewCell


@property (nonatomic,strong) NSDictionary *dataDicionary;

@property (nonatomic, assign) bool  isGJQD;

@property (nonatomic,assign) int haveFreeRob;

@property (nonatomic,assign) BOOL isDiscount;      //是否打折扣  0 - 不打折,  1 -打折

@property (nonatomic,strong) NSString *isVip;       //是否是会员

@property (nonatomic,assign) BOOL isYZKH;        //是否优质客户单

@property (nonatomic,assign) BOOL isHYTJ;        //是否会员特价单

@property (weak, nonatomic) IBOutlet UIImageView *iconimg;



@property (strong, nonatomic) UIImageView *addImgView;



@property (strong, nonatomic)  UILabel *nameLabel;

@property (strong, nonatomic)  UILabel *cityLabel;

@property (strong, nonatomic)  UILabel *rzLabel;

@property (strong, nonatomic)  RCLabel *amountRCL;

@property (strong, nonatomic)  UILabel *desLabel;

@property (strong, nonatomic)  UILabel *labelTime;

@property (strong, nonatomic)  UILabel *labelLook;


@property (strong, nonatomic)  UIButton *lightingButton;




/*
 * 抢单成功回调
 */
@property (nonatomic,copy) Block_Void lightedBlock;

@end
