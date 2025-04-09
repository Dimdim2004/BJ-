
#import "BJMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BJAnnotation.h"
#import "BJAnnotationView.h"
#import "BJDisplayView.h"
#import "BJNetworkingManger.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage.h>
#import "BJDisplayModel.h"
#import "BJCountryModel.h"
#import "BJMyHometownViewController.h"
#import "BJNotFoundViewController.h"

const static NSString *mapAPK = @"dhK73tBBx4BWr97HK8JnKocfz53ctjps";

@interface BJMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableDictionary *annotations;
@property (nonatomic, strong) BJDisplayView *displayView;
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, strong)NSMutableDictionary *anotationCache;
@property (nonatomic, strong)CLGeocoder *geocoder;
@property (nonatomic, strong)BJAnnotation *currentAnnotation;
@property (nonatomic, copy)NSString *locationName;
@end

@implementation BJMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoaded = NO;
    self.anotationCache = [NSMutableDictionary dictionary];
    self.geocoder = [[CLGeocoder alloc] init];
    [self setupMap];

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if(!self.isLoaded){
        [self RequestForSearch:@"民俗村" andType:BJAnnotationTypeScenery andUserLocation:userLocation.coordinate];
        [self RequestForSearch:@"村" andType:BJAnnotationTypeScenery andUserLocation:userLocation.coordinate];
        [self RequestForSearch:@"乡村民宿" andType:BJAnnotationTypeLiving andUserLocation:userLocation.coordinate];
        [self RequestForSearch:@"乡村客栈" andType:BJAnnotationTypeLiving andUserLocation:userLocation.coordinate];
        self.isLoaded = YES;
    }
}

- (NSString *)cacheKeyForCoordinate:(CLLocationCoordinate2D)coordinate {
    return [NSString stringWithFormat:@"%.6f|%.6f", coordinate.latitude, coordinate.longitude];
}



-(void)RequestForSearch:(NSString *)searchString
            andType:(BJAnnotationType)annotationType
       andUserLocation:(CLLocationCoordinate2D)userLocation {

    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchString;
    request.region = MKCoordinateRegionMakeWithDistance(userLocation, 60, 60);
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (error) {
            NSLog(@"搜索错误: %@", error.localizedDescription);
            return;
        }
        
        for (MKMapItem *mapItem in response.mapItems) {
            NSString *name = mapItem.name;
            BOOL hasTown = [name rangeOfString:@"村"].location != NSNotFound;
            BOOL noResidentCommittee = [name rangeOfString:@"委会"].location == NSNotFound;
            if ((hasTown && noResidentCommittee) || annotationType == BJAnnotationTypeLiving) {
                CLLocationCoordinate2D coordinate = mapItem.placemark.coordinate;
                NSString *title = name;
                dispatch_async(dispatch_get_main_queue(), ^{
                    BJAnnotation *annotation = [BJAnnotation AnnotationWithType:annotationType];
                    annotation.coordinate = coordinate;
                    annotation.title = title;
                    [self.mapView addAnnotation:annotation];
                });
            }
        }
    }];
}

- (void)setupMap {
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeMutedStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.view addSubview:self.mapView];

    
    self.displayView = [[BJDisplayView alloc] init];
    self.displayView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 175, [UIScreen mainScreen].bounds.size.width * 0.9, 125);
    self.displayView.backgroundColor = [UIColor whiteColor];
    self.displayView.layer.cornerRadius = 15;
    [self.view addSubview:self.displayView];
    
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterDisplayView)];
    [self.displayView addGestureRecognizer:tapGesture];
}

-(void)enterDisplayView {
    [[BJNetworkingManger sharedManger] findTargetCountryWithLatitude:self.currentAnnotation.coordinate.latitude andLongitude:self.currentAnnotation.coordinate.longitude WithSuccess:^(BJCountryModel * _Nonnull countryModel) {
        if (!countryModel) {
            BJNotFoundViewController *notFoundVC = [[BJNotFoundViewController alloc] init];
            countryModel = [[BJCountryModel alloc] init];
            countryModel.name = self.currentAnnotation.title;
            countryModel.longitude = self.currentAnnotation.coordinate.longitude;
            countryModel.latitude = self.currentAnnotation.coordinate.latitude;
            countryModel.location = self.locationName;
            notFoundVC.model = countryModel;

            [self.navigationController pushViewController:notFoundVC animated:YES];
        } else {
            BJMyHometownViewController *hometownVC = [[BJMyHometownViewController alloc] init];
            countryModel.location = self.locationName;
            hometownVC.countryModel = countryModel;
            
            self.navigationController.tabBarController.tabBar.hidden = YES;
            [self.navigationController pushViewController:hometownVC animated:YES];
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"获取地址失败: %@", error.localizedDescription);
    }];
    
    
    
    
}

#pragma mark - 计算路线

-(void)calculateRoutewithSelectedAnnotation:(CLLocationCoordinate2D)endCoordinate {
    [self.mapView removeOverlays:self.mapView.overlays];
    
    CLLocationCoordinate2D startCoordinate = self.mapView.userLocation.location.coordinate;
    
    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:startCoordinate];
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithCoordinate:endCoordinate];
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
    MKMapItem *endItem   = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = startItem;
    request.destination = endItem;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"路线规划错误: %@", error.localizedDescription);
            return;
        }
        if (response.routes.count == 0) {
            NSLog(@"未返回任何路线");
            return;
        }
        
        MKRoute *route = response.routes.firstObject;

        [self.mapView addOverlay:route.polyline];
        [self.mapView setVisibleMapRect:route.polyline.boundingMapRect edgePadding:UIEdgeInsetsMake(40, 40, 40, 40) animated:YES];
    }];
}

#pragma mark - MKMapViewDelegate

// 绘制路线的样式
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
        renderer.strokeColor = [UIColor systemGreenColor];
        renderer.lineWidth = 4.0;
        return renderer;
    }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BJAnnotation class]]) {
        static NSString *reuseID = @"CustomAnnotation";
        MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
        if (!view) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
            view.canShowCallout = YES;
        }
        BJAnnotation *customAnnotation = (BJAnnotation *)annotation;
        view.image = [UIImage imageNamed:customAnnotation.icon];
        return view;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    BJAnnotation *annotation = (BJAnnotation *)view.annotation;
    NSString *cacheKey = [self cacheKeyForCoordinate:annotation.coordinate];
    if (self.anotationCache[cacheKey]) {
        [self updateDisplayViewWithCache:self.anotationCache[cacheKey]];
    } else {
        [self loadDataForAnnotation:annotation cacheKey:cacheKey];
    }
    [self calculateRoutewithSelectedAnnotation:view.annotation.coordinate];
    
    CGRect finalFrame = self.displayView.frame;
    finalFrame.origin.x = [UIScreen mainScreen].bounds.size.width * 0.05;

    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.displayView.frame = finalFrame;
    } completion:nil];

}

- (void)updateDisplayViewWithCache:(BJDisplayModel *)cache {
    [self.displayView updateWithModel:cache];
}

- (void)loadDataForAnnotation:(BJAnnotation *)annotation cacheKey:(NSString *)cacheKey {
    CLLocationCoordinate2D coordinate = annotation.coordinate;
    NSString *distance = [NSString stringWithFormat:@"距离：%@", [self calculateDistanceFromCurrentLocationTo:coordinate]];
    NSString *urlString = [NSString stringWithFormat:@"https://api.map.baidu.com/panorama/v2?width=512&height=256&location=%.6f,%.6f&fov=150&ak=dhK73tBBx4BWr97HK8JnKocfz53ctjps",coordinate.longitude, coordinate.latitude];
    NSLog(@"%@",annotation.title);
    NSString *name = annotation.title;
    
    BJDisplayModel *model = [[BJDisplayModel alloc] initWithName:[name copy] distance:[distance copy] imageUrl:[urlString copy]];
    self.currentAnnotation = annotation;
    self.anotationCache[cacheKey] = model;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [model loadImageWithCompletion:^(UIImage * _Nullable image) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    
    [[BJNetworkingManger sharedManger] loadWithLatitude:coordinate.latitude andLongitude:coordinate.longitude WithSuccess:^(NSString * _Nonnull addressString) {
        model.address = addressString;
        self.locationName = addressString;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.displayView updateWithModel:model];
            NSLog(@"获取地址成功: %@", addressString);
        });
        dispatch_group_leave(group);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"获取地址失败: %@", error.localizedDescription);
        dispatch_group_leave(group);
    }];
    
    dispatch_notify(group, dispatch_get_main_queue(), ^{
        [self.displayView updateWithModel:model];
    });
}
// 距离计算
-(NSString *) calculateDistanceFromCurrentLocationTo:(CLLocationCoordinate2D)coordinate {
    if (!CLLocationCoordinate2DIsValid(coordinate)) {
        return @"-- km";
    }
    if (!self.mapView.userLocation || !self.mapView.userLocation.location) {
        return @"定位不可用";
    }
    CLLocation *target = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLLocationDistance distance = [self.mapView.userLocation.location distanceFromLocation:target];
    return [NSString stringWithFormat:@"%.2f km", distance/1000.0];
}

- (void)safeAccessUserCoordinateWithCompletion:(void (^)(CLLocationCoordinate2D coordinate, BOOL success))completion {
    
    if (self.mapView.userLocationVisible) {
        completion(self.mapView.userLocation.coordinate, YES);
    } else {
        NSLog(@"定位不可用");
        completion(kCLLocationCoordinate2DInvalid, NO);
    }
}


@end
