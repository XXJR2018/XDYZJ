//
//  FaceScanViewController.m
//  XXJR
//
//  Created by xxjr03 on 2018/1/8.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "FaceScanViewController.h"
#import "ApproveResultsViewController.h"

#import "iflyMSC/IFlyFaceSDK.h"
#import "IFlyFaceResultKeys.h"

@interface FaceScanViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *_headImgStr;
    IFlyFaceDetector  *_faceDetector;
}

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImgLayoutWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImgLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImgLayoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoLayoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnLayoutHeight;
@end

@implementation FaceScanViewController

#pragma mark - 友盟统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"拍照认证"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"拍照认证"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"拍照认证"];
    
    self.headImgLayoutWidth.constant = 250 * ScaleSize;
    self.headImgLayoutHeight.constant = 165 * ScaleSize;
    self.headImgLayoutTop.constant = 60 * ScaleSize;
    self.photoLayoutTop.constant = 102 * ScaleSize;
    self.nextBtnLayoutHeight.constant = 45 * ScaleSize;
    
    // 加入右边的按钮
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f,fRightBtnTopY,60.f, 35.0f)];
    [rightNavBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [rightNavBtn addTarget:self action:@selector(actionJump) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    if (_isShowJump)
     {
        [nav addSubview:rightNavBtn];
     }
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
    }
}

-(void) actionJump
{
    NSNotification *notifcation = [[NSNotification alloc]initWithName:DDGAccountEngineDidLoginNotification object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notifcation];
}

//拍照认证
- (IBAction)photoApprove:(UIButton *)sender {
    [self.view endEditing:YES];
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                                   UIImagePickerControllerSourceTypeCamera];
   
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.allowsEditing = YES;
     pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
}

//提交
- (IBAction)approveUrl:(id)sender {
    [self.view endEditing:YES];
    if (_headImgStr.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请拍摄个人清晰的头像" toView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 请求参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:self.paramDic];
    params[@"photoUrl"] = _headImgStr;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGfaceAuthCompare]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showSuccessWithStatus:@"提交成功" toView:self.view];
                                                                                      ApproveResultsViewController *ctl = [[ApproveResultsViewController alloc]init];
                                                                                      ctl.type = 100;
                                                                                      ctl.isShowJump = _isShowJump;
                                                                                      [self.navigationController pushViewController: ctl animated:YES];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
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
    NSData *imageData = UIImageJPEGRepresentation(image, 0.25);
    if (imageData){
        self.imageData = imageData;
        //       // 上传
        //        [self upLoadImageData];
        //检测是否有人脸
        _faceDetector=[IFlyFaceDetector sharedInstance];
        NSString* strResult=[_faceDetector detectARGB:image];
        NSLog(@"result:%@",strResult);
        if  (strResult)
         {
            [self praseDetectResult:strResult];
         }
        else
         {
            // 未检测到人脸脸框，并检测结果报空！！！！
            [self upLoadImageData];
         }
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
    params[@"photoUrl"] = @"1";
    params[@"signId"] = [DDGSetting sharedSettings].signId;
    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"xxjrIOS%@",currentVersion];
    params[@"appVersion"] = versionStr;
    
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
            if ( [attr objectForKey:@"fileId"] && [NSString stringWithFormat:@"%@",[attr objectForKey:@"fileId"] ].length > 0) {
                _headImgStr = [attr objectForKey:@"fileId"];
                self.headImg.image=[UIImage imageWithData:self.imageData];
                [self handleData];
            }
        }else{
            [MBProgressHUD showErrorWithStatus:@"上传失败" toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        self.imageData = nil;
    }];
}
    
-(void)handleData{
    [DDGSetting sharedSettings].accountNeedRefresh = YES;
    [MBProgressHUD showSuccessWithStatus:@"上传图片成功" toView:self.view];
    self.imageData = nil;
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
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
// Dispose of any resources that can be recreated.
}

@end
