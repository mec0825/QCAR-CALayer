//
//  QCARWebViewController.m
//  QCAR+CALayer+UIWebView
//
//  Created by Mec0825 on 14-11-10.
//  Copyright (c) 2014年 HiScene. All rights reserved.
//

#import "QCARWebViewController.h"
#import "ShaderUtils.h"

@interface QCARWebViewController ()

@end

@implementation QCARWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    [self.view addSubview:self.webView];
    
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
    
    _state = ON_CREATE;
    
    [self.webView loadHTMLString:@"<html><body><div style=\"width: 200px;height: 200px;background-color: blue;position:absolute;left:0; right:0;top:0; bottom:0;margin:auto;max-width:100%;max-height:100%;overflow:auto;\"><h3>This is a test</h3></div></body></html>" baseURL:nil];
    
    _state = ON_RENDERING;
    
    
}

- (void)btnPressed {
    NSLog(@"Btn pressed\n");
}

- (void)onDestroy {
    _state = ON_DESTROY;
    
    [self.webView loadHTMLString:@"" baseURL:nil];
    
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
    
    // Do not need super view to transform
//    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = -1.0/_zPosition;
//    
//    self.view.layer.sublayerTransform = transform;
    
    NSLog(@"--- zPosition: %lf\n", _zPosition);
    _state = ON_NORMAL;
    
}

- (void)updateModelViewMatrixOfSubviews:(float *)mtx {
    
//    for(int i = 0; i < 16; i++) {
//        printf("%lf ", mtx[i]);
//    }
//    printf("\n");
    
    [self.webView stringByEvaluatingJavaScriptFromString:
     @"var tagHead = document.documentElement.firstChild;"
      "var tagStyle = document.getElementById(\"updateStyle\");"
      "tagHead.removeChild(tagStyle);"
     ];
    [self.webView stringByEvaluatingJavaScriptFromString:
     [NSString stringWithFormat:
     @"var tagHead = document.documentElement.firstChild;"
      "var tagStyle = document.createElement(\"style\");"
      "tagStyle.setAttribute(\"type\", \"text/css\");"
      "tagStyle.setAttribute(\"id\", \"updateStyle\");"
      "tagStyle.appendChild(document.createTextNode(""\"body{"
      "perspective:%lf;"
      "-webkit-perspective:%lf;"
      "} div{"
      "transform:matrix3d(%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf);"
      "-webkit-transform:matrix3d(%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf);"
     "}\"));"
     "var tagHeadAdd = tagHead.appendChild(tagStyle);",
      -_zPosition,-_zPosition,
      mtx[0],mtx[1],mtx[2],mtx[3],
      mtx[4],mtx[5],mtx[6],mtx[7],
      mtx[8],mtx[9],mtx[10],mtx[11],
      mtx[12],mtx[13],mtx[14]-_zPosition,mtx[15],
      mtx[0],mtx[1],mtx[2],mtx[3],
      mtx[4],mtx[5],mtx[6],mtx[7],
      mtx[8],mtx[9],mtx[10],mtx[11],
      mtx[12],mtx[13],mtx[14]-_zPosition,mtx[15]
      ]];
    
}

@end
