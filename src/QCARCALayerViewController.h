//
//  QCARCALayerViewController.h
//  QCAR+CALayer
//
//  Created by Mec0825 on 14-9-28.
//  Copyright (c) 2014年 HiScene. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ON_NORMAL,
    ON_CREATE,
    ON_RENDERING,
    ON_DESTROY
} QCARCALayerState;

@class MPMoviePlayerController;

@interface QCARCALayerViewController : UIViewController {
    float _zPosition;
    QCARCALayerState _state;
}

// We have to retain the views
@property (nonatomic, strong) NSMutableArray* viewArray;

// Important !!!
// Add one view, and you can receive touches
@property (nonatomic, strong) UIView* viewForTouch;

// Information of target
@property (nonatomic, strong) NSString* targetName;
@property (nonatomic, assign) float targetWidth;
@property (nonatomic, assign) float targetHeight;

@property (nonatomic, strong) MPMoviePlayerController* player;

- (void)onCreate;
- (void)onDestroy;
- (void)onPause;
- (void)onResume;

- (QCARCALayerState)getState;

- (void)setProjectionMatrix:(float*)mtx;
- (void)updateModelViewMatrixOfSubviews:(float*)mtx;

@end
