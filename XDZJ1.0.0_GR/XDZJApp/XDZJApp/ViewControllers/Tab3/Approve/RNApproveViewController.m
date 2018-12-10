//
//  RNApproveViewController.m
//  XXJR
//
//  Created by xxjr03 on 2017/7/27.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "RNApproveViewController.h"

#import "CommonInfo.h"
#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>

#import <QuartzCore/QuartzCore.h>
#import "DemoPreDefine.h"


#import "iflyMSC/IFlyFaceSDK.h"

#import "IFlyFaceResultKeys.h"

@interface RNApproveViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate, AipOcrDelegate>
{
    NSInteger _updataType;
    NSInteger _idCardType;

}
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *cardNumStr;
@property (nonatomic, strong) NSString *idCardLimit;
@property (nonatomic, strong) NSString *idCardSignOrg;
@property (nonatomic, strong) NSString *realImg;
@property (nonatomic, strong) NSString *idCardImg;
@property (nonatomic, strong) NSString *handImg;

@property (nonatomic,retain) IFlyFaceDetector  *faceDetector;

@property (weak, nonatomic) IBOutlet UIImageView *realImageView;
@property (weak, nonatomic) IBOutlet UIImageView *idCardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *handImageView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *realImageLayoutWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *realImageLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutSafeAreaTopHeight;
@end

@implementation RNApproveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"上传手持身份证照"];
    
    self.realImageLayoutWidth.constant = 140 * ScaleSize;
    self.realImageLayoutHeight.constant = 90 * ScaleSize;
    self.nextBtnLayoutHeight.constant = 40 * ScaleSize;
    self.layoutSafeAreaTopHeight.constant = IS_IPHONE_X_MORE ? 90 : 74;
    //授权方法1：请在 http://ai.baidu.com中 新建App, 绑定BundleId后，在此处填写App的Api Key/Secret Key
    //[[AipOcrService shardService] authWithAK:@"u9ArxBmGxiGwPfKByIPSeNCE" andSK:@"liMOceDTAMrIXapsp5Csh9jiAB6Ozkrs"]; // 正式
    //[[AipOcrService shardService] authWithAK:@"YQGCiGzcvhPrVx9EVHQGl0af" andSK:@"RTAGqy6vkifhkcCnIy4OND0EdyScZ1p5"];
    
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    
    [self dataSource];
}

-(void)dataSource {
    if (self.idCardDic.count > 0) {
        NSDictionary *dic = self.idCardDic;
        if ([dic objectForKey:@"realImage"] && [dic objectForKey:@"idCardImage"] && [dic objectForKey:@"handImage"]) {
            _realImg = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realImage"]];
            _idCardImg = [NSString stringWithFormat:@"%@",[dic objectForKey:@"idCardImage"]];
            _handImg = [NSString stringWithFormat:@"%@",[dic objectForKey:@"photoUrl"]];
            [self.realImageView sd_setImageWithURL:[NSURL URLWithString:_realImg] placeholderImage:[UIImage imageNamed:@"appove-1"]];
            [self.idCardImageView sd_setImageWithURL:[NSURL URLWithString:_idCardImg] placeholderImage:[UIImage imageNamed:@"appove-2"]];
            [self.handImageView sd_setImageWithURL:[NSURL URLWithString:_handImg] placeholderImage:[UIImage imageNamed:@"appove-3"]];
            _nameStr = [dic objectForKey:@"realName"];
            _cardNumStr = [dic objectForKey:@"cardNo"];
            _idCardLimit = [dic objectForKey:@"idCardLimit"];
            _idCardSignOrg = [dic objectForKey:@"idCardSignOrg"];
        }
        //失败原因
        if ([[dic objectForKey:@"status"] intValue] == 2 && [dic objectForKey:@"auditDesc"]) {
            self.errorLabel.text = [NSString stringWithFormat:@"   失败原因:%@",[dic objectForKey:@"auditDesc"]];
            self.errorLabel.backgroundColor = UIColorFromRGB(0xF3604E);
        }else{
            self.errorLabel.text = @"";
            self.errorLabel.backgroundColor = [UIColor clearColor];
        }
    }
}

- (IBAction)uploadBtn:(UIButton *)sender {
    _updataType = sender.tag;
    if (sender.tag == 101) {
        if (![self scanTime]) {
            [MBProgressHUD showErrorWithStatus:@"每天有3次识别机会，请明天再试" toView:self.view];
            return;
        }
        UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont andDelegate:self];
        _idCardType = 100;
        [self presentViewController:vc animated:YES completion:nil];
    }else  if (sender.tag == 102) {
        UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardBack andDelegate:self];
        _idCardType = 101;
        [self presentViewController:vc animated:YES completion:nil];
    }else  if (sender.tag == 103) {
        _idCardType = 102;
        UIActionSheet *sheet =  [[UIActionSheet alloc] initWithTitle:@"选择"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"拍照",@"从相册选择", nil];
        [sheet showInView:self.view];
    }
}

- (IBAction)next:(UIButton *)sender {
    if (self.realImg.length == 0 || self.handImg.length == 0 || self.idCardImg.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"三张照片分别上传完成才能提交" toView:self.view];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"realImage"] = _realImg;
    params[@"idCardImage"] = _idCardImg;
    params[@"photoUrl"] = _handImg;
    params[@"realName"] = _nameStr;
    params[@"cardNo"] = _cardNumStr;
    params[@"idCardLimit"] = _idCardLimit;
    params[@"idCardSignOrg"] = _idCardSignOrg;
     params[@"fileType"] = @"identify";
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGfaceAuthCompare]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showSuccessWithStatus:@"提交成功" toView:self.view];
                                                                                      [self performBlock:^{
                                                                                          [self.navigationController popViewControllerAnimated:YES];
                                                                                      } afterDelay:1];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      if ([[operation.jsonResult.attr objectForKey:@"autoAuditCount"]intValue] == 3) {
                                                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"认证失败" message:operation.jsonResult.message delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                                                                                          alert.tag = 1001;
                                                                                          [alert show];
                                                                                      }else{
                                                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"认证失败" message:operation.jsonResult.message delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                                                                                          alert.tag = 1002;
                                                                                          [alert show];
                                                                                      }
                                                                                  }];
    [operation start];
}

//上传头像
#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if (buttonIndex == 0 || buttonIndex == 1)//从相册中获取照片
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                return;
            }
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.allowsEditing = YES;
            
            [self.navigationController presentViewController:pickerController animated:YES completion:nil];
        }
    }
    else {
        if (buttonIndex == 0) //拍摄
        {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                                           UIImagePickerControllerSourceTypeCamera];
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.allowsEditing = YES;
            pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            [self.navigationController presentViewController:pickerController animated:YES completion:nil];
        } else if (buttonIndex == 1) //从相册中获取照片
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                return;
            }
            
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.allowsEditing = YES;
            if (iOS7) {
                pickerController.navigationBar.barTintColor = [ResourceManager redColor2];
            }else{
                pickerController.navigationBar.tintColor = [ResourceManager redColor2];
            }
            
            [self.navigationController presentViewController:pickerController animated:YES completion:nil];
        }
    }
}
#pragma mark -
#pragma mark UIImagePickerViewControllerDelegate
/**
 *  Tells the delegate that the user picked a still image or movie.
 *
 *  @param picker
 *  @param info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
#define dataSize 1024.0f
#define imageSize CGSizeMake(600.0f, 600.0f)
    //先把原图保存到图片库
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
    }
    //获取用户选取的图片并转换成NSData
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //缩小图片的size
    image = [self imageByRedraw:image];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.25f);
    if (imageData){
        self.imageData = imageData;
 //       // 上传
//        [self upLoadImageData];
        //检测是否有人脸
         self.faceDetector=[IFlyFaceDetector sharedInstance];
        NSString* strResult=[self.faceDetector detectARGB:image];
        NSLog(@"result:%@",strResult);
        [self praseDetectResult:strResult];
    
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *  截图
 *
 *  @param image
 *
 *  @return UIImage
 */
- (UIImage *)imageByRedraw:(UIImage *)image
{
    if (image.size.width == image.size.height)
    {
        UIGraphicsBeginImageContext(imageSize);
        CGRect rect = CGRectZero;
        rect.size = imageSize;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextFillRect(ctx, rect);
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
        CGFloat ratio = image.size.width / image.size.height;
        CGSize size = CGSizeZero;
        
        if (image.size.width > imageSize.width)
        {
            size.width = imageSize.width;
            size.height = size.width / ratio;
        }
        else if (image.size.height > imageSize.height)
        {
            size.height = imageSize.height;
            size.width = size.height * ratio;
        }
        else
        {
            size.width = image.size.width;
            size.height = image.size.height;
        }
        //这里的size是最终获取到的图片的大小
        UIGraphicsBeginImageContext(imageSize);
        CGRect rect = CGRectZero;
        rect.size = imageSize;
        //先填充整个图片区域的颜色为黑色
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextFillRect(ctx, rect);
        rect.origin = CGPointMake((imageSize.width - size.width)/2, (imageSize.height - size.height)/2);
        rect.size = size;
        //画图
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

-(void)upLoadImageData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileType"] = @"identify";
    params[@"signId"] = [DDGSetting sharedSettings].signId;
    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestManager POST:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGuploadIDCard] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[json objectForKey:@"success"] integerValue] != 0) {
            //把图片添加到视图框内
            NSDictionary *attr = [(NSDictionary *)json objectForKey:@"attr"];
            if (_updataType == 101) {
                self.realImg = [attr objectForKey:@"fileId"];
                self.realImageView.image=[UIImage imageWithData:self.imageData];
            }if (_updataType == 102) {
                self.idCardImg = [attr objectForKey:@"fileId"];
                self.idCardImageView.image=[UIImage imageWithData:self.imageData];
            }else if (_updataType == 103) {
                self.handImg = [attr objectForKey:@"fileId"];
                self.handImageView.image=[UIImage imageWithData:self.imageData];
            }
            [self handleData];
        }else{
            [MBProgressHUD showErrorWithStatus:@"上传失败" toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        self.imageData = nil;
    }];
}


-(void)upLoadImageData2{
    // [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileType"] = @"identify";
    params[@"signId"] = [DDGSetting sharedSettings].signId;
    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestManager POST:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGuploadIDCard] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //[MBProgressHUD hideHUDForView:self.view animated:NO];
        
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[json objectForKey:@"success"] integerValue] != 0) {
            //把图片添加到视图框内
            NSDictionary *attr = [(NSDictionary *)json objectForKey:@"attr"];
            if ([attr objectForKey:@"fileId"] &&  [NSString stringWithFormat:@"%@",[attr objectForKey:@"fileId"] ].length > 0) {
                if (_updataType == 101) {
                    self.realImg = [attr objectForKey:@"fileId"];
                    self.realImageView.image=[UIImage imageWithData:self.imageData];
                }if (_updataType == 102) {
                    self.idCardImg = [attr objectForKey:@"fileId"];
                    self.idCardImageView.image=[UIImage imageWithData:self.imageData];
                }else if (_updataType == 103) {
                    self.handImg = [attr objectForKey:@"fileId"];
                    self.handImageView.image=[UIImage imageWithData:self.imageData];
                }
                [self handleData];
            }
            // 返回上级页面
            [self dismissViewControllerAnimated:NO completion:nil];
        }else{
            [MBProgressHUD showErrorWithStatus:@"上传失败" toView:self.view];
            // 返回上级页面
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        // 返回上级页面
        [self dismissViewControllerAnimated:YES completion:nil];
        self.imageData = nil;
    }];
}

-(void)handleData{
    [DDGSetting sharedSettings].accountNeedRefresh = YES;
    [MBProgressHUD showSuccessWithStatus:@"上传图片成功" toView:self.view];
    self.imageData = nil;
}

-(BOOL)scanTime{
    //获取当前时间
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    NSString *timeStr = [NSString stringWithFormat:@"%04ld%02ld%02ld",(long)comp.year,(long)comp.month,(long)comp.day];
    
    if (![CommonInfo getKey:@"scanTime"] || [NSString stringWithFormat:@"%@",[CommonInfo getKey:@"scanTime"]].length == 0) {
        return YES;
    }
    NSString *oldTime = [NSString stringWithFormat:@"%@",[CommonInfo getKey:@"scanTime"]];
    NSString *oldYear = [oldTime substringWithRange:NSMakeRange(0, 4)];
    NSString *oldMonth = [oldTime substringWithRange:NSMakeRange(4, 2)];
    NSString *oldDay = [oldTime substringWithRange:NSMakeRange(6, 2)];
    NSString *newYear = [timeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *newMonth = [timeStr substringWithRange:NSMakeRange(4, 2)];
    NSString *newDay = [timeStr substringWithRange:NSMakeRange(6, 2)];
    if ([newYear intValue] > [oldYear intValue]) {
        [CommonInfo setKey:@"scanCount" withValue:@"0"];
        return YES;
    }else{
        if ([newMonth intValue] > [oldMonth intValue]) {
            [CommonInfo setKey:@"scanCount" withValue:@"0"];
            return YES;
        }else{
            if ([newDay intValue] > [oldDay intValue]) {
                [CommonInfo setKey:@"scanCount" withValue:@"0"];
                return YES;
            }
        }
    }
    if ([[CommonInfo getKey:@"scanCount"] intValue] < 3) {
        return YES;
    }
    return NO;
}

-(void)saveTime{
    //获取当前时间
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    NSString *timeStr = [NSString stringWithFormat:@"%04ld%02ld%02ld",(long)comp.year,(long)comp.month,(long)comp.day];
    
    NSString *scanCount = [NSString stringWithFormat:@"%d",[[CommonInfo getKey:@"scanCount"] intValue] + 1];
    [CommonInfo setKey:@"scanCount" withValue:scanCount];
    NSLog(@"%@----------",[CommonInfo getKey:@"scanCount"]);
    [CommonInfo setKey:@"scanTime" withValue:timeStr];
}

#pragma mark AipOcrResultDelegate
- (void)ocrOnIdCardSuccessful:(id)result {
    NSMutableString *message = [NSMutableString string];
    if(((NSDictionary *)result)[@"words_result"]){
        [((NSDictionary *)result)[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [message appendFormat:@"%@: %@\n", key, ((NSDictionary *)obj)[@"words"]];
            NSLog(@"--------%@", message);
        }];
    }
    if (_idCardType == 100) {
        //身份证正面
        [self saveTime];
        if (((NSDictionary *)result)[@"words_result"]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSDictionary *dic = ((NSDictionary *)result)[@"words_result"];
                NSDictionary *dic_Name =[dic objectForKey:@"姓名"];
                NSDictionary *dic_CardNum = [dic objectForKey:@"公民身份号码"];
                if ([NSString stringWithFormat:@"%@",  [dic_Name objectForKey:@"words"]].length > 0 && [NSString stringWithFormat:@"%@",   [dic_CardNum objectForKey:@"words"]].length == 18) {
                    _nameStr = [NSString stringWithFormat:@"%@",   [dic_Name objectForKey:@"words"]];
                    _cardNumStr = [NSString stringWithFormat:@"%@",  [dic_CardNum objectForKey:@"words"]];
                    if ([self getDocumentImage]) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                        self.imageData = [self getDocumentImage];
                        [self upLoadImageData];
                    }
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"识别失败" message:@"请重新识别身份证" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
    }else{
        
        //身份证反面
        if (((NSDictionary *)result)[@"words_result"]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSDictionary *dic = ((NSDictionary *)result)[@"words_result"];
                NSDictionary *dic_loseTime =[dic objectForKey:@"失效日期"];
                NSDictionary *dic_issueTime = [dic objectForKey:@"签发日期"];
                NSDictionary *dic_cardOrgan = [dic objectForKey:@"签发机关"];
                if ([[dic_loseTime objectForKey:@"words"] intValue] > 0 && [[dic_issueTime objectForKey:@"words"] intValue] > 0 && [NSString stringWithFormat:@"%@",[dic_cardOrgan objectForKey:@"words"]].length > 0) {
                    _idCardLimit = [NSString stringWithFormat:@"%@-%@", [dic_issueTime objectForKey:@"words"],[dic_loseTime objectForKey:@"words"]];
                    _idCardSignOrg = [NSString stringWithFormat:@"%@", [dic_cardOrgan objectForKey:@"words"]];
                    if ([self getDocumentImage] ) {
                        self.imageData = [self getDocumentImage];
                        [self upLoadImageData2];
                    }
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"识别失败" message:@"请重新识别身份证背面" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
    }
}

- (void)ocrOnFail:(NSError *)error {
    NSLog(@"%@", error);
    NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}

// 读取并存贮到相册
-(NSData *)getDocumentImage{
    if (_idCardType == 100) {
        // 读取沙盒路径图片
        NSString *aPath3=[NSString stringWithFormat:@"%@/tmp/%@.png",NSHomeDirectory(),@"Orc"];
        // 拿到沙盒路径图片
        UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
        NSData *imageData = UIImageJPEGRepresentation(imgFromUrl3,0.25); // 压缩图片
        return imageData;
    }else{
        // 读取沙盒路径图片
        NSString *aPath3=[NSString stringWithFormat:@"%@/tmp/%@.png",NSHomeDirectory(),@"Orc2"];
        // 拿到沙盒路径图片
        UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
        NSData *imageData = UIImageJPEGRepresentation(imgFromUrl3,0.25); // 压缩图片
        return imageData;
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (alertView.tag == 1002) {
    }else{
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Data Parser
-(void)praseDetectResult:(NSString*)result{
    NSString *resultInfo = @"";
    NSError* error;
    NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
    if(dic){
        NSNumber* ret=[dic objectForKey:KCIFlyFaceResultRet];
        NSArray* faceArray=[dic objectForKey:KCIFlyFaceResultFace];
        //检测
        if(ret && [ret intValue]==0 && faceArray &&[faceArray count]>0){
            resultInfo=[resultInfo stringByAppendingFormat:@"检测到人脸轮廓"];
            [self upLoadImageData];
        }else{
            resultInfo=[resultInfo stringByAppendingString:@"未检测到人脸轮廓"];
            [MBProgressHUD showErrorWithStatus:@"未检测到人脸轮廓,请重新上传" toView:self.view];
            self.imageData = nil;
        }
        
    }
}


@end
