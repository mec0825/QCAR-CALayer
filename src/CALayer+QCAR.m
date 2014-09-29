//
//  UIView+QCARLayer.m
//  QCAR+CALayer
//
//  Created by Mec0825 on 14-9-28.
//  Copyright (c) 2014年 HiScene. All rights reserved.
//

#import "CALayer+QCAR.h"

@implementation CALayer (QCAR)

- (void)setModelViewMatrix:(float *)mtx andZPosition:(float)z{
    
    CATransform3D transform = CATransform3DIdentity;
    
    transform.m11 = mtx[0];
    transform.m12 = mtx[1];
    transform.m13 = mtx[2];
    transform.m14 = mtx[3];
    
    transform.m21 = mtx[4];
    transform.m22 = mtx[5];
    transform.m23 = mtx[6];
    transform.m24 = mtx[7];
    
    transform.m31 = mtx[8];
    transform.m32 = mtx[9];
    transform.m33 = mtx[10];
    transform.m34 = mtx[11];
    
    transform.m41 = mtx[12];
    transform.m42 = mtx[13];
    transform.m43 = mtx[14]+z;
    transform.m44 = mtx[15];
    
//    [CATransaction setDisableActions:YES];
    self.transform = transform;
    
}

@end
