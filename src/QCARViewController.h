//
//  QCARViewController.h
//  QCAR+CALayer+UIWebView
//
//  Created by Mec0825 on 14-11-10.
//  Copyright (c) 2014年 HiScene. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ON_NORMAL,
    ON_CREATE,
    ON_RENDERING,
    ON_DESTROY
} QCARCALayerState;

@interface QCARViewController : UIViewController {
    float _zPosition;
    QCARCALayerState _state;
}

// Information of target
@property (nonatomic, strong) NSString* targetName;
@property (nonatomic, assign) float targetWidth;
@property (nonatomic, assign) float targetHeight;

- (void)onCreate;
- (void)onDestroy;
- (void)onPause;
- (void)onResume;

- (QCARCALayerState)getState;

- (void)setProjectionMatrix:(float*)mtx;
- (void)updateModelViewMatrixOfSubviews:(float*)mtx;

@end
