//
//  QCARViewController.m
//  QCAR+CALayer+UIWebView
//
//  Created by Mec0825 on 14-11-10.
//  Copyright (c) 2014年 HiScene. All rights reserved.
//

#import "QCARViewController.h"

@interface QCARViewController ()

@end

@implementation QCARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - Events
///////////////////////////////////////////////////////////////////////////////////////////////////

static dispatch_queue_t context_queue;

- (void)onCreate {
    // overload
}

- (void)btnPressed {
    // overload
}

- (void)onDestroy {
    // overload
}

- (void)onPause {
    // overload
}

- (void)onResume {
    // overload
}

- (QCARCALayerState)getState {
    //NSLog(@"---<%d\n", _state);
    return _state;
}

#pragma mark - Functions
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setProjectionMatrix:(float *)mtx {
    
    float viewWidth  = self.view.frame.size.width;
    float viewHeight = self.view.frame.size.height;
    
    float layerWidth = self.view.layer.frame.size.width;
    
    // QCAR frame size 480x640
    float QCARFrameWidth  = 480;
    float QCARFrameHeight = 640;
    
    // Calculation of -1/D
    // Reference: http://milen.me/technical/core-animation-3d-model/
    float layerViewPortWidth = viewWidth * QCARFrameHeight / viewHeight;
    _zPosition = layerWidth * QCARFrameWidth * mtx[5] / layerViewPortWidth / 2;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/_zPosition;
    self.view.layer.sublayerTransform = transform;
    
    _state = ON_NORMAL;
    
}

- (void)updateModelViewMatrixOfSubviews:(float *)mtx {
    
}



@end
