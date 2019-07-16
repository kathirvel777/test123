//
//  SPUserResizableView.m
//  NotePad Plus
//  Created by apple on 20/05/16.
//  Copyright © 2016 com.seek. All rights reserved.


#import "SPUserResizableView.h"
#import "ViewController.h"

#define kSPUserResizableViewGlobalInset 1.0
#define kSPUserResizableViewDefaultMinWidth 48.0
#define kSPUserResizableViewDefaultMinHeight 48.0
#define kSPUserResizableViewInteractiveBorderSize 7.0

static SPUserResizableViewAnchorPoint SPUserResizableViewNoResizeAnchorPoint = { 0.0, 0.0, 0.0, 0.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewUpperLeftAnchorPoint = { 1.0, 1.0, -1.0, 1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewMiddleLeftAnchorPoint = { 1.0, 0.0, 0.0, 1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewLowerLeftAnchorPoint = { 1.0, 0.0, 1.0, 1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewUpperMiddleAnchorPoint = { 0.0, 1.0, -1.0, 0.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewUpperRightAnchorPoint = { 0.0, 1.0, -1.0, -1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewMiddleRightAnchorPoint = { 0.0, 0.0, 0.0, -1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewLowerRightAnchorPoint = { 0.0, 0.0, 1.0, -1.0 };
static SPUserResizableViewAnchorPoint SPUserResizableViewLowerMiddleAnchorPoint = { 0.0, 0.0, 1.0, 0.0 };

@interface SPGripViewBorderView : UIView
{
    
}
@end

@implementation SPGripViewBorderView{
    Boolean borderColour;
    
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Clear background to ensure the content view shows through.
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    
    //    CGContextSetLineWidth(context, 1.0);
    //    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    //    CGRect rectToFill = CGRectMake(0.0, 0.0, 30, 30);
    //   CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), rectToFill);
    
    UIButton *btn=[[UIButton alloc]init];
    btn.frame=CGRectMake(0.0, 0.0, 30, 30);
    
    CGContextSaveGState(context);
    // (1) Draw the bounding box.
    CGContextSetLineWidth(context, 0.5);
    
    //float num[] = {6.0, 6.0};
    //CGContextSetLineDash(context, 0.0, num, 2);
    borderColour=[[NSUserDefaults standardUserDefaults]boolForKey:@"HideBorderColour"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"HideBorderColour"];
    [[NSUserDefaults standardUserDefaults]synchronize];
//    if(borderColour==YES)
//    {
        NSLog(@"BORDER COLOR");
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:64/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:0.0].CGColor);
//    }
//    else
//    {
//        NSLog(@"BORDER COLOR ELSE");
//
//        // CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:64/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:100.0].CGColor);
//
//        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//
//
//        CGFloat dashArray[4];
//        dashArray[0] = 5;
//        dashArray[1] = 5;
//        dashArray[2] = 5;
//        dashArray[3] = 5;
//
//        //     CGFloat dashes[] = { 4, 4 };
//        CGContextSetLineDash( context, 1, dashArray, 1 );
//    }
    
    CGContextAddRect(context, CGRectInset(self.bounds, kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewInteractiveBorderSize/2));
    CGContextStrokePath(context);
    
    // (2) Calculate the bounding boxes for each of the anchor points.
    CGRect upperLeft = CGRectMake(0.0, 0.0, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    
    CGRect upperRight = CGRectMake(self.bounds.size.width - kSPUserResizableViewInteractiveBorderSize, 0.0, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    CGRect lowerRight = CGRectMake((self.bounds.size.width - kSPUserResizableViewInteractiveBorderSize)-5, (self.bounds.size.height - kSPUserResizableViewInteractiveBorderSize)-5, kSPUserResizableViewInteractiveBorderSize+5, kSPUserResizableViewInteractiveBorderSize+5);

    CGRect lowerLeft = CGRectMake(0.0, self.bounds.size.height - kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    CGRect upperMiddle = CGRectMake((self.bounds.size.width - kSPUserResizableViewInteractiveBorderSize)/2, 0.0, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    CGRect lowerMiddle = CGRectMake((self.bounds.size.width - kSPUserResizableViewInteractiveBorderSize)/2, self.bounds.size.height - kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    CGRect middleLeft = CGRectMake(0.0, (self.bounds.size.height - kSPUserResizableViewInteractiveBorderSize)/2, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    CGRect middleRight = CGRectMake(self.bounds.size.width - kSPUserResizableViewInteractiveBorderSize, (self.bounds.size.height - kSPUserResizableViewInteractiveBorderSize)/2, kSPUserResizableViewInteractiveBorderSize, kSPUserResizableViewInteractiveBorderSize);
    
   // (3) Create the gradient to paint the anchor points.
//    CGFloat colors [] = {
//        0.0, 0.4, 0.4, 0.4,
//        0.4, 0.4, 0.4, 1
//    };
//
    CGFloat colors [] = {
        0.894, 0.894, 0.894, 1.0,
        0.694, 0.694, 0.694, 1.0
    };
    
   CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    // (4) Set up the stroke for drawing the border of each of the anchor points.
    CGContextSetLineWidth(context, 1);
    CGContextSetShadow(context, CGSizeMake(0.5, 0.5), 1);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    // (5) Fill each anchor point using the gradient, then stroke the border.
    // CGRect allPoints[8] = { upperLeft, upperRight, lowerRight, lowerLeft, upperMiddle, lowerMiddle, middleLeft, middleRight };
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"HideAnchors"]){
        CGRect allPoints[2] = { upperLeft, lowerRight};
        for (NSInteger i = 0; i < 8; i++) {
            CGRect currPoint = allPoints[i];
            CGContextSaveGState(context);
            CGContextAddEllipseInRect(context, currPoint);
            CGContextClip(context);
            CGPoint startPoint = CGPointMake(CGRectGetMidX(currPoint), CGRectGetMinY(currPoint));
            CGPoint endPoint = CGPointMake(CGRectGetMidX(currPoint), CGRectGetMaxY(currPoint));
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
            
            //        float num[] = {6.0, 6.0};
            //        CGContextSetLineDash(context, 0.0, num, 2);
            
            CGContextRestoreGState(context);
            // CGContextStrokeEllipseInRect(context, CGRectInset(currPoint, 1, 1));
            CGContextStrokePath(context);
        }
    }else{
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"HideAnchors"];
    }
    
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
}

@end

@implementation SPUserResizableView{
    UITapGestureRecognizer *GalleryImageTap,*PaintImageTap,*PDFTap,*AudioTap;
    CALayer *layer;
    CGFloat oldX;
    CGFloat oldY;
    CGFloat oldWidth;
    CGFloat oldHeight;
}
-(void)CallingDelegate:(UITapGestureRecognizer *)recognizer{
    
    
}
-(void)CallingImageEditDelegate:(UITapGestureRecognizer *)recognizer{
    NSLog(@"TAPWORKING");
    if(self.delegate && [self.delegate respondsToSelector:@selector(openCamera)]){
        [self.delegate openCamera];
    }
}
-(void)CallingPDFAnnotateDelegate:(UITapGestureRecognizer *)recognizer{
    NSLog(@"TAPWORKING");
    //    if(self.delegate && [self.delegate respondsToSelector:@selector(PDFAnnotate:)]){
    //        [self.delegate PDFAnnotate:self];
    //    }
}
-(void)CallingAudioPlayDelegate:(UITapGestureRecognizer *)recognizer{
    NSLog(@"TAPWORKING");
    if(self.delegate && [self.delegate respondsToSelector:@selector(AudioPlay:)]){
        [self.delegate AudioPlay:self];
    }
}

@synthesize contentView, minWidth, minHeight, preventsPositionOutsideSuperview, delegate;

- (void)setupDefaultAttributes {
    borderView = [[SPGripViewBorderView alloc] initWithFrame:CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset)];
     [borderView setHidden:YES];
   // [self addSubview:borderView];
    
    self.minWidth = kSPUserResizableViewDefaultMinWidth;
    self.minHeight = kSPUserResizableViewDefaultMinHeight;
    
    _cancel=[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 25, 25)];
    
    NSLog(@"Status :%@",self.Status);
    //    ModeOfDrawing=self.Mode;
    //    NSLog(@"ModeOfDrawing:%@",ModeOfDrawing);
    
    //    if([self.Mode isEqualToString:@"Drawing"])
    //    {
     //   _Menu=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - kSPUserResizableViewInteractiveBorderSize-20, (( self.frame.size.height - kSPUserResizableViewInteractiveBorderSize)/2)-20, 50, 50)];
        // [_Menu setHidden:YES];
    // }
    self.preventsPositionOutsideSuperview = YES;
}

- (id)initWithFrame:(CGRect)frame {
    
    
    if ((self = [super initWithFrame:frame])) {
        [self setupDefaultAttributes];
        
    }
    //    NSString *ResizablViewType=[[NSUserDefaults standardUserDefaults] valueForKey:@"ResizableViewType"];
    //    if([ResizablViewType isEqualToString:@"GALLERY_IMAGE"]){
    GalleryImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CallingImageEditDelegate:)];
    [GalleryImageTap setNumberOfTapsRequired:1];
    GalleryImageTap.delegate=self;
    [self addGestureRecognizer:GalleryImageTap];
    //    }else if([ResizablViewType isEqualToString:@"PAINT_IMAGE"]){
    //        PaintImageTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CallingDelegate:)];
    //        [PaintImageTap setNumberOfTapsRequired:2];
    //        PaintImageTap.delegate=self;
    //        [self addGestureRecognizer:PaintImageTap];
    //
    //
    //
    //    }else if([ResizablViewType isEqualToString:@"PDF"]){
    //        PDFTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CallingPDFAnnotateDelegate:)];
    //        [PDFTap setNumberOfTapsRequired:2];
    //        PDFTap.delegate=self;
    //        [self addGestureRecognizer:PDFTap];
    //    }else if([ResizablViewType isEqualToString:@"Audio"]){
    //        NSLog(@"PDF AudioUserDefaults");
    //        AudioTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CallingAudioPlayDelegate:)];
    //        [AudioTap setNumberOfTapsRequired:2];
    //        AudioTap.delegate=self;
    //        [self addGestureRecognizer:AudioTap];
    //    }else{
    //
    //    }
    
    return self;
}

-(void)userDidPan:(UIScreenEdgePanGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    CGPoint velocity = [recognizer velocityInView:self];
    NSLog(@"Pan x %f, y %f vx %f vy %f", location.x, location.y, velocity.x, velocity.y);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
    }
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setupDefaultAttributes];
    }
    return self;
}

- (void)setContentView:(UIView *)newContentView {
    [contentView removeFromSuperview];
    contentView = newContentView;
    contentView.frame = CGRectInset(self.bounds,kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
    
    
    
    [self addSubview:contentView];
    
    // Ensure the border view is always on top by removing it and adding it to the end of the subview list.
    [borderView removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //[_cancel setBackgroundImage:[UIImage imageNamed:@"delete_red_stroke.png"] forState:UIControlStateNormal];
    
    [self addSubview:borderView];
    [_cancel addTarget:self
                action:@selector(goToFirstTrailer:)
      forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    
    
    NSLog(@"resize_x %0.1f",self.frame.origin.x);
    NSLog(@"resize_y %0.1f",self.frame.origin.y);
    NSLog(@"resize_width %0.1f",self.frame.size.width);
    NSLog(@"resize_height %0.1f",self.frame.size.height);
    
    //_Menu.frame=CGRectMake(self.frame.size.width-10, 0.0, 30, 30);
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults setFloat:self.frame.origin.x+10 forKey:@"cropped_image_x"];
    [defaults setFloat:self.frame.origin.y+10 forKey:@"cropped_image_y"];
    [defaults setFloat:self.frame.size.width-20 forKey:@"cropped_image_width"];
    [defaults setFloat:self.frame.size.height-20 forKey:@"cropped_image_height"];
    [defaults synchronize];
    
//       layer = [CALayer layer];
//    layer.backgroundColor = ((__bridge CGColorRef _Nullable)([UIColor colorWithPatternImage:[UIImage imageNamed:@"resize_icon.png"]])CGColor);
//        layer.frame = CGRectMake(0.0,
//                                 0.0, 25, 25);
//        layer.contents = (id)[UIImage imageNamed:@"resize_icon.png"];
//        [[self layer] addSublayer:layer];
//        [layer setNeedsDisplay];
}
- (void)layoutSubviews {
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"CreateButton"])
    {
        [_cancel setBackgroundImage:[UIImage imageNamed:@"Reset_icon.png"] forState:UIControlStateNormal];
    
        
        [self addSubview:_cancel];
    }
    else if([[NSUserDefaults standardUserDefaults] boolForKey:@"stickers"])
    {
        [_cancel setBackgroundImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
        [self addSubview:_cancel];
        
    }
    else
        [_cancel removeFromSuperview];
    
}
//- (void) OpenSettings:(id)sender {
//    NSLog(@"Show Settings");
//
//    ShapesSettingsControllerViewController *opendrawings = [[ShapesSettingsControllerViewController alloc]init];
//
//    popover = [[UIPopoverController alloc]initWithContentViewController:opendrawings];
//
//    popover.popoverContentSize = CGSizeMake(400, 200);
//    popover.delegate=self;
//    //opendrawings.delegate=self;
//    //opendrawings.popoverPresentationController.delegate=self;
//
//
//    //        CGRect screenRect = [[UIScreen mainScreen] bounds];
//    //        CGFloat screenWidth = screenRect.size.width;
//    //        CGFloat screenHeight = screenRect.size.height;
//    //        CGRect rect=CGRectMake(screenWidth/2, screenHeight/2, 1, 1);
//
//
//    [popover presentPopoverFromRect:[sender frame] inView:self permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
//
//}
//

- (void) goToFirstTrailer:(id)sender
{
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"CreateButton"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetCreateButton" object:self];
        
    }
    
    else if([[NSUserDefaults standardUserDefaults]boolForKey:@"stickers"])
    {
        
        self.frame=CGRectMake(100, 100, 0, 0);
        
        [self removeFromSuperview];
        
    }
}

- (void)setFrame:(CGRect)newFrame {
    [super setFrame:newFrame];
    contentView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2);
    borderView.frame = CGRectInset(self.bounds, kSPUserResizableViewGlobalInset, kSPUserResizableViewGlobalInset);
    [borderView setNeedsDisplay];
}

static CGFloat SPDistanceBetweenTwoPoints(CGPoint point1, CGPoint point2) {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy);
};

typedef struct CGPointSPUserResizableViewAnchorPointPair {
    CGPoint point;
    SPUserResizableViewAnchorPoint anchorPoint;
} CGPointSPUserResizableViewAnchorPointPair;

- (SPUserResizableViewAnchorPoint)anchorPointForTouchLocation:(CGPoint)touchPoint {
    // (1) Calculate the positions of each of the anchor points.
    CGPointSPUserResizableViewAnchorPointPair upperLeft = { CGPointMake(0.0, 0.0), SPUserResizableViewUpperLeftAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair upperMiddle = { CGPointMake(self.bounds.size.width/2, 0.0), SPUserResizableViewUpperMiddleAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair upperRight = { CGPointMake(self.bounds.size.width, 0.0), SPUserResizableViewUpperRightAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair middleRight = { CGPointMake(self.bounds.size.width, self.bounds.size.height/2), SPUserResizableViewMiddleRightAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair lowerRight = { CGPointMake(self.bounds.size.width, self.bounds.size.height), SPUserResizableViewLowerRightAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair lowerMiddle = { CGPointMake(self.bounds.size.width/2, self.bounds.size.height), SPUserResizableViewLowerMiddleAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair lowerLeft = { CGPointMake(0, self.bounds.size.height), SPUserResizableViewLowerLeftAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair middleLeft = { CGPointMake(0, self.bounds.size.height/2), SPUserResizableViewMiddleLeftAnchorPoint };
    CGPointSPUserResizableViewAnchorPointPair centerPoint = { CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2), SPUserResizableViewNoResizeAnchorPoint };
    
    // (2) Iterate over each of the anchor points and find the one closest to the user's touch.
    CGPointSPUserResizableViewAnchorPointPair allPoints[9] = { upperLeft, upperRight, lowerRight, lowerLeft, upperMiddle, lowerMiddle, middleLeft, middleRight, centerPoint };
    CGFloat smallestDistance = MAXFLOAT; CGPointSPUserResizableViewAnchorPointPair closestPoint = centerPoint;
    for (NSInteger i = 0; i < 9; i++) {
        CGFloat distance = SPDistanceBetweenTwoPoints(touchPoint, allPoints[i].point);
        if (distance < smallestDistance) {
            closestPoint = allPoints[i];
            smallestDistance = distance;
            
        }
    }
    return closestPoint.anchorPoint;
}

- (BOOL)isResizing
{
    if(!_resizableStatus)
    {
        
        NSLog(@"Returning No..");
        return NO;
    }
    else
    {
        return (anchorPoint.adjustsH || anchorPoint.adjustsW || anchorPoint.adjustsX || anchorPoint.adjustsY);
        
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've begun our editing session.
    if ([[event allTouches]count] > 1) {
        
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableViewDidBeginEditing:)]) {
            [self.delegate userResizableViewDidBeginEditing:self];
        }
        
        [borderView setHidden:NO];
        [_Menu setHidden:NO];
        UITouch *touch = [touches anyObject];
        anchorPoint = [self anchorPointForTouchLocation:[touch locationInView:self]];
        
        // When resizing, all calculations are done in the superview's coordinate space.
        touchStart = [touch locationInView:self.superview];
        if (![self isResizing]) {
            // When translating, all calculations are done in the view's coordinate space.
            touchStart = [touch locationInView:self];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Notify the delegate we've ended our editing session.
    
    NSLog(@"User Tag = %ld",(long)self.tag);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableViewDidEndEditing:)])
    {
        [self.delegate userResizableViewDidEndEditing:self];
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        
        [defaults setFloat:self.frame.origin.x+10 forKey:@"cropped_image_x"];
        [defaults setFloat:self.frame.origin.y+10 forKey:@"cropped_image_y"];
        [defaults setFloat:self.frame.size.width-20 forKey:@"cropped_image_width"];
        [defaults setFloat:self.frame.size.height-20 forKey:@"cropped_image_height"];
        [defaults synchronize];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've ended our editing session.
    if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableViewDidEndEditing:)]) {
        [self.delegate userResizableViewDidEndEditing:self];
    }
    //    MainViewController *MVC=[[MainViewController alloc]initWithNibName:@"main" bundle:nil];
    //    MVC.scrollView.scrollEnabled=YES;
}

- (void)showEditingHandles {
    [self addSubview:borderView];
    [borderView setHidden:NO];
    [_Menu setHidden:NO];
    NSLog(@"SHOW EHIT");
    
}

- (void)hideEditingHandles {
    [borderView setHidden:YES];
    [_Menu setHidden:YES];
    NSLog(@"HIDE EDIT");
}
- (void)removeBorder{
    [borderView removeFromSuperview];
}
//-(void)hidCancel {
//    [self.cancel setHidden:YES];
//
//}
- (void)resizeUsingTouchLocation:(CGPoint)touchPoint {
    // (1) Update the touch point if we're outside the superview.
    if (self.preventsPositionOutsideSuperview) {
        CGFloat border = kSPUserResizableViewGlobalInset + kSPUserResizableViewInteractiveBorderSize/2;
        if (touchPoint.x < border) {
            touchPoint.x = border;
        }
        if (touchPoint.x > self.superview.bounds.size.width - border) {
            touchPoint.x = self.superview.bounds.size.width - border;
        }
        if (touchPoint.y < border) {
            touchPoint.y = border;
        }
        if (touchPoint.y > self.superview.bounds.size.height - border) {
            touchPoint.y = self.superview.bounds.size.height - border;
        }
    }
    
    // (2) Calculate the deltas using the current anchor point.
    CGFloat deltaW = anchorPoint.adjustsW * (touchStart.x - touchPoint.x);
    CGFloat deltaX = anchorPoint.adjustsX * (-1.0 * deltaW);
    CGFloat deltaH = anchorPoint.adjustsH * (touchPoint.y - touchStart.y);
    CGFloat deltaY = anchorPoint.adjustsY * (-1.0 * deltaH);
    
    // (3) Calculate the new frame.
    CGFloat newX = self.frame.origin.x + deltaX;
    CGFloat newY = self.frame.origin.y + deltaY;
    CGFloat newWidth = self.frame.size.width + deltaW;
    CGFloat newHeight = self.frame.size.height + deltaH;
    
    
    // (4) If the new frame is too small, cancel the changes.
    if (newWidth < self.minWidth) {
        newWidth = self.frame.size.width;
        newX = self.frame.origin.x;
    }
    if (newHeight < self.minHeight) {
        newHeight = self.frame.size.height;
        newY = self.frame.origin.y;
    }
    
    // (5) Ensure the resize won't cause the view to move offscreen.
    if (self.preventsPositionOutsideSuperview) {
        if (newX < self.superview.bounds.origin.x) {
            // Calculate how much to grow the width by such that the new X coordintae will align with the superview.
            deltaW = self.frame.origin.x - self.superview.bounds.origin.x;
            newWidth = self.frame.size.width + deltaW;
            newX = self.superview.bounds.origin.x;
        }
        if (newX + newWidth > self.superview.bounds.origin.x + self.superview.bounds.size.width) {
            if(newWidth>=100)
                newWidth = self.superview.bounds.size.width - newX;
        }
        if (newY < self.superview.bounds.origin.y) {
            
            deltaH = self.frame.origin.y - self.superview.bounds.origin.y;
            newHeight = self.frame.size.height + deltaH;
            newY = self.superview.bounds.origin.y;
        }
        if (newY + newHeight > self.superview.bounds.origin.y + self.superview.bounds.size.height) {
            if(newHeight>=100)
                
                newHeight = self.superview.bounds.size.height - newY;
        }
    }
    NSLog(@"resize_x %0.1f",newX);
    NSLog(@"resize_y %0.1f",newY);
    NSLog(@"resize_width %0.1f",newWidth);
    NSLog(@"resize_height %0.1f",newHeight);
    if(newWidth<100 || newHeight<100){
        
        newX = oldX;
        newY = oldY;
        newWidth = oldWidth;
        newHeight = oldHeight;
        
    }else{
        oldX = newX;
        oldY = newY;
        oldWidth = newWidth;
        oldHeight = newHeight;
        self.frame = CGRectMake(newX, newY, newWidth, newHeight);
        [self.contentView.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.contentView.layer setShadowOpacity:0.8];
        [self.contentView.layer setShadowRadius:3.0];
        [self.contentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        
        touchStart = touchPoint;
        if([self.accessibilityHint isEqualToString:@"TextView"]){
            NSLog(@"TextView_IF_Stmt");
            if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableviewBeingResized:)])
                [self.delegate userResizableviewBeingResized:self];
        }
    }
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint {
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x, self.center.y + touchPoint.y - touchStart.y);
    if (self.preventsPositionOutsideSuperview) {
        // Ensure the translation won't cause the view to move offscreen.
        CGFloat midPointX = CGRectGetMidX(self.bounds);
        if (newCenter.x > self.superview.bounds.size.width - midPointX) {
            newCenter.x = self.superview.bounds.size.width - midPointX;
        }
        if (newCenter.x < midPointX) {
            newCenter.x = midPointX;
        }
        CGFloat midPointY = CGRectGetMidY(self.bounds);
        if (newCenter.y > self.superview.bounds.size.height - midPointY) {
            newCenter.y = self.superview.bounds.size.height - midPointY;
        }
        if (newCenter.y < midPointY) {
            newCenter.y = midPointY;
        }
    }
    self.center = newCenter;
    //    ViewController *ctr=[[ViewController alloc]init];
    //    ctr.btn.center=newCenter;
    
    NSLog(@"resize_x %0.1f",self.frame.origin.x);
    NSLog(@"resize_y %0.1f",self.frame.origin.y);
    NSLog(@"resize_width %0.1f",self.frame.size.width);
    NSLog(@"resize_height %0.1f",self.frame.size.height);
    
    CGRect rect=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UpdatedResizableView"
     object:[NSValue valueWithCGRect:rect]];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if ([self isResizing])
    {
        [self resizeUsingTouchLocation:[[touches anyObject] locationInView:self.superview]];
    }
    else
    {
        [self translateUsingTouchLocation:[[touches anyObject] locationInView:self]];
    }
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults setFloat:self.frame.origin.x+10 forKey:@"cropped_image_x"];
    [defaults setFloat:self.frame.origin.y+10 forKey:@"cropped_image_y"];
    [defaults setFloat:self.frame.size.width-20 forKey:@"cropped_image_width"];
    [defaults setFloat:self.frame.size.height-20 forKey:@"cropped_image_height"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"movesMenuEditor"
     object:self];
    
    NSLog(@"X = %f",self.frame.origin.x);
    NSLog(@"Y = %f",self.frame.origin.y);
    
}

//- (void)dealloc {
//    [contentView removeFromSuperview];
//}

@end

