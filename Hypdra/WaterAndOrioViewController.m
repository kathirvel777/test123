//
//  WaterAndOrioViewController.m
//  Montage
//
//  Created by MacBookPro on 5/26/17.
//  Copyright © 2017 sssn. All rights reserved.

#import "WaterAndOrioViewController.h"
#import "CZPicker.h"
#import <QuartzCore/QuartzCore.h>
#import "MSColorPicker.h"
#import "WYPopoverController.h"
#import "MSColorPicker.h"
#import "MBProgressHUD.h"
#import "DEMORootViewController.h"
#import "AFNetworking.h"
#import "SJVideoPlayer.h"
#import "SJVideoPlayerControl.h"
#import <Masonry.h>
#import "UIView+Toast.h"
#import "CLImageEditor.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "SJVideoPlayerControlView.h"
#import <CoreText/CoreText.h>


#define kRotateRight -M_PI/2
#define kRotateLeft  M_PI/2

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

#define URL @"https://www.hypdra.com/api/api.php?rquest=advance_watermark_pay"

CGFloat degreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};


@interface WaterAndOrioViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,CZPickerViewDataSource, CZPickerViewDelegate,WYPopoverControllerDelegate,MSColorSelectionViewControllerDelegate,UIGestureRecognizerDelegate,CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate,ClickDelegates>
{
    
    MSColorSelectionViewController *colorSelectionController;
    
    BOOL textFlag,logoFlag,OrioFlag,flipFlag,flopFlag,disableButton,boldSelected,italicSelected;
    int isIncrease;
    WYPopoverController *popoverController;
    
    MBProgressHUD *hud;
    
    UIImage *chosenImage;
    SPUserResizableView *imageResizableView;
    CGFloat fontSize;
    CGFloat opacity;
    UIView *tempLayerView;
    CGFloat diagonal,rotationAngle,imageWidth,imageHeight;
    UIImage *videoThumbnail;
    
    NSString *appDir,*Pathdir,*user_id,*lang,*textFontStyle;
    
    NSMutableURLRequest *request;
    int rotation,flip,flop;
    float x,y;
    
    NSArray *fruits;
    UIFont *boldFont,*italicFont;
    BOOL boldStatus,italicStatus,isFiltered,isOrientationChanged;
    NSMutableArray *filteredFonts,*allFonts;
    NSDictionary *selectedDic;

    CGRect font_Search_Selecting_View;
    
}

//@property ;
@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;

@property CZPickerView *pickerWithImage;

@end

@implementation WaterAndOrioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isWaterMarkVc"];
    self.playURL = [[NSUserDefaults standardUserDefaults]valueForKey:@"Source_Video"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self loadVideoPlayer];
    
    boldFont=[UIFont fontWithName:self.displayText.font.fontName size:self.displayText.font.pointSize];
    italicFont=[UIFont fontWithName:self.displayText.font.fontName size:self.displayText.font.pointSize];
    
    boldStatus=true;
    italicStatus=true;
    isFiltered = false;
    self.SearchBar.delegate = self;
    
    [self.doneBtn setEnabled:NO];
    [self.doneBtn setTintColor: [UIColor clearColor]];
    
    //    self.player = [[VKVideoPlayer alloc] init];
    //    self.player.delegate = self;
    //    self.player.view.frame = self.topView.bounds;
    //    self.player.view.playerControlsAutoHideTime = @10;
    //    [self.topView addSubview:self.player.view];
    //
    tempLayerView  = self.SJplayer.presentView;
    //
    //    [self.topView addSubview:self.player.view];
    [self calculateDiagonal];
    isIncrease=1;
    self.displayText.delegate =  self;
    
    
    //fruits = @[@"Baskerville-SemiBold",@"Baskerville-Italic",@"BodoniSvtyTwoITCTT-BookIta",@"Baskerville-Bold",@"ChalkboardSE-Light",@"Chalkduster",@"Cochin",@"Copperplate",@"Courier",@"Damascus",@"DevanagariSangamMN",@"Farah",@"Helvetica-Light",@"Helvetica-Oblique",@"HelveticaNeue-Italic",@"Helvetica Neue",@"Kailasa",@"ArialMT",@"Arial-BoldItalicMT",@"Arial-ItalicMT",@"ArialHebrew",@"ArialHebrew-Bold",@"AmericanTypewriter-Bold",@"AmericanTypewriter-CondensedBold",@"AmericanTypewriter-Light"];
    
    allFonts = [[NSMutableArray alloc]init];
    [self loadFonts];
    [self setBtnImage:self.clockWiseBtn];
    [self setBtnImage:self.antiClockWiseBtn];
    [self setBtnImage:self.horizontalBtn];
    [self setBtnImage:self.verticalBtn];
    [self setBtnImage:self.logoPlus];
    [self setBtnImage:self.editBtn];
    [self setBtnImage:self.okBtn];
    [self setBtnImage:self.delBtn];
    
    self.okBtn.layer.cornerRadius = _okBtn.frame.size.width/2;
    self.okBtn.layer.masksToBounds = YES;
    self.okBtn.layer.shadowRadius = 1.5f;
    self.okBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.okBtn.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.okBtn.layer.shadowOpacity = 0.5f;
    self.okBtn.layer.masksToBounds = NO;
    self.okBtn.layer.borderWidth=2.0f;
    self.okBtn.layer.borderColor = [UIColor navyBlue].CGColor;
    
    
    self.sizeDisplay.layer.cornerRadius=5.0f;
    self.sizeDisplay.layer.masksToBounds=YES;
    self.opacityDisplay.layer.cornerRadius=5.0f;
    self.opacityDisplay.layer.masksToBounds=YES;
    _videoResizable.hidden = YES;
    
    self.navigationController.navigationItem.backBarButtonItem.enabled = false;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.navigationController resignFirstResponder];
    
    colorSelectionController = [[MSColorSelectionViewController alloc] init];
    
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:colorSelectionController];
    
    popoverController = [[WYPopoverController alloc ]initWithContentViewController:navCtrl];
    
    popoverController.delegate = self;
    colorSelectionController.delegate = self;
    colorSelectionController.color = [UIColor whiteColor];
    
    popoverController.popoverContentSize = CGSizeMake(250, 500);
    self.TableView.separatorColor = [UIColor clearColor];
    self.SearchBar.placeholder = @"Search font";
    self.SearchBar.searchBarStyle = UISearchBarStyleMinimal ;
    
    self.fontSelectionView.layer.shadowRadius = 1.5f;
    self.fontSelectionView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.fontSelectionView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.fontSelectionView.layer.shadowOpacity = 0.5f;
    self.fontSelectionView.layer.masksToBounds = NO;
    //    self.fontSelectionView.layer.borderWidth=1.0f;
    //    self.fontSelectionView.layer.borderColor=[UIColor blackColor ].CGColor;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    [_fontSelectionView addGestureRecognizer:tapRecognizer];
    [_blurView addGestureRecognizer:singleTapRecognizer];
    _fontSelectionView.tag=1;
    _blurView.tag=2;
    
    font_Search_Selecting_View = self.font_Search_Selecting_View.frame;
    [[self.text_done_outlet imageView] setContentMode:UIViewContentModeScaleAspectFit];
    
    self.colorButton.layer.shadowRadius = 1.5f;
    self.colorButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.colorButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.colorButton.layer.shadowOpacity = 0.5f;
    self.colorButton.layer.masksToBounds = NO;
}

-(void)gestureHandlerMethod:(UITapGestureRecognizer*)sender {
    
    if(sender.view.tag == 1){
        CGRect frame = CGRectMake(0, self.topView.frame.size.height, self.topView.frame.size.width, self.view.frame.size.height-self.topView.frame.size.height);
        
        //frame.size.height = self.view.frame.size.height/2;
        [UIView animateWithDuration:0.5
                         animations:^{
                             _font_Search_Selecting_View.frame = frame;
                             [_SearchBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.font_Search_Selecting_View.frame.size.height/8)];
                             [_TableView setFrame:CGRectMake(0, _SearchBar.frame.size.height, self.view.frame.size.width, self.font_Search_Selecting_View.frame.size.height-_SearchBar.frame.size.height)];
                             
                             _blurView.hidden=NO;
                         }];
    }else{
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.view endEditing:YES];
                             [_font_Search_Selecting_View setFrame:font_Search_Selecting_View];
                             [_SearchBar setFrameHeight:0];
                             _blurView.hidden=YES;
                         }
                         completion:^(BOOL finished){
                         }];
    }
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(searchText.length == 0){
        isFiltered = false;
    }else{
        isFiltered = true;
        filteredFonts = [[NSMutableArray alloc]init];
        
        for(NSDictionary *dic in allFonts){
            NSString *font = [dic valueForKey:@"Font_Name"];
            NSRange nameRange = [font rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
                [filteredFonts addObject:dic];
        }
    }
    [self.TableView reloadData];
}

-(void)loadVideoAsset
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0), ^{
        
        while (CGSizeEqualToSize(CGSizeZero, self.naturalSize)) {
            @try {
                
                NSURL *videoURL=[[NSURL alloc] initWithString:self.playURL];
                AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
                _naturalSize = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
            } @catch (NSException *exception) {
                
            }
        }
        
    });
}

-(void)setBtnImage:(UIButton*)btn
{
    [[btn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
}

- (void)setFrameToFitImage
{
    
    tempLayerView.frame = tempLayerView.superview.bounds;
    NSLog(@"_naturalSize %f",_naturalSize.width);
    float widthRatio  = tempLayerView.bounds.size.width / _naturalSize.width;
    NSLog(@"_naturalSize %f",_naturalSize.height);
    
    float heightRatio = tempLayerView.bounds.size.height / _naturalSize.height;
    float scale = MIN(widthRatio, heightRatio);
    scale= scale+1;
    imageWidth  = scale * tempLayerView.frame.size.width;
    imageHeight = scale * tempLayerView.frame.size.height;
    
    //[tempLayerView setFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
    //[_SJplayer.control.view setFrame:CGRectMake(_SJplayer.control.view.frame.origin.x, _SJplayer.control.view.frame.origin.y, _SJplayer.control.view.frame.size.width, _SJplayer.control.view.frame.size.height)];
    
    tempLayerView.frame  = CGRectMake(0, 0, imageWidth, imageHeight);
    tempLayerView.center = CGPointMake(CGRectGetWidth(tempLayerView.superview.frame) / 2.0 , CGRectGetHeight(tempLayerView.superview.frame) / 2.0);
    [self calculateDiagonal];
}

- (void)calculateDiagonal
{
    CGRect rect = tempLayerView.frame;
    CGFloat seuareWidth  = CGRectGetWidth(rect) * CGRectGetWidth(rect);
    CGFloat seuareheight = CGRectGetHeight(rect) * CGRectGetHeight(rect);
    diagonal = sqrtf(seuareWidth + seuareheight);
    tempLayerView.frame = tempLayerView.superview.bounds;
    tempLayerView.center = tempLayerView.superview.center;
    
}

- (void)rotateWithAngle
{
    CGAffineTransform normal = CGAffineTransformIdentity;
    CGAffineTransform scale     = CGAffineTransformMakeScale([self calculateScaleForAngle:rotationAngle], [self calculateScaleForAngle:rotationAngle]);
    CGAffineTransform concate   = CGAffineTransformConcat(normal, scale);
    CGAffineTransform transform = CGAffineTransformRotate(concate, degreesToRadians(rotationAngle));
    
    //rotationAngle = angle;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^
     {
         tempLayerView.transform = transform;
     }
                     completion:^(BOOL finished)
     {
         
     }];
    
    [self setFrameToFitImage];
    if(rotationAngle==0)
        [self.SJplayer.presentView sizeToFit];
    
    
}



- (CGFloat)calculateScaleForAngle:(CGFloat)angle
{
    CGFloat minSideLength = MIN(tempLayerView.frame.size.width, tempLayerView.frame.size.height);
    
    angle = ABS(angle);
    
    CGFloat width = ((diagonal - minSideLength) / 45) * angle + minSideLength;
    
    CGFloat adjustment = 0;
    
    if(angle <= 22.5)
    {
        adjustment = (angle / 150);
    }
    else
    {
        adjustment = ((45 - angle) / 150);
    }
    
    CGFloat scale = (width / minSideLength) + adjustment;
    return scale;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    NSLog(@"viewDidDisappear");
    
    
    [imageResizableView removeFromSuperview];
    imageResizableView = nil;
    
    [hud hideAnimated:YES];
    
    self.currentTime = [SJVideoPlayer sharedPlayer].currentTime;
    
    [[SJVideoPlayer sharedPlayer] stop];
    //    delay(0.15,
    //          ^{
    //              [MKDropdownMenu closeAllComponentsAnimated:YES];
    //
    //              [MKDropdownMenu reloadAllComponents];
    //
    //          });
    
}


- (void)viewDidAppear:(BOOL)animated
{
    //tempLayerView = _SJplayer.presentView;
    NSLog(@"Did Appear");
    
    if (CGSizeEqualToSize(CGSizeZero, self.naturalSize))
        [self loadVideoAsset];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"uploadImage"])
    {
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"uploadImage"];
    }
    if(!isnan(_currentTime))
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.playURL] jumpedToTime:self.currentTime];
    else
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.playURL] jumpedToTime:0];
    //
    //    CGRect frame = _font_Search_Selecting_View.frame;
    //    frame.size.height = 0;
    //    [_font_Search_Selecting_View setFrame:frame];
    //    [self.font_Search_Selecting_View setNeedsDisplay];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.currentTime = [SJVideoPlayer sharedPlayer].currentTime;
    [[SJVideoPlayer sharedPlayer] stop];
    [self.languageSelect closeAllComponentsAnimated:YES];
    rotationAngle = 0;
    [self rotateWithAngle];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isWaterMarkVc"];
    
    
    /* [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];*/
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    //  [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"ball.png"] forState:UIControlStateNormal];
    //
    //    [self.sizeSlider setMinimumTrackImage:[[UIImage imageNamed:@"32-blue-dart-1.png"] stretchableImageWithLeftCapWidth:0.3 topCapHeight:0.0] forState:UIControlStateNormal];
    //
    //    [self.sizeSlider setMaximumTrackImage:[[UIImage imageNamed:@"32-blue-dart-1.png"] stretchableImageWithLeftCapWidth:0.3 topCapHeight:0.0] forState:UIControlStateNormal];
    
    //    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"32-blue-dart-1.png"] forState:UIControlStateNormal];
    
    [self.sizeSlider setThumbImage:[UIImage imageNamed:@"32-circle.png"] forState:UIControlStateNormal];
    [self.opacitySlider setThumbImage:[UIImage imageNamed:@"32-circle.png"] forState:UIControlStateNormal];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"imageUpload"])
    {
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"imageUpload"];
        
        textFlag = false;
        logoFlag = true;
        OrioFlag = false;
        
        self.Text_dot_icon.hidden = true;
        self.logoImage.hidden = false;
        self.orientationImage.hidden = true;
        
        self.textChange.hidden = true;
        self.logoTopView.hidden = true;
        self.logoBottomView.hidden = false;
        self.OrientationView.hidden = true;
        
        [self.text setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.logo setTitleColor:[self colorFromHexString:@"#409FE9"] forState:UIControlStateNormal];
        [self.orientation setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    }
    else
    {
        textFlag = true;
        logoFlag = false;
        OrioFlag = false;
        
        self.Text_dot_icon.hidden = false;
        self.logoImage.hidden = true;
        self.orientationImage.hidden = true;
        
        self.textChange.hidden = false;
        self.logoTopView.hidden = true;
        self.logoBottomView.hidden = true;
        self.OrientationView.hidden = true;
        
        CGFloat fontSizes = self.displayText.font.pointSize;
        
        self.sizeSlider.value = fontSizes;
        
        self.sizeDisplay.text = [@((int)fontSizes) stringValue];
        
        UIColor *clrs = self.displayText.textColor;
        
        const CGFloat *_components = CGColorGetComponents(clrs.CGColor);
        CGFloat alpha = _components[3];
        
        NSString* formattedNumber = [NSString stringWithFormat:@"%.01f", alpha];
        
        //    self.opacityDisplay.text=[@((float)self.opacitySlider.value) stringValue];
        
        self.opacityDisplay.text = formattedNumber;
        
        //        self.opacityDisplay.text = [@((CGFloat)alpha) stringValue];
        //        self.opacitySlider.value = alpha;
        
        
        self.opacitySlider.value = 1.0;
        
        self.opacityDisplay.text = @"1.0";
        
        NSString *fontName = self.displayText.font.fontName;
        
        [self.langSelection setTitle:fontName forState: UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"imageUpload"];
        
        UIColor *clr = self.displayText.textColor;
        self.colorButton.backgroundColor = clr;
        
        [self.text setTitleColor:[self colorFromHexString:@"#409FE9"] forState:UIControlStateNormal];
        [self.logo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.orientation setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    
    
}

/*
 -(UIImage*)widthSliderBackground
 {
 CGSize size = self.sizeSlider.frame.size;
 
 UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
 
 CGContextRef context = UIGraphicsGetCurrentContext();
 
 //   UIColor *color = [[[CLImageEditorTheme theme] toolbarTextColor] colorWithAlphaComponent:0.5];
 
 
 CGColorSpaceRef theSpace = CGColorSpaceCreateDeviceRGB();
 CGFloat theValues[] = {64/255.0, 153.0/255.0, 255.0/255.0, 1.0};
 CGColorRef theColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), theValues);
 
 CGFloat strRadius = 1;
 CGFloat endRadius = size.height/2 * 0.6;
 
 CGPoint strPoint = CGPointMake(strRadius + 5, size.height/2 - 2);
 CGPoint endPoint = CGPointMake(size.width-endRadius - 1, strPoint.y);
 
 CGMutablePathRef path = CGPathCreateMutable();
 CGPathAddArc(path, NULL, strPoint.x, strPoint.y, strRadius, -M_PI/2, M_PI-M_PI/2, YES);
 CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y + endRadius);
 CGPathAddArc(path, NULL, endPoint.x, endPoint.y, endRadius, M_PI/2, M_PI+M_PI/2, YES);
 CGPathAddLineToPoint(path, NULL, strPoint.x, strPoint.y - strRadius);
 
 CGPathCloseSubpath(path);
 
 CGContextAddPath(context, path);
 CGContextSetFillColorWithColor(context, theColor);
 CGContextFillPath(context);
 
 CGColorRelease(theColor);
 CGColorSpaceRelease(theSpace);
 
 UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
 
 CGPathRelease(path);
 
 UIGraphicsEndImageContext();
 
 return tmp;
 }
 */

- (IBAction)textAction:(id)sender
{
    textFlag = true;
    logoFlag = false;
    OrioFlag = false;
    
    self.Text_dot_icon.hidden = false;
    self.logoImage.hidden = true;
    self.orientationImage.hidden = true;
    
    self.textChange.hidden = false;
    self.logoTopView.hidden = true;
    self.logoBottomView.hidden = true;
    self.OrientationView.hidden = true;
    
    self.Text_Label.textColor = [UIColor navyBlue];
    self.logo_lbl.textColor = [UIColor darkGrayColor];
    self.Orientation_lbl.textColor = [UIColor darkGrayColor];
    
    _Text_Image.image = [UIImage imageNamed:@"128-text-purple"];
    _logo_image.image = [UIImage imageNamed:@"128-logo-Dark_gray"];
    _Orientation_img.image = [UIImage imageNamed:@"128-orientation-dark_gray"];
    
    //    [_Text_Image setImage:[UIImage imageNamed:@"128-Test.png"] forState:UIControlStateNormal];
    //    [sender setImage:[UIImage imageNamed:@"128-logo-Dark_gray.png"] forState:UIControlStateNormal];
    //    [sender setImage:[UIImage imageNamed:@"128-orientation-dark_gray"] forState:UIControlStateNormal];
}

- (IBAction)logoAction:(id)sender
{
    textFlag = false;
    logoFlag = true;
    OrioFlag = false;
    
    self.Text_dot_icon.hidden = true;
    self.logoImage.hidden = false;
    self.orientationImage.hidden = true;
    
    self.textChange.hidden = true;
    self.logoTopView.hidden = false;
    self.logoBottomView.hidden = true;
    self.OrientationView.hidden = true;
    
    
    
    
    self.Text_Label.textColor = [UIColor darkGrayColor];
    self.logo_lbl.textColor = [UIColor navyBlue];
    self.Orientation_lbl.textColor = [UIColor darkGrayColor];
    
    _Text_Image.image = [UIImage imageNamed:@"128-text"];
    _logo_image.image = [UIImage imageNamed:@"128-logo_purple"];
    _Orientation_img.image = [UIImage imageNamed:@"128-orientation-dark_gray"];
}


- (IBAction)orientationAction:(id)sender
{
    
    if (!CGSizeEqualToSize(CGSizeZero, self.naturalSize))
    {
        
        textFlag = false;
        logoFlag = false;
        OrioFlag = true;
        
        self.Text_dot_icon.hidden = true;
        self.logoImage.hidden = true;
        self.orientationImage.hidden = false;
        
        self.textChange.hidden = true;
        self.logoTopView.hidden = true;
        self.logoBottomView.hidden = true;
        self.OrientationView.hidden = false;
        
        self.Text_Label.textColor = [UIColor darkGrayColor];
        self.logo_lbl.textColor = [UIColor darkGrayColor];
        self.Orientation_lbl.textColor = [UIColor navyBlue];
        
        _Text_Image.image = [UIImage imageNamed:@"128-text"];
        _logo_image.image = [UIImage imageNamed:@"128-logo-Dark_gray"];
        _Orientation_img.image = [UIImage imageNamed:@"128-orientation-purple"];
        
    }
    else
    {
        [self.navigationController.view makeToast:@"Video is loading"];
    }
    
}

- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

//- (void)playSampleClip1
//{
//    NSURL *videoURL=[[NSURL alloc] initWithString:self.playURL];
//
//    [self playStream:videoURL];
//}

//- (void)playStream:(NSURL*)url
//{
///*    VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:url];
//    track.hasNext = YES;
//    [self.player loadVideoWithTrack:track];*/
//
//    [self.player loadVideoWithStreamURL:url];
//
//}


//- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event
//{
//    NSLog(@"%s event:%d", __FUNCTION__, event);
//    __weak __typeof(self) weakSelf = self;
//
//    if (event == VKVideoPlayerControlEventTapDone)
//    {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//
//    if (event == VKVideoPlayerControlEventTapCaption)
//    {
//        RUN_ON_UI_THREAD(^{
//            VKPickerButton *button = self.player.view.captionButton;
//            NSArray *subtitleList = @[@"JP", @"EN"];
//
//            if (button.isPresented)
//            {
//                [button dismiss];
//            }
//            else
//            {
//                weakSelf.player.view.controlHideCountdown = -1;
//                [button presentFromViewController:weakSelf title:NSLocalizedString(@"settings.captionSection.subtitleLanguageCell.text", nil) items:subtitleList formatCellBlock:^(UITableViewCell *cell, id item)
//                 {
//                     NSString* code = (NSString*)item;
//                     cell.textLabel.text = code;
//                     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%", @"50"];
//                 }
//                                  isSelectedBlock:^BOOL(id item)
//                 {
//                     return [item isEqualToString:weakSelf.currentLanguageCode];
//                 }
//                               didSelectItemBlock:^(id item)
//                 {
//                     //                [weakSelf setLanguageCode:item];
//                     [button dismiss];
//                 }
//                                  didDismissBlock:^{
//                                      weakSelf.player.view.controlHideCountdown = [weakSelf.player.view.playerControlsAutoHideTime integerValue];
//                                  }];
//            }
//        });
//    }
//}
//
//
//- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didChangeStateFrom:(VKVideoPlayerState)fromState
//{
//    NSLog(@"didChangeStateFrom");
//}
//
//- (void)videoPlayer:(VKVideoPlayer*)videoPlayer willChangeStateTo:(VKVideoPlayerState)toState
//{
//    NSLog(@"willChangeStateFrom");
//}


//- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didPlayToEnd:(id<VKVideoPlayerTrackProtocol>)track
//{
//    NSLog(@"didPlayToEnd");
//
//    [self playSampleClip1];
//
//}

- (IBAction)Bold:(id)sender
{
    textFontStyle = [selectedDic valueForKey:@"Font_Name"];
    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    NSRange range = [textFontStyle rangeOfCharacterFromSet:cset];
    if (range.location == NSNotFound) {
        
        if(italicSelected && !boldSelected){
            textFontStyle = [[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-BoldItalic"];
            [self downloadFont:[[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-BoldItalic"]];
            
        }else if(!italicSelected && !boldSelected){
            textFontStyle = [[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-Bold"];
            [self downloadFont:[[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-Bold"]];
            
        }else if(italicSelected && boldSelected){
            textFontStyle = [[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-Italic"];
            [self downloadFont:[[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-Italic"]];
        }else{
            textFontStyle = [selectedDic valueForKey:@"Font_Name"];
            [self downloadFont:[selectedDic valueForKey:@"Font_Name"]];
        }
        
    } else {
        if(italicSelected && !boldSelected){
            textFontStyle = [[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"BoldItalic"];
            [self downloadFont:[[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-BoldItalic"]];
            
        }else if(!italicSelected && !boldSelected){
            textFontStyle = [[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"Bold"];
            [self downloadFont:[[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-Bold"]];
            
        }else if(italicSelected && boldSelected){
            textFontStyle = [[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"Italic"];
            [self downloadFont:[[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-Italic"]];
        }else{
            textFontStyle = [selectedDic valueForKey:@"Font_Name"];
            [self downloadFont:[selectedDic valueForKey:@"Font_Name"]];
        }
    }
    
    
    if(boldSelected){
        boldSelected  = NO;
    }
    else{
        boldSelected = YES;
    }
    
    
   /* if(boldStatus)
    {
        boldStatus=false;
        
        self.displayText.font=[UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",self.displayText.font.fontName] size:self.displayText.font.pointSize];
        if([imageResizableView.contentView isKindOfClass:[UILabel class]]){
            UILabel *childLbl = (UILabel *)imageResizableView.contentView;
            childLbl.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",childLbl.font.fontName] size:childLbl.font.pointSize];
        }
    }
    
    else
    {
        boldStatus=true;
        self.displayText.font=boldFont;
        
    }*/
}
//{
//
//    NSString *font1 = lang;//self.langSelection.titleLabel.text;
//    NSLog(@"Clicked:%@",font1);
//
//    NSString *name =  self.displayText.font.fontName;
//
//    UIFont *font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Italic",name] size:self.displayText.font.pointSize];
//
//    UIFontDescriptor *fontDescriptor = font.fontDescriptor;
//    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
//    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold) != 0;
//
//    if (isBold)
//    {
//        self.displayText.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Italic",name] size:self.displayText.font.pointSize];
//    }
//    else
//    {
//        NSLog(@"No Bold");
//    }
//
//}

- (IBAction)Italic:(id)sender
{NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    NSRange range = [[selectedDic valueForKey:@"Font_Name"] rangeOfCharacterFromSet:cset];
    if (range.location == NSNotFound) {
        
        if((boldSelected && !italicSelected)){
            textFontStyle = [[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-BoldItalic"];
            [self downloadFont:[[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-BoldItalic"]];
        }else if((!boldSelected && !italicSelected)){
            textFontStyle = [[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-Italic"];
            [self downloadFont:[[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-Italic"]];
        }else if((boldSelected && italicSelected)){
            
            textFontStyle = [[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-Bold"];
            [self downloadFont:[[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-Bold"]];
        }else{
            textFontStyle = [selectedDic valueForKey:@"Font_Name"];
            [self downloadFont:[selectedDic valueForKey:@"Font_Name"]];
        }
        
    }else{
        if((boldSelected && !italicSelected)){
            textFontStyle = [[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"BoldItalic"];
            [self downloadFont:[[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-BoldItalic"]];
            italicSelected = YES;
            
        }else if((!boldSelected && !italicSelected)){
            textFontStyle = [[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"Italic"];
            [self downloadFont:[[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-Italic"]];
        }else if((boldSelected && italicSelected)){
            
            textFontStyle = [[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"Bold"];
            [self downloadFont:[[selectedDic valueForKey:@"Font_Name"] stringByAppendingString:@"-Bold"]];
        }else{
            textFontStyle = [selectedDic valueForKey:@"Font_Name"];
            [self downloadFont:[selectedDic valueForKey:@"Font_Name"]];
        }
    }
    if(italicSelected){
        italicSelected = NO;
    }
    else{
        italicSelected = YES;
    }
   /* if(italicStatus)
    {
        italicStatus=false;
        self.displayText.font=[UIFont fontWithName:[NSString stringWithFormat:@"%@-Italic",self.displayText.font.fontName] size:self.displayText.font.pointSize];
        if([imageResizableView.contentView isKindOfClass:[UILabel class]]){
            UILabel *childLbl = (UILabel *)imageResizableView.contentView;
            childLbl.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Italic",childLbl.font.fontName] size:childLbl.font.pointSize];
        }
    }
    
    else
    {
        italicStatus=true;
        self.displayText.font=italicFont;
    }*/
    
}
//{
//    NSString *name =  self.displayText.font.fontName;
//
//    UIFont *font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Italic",name] size:self.displayText.font.pointSize];
//
//    UIFontDescriptor *fontDescriptor = font.fontDescriptor;
//    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
//    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold) != 0;
//
//    if (isBold)
//    {
//        self.displayText.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Italic",name] size:self.displayText.font.pointSize];
//    }
//    else
//    {
//        NSLog(@"No Italic");
//    }
//
//}


- (IBAction)Increase:(id)sender
{
   
}

- (IBAction)Spacing:(id)sender
{
    
}

- (IBAction)sizeChange:(id)sender
{
    
    NSString *str = self.displayText.font.fontName;
    
    [self.displayText setFont:[UIFont fontWithName:str size:self.sizeSlider.value]];
    
    self.sizeDisplay.text = [@((int)self.sizeSlider.value) stringValue];
    boldFont=[UIFont fontWithName:self.displayText.font.fontName size:self.sizeSlider.value];
    italicFont=[UIFont fontWithName:self.displayText.font.fontName size:self.sizeSlider.value];
    
    //START
    if([imageResizableView.contentView isKindOfClass:[UILabel class]]){
        UILabel *childLbl = (UILabel *)imageResizableView.contentView;
        
        CGFloat fontSizes = self.sizeSlider.value;
        NSString *fontName = childLbl.font.fontName;
        UIFont *font = [UIFont fontWithName:fontName size:fontSizes];
        UIColor *clr = childLbl.textColor;
        NSDictionary *userAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: clr};
        NSString *text = childLbl.text;
        const CGSize textSize = [text sizeWithAttributes: userAttributes];
        CGRect imageFrame = CGRectMake(50, 50, textSize.width + 40, textSize.height + 30);
        [imageResizableView setFrame:imageFrame];
        [childLbl setFrame:CGRectMake(0, 20, textSize.width,textSize.height)];
        childLbl.font = font;
        
        //        UILabel *imageView = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, textSize.width,textSize.height)];
    }
    
    
}

- (IBAction)opacityChange:(id)sender
{
    opacity=self.opacitySlider.value;
    
    UIColor *currentcolor=self.displayText.textColor;
    //    CGFloat f=opacity/10;
    
    self.displayText.textColor = [currentcolor colorWithAlphaComponent:opacity];
    
    NSString* formattedNumber = [NSString stringWithFormat:@"%.01f", self.opacitySlider.value];
    
    //    self.opacityDisplay.text=[@((float)self.opacitySlider.value) stringValue];
    
    self.opacityDisplay.text = formattedNumber;
    
}

- (IBAction)uploadImage:(id)sender
{
    if (!CGSizeEqualToSize(CGSizeZero, self.naturalSize))
    {
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"uploadImage"];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        [self.navigationController.view makeToast:@"Video is loading"];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"imageUpload"];
    
    chosenImage = info[UIImagePickerControllerOriginalImage];
    //    self.imgView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.logoTopView.hidden = true;
    self.logoBottomView.hidden = false;
    
    self.btnImgView.image = chosenImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)edit_Atn:(id)sender
{
    if (!CGSizeEqualToSize(CGSizeZero, self.naturalSize))
    {
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"imageUpload"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageEditing:) name:@"imgEditing" object:nil];
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:chosenImage delegate:self];
        
        editor.delegate=self;
        
        [self.navigationController pushViewController:editor animated:YES];
    }
    else
    {
        [self.navigationController.view makeToast:@"Video is loading"];
    }
    
}

- (IBAction)ok_Atn:(id)sender
{
    NSLog(@"Done");
    
    //    for (UIView *temp in tempLayerView.subviews)
    //    {
    //
    //        [imageResizableView removeFromSuperview];
    //        imageResizableView = nil;
    //    }
    if(imageResizableView == nil){
        CGRect imageFrame = CGRectMake(50, 50, 100, 100);
        imageResizableView = [[SPUserResizableView alloc] initWithFrame:imageFrame];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:chosenImage];
    
    imageResizableView.contentView = imageView;
    imageResizableView.delegate = self;
    [self.SJplayer.view addSubview:imageResizableView];
    [imageResizableView removeBorder];
    [self.doneBtn setEnabled:YES];
    [self.doneBtn setTintColor: [UIColor whiteColor]];
}

- (IBAction)del_Atn:(id)sender
{
    if([imageResizableView.contentView isKindOfClass:[UIImageView class]]){
        UIImageView *childImg = (UIImageView *)imageResizableView.contentView;
        childImg.image = nil;
        [childImg setNeedsDisplay];
    }
    _btnImgView.image = nil;
    [_btnImgView setNeedsDisplay];
    chosenImage = nil;
    
    self.textChange.hidden = true;
    self.logoTopView.hidden = false;
    self.logoBottomView.hidden = true;
    self.OrientationView.hidden = true;
    
    [self.doneBtn setEnabled:NO];
    [self.doneBtn setTintColor: [UIColor clearColor]];
}

- (IBAction)plus_Atn:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"uploadImage"];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}


- (IBAction)clockWise:(id)sender
{
    isOrientationChanged = true;
    if (!CGSizeEqualToSize(CGSizeZero, _naturalSize)) {
        // do something
        
        if (rotation == 4)
        {
            rotation = 0;
        }
        else
        {
            rotation = rotation + 1;
        }
        
        if(rotationAngle == 360)
            rotationAngle = 90;
        else rotationAngle = rotationAngle + 90;
        
        NSLog(@"Clockwise");
        
        //        if (rotation == 4)
        //        {
        //            rotation = 0;
        //        }
        //        else
        //        {
        //            rotation = rotation + 1;
        //        }
        //
        //        if(rotationAngle == 360)
        //            rotationAngle = 90;
        //        else rotationAngle = rotationAngle + 90;
        //
        //        NSLog(@"Clockwise");
        //
        //        [self rotateWithAngle];
        
        
        
        [self rotateWithAngle];
    }else{
        
    }
    
}

- (IBAction)antiClockWise:(id)sender
{
    if (!CGSizeEqualToSize(CGSizeZero, _naturalSize)) {
        
        if (rotation == -4)
        {
            rotation = 0;
        }
        else
        {
            rotation = rotation - 1;
        }
        
        if(rotationAngle == 0)
            rotationAngle = 270;
        else rotationAngle = rotationAngle - 90;
        NSLog(@"Clockwise %f",rotationAngle);
        [self rotateWithAngle];
        
    }else{
        
    }
}

- (IBAction)horizontal:(id)sender
{
    if(!flipFlag)
    {
        NSLog(@"Hrizontal");
        
        tempLayerView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        [UIView transitionWithView:tempLayerView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations: ^{
                            // [self.backView removeFromSuperview];
                            //                            [self addSubview:self.frontView];
                        }
                        completion:NULL];
        
        //_SJplayer.presentView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        
        flipFlag = TRUE;
    }
    else
    {
        NSLog(@"Hrizontal else");
        
        // _SJplayer.presentView.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0);
        
        tempLayerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        [UIView transitionWithView:tempLayerView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations: ^{
                            //                            [self.backView removeFromSuperview];
                            //                            [self addSubview:self.frontView];
                        }
                        completion:NULL];
        
        flipFlag = FALSE;
        
    }
    
    
    
    tempLayerView.frame = tempLayerView.superview.bounds;
    tempLayerView.center = tempLayerView.superview.center;
}

- (IBAction)vertical:(id)sender
{
    
    if(!flopFlag)
    {
        NSLog(@"vertical");
        
        tempLayerView.transform = CGAffineTransformMakeScale(1.0, -1.0);
        
        [UIView transitionWithView:tempLayerView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromTop
                        animations: ^{
                            //                            [self.backView removeFromSuperview];
                            //                            [self addSubview:self.frontView];
                        }
                        completion:NULL];
        
        flopFlag=TRUE;
    }
    else
    {
        NSLog(@"vertical else");
        
        tempLayerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        [UIView transitionWithView:tempLayerView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromTop
                        animations: ^{
                            //                            [self.backView removeFromSuperview];
                            //                            [self addSubview:self.frontView];
                        }
                        completion:NULL];
        
        flopFlag=FALSE;
        
    }
    
    
    
    tempLayerView.frame = tempLayerView.superview.bounds;
    tempLayerView.center = tempLayerView.superview.center;
}


/*
 - (IBAction)clockWise:(id)sender
 {
 
 if(rotationAngle == 360)
 rotationAngle = 90;
 else rotationAngle = rotationAngle + 90;
 
 NSLog(@"Clockwise");
 //    NSURL *videoURL=[[NSURL alloc] initWithString:self.playURL];
 //    AVURLAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
 //    _naturalSize = [[[movieAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
 [self rotateWithAngle];
 
 }
 
 - (IBAction)antiClockWise:(id)sender
 {
 if(rotationAngle == 0)
 rotationAngle = 360;
 else rotationAngle = rotationAngle - 90;
 
 NSLog(@"Clockwise");
 //    NSURL *videoURL=[[NSURL alloc] initWithString:@"http://108.175.2.116/montage/api/edit_image/1805726850No_title.mp4"];
 //    AVURLAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
 //    _naturalSize = [[[movieAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
 [self rotateWithAngle];
 }
 
 - (IBAction)horizontal:(id)sender
 {
 if(!flipFlag)
 {
 NSLog(@"Hrizontal");
 
 tempLayerView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
 flipFlag = TRUE;
 }
 else
 {
 NSLog(@"Hrizontal else");
 
 tempLayerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
 flipFlag = FALSE;
 }
 }
 
 - (IBAction)vertical:(id)sender
 {
 if(!flopFlag)
 {
 NSLog(@"vertical");
 
 tempLayerView.transform = CGAffineTransformMakeScale(1.0, -1.0);
 flopFlag=TRUE;
 }
 else
 {
 NSLog(@"vertical else");
 
 tempLayerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
 flopFlag=FALSE;
 }
 }*/



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
 -(void)textFieldDidBeginEditing:(UITextField *)textField
 {
 [self animateTextField:textField up:YES];
 }
 
 - (void)textFieldDidEndEditing:(UITextField *)textField
 {
 [self animateTextField:textField up:NO];
 }
 
 -(void)animateTextField:(UITextField*)textField up:(BOOL)up
 {
 const int movementDistance = -130;
 const float movementDuration = 0.3f;
 
 int movement = (up ? movementDistance : -movementDistance);
 
 [UIView beginAnimations: @"animateTextField" context: nil];
 [UIView setAnimationBeginsFromCurrentState: YES];
 [UIView setAnimationDuration: movementDuration];
 self.view.frame = CGRectOffset(self.view.frame, 0, movement);
 [UIView commitAnimations];
 }
 */

- (IBAction)languageAction:(id)sender
{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Style" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Done"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    [picker show];
}


- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
               attributedTitleForRow:(NSInteger)row
{
    NSAttributedString *att = [[NSAttributedString alloc]
                               initWithString:fruits[row]
                               attributes:@{
                                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:15.0]
                                            }];
    return att;
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row
{
    return fruits[row];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isFiltered){
        return filteredFonts.count;
    }
    return allFonts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if(isFiltered){
        selectedDic = [allFonts objectAtIndex:indexPath.row];
        textFontStyle = [selectedDic valueForKey:@"Font_Name"];
        cell.textLabel.text = textFontStyle;
    }
    else{
        selectedDic = [allFonts objectAtIndex:indexPath.row];
        textFontStyle = [selectedDic valueForKey:@"Font_Name"];
        
        NSString *fontType = textFontStyle;//_fruits[indexPath.row];
        UIFont *font = [UIFont fontWithName:fontType size:15.0];
        cell.textLabel.text = fontType; //_fruits[indexPath.row];
        cell.textLabel.font = font;
    }
    
    cell.textLabel.textColor = [UIColor navyBlue];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedFontName;
    int BoldVal,ItalicVal;
    selectedDic = [allFonts objectAtIndex:indexPath.row];
    BoldVal = [[selectedDic valueForKey:@"Bold"] integerValue];
    ItalicVal = [[selectedDic valueForKey:@"Italic"] integerValue];
    _Bold_outlet.enabled = YES;
    _Italic_outlet.enabled = YES;
    textFontStyle = [selectedDic valueForKey:@"Font_Name"];
    [self downloadFont:[selectedDic valueForKey:@"Font_Name"]];
    if(BoldVal == 0){
        _Bold_outlet.enabled = NO;
    }if(ItalicVal == 0){
        _Italic_outlet.enabled = NO;
    }
    italicSelected = NO;
    boldSelected = NO;
    
    
    
    
    
    /*lang = fruits[indexPath.row];
    
    _SelectedFont_lbl.text = fruits[indexPath.row];
    self.SelectedFont_lbl.font=[UIFont fontWithName:fruits[indexPath.row] size:15];
    self.displayText.font = [UIFont fontWithName:fruits[indexPath.row] size:self.displayText.font.pointSize];
    if([imageResizableView.contentView isKindOfClass:[UILabel class]]){
        UILabel *childLbl = (UILabel *)imageResizableView.contentView;
        childLbl.font = [UIFont fontWithName:fruits[indexPath.row] size:childLbl.font.pointSize];
    }*/
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view endEditing:YES];
                         [_font_Search_Selecting_View setFrame:font_Search_Selecting_View];
                         [_SearchBar setFrameHeight:0];
                         _blurView.hidden=YES;
                     }
                     completion:^(BOOL finished){
                     }];
    
}
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView
{
    return fruits.count;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row
{
    NSLog(@"%@ is chosen!", fruits[row]);
    
    [self.langSelection setTitle:fruits[row] forState: UIControlStateNormal];
    
    self.displayText.font = [UIFont fontWithName:fruits[row] size:self.displayText.font.pointSize];
    
    //  UIFont *newFont = [UIFont fontWithName:self.fruits[row] size:fontSize];
    //self.displayText.font = newFont;
    
    //    [self.navigationController setNavigationBarHidden:YES];
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows
{
    
}

- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView
{
    //    [self.navigationController setNavigationBarHidden:YES];
    NSLog(@"Canceled.");
}

- (void)czpickerViewWillDisplay:(CZPickerView *)pickerView
{
    NSLog(@"Picker will display.");
}

- (void)czpickerViewDidDisplay:(CZPickerView *)pickerView
{
    NSLog(@"Picker did display.");
}

- (void)czpickerViewWillDismiss:(CZPickerView *)pickerView
{
    NSLog(@"Picker will dismiss.");
}

- (void)czpickerViewDidDismiss:(CZPickerView *)pickerView
{
    NSLog(@"Picker did dismiss.");
}



- (IBAction)colorPicker:(UIButton*)sender
{
    
    [popoverController presentPopoverFromRect:self.colorButton.frame
                                       inView:self.colorButton.superview
                     permittedArrowDirections:WYPopoverArrowDirectionAny
                                     animated:YES
                                      options:WYPopoverAnimationOptionFadeWithScale];
    
}

- (IBAction)addText:(id)sender
{
    
    if (self.displayText.text.length == 0)
    {
        [self.displayText resignFirstResponder];
        
        //        [self.view endEditing:YES];
        
        
        /*        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please Enter some text" preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
         [alertController addAction:ok];
         
         [self presentViewController:alertController animated:YES completion:nil];*/
    }
    else
    {
        
        for (UIView *temp in self.SJplayer.view.subviews)
        {
            [imageResizableView removeFromSuperview];
            imageResizableView = nil;
        }
        
        //  CGRect labelRect = [self.displayText.text
        //                        boundingRectWithSize:self.displayText.frame.size
        //                        options:NSStringDrawingUsesLineFragmentOrigin
        //                        attributes:@{
        //                                     NSFontAttributeName : [UIFont systemFontOfSize:fontSizes]
        //                                     }
        //                        context:nil];
        CGFloat fontSizes = self.displayText.font.pointSize;
        NSString *fontName = self.displayText.font.fontName;
        
        UIFont *font = [UIFont fontWithName:fontName size:fontSizes];
        
        UIColor *clr = self.displayText.textColor;
        
        NSDictionary *userAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: clr};
        
        NSString *text = self.displayText.text;
        
        const CGSize textSize = [text sizeWithAttributes: userAttributes];
        
        CGRect imageFrame = CGRectMake(50, 50, textSize.width + 40, textSize.height + 30);
        
        imageResizableView = [[SPUserResizableView alloc] initWithFrame:imageFrame];
        
        UILabel *Lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, textSize.width, textSize.height)];
        
        Lbl.attributedText = self.displayText.attributedText;
        
        imageResizableView.contentView = Lbl;
        imageResizableView.delegate = self;
        [self.SJplayer.view addSubview:imageResizableView];
        [imageResizableView removeBorder];
        //self.displayText.text = nil;
        
        [self.displayText resignFirstResponder];
        [self.doneBtn setEnabled:YES];
        [self.doneBtn setTintColor: [UIColor whiteColor]];
        // [self animateTextField:self.displayText up:NO];
    }
}

- (IBAction)Done:(id)sender
{
    //UILabel *content = (UILabel *)[imageResizableView.contentView];
    //    [self.player pauseContent];
    //    [self.player setAvPlayer:nil];
    //    [self.player setState:VKVideoPlayerStateDismissed];
    
    CGSize size = [imageResizableView bounds].size;
    UIGraphicsBeginImageContextWithOptions(size,NO,2.0);
    [[imageResizableView.contentView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *drawingViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    float screenWidth = self.SJplayer.view.frame.size.width;
    float screenHeight = self.SJplayer.view.frame.size.height;
    
    NSLog(@"screenWidth = %f",screenWidth);
    NSLog(@"screenHeight = %f",screenHeight);
    
    float imageX = imageResizableView.frame.origin.x;
    float imageY = imageResizableView.frame.origin.y;
    
    NSLog(@"imageX = %f",imageX);
    NSLog(@"imageY = %f",imageY);
    
    x = (imageX / screenWidth)*100;
    y = (imageY / screenHeight)*100;
    
    NSData *logoData = UIImagePNGRepresentation(drawingViewImage);
    
    NSLog(@"logoData = %lu",(unsigned long)logoData.length);
        if (logoData.length == 0)
        {
    //        UIAlertController * alert = [UIAlertController
    //                                     alertControllerWithTitle:@"Alert"
    //                                     message:@"You are not change watermark !"
    //                                     preferredStyle:UIAlertControllerStyleAlert];
    //
    //        //Add Buttons
    //
    //        UIAlertAction* yesButton = [UIAlertAction
    //                                    actionWithTitle:@"Ok"
    //                                    style:UIAlertActionStyleDefault
    //                                    handler:nil];
    //
    //
    //        [alert addAction:yesButton];
    //        [self presentViewController:alert animated:YES completion:nil];
    
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"You din't make any changes" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.backgroundColor = [UIColor lightGreen];
    popUp.accessibilityHint = @"";
    popUp.agreeBtn.hidden = YES;
    popUp.cancelBtn.hidden = YES;
    popUp.inputTextField.hidden = YES;
    [popUp show];
    
        }else
        {
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Save Changes?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.hidden = YES;
            popUp.accessibilityHint = @"SaveChanges";
            popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
            popUp.cancelBtn.backgroundColor = [UIColor darkGrayColor];
            popUp.inputTextField.hidden = YES;
            [popUp show];
            
            
    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"randomVideoID"];
    //if(logoData == nil)
    [self sendComplete:logoData nxt:str];

     }
}


-(void)sendComplete:(NSData*)data nxt:(NSString*)s
{
    NSString *Url;
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Section"] isEqualToString:@"BUSINESS_TEMPLATES"]){
        
        Url = @"https://www.hypdra.com/api/api.php?rquest=business_template_watermark_pay";
        
    }else if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Section"] isEqualToString:@"WIZARD"]){
        
       Url = @"https://www.hypdra.com/api/api.php?rquest=wizard_watermark_pay";
        
    }else{
        
        Url = @"https://www.hypdra.com/api/api.php?rquest=advance_watermark_pay";
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading...", @"HUD loading title");
    
    NSMutableURLRequest *requests = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:Url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                     {
                                         UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(200, 200, 300, 300)];
                                         im.image = [UIImage imageWithData:data];
                                         // [self.view addSubview:im];
                                         [formData appendPartWithFileData:data name:@"logo" fileName:@"uploads.png" mimeType:@"image/jpeg"];
                                         
                                         [formData appendPartWithFormData:[s dataUsingEncoding:NSUTF8StringEncoding] name:@"video_id"];
                                         
                                         [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding] name:@"lang"];
                                         
                                         [formData appendPartWithFormData:[user_id dataUsingEncoding:NSUTF8StringEncoding] name:@"User_ID"];
                                         
                                         [formData appendPartWithFormData:[[NSString stringWithFormat:@"%f",x] dataUsingEncoding:NSUTF8StringEncoding] name:@"x_position"];
                                         
                                         [formData appendPartWithFormData:[[NSString stringWithFormat:@"%f",y] dataUsingEncoding:NSUTF8StringEncoding] name:@"y_position"];
                                         
                                          [formData appendPartWithFormData:[[NSString stringWithFormat:@"%f",imageResizableView.frame.size.width] dataUsingEncoding:NSUTF8StringEncoding] name:@"width"];
                                         
                                          [formData appendPartWithFormData:[[NSString stringWithFormat:@"%f",imageResizableView.frame.size.height] dataUsingEncoding:NSUTF8StringEncoding] name:@"height"];
                                         
                                         if (rotation == 0)
                                         {
                                             [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"video_position"];
                                         }
                                         else
                                         {
                                             [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",rotation] dataUsingEncoding:NSUTF8StringEncoding] name:@"video_position"];
                                         }
                                         
                                         if (flip == 0)
                                         {
                                             [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"flip_value"];
                                         }
                                         else
                                         {
                                             [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",flip] dataUsingEncoding:NSUTF8StringEncoding] name:@"flip_value"];
                                         }
                                         if (flop == 0)
                                         {
                                             [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"flop_value"];
                                         }
                                         else
                                         {
                                             [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",flop] dataUsingEncoding:NSUTF8StringEncoding] name:@"flop_value"];
                                         }
                                         
                                     } error:nil];
    [request setTimeoutInterval:120];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:requests
                  progress:^(NSProgress * _Nonnull uploadProgress)
                  {
                      dispatch_async(dispatch_get_main_queue(),
                                     ^{
                                         [MBProgressHUD HUDForView:self.navigationController.view].progress = uploadProgress.fractionCompleted;
                                         
                                     });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                  {
                      if (error)
                      {
                          NSLog(@"Error For Image: %@", error);
                          [hud hideAnimated:YES];

                          CustomPopUp *popUp = [CustomPopUp new];
                          [popUp initAlertwithParent:self withDelegate:self withMsg:@"Upload failed" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                          popUp.okay.backgroundColor = [UIColor navyBlue];
                          popUp.accessibilityValue =@"UploadFailed";
                          popUp.agreeBtn.hidden = YES;
                          popUp.cancelBtn.hidden = YES;
                          popUp.inputTextField.hidden = YES;
                          [popUp show];
                          
                      }
                      else
                      {
                          
                          NSDictionary *responsseObject=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                          
                          NSLog(@"Response For Image:%@",responsseObject);
                          
                          [hud hideAnimated:YES];
                          
                         
                          [self.navigationController popToRootViewControllerAnimated:YES];

                          
                          if (responsseObject == NULL)
                          {
                              
                          }
                          else
                          {
                              if ([[responsseObject objectForKey:@"status"] isEqualToString:@"Success"])
                              {
                                  
                              }
                              else
                              {
                                  
                              }
                          }
                          
                      }
                  }];
    
    [uploadTask resume];
    
}




-(BOOL)setImageParams:(NSData *)imgData imageID:(NSString *)videoId
{
    @try
    {
        if (imgData!=nil)
        {
            NSLog(@"image not equal to nil");
            
            request = [NSMutableURLRequest new];
            request.timeoutInterval = 60.0;
            [request setURL:[NSURL URLWithString:URL]];
            [request setHTTPMethod:@"POST"];
            //[request setCachePolicy:NSURLCacheStorageNotAllowed];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
            
            
            [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
            
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"logo\"; filename=\"%@.jpg\"\r\n", @"uploads"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imgData];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"video_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[videoId dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"User_ID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[user_id dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"x_position\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%f",x] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"y_position\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%f",y] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"video_position\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            if (rotation == 0)
            {
                [body appendData:[[NSString stringWithFormat:@"%s",""] dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            else
            {
                [body appendData:[[NSString stringWithFormat:@"%d",rotation] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"flip_value\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            if (flip == 0)
            {
                [body appendData:[[NSString stringWithFormat:@"%@",@""] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                [body appendData:[[NSString stringWithFormat:@"%d",flip] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"flop_value\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            if (flop == 0)
            {
                [body appendData:[[NSString stringWithFormat:@"%@",@""] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                [body appendData:[[NSString stringWithFormat:@"%d",flop] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lang\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"After Values");
            [request setHTTPBody:body];
            NSLog(@"From Body");
            [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
            NSLog(@"After Content length");
            
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Send Image Exception = %@",exception);
    }
    @finally
    {
        NSLog(@"Send Image Finally...");
    }
}

- (void)colorViewController:(MSColorSelectionViewController *)colorViewCntroller didChangeColor:(UIColor *)color
{
    
    opacity=self.opacitySlider.value;
    
    self.displayText.textColor = [color colorWithAlphaComponent:opacity];
    
    self.colorButton.backgroundColor = color;
    if([imageResizableView.contentView isKindOfClass:[UILabel class]]){
        UILabel *childLbl = (UILabel *)imageResizableView.contentView;
        childLbl.textColor = [color colorWithAlphaComponent:opacity];;
    }
    
    
}


- (void)ms_dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component
{
    return 60;
}


- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu
{
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component
{
    
    //    NSLog(@"No of Rows");
    
    return [fruits count];
}

/*
 - (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForComponent:(NSInteger)component
 {
 
 if (dropdownMenu == self.minutesList)
 {
 return min;
 }
 else
 {
 return spc;
 }
 
 return @"";
 
 }*/


- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component
{
    
    UIFont *font;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        font = [UIFont fontWithName:lang size:14.0];
    }
    else
    {
        font = [UIFont fontWithName:lang size:14.0];
    }
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    NSAttributedString *attrString;
    
    attrString = [[NSAttributedString alloc] initWithString:lang attributes:attrsDictionary];
    
    return attrString;
    
}


/*
 - (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component
 {
 
 if (dropdownMenu == self.minutesList)
 {
 return minAry[row];
 }
 else
 {
 return SpcAry[row];
 }
 
 return @"";
 
 }
 */


- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    UIFont *font;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        font = [UIFont fontWithName:fruits[row] size:14.0];
    }
    else
    {
        font = [UIFont fontWithName:fruits[row] size:14.0];
    }
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    NSAttributedString *attrString;
    
    attrString = [[NSAttributedString alloc] initWithString:fruits[row] attributes:attrsDictionary];
    
    return attrString;
}
-(void)imageEditing:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imgEditing" object:nil];
    
    NSLog(@"CLI dta:%@",notification.userInfo);
    NSDictionary *dic=notification.userInfo;
    NSData *imageData=[dic objectForKey:@"total"];
    chosenImage = [UIImage imageWithData:imageData];
    self.btnImgView.image = chosenImage;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imgEditing" object:nil];
  
}
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    [editor dismissViewControllerAnimated:YES completion:nil];
    chosenImage = image;
    self.logoTopView.hidden = true;
    self.logoBottomView.hidden = false;
    
    
}
- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imgEditing" object:nil];
    //    [self refreshImageView];
}
- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    /*    NSString *colorString = self.colors[row];
     self.textLabel.text = colorString;
     
     UIColor *color = UIColorWithHexString(colorString);
     self.view.backgroundColor = color;
     //    self.childViewController.shapeView.strokeColor = color;
     
     delay(0.15, ^{
     [dropdownMenu closeAllComponentsAnimated:YES];
     });*/
    
    lang = fruits[row];
    
    
    [self.langSelection setTitle:fruits[row] forState: UIControlStateNormal];
    
    self.displayText.font = [UIFont fontWithName:fruits[row] size:self.displayText.font.pointSize];
    
    
    delay(0.15,
          ^{
              [dropdownMenu closeAllComponentsAnimated:YES];
              
              [dropdownMenu reloadAllComponents];
              
          });
}

static inline void delay(NSTimeInterval delay, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}


//Declare a delegate, assign your textField to the delegate and then include these methods

#pragma mark - keyboard movements


/*
 -(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
 return YES;
 }
 
 
 - (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
 
 [self.view endEditing:YES];
 return YES;
 }
 
 
 - (void)keyboardDidShow:(NSNotification *)notification
 {
 // Assign new frame to your view
 //    [self.view setFrame:CGRectMake(0,-110,320,460)];
 
 [self.view setFrameOriginY:-130];
 
 //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
 
 }
 
 -(void)keyboardDidHide:(NSNotification *)notification
 {
 //    [self.view setFrame:CGRectMake(0,0,320,460)];
 
 [self.view setFrameOriginY:0];
 
 }
 */


- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    float newVerticalPosition = -130;
    
    [self moveFrameToVerticalPosition:newVerticalPosition forDuration:0.3f];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    [self moveFrameToVerticalPosition:0.0f forDuration:0.3f];
}


- (void)moveFrameToVerticalPosition:(float)position forDuration:(float)duration {
    CGRect frame = self.view.frame;
    frame.origin.y = position;
    
    
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = frame;
        
        NSLog(@"My view frame: %@", NSStringFromCGRect(self.view.frame));
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)loadVideoPlayer
{
    _SJplayer = [SJVideoPlayer sharedPlayer];
    
    [_SJplayer.containerView addSubview:_SJplayer.self.control.view];
    _SJplayer.control.isCircularView=NO;
    
    //SJVideoPlayerControlView *cv = _SJplayer.control.view
    [_SJplayer.presentView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.offset(0);
     }];
    
    [_SJplayer.control.view mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.offset(0);
     }];
    [self.topView addSubview:_SJplayer.view];
    
    
    if (IS_PAD)
    {
        [_SJplayer.view mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.offset(0);
             make.leading.trailing.offset(0);
             
             make.height.equalTo(_SJplayer.view.mas_width).multipliedBy(9.0 / 16);
         }];
    }
    else
    {
        [_SJplayer.view mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.offset(0);
             make.leading.trailing.offset(0);
             
             make.height.equalTo(_SJplayer.view.mas_width).multipliedBy(9.0 / 12.5);
         }];
    }
    
    
    //    self.topView.backgroundColor = [UIColor redColor];
    
    
#pragma mark - AssetURL
    
    //    player.assetURL = [[NSBundle mainBundle] URLForResource:@"sample.mp4" withExtension:nil];
    
    //    player.assetURL = [NSURL URLWithString:@"http://streaming.youku.com/live2play/gtvyxjj_yk720.m3u8?auth_key=1525831956-0-0-4ec52cd453761e1e7f551decbb3eee6d"];
    
    //    player.assetURL = [NSURL URLWithString:@"http://video.cdn.lanwuzhe.com/1493370091000dfb1"];
    
    //    player.assetURL = [NSURL URLWithString:@"http://vod.lanwuzhe.com/9da7002189d34b60bbf82ac743241a61/d0539e7be21a4f8faa9fef69a67bc1fb-5287d2089db37e62345123a1be272f8b.mp4?video="];
    
    
#pragma mark - Setting Player
    
    [_SJplayer playerSettings:^(SJVideoPlayerSettings * _Nonnull settings)
     {
         settings.traceColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                               green:arc4random() % 256 / 255.0
                                                blue:arc4random() % 256 / 255.0
                                               alpha:1];
         settings.trackColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                               green:arc4random() % 256 / 255.0
                                                blue:arc4random() % 256 / 255.0
                                               alpha:1];
         settings.bufferColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                                green:arc4random() % 256 / 255.0
                                                 blue:arc4random() % 256 / 255.0
                                                alpha:1];
         settings.replayBtnTitle = @"Replay";
         settings.replayBtnFontSize = 12;
     }];
    
    
    
#pragma mark - Loading Placeholder
    
    //    player.placeholder = [UIImage imageNamed:@"sj_video_player_placeholder"];
    
    
    
#pragma mark - 1 Level More Settings
    
    SJVideoPlayerMoreSetting.titleFontSize = 12;
    
    SJVideoPlayerMoreSetting *model0 = [[SJVideoPlayerMoreSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_video_like_n"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        NSLog(@"clicked %@", model.title);
        [[SJVideoPlayer sharedPlayer] showTitle:@"Sample"];
    }];
    
    SJVideoPlayerMoreSetting *model2 = [[SJVideoPlayerMoreSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_video_favorite_n"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        NSLog(@"clicked %@", model.title);
        [[SJVideoPlayer sharedPlayer] showTitle:model.title];
    }];
    
    
#pragma mark - 2 Level More Settings
    
    SJVideoPlayerMoreSettingTwoSetting *twoS0 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:nil clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [[SJVideoPlayer sharedPlayer] showTitle:model.title];
    }];
    
    SJVideoPlayerMoreSettingTwoSetting *twoS1 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:nil clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [[SJVideoPlayer sharedPlayer] showTitle:model.title];
    }];
    
#pragma mark - 1 Level More Settings
    
    SJVideoPlayerMoreSetting *model1 =
    [[SJVideoPlayerMoreSetting alloc] initWithTitle:@""
                                              image:[UIImage imageNamed:@"db_audio_play_download_n"]
                                     showTowSetting:YES
                                 twoSettingTopTitle:@""
                                    twoSettingItems:@[twoS0, twoS1]
                                    clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {}];
    
    
#pragma mark - 2 Level More Settings
    
    SJVideoPlayerMoreSettingTwoSetting.topTitleFontSize = 14;
    
    SJVideoPlayerMoreSettingTwoSetting *twoSetting0 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"QQ" image:[UIImage imageNamed:@"db_login_qq"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [[SJVideoPlayer sharedPlayer] showTitle:model.title];
    }];
    
    SJVideoPlayerMoreSettingTwoSetting *twoSetting1 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_login_weibo"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [[SJVideoPlayer sharedPlayer] showTitle:model.title];
    }];
    
    SJVideoPlayerMoreSettingTwoSetting *twoSetting2 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_login_weixin"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [[SJVideoPlayer sharedPlayer] showTitle:model.title];
    }];
    
    SJVideoPlayerMoreSetting *model3 =
    [[SJVideoPlayerMoreSetting alloc] initWithTitle:@""
                                              image:[UIImage imageNamed:@"db_audio_play_share_n"]
                                     showTowSetting:YES
                                 twoSettingTopTitle:@""
                                    twoSettingItems:@[twoSetting0, twoSetting1, twoSetting2]  // 2级 Settings
                                    clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {}];
    
    [_SJplayer moreSettings:^(NSMutableArray<SJVideoPlayerMoreSetting *> * _Nonnull moreSettings)
     {
         /*        [moreSettings addObject:model0];
          [moreSettings addObject:model1];
          [moreSettings addObject:model2];
          [moreSettings addObject:model3];*/
     }];
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"UploadFailed"]){
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DEMORootViewController *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc1 awakeFromNib:@"demo_pageselection" arg:@"menuController"];
        
        vc1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc1 animated:YES completion:nil];
    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
        
    }
    [alertView hide];
    alertView = nil;
}

- (void)agreeCLicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
    }
    [alertView hide];
    alertView = nil;
}
-(void)loadFonts
{
    @try
    {
        NSString *fontUrl = @"https://www.hypdra.com/font_api.php";
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:fontUrl parameters:nil error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add paramerets to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              
              if (!error)
              {
                  
                  allFonts = responseObject;
                  
                  [self.TableView reloadData];
                  
                  int BoldVal,ItalicVal;
                  selectedDic = [allFonts objectAtIndex:0];
                  BoldVal = [[selectedDic valueForKey:@"Bold"] integerValue];
                  ItalicVal = [[selectedDic valueForKey:@"Italic"] integerValue];
                  _Bold_outlet.enabled = YES;
                  _Italic_outlet.enabled = YES;
                  textFontStyle = [selectedDic valueForKey:@"Font_Name"];
                  [self downloadFont:[selectedDic valueForKey:@"Font_Name"]];
                  if(BoldVal == 0){
                      _Bold_outlet.enabled = NO;
                  }if(ItalicVal == 0){
                      _Italic_outlet.enabled = NO;
                  }
                  italicSelected = NO;
                  boldSelected = NO;
                  
                  
                  [hud hideAnimated:YES];
                  
              }
              else
              {
                  
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
              }
              
          }]resume];
        
    }@catch(NSException *exception)
    {
        
    }
}
-(void)downloadFont:(NSString *)fontName{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    
    //NSString *dataUrl = @"http://seekitechdemo.com/ttf/OpenSans-ExtraBoldItalic.ttf";
    NSString *baseURL = @"https://www.hypdra.com/ios_fonts/";//OpenSans-ExtraBoldItalic.ttf";
    NSString *dataUrl = [baseURL stringByAppendingString:fontName];
    dataUrl = [dataUrl stringByAppendingString:@".ttf"];
    NSURL *url = [NSURL URLWithString:dataUrl];
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // 4: Handle response here
        if (error == nil) {
            NSLog(@"no error!");
            if (data != nil) {
                NSLog(@"There is data!");
                [self loadFont:data withName:fontName];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [downloadTask resume];
}
- (void)loadFont:(NSData *)data withName:(NSString *)Name
{
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if(!CTFontManagerRegisterGraphicsFont(font, &error)){
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(provider);
    dispatch_async(dispatch_get_main_queue(), ^{
        lang = textFontStyle;
        
        _SelectedFont_lbl.text = textFontStyle;
        self.SelectedFont_lbl.font=[UIFont fontWithName:textFontStyle size:15];
        self.displayText.font = [UIFont fontWithName:textFontStyle size:self.displayText.font.pointSize];
        if([imageResizableView.contentView isKindOfClass:[UILabel class]]){
            UILabel *childLbl = (UILabel *)imageResizableView.contentView;
            childLbl.font = [UIFont fontWithName:textFontStyle size:childLbl.font.pointSize];
        }
        [hud hideAnimated:YES];
        
    });
}

- (IBAction)UpperLowerCase_btn:(id)sender {
    if(isIncrease==1)
    {
        NSString *txt=self.displayText.text;
        self.displayText.text=[txt lowercaseString];
        if([imageResizableView.contentView isKindOfClass:[UILabel class]]){
            UILabel *childLbl = (UILabel *)imageResizableView.contentView;
            childLbl.text = [childLbl.text lowercaseString];
        }
        isIncrease=2;
    }
    else if(isIncrease==2)
    {
        NSString *txt=self.displayText.text;
        self.displayText.text=[txt uppercaseString];
        if([imageResizableView.contentView isKindOfClass:[UILabel class]]){
            UILabel *childLbl = (UILabel *)imageResizableView.contentView;
            childLbl.text = [childLbl.text uppercaseString];
        }
        isIncrease=3;
    }
    else if (isIncrease==3)
    {
        NSString *txt=self.displayText.text;
        self.displayText.text= [txt capitalizedString];
        if([imageResizableView.contentView isKindOfClass:[UILabel class]]){
            UILabel *childLbl = (UILabel *)imageResizableView.contentView;
            childLbl.text = [childLbl.text capitalizedString];
        }
        isIncrease=1;
    }
}
@end

