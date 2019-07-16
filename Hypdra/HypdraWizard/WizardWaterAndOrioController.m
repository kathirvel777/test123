//
//  WizardWaterAndOrioController.m
//  Montage
//
//  Created by MacBookPro on 7/5/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "WizardWaterAndOrioController.h"
#import "VKVideoPlayerViewController.h"
#import "VKVideoPlayerView.h"
#import "CZPicker.h"
#import <QuartzCore/QuartzCore.h>
#import "MSColorPicker.h"
#import "WYPopoverController.h"
#import "MSColorPicker.h"
#import "MBProgressHUD.h"
#import "DEMORootViewController.h"
#import "AFNetworking.h"
#import "UIView+Toast.h"
#import "SJVideoPlayer.h"
#import "SJVideoPlayerControl.h"
#import <Masonry.h>
#import "UIView+Toast.h"
#import "CLImageEditor.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"


#define kRotateRight -M_PI/2
#define kRotateLeft  M_PI/2

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
//#define URL @"https://www.hypdra.com/api/api.php?rquest=wizard_watermark_pay"

CGFloat degreesTooRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};

@interface WizardWaterAndOrioController ()<VKVideoPlayerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,CZPickerViewDataSource, CZPickerViewDelegate,WYPopoverControllerDelegate,MSColorSelectionViewControllerDelegate,CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate,ClickDelegates>
{
    MSColorSelectionViewController *colorSelectionController;
    BOOL textFlag,logoFlag,OrioFlag,flipFlag,flopFlag;
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
    
    NSString *appDir,*Pathdir,*user_id,*lang;
    NSMutableURLRequest *request;
    int rotation,flip,flop;
    float x,y;
}

@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;
@property NSArray *fruits;
@property CZPickerView *pickerWithImage;


@end

@implementation WizardWaterAndOrioController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isWaterMarkVc"];
    
    [self loadVideoPlayer];
    
    lang = @"Select Font";
    
    //    self.player = [[VKVideoPlayer alloc] init];
    //    self.player.delegate = self;
    //    self.player.view.frame = self.topView.bounds;
    //    self.player.view.playerControlsAutoHideTime = @10;
    //    [self.topView addSubview:self.player.view];
    
    tempLayerView  = _SJplayer.presentView;
    
    //[self.topView addSubview:self.SJplayer.view];
    [self calculateDiagonal];
    isIncrease=1;
    self.displayText.delegate = self;
    
    //    NSURL *videoURL=[[NSURL alloc] initWithString:self.playURL];
    
    //     AVURLAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    //     _naturalSize = [[[movieAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
    
    self.fruits = @[@"Baskerville",@"Baskerville-SemiBold",@"Baskerville-Italic",@"BodoniOrnamentsITCTT",@"BodoniSvtyTwoITCTT-BookIta",@"Baskerville-Bold",@"ChalkboardSE-Light",@"Chalkduster",@"Cochin",@"Copperplate",@"Courier",@"Damascus",@"DevanagariSangamMN",@"Farah",@"Helvetica-Light",@"Helvetica-Oblique",@"HelveticaNeue-Italic",@"HelveticaNeue",@"IowanOldStyle",@"Kailasa",@"ArialMT",@"Arial-BoldItalicMT",@"Arial-ItalicMT",@"ArialHebrew",@"ArialHebrew-Bold",@"AmericanTypewriter-Bold",@"AmericanTypewriter-CondensedBold",@"AmericanTypewriter-Light"];
    
    [self setBtnImage:self.clockWiseBtn];
    [self setBtnImage:self.antiClockWiseBtn];
    [self setBtnImage:self.horizontalBtn];
    [self setBtnImage:self.verticalBtn];
    [self setBtnImage:self.logoPlus];
    [self setBtnImage:self.editBtn];
    [self setBtnImage:self.okBtn];
    [self setBtnImage:self.delBtn];
    
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
    
    //        navCtrl.delegate = self;
    
    popoverController = [[WYPopoverController alloc ]initWithContentViewController:navCtrl];
    
    popoverController.delegate = self;
    
    colorSelectionController.delegate = self;
    
    colorSelectionController.color = [UIColor whiteColor];
    
    popoverController.popoverContentSize = CGSizeMake(250, 500);
    }

-(void)loadVideoAsset
{
    
    
    /*    dispatch_group_t sub_group=dispatch_group_create();
     dispatch_group_enter(sub_group);
     NSURL *videoURL=[[NSURL alloc] initWithString:self.playURL];
     
     AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
     dispatch_group_leave(sub_group);
     dispatch_group_notify(sub_group, dispatch_get_main_queue(), ^{
     
     NSLog(@"Loaded Video Asset");
     _naturalSize = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
     });*/
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0),
                   ^{
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


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    NSLog(@"viewDidDisappear");
    
    [imageResizableView removeFromSuperview];
    imageResizableView = nil;
    
    [hud hideAnimated:YES];
    
    self.currentTime = [SJVideoPlayer sharedPlayer].currentTime;
    
    [[SJVideoPlayer sharedPlayer] stop];
    
}


-(void)setBtnImage:(UIButton*)btn
{
    [[btn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

- (void)rotateWithAngle
{
    CGAffineTransform normal = CGAffineTransformIdentity;
    CGAffineTransform scale     = CGAffineTransformMakeScale([self calculateScaleForAngle:rotationAngle], [self calculateScaleForAngle:rotationAngle]);
    CGAffineTransform concate   = CGAffineTransformConcat(normal, scale);
    CGAffineTransform transform = CGAffineTransformRotate(concate, degreesTooRadians(rotationAngle));
    
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
        [self.SJplayer.view sizeToFit];
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


- (void)viewDidAppear:(BOOL)animated
{
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    /*[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];*/
    
    self.currentTime = [SJVideoPlayer sharedPlayer].currentTime;
    [[SJVideoPlayer sharedPlayer] stop];
    rotationAngle = 0;
    [self rotateWithAngle];
    [self.SJplayer.view sizeToFit];
    [self.languageSelect closeAllComponentsAnimated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isWaterMarkVc"];
    
    self.opacitySlider.value = 1.0;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    
    //    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"ball.png"] forState:UIControlStateNormal];
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
        
        self.textImage.hidden = true;
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
        
        self.textImage.hidden = false;
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

- (IBAction)textAction:(id)sender
{
    textFlag = true;
    logoFlag = false;
    OrioFlag = false;
    
    self.textImage.hidden = false;
    self.logoImage.hidden = true;
    self.orientationImage.hidden = true;
    
    self.textChange.hidden = false;
    self.logoTopView.hidden = true;
    self.logoBottomView.hidden = true;
    self.OrientationView.hidden = true;
    
    [self.text setTitleColor:[self colorFromHexString:@"#409FE9"] forState:UIControlStateNormal];
    [self.logo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.orientation setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
}

- (IBAction)logoAction:(id)sender
{
    textFlag = false;
    logoFlag = true;
    OrioFlag = false;
    
    self.textImage.hidden = true;
    self.logoImage.hidden = false;
    self.orientationImage.hidden = true;
    
    self.textChange.hidden = true;
    self.logoTopView.hidden = false;
    self.logoBottomView.hidden = true;
    self.OrientationView.hidden = true;
    
    [self.text setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.logo setTitleColor:[self colorFromHexString:@"#409FE9"] forState:UIControlStateNormal];
    [self.orientation setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
}


- (IBAction)orientationAction:(id)sender
{
    
    if (!CGSizeEqualToSize(CGSizeZero, self.naturalSize))
    {
        textFlag = false;
        logoFlag = false;
        OrioFlag = true;
        
        self.textImage.hidden = true;
        self.logoImage.hidden = true;
        self.orientationImage.hidden = false;
        
        self.textChange.hidden = true;
        self.logoTopView.hidden = true;
        self.logoBottomView.hidden = true;
        self.OrientationView.hidden = false;
        
        [self.text setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.logo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.orientation setTitleColor:[self colorFromHexString:@"#409FE9"] forState:UIControlStateNormal];
    }
    else
    {
        [self.navigationController.view makeToast:@"Video is loading.."];
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
//
//- (void)playStream:(NSURL*)url
//{
///*    VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:url];
//    track.hasNext = YES;
//    [self.player loadVideoWithTrack:track];*/
//
//    [self.player loadVideoWithStreamURL:url];
//
//}
//
//
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
//
//
//- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didPlayToEnd:(id<VKVideoPlayerTrackProtocol>)track
//{
//    NSLog(@"didPlayToEnd");
//
//    [self playSampleClip1];
//
//}

- (IBAction)Bold:(id)sender
{
    NSString *font1 = lang;//self.langSelection.titleLabel.text;
    NSLog(@"Clicked:%@",font1);
    
    NSString *name =  self.displayText.font.fontName;
    
    UIFont *font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Italic",name] size:self.displayText.font.pointSize];
    
    UIFontDescriptor *fontDescriptor = font.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold) != 0;
    
    if (isBold)
    {
        self.displayText.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Italic",name] size:self.displayText.font.pointSize];
    }
    else
    {
        NSLog(@"No Bold");
    }
    
}

- (IBAction)Italic:(id)sender
{
    NSString *name =  self.displayText.font.fontName;
    
    UIFont *font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Italic",name] size:self.displayText.font.pointSize];
    
    UIFontDescriptor *fontDescriptor = font.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold) != 0;
    
    if (isBold)
    {
        self.displayText.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Italic",name] size:self.displayText.font.pointSize];
    }
    else
    {
        NSLog(@"No Italic");
    }
    
}


- (IBAction)Increase:(id)sender
{
    if(isIncrease==1)
    {
        NSString *txt=self.displayText.text;
        self.displayText.text=[txt lowercaseString];
        isIncrease=2;
    }
    else if(isIncrease==2)
    {
        NSString *txt=self.displayText.text;
        self.displayText.text=[txt uppercaseString];
        isIncrease=3;
    }
    else if (isIncrease==3)
    {
        NSString *txt=self.displayText.text;
        self.displayText.text= [txt capitalizedString];
        isIncrease=1;
    }
}

- (IBAction)Spacing:(id)sender
{
    
}

- (IBAction)sizeChange:(id)sender
{
    
    NSString *str = self.displayText.font.fontName;
    
    [self.displayText setFont:[UIFont fontWithName:str size:self.sizeSlider.value]];
    
    //    self.displayText.font = [UIFont systemFontOfSize:self.sizeSlider.value];
    self.sizeDisplay.text = [@((int)self.sizeSlider.value) stringValue];
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
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:chosenImage delegate:self];
        
        [self presentViewController:editor animated:YES completion:nil];
    }
    else
    {
        [self.navigationController.view makeToast:@"Video is loading"];
    }
}




- (IBAction)ok_Atn:(id)sender
{
    NSLog(@"Done");
    
    //    for (UIView *temp in self.videoResizable.subviews)
    //    {
    //        //[imageResizableView removeFromSuperview];
    //       // imageResizableView = nil;
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
    
    
    //    self.videoResizable.backgroundColor = [UIColor redColor];
}

- (IBAction)del_Atn:(id)sender
{
    float screenWidth = self.videoResizable.frame.size.width;
    float screenHeight = self.videoResizable.frame.size.height;
    
    NSLog(@"screenWidth = %f",screenWidth);
    NSLog(@"screenHeight = %f",screenHeight);
    
    float imageX = imageResizableView.frame.origin.x;
    float imageY = imageResizableView.frame.origin.y;
    
    NSLog(@"imageX = %f",imageX);
    NSLog(@"imageY = %f",imageY);
    
    float finalX = (imageX / screenWidth)*100;
    float finalY = (imageY / screenHeight)*100;
    
    NSLog(@"finalX = %f",finalX);
    NSLog(@"finalY = %f",finalY);
    
    NSLog(@"Decode");
    
    NSLog(@"X = %f",(finalX * screenWidth)/100);
    
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
    
    if (!CGSizeEqualToSize(CGSizeZero, _naturalSize)) {
        // do something
        
        if (rotation == 4)
        {
            rotation = 0;
            [self.SJplayer.view sizeToFit];
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
        flip = 1;
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
        
        flip = 2;
    }
    
    tempLayerView.frame = tempLayerView.superview.bounds;
    
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
        
        flop = 1;
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
        
        flop = 2;
        
    }
    
    tempLayerView.frame = tempLayerView.superview.bounds;
    
}


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
 
 NSLog(@"My view frame: %@", NSStringFromCGRect(self.view.frame));
 
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
                               initWithString:self.fruits[row]
                               attributes:@{
                                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:15.0]
                                            }];
    return att;
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row
{
    return self.fruits[row];
}

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView
{
    return self.fruits.count;
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row
{
    NSLog(@"%@ is chosen!", self.fruits[row]);
    
    [self.langSelection setTitle:self.fruits[row] forState: UIControlStateNormal];
    
    self.displayText.font = [UIFont fontWithName:self.fruits[row] size:self.displayText.font.pointSize];
    
    //  UIFont *newFont = [UIFont fontWithName:self.fruits[row] size:fontSize];
    //self.displayText.font = newFont;
    
    //    [self.navigationController setNavigationBarHidden:YES];
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows
{
    /*    for (NSNumber *n in rows)
     {
     NSInteger row = [n integerValue];
     
     NSLog(@"%@ is chosen!", self.fruits[row]);
     }*/
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



- (IBAction)colorPicker:(id)sender
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
        
        //        [self.displayText resignFirstResponder];
        
        //        [self textFieldShouldReturn:self.displayText];
        
        
        //        [self.navigationController.view makeToast:@"Please Enter some text"];
        
        [self.displayText resignFirstResponder];
        
        //
        
        
        /*        [UIView animateWithDuration:0.5
         delay:0.1
         options: UIViewAnimationOptionTransitionNone
         animations:^
         {
         }
         completion:^(BOOL finished)
         {
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please Enter some text" preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
         [alertController addAction:ok];
         
         [self presentViewController:alertController animated:YES completion:nil];
         }];
         */
        
    }
    else
    {
        
        for (UIView *temp in self.SJplayer.view.subviews)
        {
            [imageResizableView removeFromSuperview];
            imageResizableView = nil;
        }
        
        CGFloat fontSizes = self.displayText.font.pointSize;
        
        //    CGRect labelRect = [self.displayText.text
        //                        boundingRectWithSize:self.displayText.frame.size
        //                        options:NSStringDrawingUsesLineFragmentOrigin
        //                        attributes:@{
        //                                     NSFontAttributeName : [UIFont systemFontOfSize:fontSizes]
        //                                     }
        //                        context:nil];
        
        NSString *fontName = self.displayText.font.fontName;
        
        UIFont *font = [UIFont fontWithName:fontName size:fontSizes];
        
        UIColor *clr = self.displayText.textColor;
        
        NSDictionary *userAttributes = @{NSFontAttributeName: font,
                                         NSForegroundColorAttributeName: clr};
        NSString *text = self.displayText.text;
        
        const CGSize textSize = [text sizeWithAttributes: userAttributes];
        
        CGRect imageFrame = CGRectMake(50, 50, textSize.width + 20, textSize.height + 20);
        
        imageResizableView = [[SPUserResizableView alloc] initWithFrame:imageFrame];
        
        UILabel *imageView = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, textSize.width, textSize.height)];
        
        imageView.attributedText = self.displayText.attributedText;
        
        imageResizableView.contentView = imageView;
        imageResizableView.delegate = self;
        [self.SJplayer.view addSubview:imageResizableView];
        [imageResizableView removeBorder];
        self.displayText.text = nil;
        
        [self.displayText resignFirstResponder];
        
        //        [self textFieldShouldReturn:self.displayText];
    }
    
}

- (IBAction)Done:(id)sender
{
    //UILabel *content = (UILabel *)[imageResizableView.contentView];
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDModeDeterminate;
    //    hud.progress = progress;
    
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    CGSize size = [imageResizableView bounds].size;
    UIGraphicsBeginImageContextWithOptions(size,NO,2.0);
    [[imageResizableView.contentView layer] renderInContext:UIGraphicsGetCurrentContext()];
    NSLog(@"ERROR HERE2");
    UIImage *drawingViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    x = imageResizableView.frame.origin.x;
    y = imageResizableView.frame.origin.y;
    
    
    //    UIImageView *tem = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, imageResizableView.frame.size.width, imageResizableView.frame.size.height)];
    //    tem.image=drawingViewImage;
    
    //    [self.videoResizable addSubview:tem];
    
    NSData *logoData = UIImagePNGRepresentation(drawingViewImage);
    
    NSString *str = self.finalRndID;//[[NSUserDefaults standardUserDefaults]valueForKey:@"randomVideoID"];
    
    
    
    
    if (logoData.length == 0)
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"You didn't change watermark" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        
        
        
        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"randomVideoID"];
        
        [self sendComplete:logoData nxt:str];
        
    }
    
    
    
    /*    if( [self setImageParams:logoData imageID:str])
     {
     NSLog(@"Enter block");
     
     NSOperationQueue *queue = [NSOperationQueue mainQueue];
     
     [NSURLConnection sendAsynchronousRequest:request
     queue:queue
     completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
     {
     
     NSLog(@"User ID = %@",user_id);
     NSLog(@"Video ID = %@",str);
     //             NSLog(@"Ori = %d",rotation);
     //             NSLog(@"Logo = %@",logoData);
     
     
     NSLog(@"Video Sent Response = %@",urlResponse);
     
     
     [hud hideAnimated:YES];
     
     //             [self.navigationController popViewControllerAnimated:YES];
     
     
     UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     
     PageSelectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PageSelection"];
     
     vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
     
     [self presentViewController:vc animated:YES completion:NULL];
     
     }];
     
     NSLog(@"Image Sent");
     }
     else
     {
     [hud hideAnimated:YES];
     
     NSLog(@"Image Failed...");
     }*/
    
}



-(void)sendComplete:(NSData*)data nxt:(NSString*)s
{
    NSString *URL;
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Section"] isEqualToString:@"BUSINESS_TEMPLATES"]){
        
        URL = @"https://www.hypdra.com/api/api.php?rquest=business_template_watermark_pay";
    }else{
        
        URL = @"https://www.hypdra.com/api/api.php?rquest=wizard_watermark_pay";
    }

    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading...", @"HUD loading title");
    
    NSMutableURLRequest *requests = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                     {
                                         
                                         [formData appendPartWithFileData:data name:@"logo" fileName:@"uploads.png" mimeType:@"image/jpeg"];
                                         
                                         [formData appendPartWithFormData:[s dataUsingEncoding:NSUTF8StringEncoding] name:@"video_id"];
                                         
                                         [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding] name:@"lang"];
                                         
                                         [formData appendPartWithFormData:[user_id dataUsingEncoding:NSUTF8StringEncoding] name:@"User_ID"];
                                         
                                         [formData appendPartWithFormData:[[NSString stringWithFormat:@"%f",x] dataUsingEncoding:NSUTF8StringEncoding] name:@"x_position"];
                                         
                                         [formData appendPartWithFormData:[[NSString stringWithFormat:@"%f",y] dataUsingEncoding:NSUTF8StringEncoding] name:@"y_position"];
                                         
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
                          [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your upload could not be completed.\nTry again ?" withTitle:@"Upload failed" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                          popUp.okay.backgroundColor = [UIColor navyBlue];
                          popUp.accessibilityHint =@"UploadFailed";
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
                          
                          UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                          DEMORootViewController *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
                          
                          [vc1 awakeFromNib:@"demo_pageselection" arg:@"menuController"];
                          
                          vc1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                          [self presentViewController:vc1 animated:YES completion:nil];
                          
                          if (responseObject == NULL)
                          {
                              
                          }
                          else
                          {
                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"Success"])
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










- (void)colorViewController:(MSColorSelectionViewController *)colorViewCntroller didChangeColor:(UIColor *)color
{
    
    //    self.view.backgroundColor = color;
    //    self.displayText.textColor = color;
    
    opacity=self.opacitySlider.value;
    
    //    UIColor *currentcolor=self.displayText.textColor;
    //    CGFloat f=opacity/10;
    
    self.displayText.textColor = [color colorWithAlphaComponent:opacity];
    
    self.colorButton.backgroundColor = color;
    
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
    
    return [self.fruits count];
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
        font = [UIFont fontWithName:_fruits[row] size:14.0];
    }
    else
    {
        font = [UIFont fontWithName:_fruits[row] size:14.0];
    }
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    NSAttributedString *attrString;
    
    attrString = [[NSAttributedString alloc] initWithString:_fruits[row] attributes:attrsDictionary];
    
    return attrString;
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
    
    lang = _fruits[row];
    
    
    [self.langSelection setTitle:_fruits[row] forState: UIControlStateNormal];
    
    self.displayText.font = [UIFont fontWithName:_fruits[row] size:self.displayText.font.pointSize];
    
    
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
-(void)loadVideoPlayer
{
    _SJplayer = [SJVideoPlayer sharedPlayer];
    [_SJplayer.containerView addSubview:_SJplayer.self.control.view];
    _SJplayer.control.isCircularView=NO;

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
@end

