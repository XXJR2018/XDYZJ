//
//  BalanceRecordCell.m
//  XXJR
//
//  Created by xxjr03 on 17/4/14.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "BalanceRecordCell.h"

@interface BalanceRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;


@end

@implementation BalanceRecordCell

-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    self.dataDic = dataDicionary;
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"recordDesc"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"createTime"]];
    self.balanceLabel.text = [NSString stringWithFormat:@"余额:%.2f",[[self.dataDic objectForKey:@"usableAmount"]floatValue]];
    NSString *changeStr = [NSString stringWithFormat:@"%.2f",[[self.dataDic objectForKey:@"amount"]floatValue]];
    if ([changeStr rangeOfString:@"-"].location != NSNotFound) {
        self.changeLabel.text = [NSString stringWithFormat:@"%.2f",[[self.dataDic objectForKey:@"amount"]floatValue]];
    }else{
        self.changeLabel.text = [NSString stringWithFormat:@"+%.2f",[[self.dataDic objectForKey:@"amount"]floatValue]];
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
