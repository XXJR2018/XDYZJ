//
//  GaoDeMapViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/11/30.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "GaoDeMapViewController.h"


@interface GaoDeMapViewController ()
{
    NSString *_address;
    NSString *_longitude;
    NSString *_latitude;
    BOOL isFistrSetLocal;
}
@property (nonatomic, strong) MAMapView            *mapView;
@property (nonatomic, strong) AMapSearchAPI        *search;

//@property (nonatomic, strong) PlaceAroundTableView *tableview;
@property (nonatomic, strong) UIImageView          *redWaterView;
@property (nonatomic, assign) BOOL                  isMapViewRegionChangedFromTableView;

@property (nonatomic, assign) BOOL                  isLocated;

@property (nonatomic, strong) UIButton             *locationBtn;
@property (nonatomic, strong) UIImage              *imageLocated;
@property (nonatomic, strong) UIImage              *imageNotLocate;

@property (nonatomic, assign) NSInteger             searchPage;

@property (nonatomic, strong) UISegmentedControl    *searchTypeSegment;
@property (nonatomic, copy) NSString               *currentType;
@property (nonatomic, copy) NSArray                *searchTypes;

@property (nonatomic, strong) UILabel              *adressLabel;

@end

@implementation GaoDeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isFistrSetLocal = YES;
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"地图位置"];
    
    float fRightBtnTopY =  NavHeight - 37;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 40;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f,fRightBtnTopY,60.f, 35.0f)];
    [rightNavBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[ResourceManager navgationTitleColor] forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [ResourceManager font_7];
    [nav addSubview:rightNavBtn];
    
    
    
    [AMapServices sharedServices].apiKey = kGDAPIKey;
    //    [self initTableview];
    [self initSearch];
    [self initMapView];
    [self initRedWaterView];
    //    [self initLocationButton];
    //    [self initSearchTypeView];
    _address = [NSString stringWithFormat:@"%@%@",self.cityStr,self.addressStr];
    _adressLabel.text = _address;
}
//保存
-(void)save{
    
    NSArray * arr = @[_longitude,_latitude,_address];
    if (arr && arr.count == 3) {
        self.cityBlock(arr);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showErrorWithStatus:@"出错" toView:self.view];
        return;
    }
}

#pragma mark - Initialization
- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, NavHeight, CGRectGetWidth(self.view.bounds), self.view.bounds.size.height - NavHeight)];
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    //self.mapView.showsIndoorMap = NO;
    //self.mapView.rotateCameraEnabled = NO;
    self.mapView.zoomLevel = 17;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    self.mapView.showsUserLocation = NO;    //YES 为打开定位，NO为关闭定位
    self.isLocated = NO;
}

- (void)initSearch
{
    self.searchPage = 1;
    self.search = [[AMapSearchAPI alloc] init];
   
    self.search.delegate = self;
    AMapGeocodeSearchRequest *searchRequest = [[AMapGeocodeSearchRequest alloc] init];
    searchRequest.address = [NSString stringWithFormat:@"%@%@",self.cityStr,self.addressStr];
//    searchRequest.city = self.cityStr;
    //发起正向地理编码
    [self.search AMapGeocodeSearch: searchRequest];
}

//- (void)initTableview
//{
//    self.tableview = [[PlaceAroundTableView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/3 * 2 + 50, CGRectGetWidth(self.view.bounds), self.view.bounds.size.height/3 - 50)];
//    self.tableview.delegate = self;
//
//    [self.view addSubview:self.tableview];
//}

- (void)initRedWaterView
{
    UIImage *image = [UIImage imageNamed:@"privatism-47"];
    self.redWaterView = [[UIImageView alloc] initWithImage:image];
    
    self.redWaterView.frame = CGRectMake(self.view.bounds.size.width/2-image.size.width/2, self.mapView.bounds.size.height/2-image.size.height, image.size.width, image.size.height);
    
    self.redWaterView.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(self.mapView.bounds) / 2 - CGRectGetHeight(self.redWaterView.bounds) / 2);
    
    [self.mapView addSubview:self.redWaterView];
    
    _adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(_redWaterView.frame) - 40, self.view.bounds.size.width, 40)];
    [self.mapView addSubview:_adressLabel];
    
    _adressLabel.font = [UIFont systemFontOfSize:14];
    _adressLabel.numberOfLines = 0;
    _adressLabel.textAlignment = NSTextAlignmentCenter;
    
}

//- (void)initLocationButton
//{
//    self.imageLocated = [UIImage imageNamed:@"gpssearchbutton"];
//    self.imageNotLocate = [UIImage imageNamed:@"gpsnormal"];
//
//    self.locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.mapView.bounds) - 40, CGRectGetHeight(self.mapView.bounds) - 50, 32, 32)];
//    self.locationBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    self.locationBtn.backgroundColor = [UIColor whiteColor];
//
//    self.locationBtn.layer.cornerRadius = 3;
//    [self.locationBtn addTarget:self action:@selector(actionLocation) forControlEvents:UIControlEventTouchUpInside];
//    [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];
//
//    [self.view addSubview:self.locationBtn];
//}
//
//- (void)initSearchTypeView
//{
//    self.searchTypes = @[@"住宅", @"学校", @"楼宇", @"商场"];
//
//    self.currentType = self.searchTypes.firstObject;
//
//    self.searchTypeSegment = [[UISegmentedControl alloc] initWithItems:self.searchTypes];
//    self.searchTypeSegment.frame = CGRectMake(10, CGRectGetHeight(self.mapView.bounds) - 50, CGRectGetWidth(self.mapView.bounds) - 80, 32);
//    self.searchTypeSegment.layer.cornerRadius = 3;
//    self.searchTypeSegment.backgroundColor = [UIColor whiteColor];
//    self.searchTypeSegment.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    self.searchTypeSegment.selectedSegmentIndex = 0;
//    [self.searchTypeSegment addTarget:self action:@selector(actionTypeChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:self.searchTypeSegment];
//
//}

#pragma mark -- 正向地理编码 (根据地名定位当前位置)
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {

       
        //移动地图动态获取位置
        if (response.regeocode.formattedAddress.length > 0) {
            
            if (isFistrSetLocal)
             {
                isFistrSetLocal = NO;
                _address = response.regeocode.formattedAddress;
             }
            else
             {
                _adressLabel.text = response.regeocode.formattedAddress;
                _address = response.regeocode.formattedAddress;
             }
            
        }
       
        
    }
}
//地址转经纬度
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0) {
        [MBProgressHUD showErrorWithStatus:@"没有找到该位置" toView:self.view];
        _adressLabel.hidden = YES;
        return;
    }
    NSArray *locationInfo = response.geocodes; // 用户位置信息
    AMapGeocode *geocode = locationInfo.firstObject;
    AMapGeoPoint *geoPoint = geocode.location;
    CLLocationCoordinate2D Coordinate2D = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude); // 根据地址获取的经纬度
    [self.mapView setCenterCoordinate:Coordinate2D animated:YES];// 在地图上设置出该位置
    
    //初始位置经纬度
    _latitude = [NSString stringWithFormat:@"%f",geoPoint.latitude];
    _longitude = [NSString stringWithFormat:@"%f",geoPoint.longitude];
    
    
    //以该经纬度为中心加载到地图
    self.isMapViewRegionChangedFromTableView = YES;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    [self.mapView setCenterCoordinate:location animated:YES];
    
}

#pragma mark - Utility

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate:(CLLocationCoordinate2D )coord
{
    AMapPOIAroundSearchRequest*request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:coord.latitude  longitude:coord.longitude];
    request.radius   = 1000;
    request.types = self.currentType;
    request.sortrule = 0;
    request.page     = self.searchPage;
    
    [self.search AMapPOIAroundSearch:request];
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    //移动地图动态获取位置经纬度
    _latitude = [NSString stringWithFormat:@"%f",regeo.location.latitude];
    _longitude = [NSString stringWithFormat:@"%f",regeo.location.longitude];
    
    [self.search AMapReGoecodeSearch:regeo];
}

#pragma mark - MapViewDelegate

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!self.isMapViewRegionChangedFromTableView && self.mapView.userTrackingMode == MAUserTrackingModeNone)
    {
        [self actionSearchAround];
    }
    self.isMapViewRegionChangedFromTableView = NO;
}

#pragma mark - TableViewDelegate

- (void)didTableViewSelectedChanged:(AMapPOI *)selectedPoi
{
    // 防止连续点两次
    if(self.isMapViewRegionChangedFromTableView == YES)
    {
        return;
    }
    
    
    self.isMapViewRegionChangedFromTableView = YES;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(selectedPoi.location.latitude, selectedPoi.location.longitude);
    
    [self.mapView setCenterCoordinate:location animated:YES];
}

- (void)didPositionCellTapped
{
    // 防止连续点两次
    if(self.isMapViewRegionChangedFromTableView == YES)
    {
        return;
    }
    
    self.isMapViewRegionChangedFromTableView = YES;
    
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (void)didLoadMorePOIButtonTapped
{
    self.searchPage++;
    [self searchPoiByCenterCoordinate:self.mapView.centerCoordinate];
}

#pragma mark - userLocation

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(!updatingLocation)
        return ;
    
    if (userLocation.location.horizontalAccuracy < 0)
    {
        return ;
    }
    
    // only the first locate used.
    if (!self.isLocated)
    {
        self.isLocated = YES;
        
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        
        [self actionSearchAround];
        
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
}

- (void)mapView:(MAMapView *)mapView  didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    if (mode == MAUserTrackingModeNone)
    {
        [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];
    }
    else
    {
        [self.locationBtn setImage:self.imageLocated forState:UIControlStateNormal];
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}

#pragma mark - Handle Action

- (void)actionSearchAround
{
    [self searchReGeocodeWithCoordinate:self.mapView.centerCoordinate];
    [self searchPoiByCenterCoordinate:self.mapView.centerCoordinate];
    
    self.searchPage = 1;
    [self redWaterAnimimate];
}

- (void)actionLocation
{
    if (self.mapView.userTrackingMode == MAUserTrackingModeFollow)
    {
        [self.mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
    }
    else
    {
        self.searchPage = 1;
        
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // 因为下面这句的动画有bug，所以要延迟0.5s执行，动画由上一句产生
            [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        });
    }
}

- (void)actionTypeChanged:(UISegmentedControl *)sender
{
    self.currentType = self.searchTypes[sender.selectedSegmentIndex];
    [self actionSearchAround];
}


/* 移动窗口弹一下的动画 */
- (void)redWaterAnimimate
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint center = self.redWaterView.center;
                         center.y -= 20;
                         [self.redWaterView setCenter:center];}
                     completion:nil];
    
    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGPoint center = self.redWaterView.center;
                         center.y += 20;
                         [self.redWaterView setCenter:center];}
                     completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
