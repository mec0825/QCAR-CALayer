/*==============================================================================
 Copyright (c) 2010-2013 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import "ARParentViewController.h"
#import "ARViewController.h"
#import "OverlayViewController.h"
#import "QCARutils.h"

@implementation ARParentViewController

@synthesize arViewRect;

// initialisation functions set up size of managed view
- (id)initWithWindow:(UIWindow*)window
{
    self = [super init];
    
    if (self) {
        // Custom initialization
        arViewRect.size = [[UIScreen mainScreen] bounds].size;
        arViewRect.origin.x = arViewRect.origin.y = 0;
        appWindow = window;
        [appWindow retain];
    }
    
    return self;
}

- (void)dealloc
{
    [arViewController release];
    [overlayViewController release];
    [parentView release];
    [appWindow release];
    [super dealloc];
}

- (void)loadView
{
    NSLog(@"ARParentVC: creating");
    [self createParentViewAndSplashContinuation];
    
    // Add the EAGLView and the overlay view to the window
    arViewController = [[ARViewController alloc] init];
    
    // need to set size here to setup camera image size for AR
    arViewController.arViewSize = arViewRect.size;
    [parentView addSubview:arViewController.view];
    
    // Hide the AR view so the parent view can be seen during start-up (the
    // parent view contains the splash continuation image on iPad and is empty
    // on iPhone and iPod)
    [arViewController.view setHidden:YES];
    
    // Create an auto-rotating overlay view and its view controller (used for
    // displaying UI objects, such as the camera control menu)
    overlayViewController = [[OverlayViewController alloc] init];
    [parentView addSubview: overlayViewController.view];
    
    self.view = parentView;
}

- (void)viewDidLoad
{
    NSLog(@"ARParentVC: loading");
    // it's important to do this from here as arViewController has the wrong idea of orientation
    [arViewController handleARViewRotation:self.interfaceOrientation];
    // we also have to set the overlay view to the correct width/height for the orientation
    [overlayViewController handleViewRotation:self.interfaceOrientation];
}


- (void)viewWillAppear:(BOOL)animated 
{
    NSLog(@"ARParentVC: appearing");
    // make sure we're oriented/sized properly before reappearing/restarting
    [arViewController handleARViewRotation:self.interfaceOrientation];
    [overlayViewController handleViewRotation:self.interfaceOrientation];
    [arViewController viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated 
{
    NSLog(@"ARParentVC: appeared");
    [arViewController viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"ARParentVC: dissappeared");
    [arViewController viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Support all orientations
    return YES;
    
    // Support both portrait orientations
    //return (UIInterfaceOrientationPortrait == interfaceOrientation ||
    //        UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation);

    // Support both landscape orientations
    //return (UIInterfaceOrientationLandscapeLeft == interfaceOrientation ||
    //        UIInterfaceOrientationLandscapeRight == interfaceOrientation);
}


// Not using iOS6 specific enums in order to compile on iOS5 and lower versions
-(NSUInteger)supportedInterfaceOrientations
{
    return ((1 << UIInterfaceOrientationPortrait) | (1 << UIInterfaceOrientationLandscapeLeft) | (1 << UIInterfaceOrientationLandscapeRight) | (1 << UIInterfaceOrientationPortraitUpsideDown));
}


// This is called on iOS 4 devices (when built with SDK 5.1 or 6.0) and iOS 6
// devices (when built with SDK 5.1)
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    // ensure overlay size and AR orientation is correct for screen orientation
    [overlayViewController handleViewRotation:self.interfaceOrientation];
    [arViewController handleARViewRotation:interfaceOrientation];
    
    if (YES == [arViewController.view isHidden] && UIInterfaceOrientationIsLandscape([self interfaceOrientation])) {
        // iPad - the interface orientation is landscape, so we must switch to
        // the landscape splash image
        [self updateSplashScreenImageForLandscape];
    }
}


// This is called on iOS 6 devices (when built with SDK 5.1 or 6.0)
- (void) viewWillLayoutSubviews
{
    if (YES == [arViewController.view isHidden] && UIInterfaceOrientationIsLandscape([self interfaceOrientation])) {
        // iPad - the interface orientation is landscape, so we must switch to
        // the landscape splash image
        [self updateSplashScreenImageForLandscape];
    }
}


// touch handlers
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[arViewController.arView touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // iOS requires all events handled if touchesBegan is handled and not forwarded
    //[arViewController.arView touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[arViewController.arView touchesEnded:touches withEvent:event];

    // iOS requires all events handled if touchesBegan is handled and not forwarded
    UITouch* touch = [touches anyObject];
    
    int tc = [touch tapCount];
    if (2 == tc)
    {
        // Show camera control action sheet
        [[QCARutils getInstance] cameraCancelAF];
        [overlayViewController showOverlay];
    }
    if (1 == tc)
    {
        [[QCARutils getInstance] cameraTriggerAF];
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // iOS requires all events handled if touchesBegan is handled and not forwarded
}


#pragma mark -
#pragma mark Splash screen control
// Set up a continuation of the splash screen until the camera is initialised
- (void)createParentViewAndSplashContinuation
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    NSString* splashImageName = @"Default.png";
    
    if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom]) {
        // iPad
        if (YES == [self isRetinaEnabled]) {
            splashImageName = @"Default-Portrait@2x~ipad.png";
        }
        else {
            splashImageName = @"Default-Portrait~ipad.png";
        }
    }
    else {
        // iPhone and iPod
        if (568 == screenBounds.size.height) {
            // iPhone 5
            splashImageName = @"Default-568h@2x.png";
        }
        else if (YES == [self isRetinaEnabled]) {
            splashImageName = @"Default@2x.png";
        }
    }
    
    // Create the splash image
    UIImage *image = [UIImage imageNamed:splashImageName];
    
    if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom]) {
        // iPad - create the parent view and populate it with the splash image
        parentView = [[UIImageView alloc] initWithImage:image];
        parentView.frame = screenBounds;
    }
    else {
        // iPhone and iPod - create the parent view, but don't populate it with
        // an image
        parentView = [[UIImageView alloc] initWithFrame:arViewRect];
        
        // Create a splash view
        splashView = [[UIImageView alloc] initWithImage:image];
        splashView.frame = screenBounds;
        
        // Add the splash view directly to the window (this prevents the splash
        // view from rotating, so it is always portrait)
        [appWindow addSubview:splashView];
    }
    
    // userInteractionEnabled defaults to NO for UIImageViews
    [parentView setUserInteractionEnabled:YES];
    
    // Poll to see if the camera video stream has started and if so remove the
    // splash screen
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(endSplash:) userInfo:nil repeats:YES];
}


- (void)updateSplashScreenImageForLandscape
{
    // The splash screen update needs to happen only once
    static BOOL done = NO;
    
    if (NO == done && UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom]) {
        done = YES;
        
        // On the iPad, we must support landscape splash screen images, to match
        // the one iOS shows for us.  Update the splash screen image
        // appropriately
        
        NSString* splashImageName = @"Default-Landscape~ipad.png";
        
        if (YES == [self isRetinaEnabled]) {
            splashImageName = @"Default-Landscape@2x~ipad.png";
        }
        
        // Load the landscape image
        UIImage* image = [UIImage imageNamed:splashImageName];
        
        // Update the size and image for the existing UIImageView object
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.width = screenBounds.size.height;
        frame.size.height = screenBounds.size.width;
        
        UIImageView* imageView = (UIImageView*)self.view;
        [imageView setImage:image];
    }
}


- (void)endSplash:(NSTimer*)theTimer
{
    // Poll to see if the camera video stream has started and if so remove the
    // splash screen
    if ([QCARutils getInstance].videoStreamStarted == YES)
    {
        // Make the AR view visible
        [arViewController.view setHidden:NO];
        
        // The parent view no longer needs the image data (iPad)
        [parentView setImage:nil];
        
        // On iPhone and iPod, remove the splash view from the window
        // (splashView will be nil on iPad)
        [splashView removeFromSuperview];
        [splashView release];
        splashView = nil;
        
        // Stop the repeating timer
        [theTimer invalidate];
    }
}


// Test to see if the screen has retina mode
- (BOOL) isRetinaEnabled
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]
            &&
            ([UIScreen mainScreen].scale == 2.0));
}


// Free any OpenGL ES resources that are easily recreated when the app resumes
- (void)freeOpenGLESResources
{
    [arViewController freeOpenGLESResources];
}

@end
