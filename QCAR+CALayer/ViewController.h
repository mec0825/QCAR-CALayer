//
//  ViewController.h
//  QCAR+CALayer
//
//  Created by Mec0825 on 14-9-28.
//  Copyright (c) 2014年 HiScene. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;
@class QCARViewController;

@interface ViewController : UIViewController 

@property (nonatomic, strong) EAGLView* eaglView;
@property (nonatomic, strong) QCARViewController* QCARCtl;

@property (nonatomic, strong) UIButton* cancelBtn;

@end
