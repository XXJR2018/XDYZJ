//
//  MessageBoxView.h
//  XXJR
//
//  Created by xxjr02 on 2017/12/15.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageBoxViewDelegate<NSObject>
@optional
-(void)didClickButtonAtIndex:(NSUInteger)index;
@end

@interface MessageBoxView : UIView

@property (weak,nonatomic) id<MessageBoxViewDelegate> delegate;
@property (strong,nonatomic) UIViewController  *parentVC;




//  初始化
-(instancetype)initWithTitle:(NSString *) title  Message:(NSString*)message  CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton;

- (void)show;
@end
