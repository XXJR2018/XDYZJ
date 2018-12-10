//
//  MapLocationViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/8/5.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "MapLocationViewController.h"

@interface MapLocationViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
//    UITextField * _txtQueryKey;
    MKMapView  * _mapView;
    NSString * _disCityStr;
    //    CLLocationManager *_locationManager;
    NSString * _address;
    NSString * _longitude;
    NSString * _latitude;
}
@end

@implementation MapLocationViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"工作地点"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"工作地点"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"工作地点"];
    
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f,fRightBtnTopY,60.f, 35.0f)];
    [rightNavBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [ResourceManager font_7];
    [nav addSubview:rightNavBtn];
//    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, NavHeight, SCREEN_WIDTH - 20, 60)];
//    [self.view addSubview:cityLabel];
//    cityLabel.font = [UIFont systemFontOfSize:13];
//    cityLabel.textColor = [ResourceManager color_6];
//    cityLabel.numberOfLines = 0;
//    cityLabel.text = [NSString stringWithFormat:@"所在城市：%@ \n示例：输入**公司，则会默认搜索所在城市+**公司的具体位置 ",self.cityStr];
//    
//    _txtQueryKey = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(cityLabel.frame) + 5, SCREEN_WIDTH - 20, 40)];
//    _txtQueryKey.layer.cornerRadius = 5;
//    _txtQueryKey.layer.borderWidth = .5;
//    _txtQueryKey.backgroundColor = [UIColor whiteColor];
//    _txtQueryKey.layer.borderColor = [ResourceManager color_5].CGColor;
//    [self.view addSubview:_txtQueryKey];
//    _txtQueryKey.placeholder = @" 请输入输入县(区)级以下详细地址";
//    _txtQueryKey.font = [UIFont systemFontOfSize:14];
//    
//    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, CGRectGetMaxY(cityLabel.frame) + 7, 35, 35)];
//    [self.view addSubview:btn];
//    [btn setImage:[UIImage imageNamed:@"privatism-22"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(geocodeQuery) forControlEvents:UIControlEventTouchUpInside];
    
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:_mapView];
    _mapView.backgroundColor = [UIColor whiteColor];
    // 标注地图类型
    _mapView.mapType = MKMapTypeStandard ;
    //用于将当前视图控制器赋值给地图视图的delegate属性
    _mapView.delegate = self;
    
    [self geocodeQuery];
    
    //    //定位管理器
    //    _locationManager=[[CLLocationManager alloc]init];
    //    _locationManager.delegate = self;
    //    //判断是否已经打开定位
    //    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
    //        [MBProgressHUD showErrorWithStatus:@"请在设置中允许小小金融使用定位功能" toView:self.view];
    //        return;
    //    }
    //    else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
    //        //设置代理
    //        _locationManager.delegate=self;
    //        //设置定位精度
    //        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //        //定位频率,每隔多少米定位一次
    //        CLLocationDistance distance=10.0;//十米定位一次
    //        _locationManager.distanceFilter=distance;
    //        //启动跟踪定位
    //        [_locationManager startUpdatingLocation];
    //    }
    
}

- (void)geocodeQuery {
    
    _disCityStr = [NSString stringWithFormat:@"%@%@",self.cityStr,self.addressStr];
    
    CLGeocoder *geocode = [[CLGeocoder alloc] init];
    
    [geocode geocodeAddressString:_disCityStr completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"查询记录数: %lu",(unsigned long)[placemarks count]);
        
        if ([placemarks count ] > 0) {
            //移除目前地图上得所有标注点
            [_mapView removeAnnotations:_mapView.annotations];
            
        }else{
            [MBProgressHUD showErrorWithStatus:@"没有查到该地点" toView:self.view];
            return ;
        }
        for (int i = 0; i< [placemarks count]; i++) {
            CLPlacemark * placemark = placemarks[i];
            //关闭键盘
//            [_txtQueryKey resignFirstResponder];
            //调整地图位置和缩放比例,第一个参数是目标区域的中心点，第二个参数：目标区域南北的跨度，第三个参数：目标区域的东西跨度，单位都是米
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 1000, 1000);
            //重新设置地图视图的显示区域
            [_mapView setRegion:viewRegion animated:YES];
            // 实例化 MapLocation 对象
            MapLocation * annotation = [[MapLocation alloc] init];
            annotation.streetAddress = placemark.thoroughfare ;
            annotation.city = placemark.locality;
            annotation.state = placemark.administrativeArea ;
            annotation.zip = placemark.postalCode;
            annotation.coordinate = placemark.location.coordinate;
            if (i == 0) {
                _address = [NSString stringWithFormat:@"%@%@%@",annotation.state,annotation.city,annotation.streetAddress];
                _longitude = [NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
                _latitude = [NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
            }

            //把标注点MapLocation 对象添加到地图视图上，一旦该方法被调用，地图视图委托方法mapView：ViewForAnnotation:就会被回调
            [_mapView addAnnotation:annotation];
        }
    }];
    
}

#pragma mark mapView Delegate 地图 添加标注时 回调
- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
    // 获得地图标注对象
    MKPinAnnotationView * annotationView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PIN_ANNOTATION"];
    }
    // 设置大头针标注视图为紫色
    annotationView.pinColor = MKPinAnnotationColorPurple ;
    // 标注地图时 是否以动画的效果形式显示在地图上
    annotationView.animatesDrop = YES ;
    // 用于标注点上的一些附加信息
    annotationView.canShowCallout = YES ;
    
    return annotationView;
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)theMapView withError:(NSError *)error {
    NSLog(@"error : %@",[error description]);
}
//保存
-(void)save{
   
    NSArray * arr = @[_longitude,_latitude,_disCityStr];
    if (arr && arr.count == 3) {
        self.cityBlock(arr);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showErrorWithStatus:@"出错" toView:self.view];
        return;
    }
}

@end
