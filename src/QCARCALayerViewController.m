//
//  QCARCALayerViewController.m
//  QCAR+CALayer
//
//  Created by Mec0825 on 14-9-28.
//  Copyright (c) 2014年 HiScene. All rights reserved.
//

#import "QCARCALayerViewController.h"

#import "CALayer+QCAR.h"
#import <MediaPlayer/MediaPlayer.h>

@interface QCARCALayerViewController ()

@end

@implementation QCARCALayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewArray = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Events
///////////////////////////////////////////////////////////////////////////////////////////////////

static dispatch_queue_t context_queue;

- (void)onCreate {
    
    _state = ON_CREATE;
    
    // Important !!!
    // Add one view, and you can receive touches
    self.viewForTouch = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.viewForTouch];
    
    // UIButton Example
    UIButton* testBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [testBtn setBackgroundColor:[UIColor blackColor]];
    [testBtn setTitle:@"Test" forState:UIControlStateNormal];
    [testBtn addTarget:self
                     action:@selector(btnPressed)
           forControlEvents:UIControlEventTouchUpInside];
    testBtn.layer.position = CGPointMake(self.view.frame.size.width/2.0,
                                         self.view.frame.size.height/2.0);

    [self.view.layer addSublayer:testBtn.layer];
    [self.viewArray addObject:testBtn];
    
    _state = ON_RENDERING;

    
    // UIWebView Example
//    UIWebView* testWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    testWeb.layer.position = CGPointMake(self.view.frame.size.width/2.0,
//                                         self.view.frame.size.height/2.0);
//    
//    NSString *urlString = @"http://www.baidu.com";
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    
//    [self.view.layer addSublayer:testWeb.layer];
//    [self.viewArray addObject:testWeb];
//    
//    _state = ON_RENDERING;
//
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         
//         if ([data length] > 0 && error == nil) {
//             [testWeb loadRequest:request];
//         }
//         else if (error != nil) {
//             NSLog(@"Error: %@", error);
//         }
//         
//     }];
    
    // MPMoviePlayerController
    // There is some bug
//    self.player = [[MPMoviePlayerController alloc] initWithContentURL:
//                   [NSURL URLWithString:@"http://video.hiscene.com/20130529_1369795513.mp4"]];
//    self.player.view.frame = CGRectMake(0, 0, 320, 300);
//    [self.view.layer addSublayer:self.player.view.layer];
//    self.view.center = CGPointMake(self.view.frame.size.width/2.0,
//                                   self.view.frame.size.height/2.0);
//    self.view.layer.zPosition = 0;
//    self.view.layer.position = CGPointMake(self.view.frame.size.width/2.0,
//                                           self.view.frame.size.height/2.0);
//
//    [self.viewArray addObject:self.player.view];
//    
//    [self.player play];
//    
//    _state = ON_RENDERING;

    
}

- (void)btnPressed {
    NSLog(@"Btn pressed\n");
}

- (void)onDestroy {
    _state = ON_DESTROY;
    
    NSLog(@"---%@", self.view.layer.sublayers);
    NSArray * layerArray = [NSArray arrayWithArray:self.view.layer.sublayers];
    for(const CALayer* layer in layerArray) {
        [layer removeFromSuperlayer];
    }
    [self.viewArray removeAllObjects];
    
    _state = ON_NORMAL;
}

- (void)onPause {
    
}

- (void)onResume {
    
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
    
    for(CALayer* layer in self.view.layer.sublayers) {
        if([layer respondsToSelector:@selector(setModelViewMatrix:andZPosition:)]) {
            [layer setModelViewMatrix:mtx andZPosition:_zPosition];
        }
    }
    
}

@end
