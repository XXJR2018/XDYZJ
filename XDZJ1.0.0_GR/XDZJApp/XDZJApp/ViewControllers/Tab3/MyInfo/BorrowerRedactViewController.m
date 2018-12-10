//
//  BorrowerRedactViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/10/20.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "BorrowerRedactViewController.h"
#import "UIImageView+WebCache.h"
#import "SelectCityViewController.h"

@interface BorrowerRedactViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UIImageView *_headImg;
    NSString *_headImgStr;
    NSString *_pro;
    NSString *_city;
    NSString *_area;
    UITextField *_nameTextField;
    UITextField *_emTextField;
    UILabel *_cityLabel;
    UIScrollView *_scView;
    UITextView *_synopsisTextView;
}
@end

@implementation BorrowerRedactViewController
-(void)viewWillAppear:(BOOL)animated{
 
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"编辑个人信息"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"编辑个人信息"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"个人信息"];
    
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f,fRightBtnTopY,60.f, 35.0f)];
    [rightNavBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [ResourceManager font_7];
    [nav addSubview:rightNavBtn];
    
    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    _scView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - NavHeight);
    
    //关闭翻页效果
    _scView.pagingEnabled = NO;
    //隐藏滚动条
    _scView.showsVerticalScrollIndicator = NO;
    _scView.backgroundColor = [ResourceManager viewBackgroundColor];
    [self.view addSubview:_scView];
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    [self layoutUI];
    [self dataOut];
}
-(void)clickNavButton:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//Return 键回收键盘
- (BOOL)textViewShouldReturn:(UITextField *)textView
{
    //  回收键盘,取消第一响应者
    [_synopsisTextView resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_emTextField resignFirstResponder];
    return YES;
}
//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [self.view endEditing:YES];
}
-(void)dataOut{
    NSString *headImgUrl=[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"userImage"]];
    //头像
    [_headImg sd_setImageWithURL:[NSURL URLWithString:headImgUrl] placeholderImage:[UIImage imageNamed:@"privatism-7"]];
    _headImg.layer.cornerRadius = 60/2;
    if ([[NSString alloc]initWithFormat:@"%@",[_dataDic objectForKey:@"realName"]].length > 0) {
        _nameTextField.text =[[NSString alloc]initWithFormat:@"%@",[_dataDic objectForKey:@"realName"]];
        //不可编辑
        [_nameTextField setEnabled:NO];
    }
    
    _emTextField.text = [_dataDic objectForKey:@"email"]?[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"email"]]:@"";
    if ([NSString stringWithFormat:@"%@%@%@",[_dataDic objectForKey:@"provice"],[_dataDic objectForKey:@"cityName"],[_dataDic objectForKey:@"cityArea"]].length > 0) {
       _cityLabel.text = [NSString stringWithFormat:@"%@%@%@",[_dataDic objectForKey:@"provice"],[_dataDic objectForKey:@"cityName"],[_dataDic objectForKey:@"cityArea"]];
        _pro = [_dataDic objectForKey:@"proName"];
        _city = [_dataDic objectForKey:@"cityName"];
        _area = [_dataDic objectForKey:@"cityArea"];
    }
    if ([NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"custDesc"]]) {
        _synopsisTextView.text = [_dataDic objectForKey:@"custDesc"];
    }
   
}
-(void)layoutUI{
    UIFont * font = [UIFont systemFontOfSize:14];
    UIColor * color_1 = UIColorFromRGB(0x333333);
    UIColor * color_2 = [ResourceManager color_6];
    UIView * view_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 70)];
    [_scView addSubview:view_1];
    view_1.backgroundColor = [UIColor whiteColor];
    UIView * viewX_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
    [view_1 addSubview:viewX_1];
    viewX_1.backgroundColor = [ResourceManager color_5];
    UIView * viewX_2 = [[UIView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, .5)];
    [view_1 addSubview:viewX_2];
    viewX_2.backgroundColor = [ResourceManager color_5];
    UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 70)];
    [view_1 addSubview:label_1];
    label_1.font = font;
    label_1.textColor = color_1;
    label_1.text = @"头像";
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 5, 60, 60)];
    [view_1 addSubview:_headImg];
    _headImg.image = [UIImage imageNamed:@"privatism-7"];
    _headImg.layer.cornerRadius = 60/2;
    // 没这句话倒不了角
    _headImg.layer.masksToBounds = YES;
    UIButton * upDataImg = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, 55)];
    [view_1 addSubview:upDataImg];
    [upDataImg addTarget:self action:@selector(upDataImg) forControlEvents:UIControlEventTouchUpInside];

    UIView * view_2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view_1.frame) + 15, SCREEN_WIDTH, 50 * 3)];
    [_scView addSubview:view_2];
    view_2.backgroundColor = [UIColor whiteColor];
    UIView * viewX_3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
    [view_2 addSubview:viewX_3];
    viewX_3.backgroundColor = [ResourceManager color_5];
    NSArray *titleArr = @[@"真实姓名",@"电子邮箱",@"所在城市"];
    for (int i = 0; i < 3; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0, 50 * (i + 1) - .5, SCREEN_WIDTH, .5)];
        [view_2 addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50 * i, 80, 50)];
        [view_2 addSubview:label];
        label.font = font;
        label.textColor = color_1;
        label.text = titleArr[i];
        if (i == 0) {
            _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 50 * i, SCREEN_WIDTH - 110, 50)];
            [view_2 addSubview:_nameTextField];
            _nameTextField.placeholder = @"请输入真实姓名";
            _nameTextField.textColor = color_2;
            _nameTextField.font = font;
            _nameTextField.delegate = self;
            _nameTextField.textAlignment = NSTextAlignmentRight;
            _nameTextField.keyboardType = UIKeyboardTypeDefault;
        }if (i == 1) {
            _emTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 50 * i, SCREEN_WIDTH - 110, 50)];
            [view_2 addSubview:_emTextField];
            _emTextField.placeholder = @"请输入电子邮箱";
            _emTextField.textColor = color_2;
            _emTextField.font = font;
            _emTextField.delegate = self;
            _emTextField.textAlignment = NSTextAlignmentRight;
            _emTextField.keyboardType = UIKeyboardTypeEmailAddress;
        }if (i == 2) {
            _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 50 * i, SCREEN_WIDTH - 110, 50)];
            [view_2 addSubview:_cityLabel];
            _cityLabel.textColor = color_2;
            _cityLabel.font = font;
            _cityLabel.text = @"未选择";
            _cityLabel.textAlignment = NSTextAlignmentRight;
            UIButton * cityBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50 * i, SCREEN_WIDTH, 50)];
            [view_2 addSubview:cityBtn];
            [cityBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    UILabel * synopsisLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(view_2.frame) + 10, 90, 20)];
    [_scView addSubview:synopsisLabel];
    synopsisLabel.font = font;
    synopsisLabel.textColor = color_1;
    synopsisLabel.text = @"个人简介";
    UIView * view_4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(synopsisLabel.frame) + 10, SCREEN_WIDTH, 90)];
    [_scView addSubview:view_4];
    view_4.backgroundColor = [UIColor whiteColor];
    UIView * viewX_5 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
    [view_4 addSubview:viewX_5];
    viewX_5.backgroundColor = [ResourceManager color_5];
    UIView * viewX_6 = [[UIView alloc]initWithFrame:CGRectMake(0, view_4.bounds.size.height - .5, SCREEN_WIDTH, .5)];
    [view_4 addSubview:viewX_6];
    viewX_6.backgroundColor = [ResourceManager color_5];
    
    _synopsisTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 90)];
    [view_4 addSubview:_synopsisTextView];
    _synopsisTextView.textColor = color_2;
    _synopsisTextView.font = font;
    _synopsisTextView.delegate = self;
    _synopsisTextView.text = @"请输入您的个人说明(50字以内)";
}
-(void)saveInfo{
    [self.view endEditing:YES];
    if (_nameTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"真实姓名不能为空" toView:self.view];
        return;
    }else if (_emTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"电子邮箱不能为空" toView:self.view];
        return;
    }else if (_cityLabel.text.length == 0 || [_cityLabel.text isEqualToString:@"未选择"]) {
        [MBProgressHUD showErrorWithStatus:@"公司名称不能为空" toView:self.view];
        return;
    }else if (_synopsisTextView.text.length == 0 || [_synopsisTextView.text isEqualToString:@"请输入您的个人简介(50字以内)"]) {
        [MBProgressHUD showErrorWithStatus:@"个人简介不能为空" toView:self.view];
        return;
    }
    [self saveUrl];
    
}
-(void)saveUrl
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_synopsisTextView.text.length > 0 && ![_synopsisTextView.text isEqualToString:@"请输入您的个人简介(50字以内)"]) {
        params[@"custDesc"]=_synopsisTextView.text;
    }
    if (_headImgStr.length > 0) {
        params[@"headImgUrl"]= _headImgStr;
    }
    params[@"realName"]=_nameTextField.text;
    params[@"email"]=_emTextField.text;
    params[@"provice"]= _pro;
    params[@"cityName"]= _city;
    params[@"cityArea"]= _area;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userGetModifyInfoAPI]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
    
}

//选择城市区域
-(void)selectCity{
    [self.view endEditing:YES];
    //选择城市区域
    SelectCityViewController *ctl = [[SelectCityViewController alloc] init];
    ctl.rootVC = self;
    //选择区域
    ctl.area = YES;
    ctl.block = ^(id city){
        NSDictionary * dic = city;
        _pro = [dic objectForKey:@"province"];
        _city = [dic objectForKey:@"areaName"];
        _area = [dic objectForKey:@"area"];
        _cityLabel.text = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"areaName"],[dic objectForKey:@"area"]];
    };
    [self.navigationController pushViewController:ctl animated:YES];
    
}

//上传头像
-(void)upDataImg{
    [self.view endEditing:YES];
    UIActionSheet *sheet =  [[UIActionSheet alloc] initWithTitle:@"选择"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照",@"从相册选择", nil];
    [sheet showInView:self.view];
}

#pragma mark === UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""] && textView.text.length > 50) {
        [MBProgressHUD showErrorWithStatus:@"不能超过50字" toView:self.view];
        return NO;
    }
    return YES;
}
//开始编辑时,键盘遮挡文本框，视图上移
//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    _scView.contentSize = CGSizeMake(10, 530 + 250);
//    return YES;
//}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == _synopsisTextView) {
        _scView.contentSize = CGSizeMake(10, 530 + 270);
        [_scView scrollRectToVisible:CGRectMake(0, _scView.contentSize.height - 270, 10, 530) animated:YES];
    }
    
}
//键盘落下事件
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (_synopsisTextView.text.length < 1) {
        _synopsisTextView.hidden = NO;
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (_synopsisTextView.text == nil || _synopsisTextView.text.length < 1) {
        _synopsisTextView.text = @"请输入您的个人简介(50字以内)";
    }
    _scView.contentSize = CGSizeMake(10, 530);
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
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
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
    params[@"fileType"] = @"mjbHead";
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"xdjlIOS%@",currentVersion];
    params[@"appVersion"] = versionStr;
    NSLog(@"self.imageData:%luK", (unsigned long)[self.imageData length]/1024);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestManager POST:[PDAPI getSendFileAPI] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //把图片添加到视图框内
        _headImg.image=[UIImage imageWithData:self.imageData];
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[(NSDictionary *)json objectForKey:@"state"] isEqualToString:@"SUCCESS"]) {
            [self handleData];
            _headImgStr = [(NSDictionary *)json objectForKey:@"fileId"];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
