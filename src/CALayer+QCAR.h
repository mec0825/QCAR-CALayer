//
//  UIView+QCARLayer.h
//  QCAR+CALayer
//
//  Created by Mec0825 on 14-9-28.
//  Copyright (c) 2014年 HiScene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CALayer (QCAR)

- (void)setModelViewMatrix:(float*)mtx andZPosition:(float)z;

@end
