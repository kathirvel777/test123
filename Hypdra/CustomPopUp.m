#import "CustomPopUp.h"
#import "Util.h"
#import "UIColor+Utils.h"
#import <CoreText/CoreText.h>


@implementation CustomPopUp{
    
    float popUpX;
    CGRect popUpRect;
}

@synthesize _click_delegate, _parent;

-(void) initAlertwithParent : (UIViewController *) parent withDelegate : (id<ClickDelegates>) theDelegate withMsg : (NSString *)msg withTitle : (NSString *)title withImage:(UIImage *)alertIcon{
    
    self._click_delegate = theDelegate;
    self._parent = parent;
    //[self downloadFont];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGRect rect = CGRectMake(0, 0, screenWidth, screenHeight);
    self.frame = rect;
    self.backgroundColor = [UIColor clearColor];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.3;
    UITapGestureRecognizer *outsideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Taped:)];
    [bgView addGestureRecognizer:outsideTap];
    bgView.tag=1;
    
    [self addSubview:bgView];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = NO;
    childPopUp = [UIView new];
    float popUpHeight = 208;//screenHeight/4;
    popUpX =0;//screenWidth/4;
    popUpRect = CGRectMake(popUpX, (screenHeight - popUpHeight)/2, 314, 208);
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [self setBorderOnly:childPopUp withBGColor:[UIColor orangeColor] withCornerRadius:5.0 andBorderWidth:0.0 andBorderColor:[UIColor greenColor] WithAlpha:1];
    
    childPopUp.frame = popUpRect;
    childPopUp.center = self.center;
    childPopUp.backgroundColor = [UIColor clearColor];
    [self addSubview:childPopUp];
    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 314, 208)];
    bgImg.image =[UIImage imageNamed:@"Alert_Bg.png"];
    bgImg.alpha = 0.97;
    bgImg.contentMode = UIViewContentModeScaleAspectFit;
    [childPopUp addSubview:bgImg];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView commitAnimations];
    [self createThreeMajorViews:msg withTitle:title withImage:alertIcon];
    self.outSideTap = YES;
}
//-(void)downloadFont{
//    
//    NSString *dataUrl = @"http://seekitechdemo.com/ttf/OpenSans-ExtraBoldItalic.ttf";
//    NSURL *url = [NSURL URLWithString:dataUrl];
//    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        // 4: Handle response here
//        if (error == nil) {
//            NSLog(@"no error!");
//            if (data != nil) {
//                NSLog(@"There is data!");
//                [self loadFont:data];
//            }
//        } else {
//            NSLog(@"%@", error.localizedDescription);
//        }
//    }];
//    [downloadTask resume];
//    
//}
//- (void)loadFont:(NSData *)data
//{
//    NSData *inData = data;
//    CFErrorRef error;
//    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
//    CGFontRef font = CGFontCreateWithDataProvider(provider);
//    if(!CTFontManagerRegisterGraphicsFont(font, &error)){
//        CFStringRef errorDescription = CFErrorCopyDescription(error);
//        NSLog(@"Failed to load font: %@", errorDescription);
//        CFRelease(errorDescription);
//    }
//    CFRelease(font);
//    CFRelease(provider);
//}
- (void)Taped:(UITapGestureRecognizer*)sender {
    if(_outSideTap){
        [_click_delegate cancelClicked:self];
    }
}

-(void) createThreeMajorViews: (NSString *)msg withTitle : (NSString *)title withImage : (UIImage *)alertIcon{
    
    FirstView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, childPopUp.frame.size.width, childPopUp.frame.size.height/3)];
    //FirstView.backgroundColor = [UIColor redColor];
    [childPopUp addSubview:FirstView];
    
    CGPoint center = FirstView.center;
    CGPoint alertIconCenter= CGPointMake(center.x, center.y-10);
    CGPoint titleLblCenter =CGPointMake(center.x, center.y+15);
    _alertIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _alertIcon.image = alertIcon;
    [_alertIcon setCenter:alertIconCenter];
    titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, FirstView.frame.size.height-20)];
    [titleLbl setCenter:titleLblCenter];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = title;
    
    [_msgLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:14]];
    [titleLbl setFont:[UIFont fontWithName:@"FuturaT-Book" size:16]];
    
    [FirstView addSubview:titleLbl];
    [FirstView addSubview:_alertIcon];
    
    secondView =[[UIView alloc]initWithFrame:CGRectMake(0, FirstView.frame.size.height, childPopUp.frame.size.width, childPopUp.frame.size.height/3)];
    //secondView.backgroundColor = [UIColor yellowColor];
    [childPopUp addSubview:secondView];
    [self createInputTxtField];
    [self createMsgLabel:msg];
    
    thirdView =[[UIView alloc]initWithFrame:CGRectMake(0, secondView.frame.size.height + secondView.frame.origin.y, childPopUp.frame.size.width, childPopUp.frame.size.height/3)];
    [childPopUp addSubview:thirdView];
    [self createOkayBtn];
    [self createCancelBtn];
    [self createAgreeBtn];
}

- (void)createInputTxtField{
    
    _inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, (secondView.frame.size.width-50), (secondView.frame.size.height-30))];
    _inputTextField.tintColor = [UIColor navyBlue];

   // [_inputTextField setBackgroundColor:[UIColor whiteColor]];
    [_inputTextField.layer setBorderColor:[UIColor grayColor].CGColor];
    [_inputTextField.layer setBorderWidth:1.0];
    _inputTextField.layer.cornerRadius = 5;
    [secondView addSubview:_inputTextField];
    [_inputTextField setFont:[UIFont fontWithName:@"FuturaT-Book" size:17]];
    [_inputTextField setCenter:CGPointMake(secondView.frame.size.width/2, secondView.frame.size.height/2)];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, _inputTextField.frame.size.height)];
    _inputTextField.leftView = paddingView;
    _inputTextField.leftViewMode = UITextFieldViewModeAlways;

}

- (void)createCancelBtn{
    
    _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, thirdView.frame.size.width/3, thirdView.frame.size.height-35)];
    [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.textColor = [UIColor greenColor];
    [_cancelBtn.titleLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:16]];
    
    _cancelBtn.backgroundColor = [UIColor grayColor];
    _cancelBtn.layer.shadowRadius = 2;
    _cancelBtn.layer.cornerRadius = 5;
    _cancelBtn.layer.masksToBounds = NO;
    [[_cancelBtn layer] setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [[_cancelBtn layer] setShadowOffset:CGSizeMake(0,2)];
    [[_cancelBtn layer] setShadowOpacity:1];
    [thirdView addSubview:_cancelBtn];
    [_cancelBtn addTarget:self action:@selector(OnCancelCLicked:) forControlEvents:UIControlEventTouchDown];
    _cancelBtn.center = CGPointMake(thirdView.frame.size.width/3.5, thirdView.frame.size.height/2);
}
- (void)createOkayBtn{
    
    _okay = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, thirdView.frame.size.width/3.2, thirdView.frame.size.height-32)];
    [_okay.titleLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:16]];
    [_okay setTitle:@"Okay" forState:UIControlStateNormal];
    _okay.backgroundColor = [UIColor grayColor];
    _okay.layer.shadowRadius = 2;
    _okay.layer.cornerRadius = 5;
    _okay.layer.masksToBounds = NO;
    [[_okay layer] setShadowColor:[[UIColor darkGrayColor] CGColor]];
    
    [[_okay layer] setShadowOffset:CGSizeMake(0,2)];
    [[_okay layer] setShadowOpacity:1];
    [_okay addTarget:self action:@selector(OnOKClick:) forControlEvents:UIControlEventTouchDown];
    [thirdView addSubview:_okay];
    _okay.center = CGPointMake(thirdView.frame.size.width/2, thirdView.frame.size.height/2);
}
- (void)createAgreeBtn{
    
    _agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, thirdView.frame.size.width/3, thirdView.frame.size.height-35)];
    [_agreeBtn.titleLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:16]];
    [_agreeBtn setTitle:@"Ok" forState:UIControlStateNormal];
    _agreeBtn.backgroundColor = [UIColor grayColor];
    _agreeBtn.layer.shadowRadius = 2;
    _agreeBtn.layer.cornerRadius = 5;
    _agreeBtn.layer.masksToBounds = NO;
    [[_agreeBtn layer] setShadowColor:[[UIColor darkGrayColor] CGColor]];
    
    [[_agreeBtn layer] setShadowOffset:CGSizeMake(0,2)];
    [[_agreeBtn layer] setShadowOpacity:1];
    [thirdView addSubview:_agreeBtn];
    [_agreeBtn addTarget:self action:@selector(OnAgreeCLicked:) forControlEvents:UIControlEventTouchDown];
    _agreeBtn.center = CGPointMake(thirdView.frame.size.width/1.4, thirdView.frame.size.height/2);
}
- (void)createMsgLabel : (NSString *)msg{
    
    _msgLabel  = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, secondView.frame.size.width-50, secondView.frame.size.height)];
    //_msgLabel.backgroundColor = [UIColor yellowColor];
    
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    [_msgLabel setFont:[UIFont fontWithName:@"FuturaT-Book" size:14]];    _msgLabel.text = msg;
    [_msgLabel sizeToFit];
    [_msgLabel setCenter:CGPointMake(secondView.frame.size.width/2, secondView.frame.size.height/2)];
    _msgLabel.backgroundColor = [UIColor clearColor];
    [secondView addSubview:_msgLabel];
}
-(void) show{
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:self];
    // [self._parent.view addSubview:self];
}

-(IBAction)OnOKClick :(id) sender{
    [_click_delegate okClicked:self];
}
-(IBAction)OnAgreeCLicked:(id)sender{
    [_click_delegate agreeCLicked:self];
    
}
-(IBAction)OnCancelCLicked:(id)sender{
    [_click_delegate cancelClicked:self];
    
}
-(void) show : (UIViewController *) parent{
    
}

-(void) hide{
    [self removeFromSuperview];
}

- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    childPopUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    childPopUp.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}


-(void) setBorderOnly:(UIView *) theView withBGColor:(UIColor *) color withCornerRadius :(float) radius andBorderWidth :(float) borderWidth andBorderColor :(UIColor *) bgColor WithAlpha:(float) curAlpha
{
    theView.layer.borderWidth = borderWidth;
    theView.layer.cornerRadius = radius;
    theView.layer.borderColor = [color CGColor];
    UIColor *c = [color colorWithAlphaComponent:curAlpha];
    theView.layer.backgroundColor = CFBridgingRetain(c);
}

@end

