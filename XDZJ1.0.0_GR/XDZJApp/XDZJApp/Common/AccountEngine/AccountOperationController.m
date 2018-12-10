//
//  DDGAccountBLController.m
//  DDGProject
//
//  Created by Cary on 15/1/5.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "AccountOperationController.h"
#import "CommonInfo.h"

#define kTimeoutSeconds 10

@implementation AccountOperationController

-(NSMutableDictionary *)paramDictionary{
    if (!_paramDictionary) {
        _paramDictionary = [NSMutableDictionary dictionary];
    }
    return _paramDictionary;
}

-(void)cancelRequest{
    [self.operation cancel];
}

-(void)accountRequest:(AccountRequestType)businessType success:(Block_Id)successBlock fail:(Block_Id)failedBlock{
    [self cancelRequest];
    
    if (self.viewControler){
        [MBProgressHUD hideAllHUDsForView:self.viewControler.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.viewControler.view animated:YES];
    }
    
    self.requestType = businessType;
    _successBlock = successBlock;
    _failedBlock = failedBlock;
    
    self.operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[self apiString:businessType]  parameters:self.paramDictionary HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray success:^(DDGAFHTTPRequestOperation *operation, id responseObject) {
        [self handleData:operation];
    } failure:^(DDGAFHTTPRequestOperation *operation, NSError *error) {
        [self handleErrorData:operation];
    }];
    
    self.operation.timeoutInterval = kTimeoutSeconds;
    [self.operation start];
}

-(NSString *)apiString:(AccountRequestType)businessType{
    
    switch (businessType) {
        case AccountRequestTypeLogin:
            return [PDAPI userDoLoginAPI];
            break;
        case AccountRequestTypeVerifyLogin:
            return [PDAPI userVerifyLoginAPI];
            break;
        case AccountRequestTypeRegister:
            return [PDAPI userGetRegisterAPI];
            break;
        case AccountRequestTypeGetVerifyCode:
            return [PDAPI getRegSendMsghAPI];
            break;
        case AccountRequestTypeLogOut:
            return [PDAPI userDoLogoutAPI];
            break;
        case AccountRequestTypeResetPassword:
            return @"";
            break;
        case AccountRequestTypeResetPassword_submitVerifyCode:
            return @"";
            break;
        case AccountRequestTypeResetPayPassword:
            return @"";
            break;
        case AccountRequestTypeResetPayPassword_submitVerifyCode:
            return @"";
            break;
        case AccountRequestTypeGetUserInfo:
            return [PDAPI getUserBaseInfoAPI];
            break;
        default:
            break;
    }
    
    return nil;
    
}


#pragma mark === HandleData
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    
    [MBProgressHUD hideAllHUDsForView:self.viewControler.view animated:NO];
    
    if (_successBlock) {
        _successBlock(operation);
    }else{
        [self successBlock:operation];
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    dispatch_main_sync_safe(^{
        if (_failedBlock) {
            _failedBlock(operation);
        }else{
            [self failedBlock:operation];
        }
    });
}

-(void)successBlock:(DDGAFHTTPRequestOperation *)operation{
    if (self.requestType == AccountRequestTypeGetUserInfo) {
        if (operation.jsonResult.success) {
            NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithDictionary:operation.jsonResult.rows[0]];
            for (NSString *key in dataDic.allKeys) {   //避免NULL字段
                if ([[dataDic objectForKey:key] isEqual:[NSNull null]]) {
                    [dataDic setValue:@"" forKey:key];
                }
            }
            [DDGAccountManager sharedManager].userInfo = dataDic;
            
            [[DDGAccountManager sharedManager] setUserInfoWithDictionary:self.paramDictionary];
            [[DDGAccountManager sharedManager] saveUserData];
            
            // 注册推送
            //[JPUSHService setAlias:[DDGSetting sharedSettings].uid callbackSelector:nil object:nil];
            
            [[DDGUserInfoEngine engine] finishDoBlock];
            [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
        }else{
            [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.viewControler.view];
        }
    }else if (self.requestType == AccountRequestTypeLogin || self.requestType == AccountRequestTypeVerifyLogin) {
        if (operation.jsonResult.success){
            [MBProgressHUD showSuccessWithStatus:@"登录成功" toView:self.viewControler.view];
            
            // 保存数据 /////////////////////////////////////////////////
            // 1. 账号相关：uid、 mobile、 密码、真实姓名
            self.paramDictionary[kUser_ID] = [(NSDictionary *)operation.jsonResult.attr objectForKey:@"customerId"];
            self.paramDictionary[kRealName] = [(NSDictionary *)operation.jsonResult.rows[0] objectForKey:kRealName];
            
            
            // 2. userInfo
            [self accountRequest:AccountRequestTypeGetUserInfo success:nil fail:nil];
            
            
        } else {
            [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.viewControler.view];
        }
    }else if (self.requestType == AccountRequestTypeRegister) {
        if (operation.jsonResult.success) {
            
            //注册进入
            [CommonInfo setRegistType:@"1"];
            
            
            [self.paramDictionary removeObjectForKey:@"randomNo"];
            [self accountRequest:AccountRequestTypeLogin success:nil fail:nil];
        } else {
            [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.viewControler.view];
        }
    }
}
-(void)failedBlock:(DDGAFHTTPRequestOperation *)operation{
    if (self.viewControler) {
        [MBProgressHUD showErrorWithStatus:[operation.errorDDG localizedDescription] toView:self.viewControler.view];
    }
}

@end
