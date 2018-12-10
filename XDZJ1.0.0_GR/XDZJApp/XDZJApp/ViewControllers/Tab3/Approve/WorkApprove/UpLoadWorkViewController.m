//
//  UpLoadWorkViewController.m
//  XXJR
//
//  Created by xxjr03 on 2017/8/1.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "UpLoadWorkViewController.h"

@interface UpLoadWorkViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *_imageStr;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadImageLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadBtnLayoutHeight;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;

@end

@implementation UpLoadWorkViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"上传工牌照"];
    
    self.imageLayoutHeight.constant = 167 * ScaleSize;
    self.uploadImageLayoutHeight.constant = self.uploadBtnLayoutHeight.constant = 180 * ScaleSize;
    if (self.jobImage.length > 0) {
        [self.uploadImageView sd_setImageWithURL:[NSURL URLWithString:self.jobImage]];
    }
}

- (IBAction)uploadBtn:(id)sender {
    if (self.statusType == 1) {
        [MBProgressHUD showErrorWithStatus:@"您的认证已成功，请勿更改图片信息" toView:self.view];
        return;
    }
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
            pickerController.allowsEditing = NO;
            
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
            pickerController.allowsEditing = NO;
            
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
            pickerController.allowsEditing = NO;
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
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //缩小图片的size
    //image = [self imageByRedraw:image];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2f);
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileType"] = @"identifyCard";
    params[@"signId"] = [DDGSetting sharedSettings].signId;
    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    
    [requestManager POST:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGuploadIDCard] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //把图片添加到视图框内
        self.uploadImageView.image=[UIImage imageWithData:self.imageData];
        
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[json objectForKey:@"success"] integerValue] != 0) {
            [self handleData];
            NSDictionary *attr = json[@"attr"];
            if (attr)
             {
                _imageStr = [(NSDictionary *)attr objectForKey:@"fileId"];
             }
        }else{
            [MBProgressHUD showErrorWithStatus:@"上传失败" toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        self.imageData = nil;
    }];
}

-(void)handleData{
    [DDGSetting sharedSettings].accountNeedRefresh = YES;
    [MBProgressHUD showSuccessWithStatus:@"上传图片成功" toView:self.view];
    //延时操作
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1];
}

-(void)delayMethod
{
    self.workBlock(_imageStr);
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
