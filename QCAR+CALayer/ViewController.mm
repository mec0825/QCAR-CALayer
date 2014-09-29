//
//  ViewController.m
//  QCAR+CALayer
//
//  Created by Mec0825 on 14-9-28.
//  Copyright (c) 2014年 HiScene. All rights reserved.
//

#import "ViewController.h"

#import "EAGLView.h"
#import "QCARutils.h"
#import "QCARCALayerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect bounds  = [[UIScreen mainScreen] bounds];
    CGRect newBounds = CGRectMake(0,0,bounds.size.height,bounds.size.width);
    
    self.eaglView = [[EAGLView alloc] initWithFrame:newBounds];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI_2);
    
    self.eaglView.layer.position = CGPointMake(bounds.size.width /2.0,
                                               bounds.size.height/2.0);
    self.eaglView.transform = rotate;
    
    QCARutils* qUtils = [QCARutils getInstance];
    
    [qUtils addTargetName:@"Stones & Chips"
                   atPath:@"StonesAndChips.xml"];

    [qUtils createARofSize:self.view.frame.size
               forDelegate:self];
    
    [self.view addSubview:self.eaglView];
    
    self.QCARCAlayerCtl = [[QCARCALayerViewController alloc] init];
    self.QCARCAlayerCtl.view.frame = self.eaglView.frame;
    
    [self.view addSubview:self.QCARCAlayerCtl.view];
    
    self.eaglView.QCARCAlayerCtl = self.QCARCAlayerCtl;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QCAR Delegates

- (void)cameraDidStart {
    
    QCARutils* qUtils = [QCARutils getInstance];
    [self.QCARCAlayerCtl setProjectionMatrix:qUtils.projectionMatrix.data];
    
}

- (void)btnPressed {
    NSLog(@"Button pressed");
}

- (void)cameraDidStop {
    
}

@end
