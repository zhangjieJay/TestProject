//
//  BDMapView.m
//  YJAutoProject
//
//  Created by 峥刘 on 17/4/11.
//  Copyright © 2017年 JayZhang. All rights reserved.
//


#import "BDMapView.h"

#import <BaiduMapAPI_Map/BMKMapView.h>//地图视图
#import <BaiduMapAPI_Location/BMKLocationService.h>//定位文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Map/BMKPolygon.h>//多边形覆盖物
#import <BaiduMapAPI_Map/BMKCircle.h>//园
#import <BaiduMapAPI_Map/BMKArcline.h>//圆弧




static NSString * reuseIdentifier = @"Annotation_reuseIdentifier";

@interface BDMapView()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property(nonatomic,strong)BMKLocationService * localService;

@property(nonatomic,strong)BMKMapView * mapView;

@property(nonatomic,strong)BMKPointAnnotation * annotation;
@property(nonatomic,strong)BMKCircle * circle;
@property(nonatomic,strong)UIView * infoView;


@property(nonatomic,assign)CLLocationCoordinate2D userLocation;


@end
//104.050858,30.644178
@implementation BDMapView{


    CGRect hideRect;
    CGRect showRect;


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview: self.mapView];
        [self.localService startUserLocationService];
    }
    return self;
}

-(BMKMapView *)mapView{

    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:self.bounds];
        _mapView.delegate =self;
        _mapView.showsUserLocation = YES;//显示用户当前定位
        _mapView.zoomLevel = 17.5f;//初始化的缩放比例
        _mapView.rotateEnabled = NO; //设置是否可以旋转
        _mapView.showMapScaleBar = YES;//显示比例尺
        _mapView.showMapPoi = YES;
        _mapView.mapScaleBarPosition = CGPointMake(0, 200);
        _mapView.showIndoorMapPoi = YES;
    }

    return _mapView;
}

-(BMKLocationService *)localService{
    if (!_localService) {
        _localService = [[BMKLocationService alloc]init];
        _localService.delegate =self;
    }

    return _localService;
}

-(UIView *)infoView{

    if (!_infoView) {
        CGFloat height = 100.f;
        CGFloat y = CGRectGetHeight(self.mapView.frame);
        _infoView = [[UIView alloc]initWithFrame:CGRectMake(0, y, YJ_SCREEN_WIDTH, 0)];
        _infoView.backgroundColor = [UIColor redColor];
        hideRect = _infoView.frame;
        showRect = hideRect;
        showRect.size.height = height;
        showRect.origin.y = y - height;
        [self addSubview:_infoView];
    }
    return _infoView;
}



-(void)viewWillAppear{

    [self.mapView viewWillAppear];
}


-(void)viewWillDisappear{

    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    [self.localService stopUserLocationService];//停止定位
    self.localService.delegate = nil;//置空
}


#pragma mark ---------------BMKLocationServiceDelegate---------------
-(void)willStartLocatingUser{

}
-(void)didStopLocatingUser{

}
-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation{

}
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [self.mapView updateLocationData:userLocation];//刷新用户位置大头针
    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];//定位成功以后设置中心店
    self.userLocation = userLocation.location.coordinate;
    [self.localService stopUserLocationService];//定位成功以后停止定位


}

- (void)didFailToLocateUserWithError:(NSError *)error{//定位失败

}


#pragma mark ---------------BMKMapViewDelegate---------------
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{//完成加载地图
    self.mapView.compassPosition = CGPointMake(0, 300);
    [self.mapView setCompassImage:[UIImage imageNamed:@"pig.jpeg"]];
}
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status{

    if (status.fLevel >= 17.5f) {
        //定位后画圆
        if (self.circle) {
            [self.mapView removeOverlay:self.circle];
        }
        CLLocationDistance dis = 200.f;
        BMKCircle * circle = [BMKCircle circleWithCenterCoordinate:self.userLocation radius:dis];
        [self.mapView addOverlay:circle];
        self.circle = circle;
    }else{
        if (self.circle) {
            [self.mapView removeOverlay:self.circle];
        }
    }


}
//点击地图标注物时调用
-(void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi{
    
    if (self.annotation) {
        [self.mapView removeAnnotation:self.annotation ];
        self.annotation = nil;
    }
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = mapPoi.pt;
    annotation.title = mapPoi.text;
    self.annotation = annotation;
    [self.mapView addAnnotation:annotation];

}
//点击泡泡时调用
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{

    
    [self showInfoViewWithAnnotationView:view];

}

-(void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{

    if (self.annotation) {
        [self.mapView removeAnnotation:self.annotation];
        self.annotation = nil;
    }
    

//    // 添加多边形覆盖物
//    CLLocationCoordinate2D coords[3] = {0};
//    coords[0].latitude = 30.604178;
//    coords[0].longitude = 104.020858;
//    coords[1].latitude = 30.634178;
//    coords[1].longitude = 104.040858;
//    coords[2].latitude = 30.664178;
//    coords[2].longitude = 104.040858;
//    
//    BMKPolygon* polygon = [BMKPolygon polygonWithCoordinates:coords count:3];
//    [self.mapView addOverlay:polygon];
//    
    

    
    

}

//泡泡出现时调用
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
        newAnnotationView.canShowCallout = YES;
        newAnnotationView.image = [UIImage imageNamed:@"NB_Location"];
        newAnnotationView.draggable = YES;
        return newAnnotationView;
    }
    return nil;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolygon class]]){
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        polygonView.lineWidth = 1.f;
        
        return polygonView;
    }else if ([overlay isKindOfClass:[BMKCircle class]]){
    
        BMKCircleView * circleView = [[BMKCircleView alloc] initWithCircle:overlay];
        circleView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        circleView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
        circleView.lineWidth = 0.5f;
        return circleView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{


}
- (void)mapView:(BMKMapView *)mapView onClickedBMKOverlayView:(BMKOverlayView *)overlayView{



}

-(void)showInfoViewWithAnnotationView:(BMKAnnotationView *)annotationView{

    
    [UIView animateWithDuration:.5f animations:^{
        self.infoView.frame = showRect;
    }];

}


@end
