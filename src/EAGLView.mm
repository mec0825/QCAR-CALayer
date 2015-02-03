//
//  EAGLView.m
//  QCAR+CALayer
//
//  Created by Mec0825 on 14-9-28.
//  Copyright (c) 2014年 HiScene. All rights reserved.
//

#import "EAGLView.h"

#import <QCAR/QCAR.h>
#import <QCAR/Tool.h>
#import <QCAR/State.h>
#import <QCAR/Renderer.h>
#import <QCAR/VideoBackgroundConfig.h>

#import "QCARutils.h"
#import "ShaderUtils.h"

#import "QCARViewController.h"
#import "QCARWebViewController.h"
#import "QCARCALayerViewController.h"

@implementation EAGLView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)renderFrameQCAR
{
    [self setFramebuffer];
    
    // Clear colour and depth buffers
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Render video background and retrieve tracking state
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    QCAR::Renderer::getInstance().drawVideoBackground();
    
    if (QCAR::GL_11 & qUtils.QCARFlags) {
        glEnable(GL_TEXTURE_2D);
        glDisable(GL_LIGHTING);
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_NORMAL_ARRAY);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    }
    
    glEnable(GL_DEPTH_TEST);
    // We must detect if background reflection is active and adjust the culling direction.
    // If the reflection is active, this means the pose matrix has been reflected as well,
    // therefore standard counter clockwise face culling will result in "inside out" models.
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    if(QCAR::Renderer::getInstance().getVideoBackgroundConfig().mReflection == QCAR::VIDEO_BACKGROUND_REFLECTION_ON)
        glFrontFace(GL_CW);  //Front camera
    else
        glFrontFace(GL_CCW);   //Back camera
    
    BOOL didReco = false;
    for (int i = 0; i < state.getNumTrackableResults(); ++i) {
        
        didReco = true;
        // Render using the appropriate version of OpenGL
        if (QCAR::GL_11 & qUtils.QCARFlags){
            ////////////////////////////////////////////////
            // In subclass, draw augmentations in OpenGL ES 1.1 here
            ////////////////////////////////////////////////
        }
#ifndef USE_OPENGL1
        else {
            ////////////////////////////////////////////////
            // In subclass, draw augmentations in OpenGL ES 2.0 here
            ////////////////////////////////////////////////
            
            const QCAR::TrackableResult* trackableResult = state.getTrackableResult(i);
            const QCAR::Matrix34F& trackablePose = trackableResult->getPose();
            
            const QCAR::ImageTarget& imageTarget =
            (const QCAR::ImageTarget&) trackableResult->getTrackable();
            NSString *targetName = [NSString stringWithFormat:@"%s", imageTarget.getName()];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(self.QCARCtl != nil &&
                   [self.QCARCtl getState] == ON_NORMAL) {
                    
                    [self.QCARCtl onCreate];
                    
                }
                
                if(self.QCARCtl != nil &&
                   [self.QCARCtl getState] == ON_RENDERING) {
                    QCAR::Matrix44F modelViewMatrix = QCAR::Tool::convertPose2GLMatrix(trackablePose);
                    
                    // The coordinate of OpenGLES is different from CALayer
                    float* rot = new float[16];
                    ShaderUtils::setRotationMatrix(90, 0, 0, 1, rot);
                    if([self.QCARCtl class] == [QCARWebViewController class])
                        ShaderUtils::scalePoseMatrix(1, 1, -1, rot);
                    ShaderUtils::multiplyMatrix(rot,
                                                modelViewMatrix.data,
                                                modelViewMatrix.data);
                    
                    ShaderUtils::setRotationMatrix(180, 0, 0, 1, rot);
                    ShaderUtils::multiplyMatrix(modelViewMatrix.data,
                                                rot,
                                                modelViewMatrix.data);
                    ShaderUtils::setRotationMatrix(180, 0, 1, 0, rot);
                    ShaderUtils::multiplyMatrix(modelViewMatrix.data,
                                                rot,
                                                modelViewMatrix.data);
                    
                    [self.QCARCtl updateModelViewMatrixOfSubviews:modelViewMatrix.data];
                }
            });
            
        }
#endif
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(didReco == false &&
           self.QCARCtl != nil &&
           [self.QCARCtl getState] == ON_RENDERING) {
            
            [self.QCARCtl onDestroy];
            
        }
    });
    
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    
    if (QCAR::GL_11 & qUtils.QCARFlags) {
        glDisable(GL_TEXTURE_2D);
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_NORMAL_ARRAY);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    }
    
    QCAR::Renderer::getInstance().end();
    [self presentFramebuffer];
}

@end
