
#import "BJMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BJAnnotation.h"
#import "BJAnnotationView.h"

@interface BJMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableDictionary *annotations;
@end

@implementation BJMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMap];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self RequestForSearch:@"民俗村" andType:BJAnnotationTypeScenery andUserLocation:userLocation.coordinate];
        [self RequestForSearch:@"村" andType:BJAnnotationTypeScenery andUserLocation:userLocation.coordinate];
        [self RequestForSearch:@"乡村民宿" andType:BJAnnotationTypeLiving andUserLocation:userLocation.coordinate];
        [self RequestForSearch:@"乡村客栈" andType:BJAnnotationTypeLiving andUserLocation:userLocation.coordinate];
    });
   
}

-(void)RequestForSearch:(NSString *)searchString
            andType:(BJAnnotationType)annotationType
       andUserLocation:(CLLocationCoordinate2D)userLocation {
    NSLog(@"起点坐标:%f %f", userLocation.latitude, userLocation.longitude);

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
                NSString *subtitle = [self calculateDistanceFromCurrentLocationTo:coordinate];
                NSLog(@"符合条件的条目: %@", title);
                
                // 主线程更新 UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    BJAnnotation *annotation = [BJAnnotation AnnotationWithType:annotationType];
                    annotation.coordinate = coordinate;
                    annotation.title = title;
                    annotation.subtitle = [NSString stringWithFormat:@"距离：%@", subtitle];
                    [self.mapView addAnnotation:annotation];
                });
            }
        }
    }];
}

- (void)setupMap {
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.view addSubview:self.mapView];

}

#pragma mark - 计算路线

- (void)calculateRoutewithSelectedAnnotation:(CLLocationCoordinate2D)endCoordinate {
    [self.mapView removeOverlays:self.mapView.overlays];
    
    //起点
    CLLocationCoordinate2D startCoordinate = self.mapView.userLocation.location.coordinate;
    
    NSLog(@"起点坐标:%f %f",startCoordinate.latitude,startCoordinate.longitude);
    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:startCoordinate];
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithCoordinate:endCoordinate];
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
    MKMapItem *endItem   = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    
    // 创建路线规划请求
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
        // 关键：每次复用都重新设置图片
        BJAnnotation *customAnnotation = (BJAnnotation *)annotation;
        view.image = [UIImage imageNamed:customAnnotation.icon];
        return view;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [self calculateRoutewithSelectedAnnotation:view.annotation.coordinate];
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
