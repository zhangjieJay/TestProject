//
//  MapViewController.m
//  YJAutoProject
//
//  Created by 峥刘 on 17/4/11.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "MapViewController.h"
#import "BDMapView.h"

@interface MapViewController ()


@property(nonatomic,strong)BDMapView * mapView;//地图主视图

@end

@implementation MapViewController


-(BDMapView *)mapView{

    if (!_mapView) {
        _mapView = [[BDMapView alloc]initWithFrame:self.view.bounds];
        _mapView.backgroundColor = [UIColor grayColor];
    }
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.mapView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.mapView viewWillAppear];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{

    [self.mapView viewWillDisappear];
    [super viewWillDisappear:animated];
}

-(void)initMapViewWithLongitude:(NSString *)lon latitude:(NSString *)lat{

    
    






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
