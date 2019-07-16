//
//  CLActionTool.m
//  Montage
//
//  Created by MacBookPro on 12/29/17.
//  Copyright © 2017 sssn. All rights reserved.
//



#import "CLActionTool.h"
#import "AFNetworking.h"
#import "CLCircleView.h"

static NSString* const kCLStickerToolStickerPathKey = @"stickerPath";
static NSString* const kCLStickerToolDeleteIconName = @"deleteIconAssetsName";

@interface _CLStickerView1 : UIView
+ (void)setActiveStickerView:(_CLStickerView1*)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image tool:(CLActionTool*)tool;
- (void)setScale:(CGFloat)scale;
@end



@implementation CLActionTool
{
    UIImage *_originalImage;
    
    UIView *_workingView;
    
    UIScrollView *_menuScroll;
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return [CLImageEditorTheme localizedString:@"CLActionTool_DefaultTitle" withDefault:@"Action"];
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 9;
}

#pragma mark- optional info

+ (NSString*)defaultStickerPath
{
    return [[[CLImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/stickers", NSStringFromClass(self)]];
}

+ (NSDictionary*)optionalInfo
{
    return @{
             kCLStickerToolStickerPathKey:[self defaultStickerPath],
             kCLStickerToolDeleteIconName:@"",
             };
}

#pragma mark- implementation

- (void)setup
{
    _originalImage = self.editor.imageView.image;
    
    [self.editor fixZoomScaleWithAnimated:YES];
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = YES;
    [self.editor.view addSubview:_workingView];
    
    [self setStickerMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
}

- (void)cleanup
{
    [self.editor resetZoomScaleWithAnimated:YES];
    
    [_workingView removeFromSuperview];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    [_CLStickerView1 setActiveStickerView:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark-

- (void)setStickerMenu
{
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;
    
    NSString *stickerPath = self.toolInfo.optionalInfo[kCLStickerToolStickerPathKey];
    if(stickerPath==nil){ stickerPath = [[self class] defaultStickerPath]; }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:stickerPath error:&error];
    
    for(NSString *path in list){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", stickerPath, path];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if(image){
            CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedStickerPanel:) toolInfo:nil];
            view.iconImage = [image aspectFit:CGSizeMake(50, 50)];
            view.userInfo = @{@"filePath" : filePath};
            
            [_menuScroll addSubview:view];
            x += W;
        }
    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}

- (void)tappedStickerPanel:(UITapGestureRecognizer*)sender
{
    
    UIView *view = sender.view;

    NSString *filePath = view.userInfo[@"filePath"];
    if(filePath){
        _CLStickerView1 *view = [[_CLStickerView1 alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath] tool:self];
        CGFloat ratio = MIN( (0.5 * _workingView.width) / view.width, (0.5 * _workingView.height) / view.height);
        [view setScale:ratio];
        view.center = CGPointMake(_workingView.width/2, _workingView.height/2);

        [_workingView addSubview:view];
        [_CLStickerView1 setActiveStickerView:view];
    }
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
}

- (UIImage*)buildImage:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [image drawAtPoint:CGPointZero];
    
    CGFloat scale = image.size.width / _workingView.width;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [_workingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

@end

@implementation _CLStickerView1
{
    UIImageView *_imageView1;
    UIButton *_deleteButton1;
    CLCircleView *_circleView1;
    
    CGFloat _scale1;
    CGFloat _arg1;
    
    CGPoint _initialPoint1;
    CGFloat _initialArg1;
}

+ (void)setActiveStickerView:(_CLStickerView1*)view
{
    static _CLStickerView1 *activeView = nil;
    if(view != activeView){
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
    }
}

- (id)initWithImage:(UIImage *)image tool:(CLActionTool*)tool
{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width+32, image.size.height+32)];
    if(self){
        _imageView1 = [[UIImageView alloc] initWithImage:image];
        _imageView1.layer.borderColor = [[UIColor blackColor] CGColor];
        _imageView1.layer.cornerRadius = 3;
        _imageView1.center = self.center;
        [self addSubview:_imageView1];
        
        _deleteButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_deleteButton1 setImage:[tool imageForKey:kCLStickerToolDeleteIconName defaultImageName:@"btn_delete.png"] forState:UIControlStateNormal];
        _deleteButton1.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton1.center = _imageView1.frame.origin;
        [_deleteButton1 addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton1];
        
        _circleView1 = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _circleView1.center = CGPointMake(_imageView1.width + _imageView1.frame.origin.x, _imageView1.height + _imageView1.frame.origin.y);
        _circleView1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView1.radius = 0.7;
        _circleView1.color = [UIColor whiteColor];
        _circleView1.borderColor = [UIColor blackColor];
        _circleView1.borderWidth = 5;
        [self addSubview:_circleView1];
        
        _scale1 = 1;
        _arg1 = 0;
        
        [self initGestures];
    }
    return self;
}

- (void)initGestures
{
    _imageView1.userInteractionEnabled = YES;
    [_imageView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_imageView1 addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    [_circleView1 addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view= [super hitTest:point withEvent:event];
    if(view==self){
        return nil;
    }
    return view;
}

- (UIImageView*)imageView
{
    return _imageView1;
}

- (void)pushedDeleteBtn:(id)sender
{
    _CLStickerView1 *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[_CLStickerView1 class]]){
            nextTarget = (_CLStickerView1*)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[_CLStickerView1 class]]){
                nextTarget = (_CLStickerView1*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveStickerView:nextTarget];
    [self removeFromSuperview];
}

- (void)setAvtive:(BOOL)active
{
    _deleteButton1.hidden = !active;
    _circleView1.hidden = !active;
    _imageView1.layer.borderWidth = (active) ? 1/_scale1 : 0;
}

- (void)setScale:(CGFloat)scale
{
    _scale1 = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _imageView1.transform = CGAffineTransformMakeScale(_scale1, _scale1);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_imageView1.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_imageView1.height + 32)) / 2;
    rct.size.width  = _imageView1.width + 32;
    rct.size.height = _imageView1.height + 32;
    self.frame = rct;
    
    _imageView1.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg1);
    
    _imageView1.layer.borderWidth = 1/_scale1;
    _imageView1.layer.cornerRadius = 3/_scale1;
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint1 = self.center;
    }
    self.center = CGPointMake(_initialPoint1.x + p.x, _initialPoint1.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint1 = [self.superview convertPoint:_circleView1.center fromView:_circleView1.superview];
        
        CGPoint p = CGPointMake(_initialPoint1.x - self.center.x, _initialPoint1.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg1 = _arg1;
        _initialArg1 = _scale1;
    }
    
    p = CGPointMake(_initialPoint1.x + p.x - self.center.x, _initialPoint1.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg1   = _initialArg1 + arg - tmpA;
    [self setScale:MAX(_initialArg1 * R / tmpR, 0.2)];
}

@end
