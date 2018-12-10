//
//  FeedbackViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/12/19.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    NSString *_headImgStr;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *updataBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textviewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewLayoutHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NavConstraint;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"意见反馈"];
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    self.textviewLayoutHeight.constant = 128 * ScaleSize;
    self.imgViewLayoutHeight.constant = 170 * ScaleSize;
    //设置圆角边框
    self.textView.layer.cornerRadius = 8;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [ResourceManager color_5].CGColor;
    
    if(IS_IPHONE_X_MORE)
     {
        _NavConstraint.constant = 95;
     }
    
    _imageView.image = [UIImage imageNamed:@"addImag2"];
    [_updataBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}



//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard{
    [self.view endEditing:YES];
}
//提交按钮
- (IBAction)nextBtn:(id)sender {
    [self.view endEditing:YES];

    
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:@"请输入您的宝贵意见!"]) {
        [MBProgressHUD showErrorWithStatus:@"请输入您的宝贵意见!" toView:self.view];
        return;
    }
    [self nextUrl];
}

-(void)nextUrl
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_headImgStr.length > 0)
     {
        params[@"feebackImg"]= _headImgStr;
     }
    params[@"content"]=self.textView.text;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@mjb/account/info/feedback",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD showSuccessWithStatus:@"提交成功" toView:self.view];
                                                                                      
                                                                                      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
                                                                                      dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                                                          // 执行某个 耗时较长的操作.
                                                                                          
                                                                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                      });

                                                                                      
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
}


#pragma mark === UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""] && textView.text.length > 150) {
        [MBProgressHUD showErrorWithStatus:@"不能超过150字" toView:self.view];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入您的宝贵意见!"])
     {
        textView.text = @"";
        textView.textColor = [ResourceManager color_1];
     }

}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text == nil || textView.text.length < 1) {
        textView.text = @"请输入您的宝贵意见!";
    }
}

//上传图片
- (IBAction)uodataBtn:(id)sender {
    [self.view endEditing:YES];
    
    UIActionSheet *sheet =  [[UIActionSheet alloc] initWithTitle:@"选择"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照",@"从相册选择", nil];
    [sheet showInView:self.view];
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
            //pickerController.allowsEditing = YES;
            
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
            //pickerController.allowsEditing = YES;
            
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
            //pickerController.allowsEditing = YES;
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

    UIImage *originalImage = nil;

    originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //缩小图片的size
    //image = [self imageByRedraw:image];
    NSData *imageData = UIImageJPEGRepresentation(originalImage, 0.2f);
    if (imageData){
        self.imageData = imageData;
        // 上传
        [self upLoadImageData];
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
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"fileType"] = @"feedback";
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"xdjlIOS%@",currentVersion];
    params[@"appVersion"] = versionStr;
    
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestManager POST:[PDAPI getSendFileAPI] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self.updataBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //把图片添加到视图框内
        self.imageView.image=[UIImage imageWithData:self.imageData];
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[(NSDictionary *)json objectForKey:@"state"] isEqualToString:@"SUCCESS"]) {
            [self handleData];
            _headImgStr = [(NSDictionary *)json objectForKey:@"fileId"];
        }else{
            [MBProgressHUD showErrorWithStatus:@"上传失败" toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        self.imageData = nil;
    }];
}
-(void)handleData{
    [DDGSetting sharedSettings].accountNeedRefresh = YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
