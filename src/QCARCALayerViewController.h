//
//  QCARCALayerViewController.h
//  QCAR+CALayer
//
//  Created by Mec0825 on 14-9-28.
//  Copyright (c) 2014年 HiScene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCARViewController.h"

@class MPMoviePlayerController;

@interface QCARCALayerViewController : QCARViewController {
}

// We have to retain the views
@property (nonatomic, strong) NSMutableArray* viewArray;

// Important !!!
// Add one view, and you can receive touches
@property (nonatomic, strong) UIView* viewForTouch;

@property (nonatomic, strong) MPMoviePlayerController* player;

@end
