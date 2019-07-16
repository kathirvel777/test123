//
//  CreateButtonsViewController.m
//  Montage
//
//  Created by MacBookPro on 6/29/17.
//  Copyright © 2017 sssn. All rights reserved.

#import "CreateButtonsViewController.h"
#import "SPUserResizableView.h"
#import "MSColorPicker.h"
#import "WYPopoverController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "CallToActionTabViewController.h"
#import "CallToActionPlayerController.h"
#import "CallToActionTabViewController.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import <CoreText/CoreText.h>

#define kDefaultFontSize 100.0
#define URL @"https://www.hypdra.com/api/api.php?rquest=user_call_to_action_button"

@interface CreateButtonsViewController ()<SPUserResizableViewDelegate,WYPopoverControllerDelegate,MSColorSelectionViewControllerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,ClickDelegates,UITextFieldDelegate>
{
    int cornerradius,fontSize,sliderValue;;
    BOOL CreateShape,CreateText,CreateLogo,Flag;
    UIColor *globalColor;
    UIImagePickerController *picker;
    WYPopoverController *popoverController;
    CGFloat opacity;
    NSMutableURLRequest *request;
    MBProgressHUD *hud;
    NSString *user_id,*headerValue,*shapeBgColor,*textBgColor,*TextSize,*TextFont,*shapeBorderColor;
    BOOL textcolorPicker,shapeColorPicker,fromTextDoneBtn,borderColorPicker,isFiltered,boldSelected,italicSelected;
    UIColor *selectedTextColor,*selectedBorderColor;
    NSDictionary *selectedDic;
    NSString *MainText,*textFontSize,*TextViewX,*TextViewY,*TextViewHeight,*TextViewWidth,*textFontStyle,*borderWidth,*borderRadius,*mainShapeHeight,*mainShapeWidth;
    NSMutableArray *filteredFonts;
    CGRect font_Search_Selecting_View;
    NSMutableArray *allFonts;
}

@property NSArray *fruits;

@end

@implementation CreateButtonsViewController

- (void)viewDidLoad
{
    headerValue = @"Choose Font";
    CreateShape=YES;
    CreateText=YES;
    CreateLogo = YES;
    
    //self.sizeIndicator.layer.cornerRadius=10.0f;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    [defaults setInteger:2 forKey:@"SelectedIndex"];
    [defaults synchronize];
    selectedTextColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    selectedBorderColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    shapeBgColor = @"Null";
    shapeBorderColor = @"Null";
    textBgColor = @"Null";
    
    NSLog(@"loading");
    //self.fruits  = @[@"Baskerville-SemiBold",@"Baskerville-Italic",@"BodoniSvtyTwoITCTT-BookIta",@"Baskerville-Bold",@"ChalkboardSE-Light",@"Chalkduster",@"Cochin",@"Copperplate",@"Courier",@"Damascus",@"DevanagariSangamMN",@"Farah",@"Helvetica-Light",@"Helvetica-Oblique",@"HelveticaNeue-Italic",@"Helvetica Neue",@"Kailasa",@"ArialMT",@"Arial-BoldItalicMT",@"Arial-ItalicMT",@"ArialHebrew",@"ArialHebrew-Bold",@"AmericanTypewriter-Bold",@"AmericanTypewriter-CondensedBold",@"AmericanTypewriter-Light"];
    
    self.fruits = @[@"OpenSans-Bold",@"OpenSans-BoldItalic",@"OpenSans-ExtraBold",@"OpenSans-ExtraBoldItalic",@"OpenSans-Italic",@"OpenSans-Light",@"OpenSans-LightItalic",@"OpenSans-Regular",@"OpenSans-Semibold",@"OpenSans-SemiboldItalic"];
    headerValue = self.fruits[0];
    _currentWindow = [UIApplication sharedApplication].keyWindow;
    
    _BlurView = [[UIView alloc]initWithFrame:CGRectMake(_currentWindow.frame.origin.x, _currentWindow.frame.origin.y, _currentWindow.frame.size.width, _currentWindow.frame.size.height)];
    
    _BlurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(cancel:)
     name:@"sendCloseAlert"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(SaveToCollection:)
     name:@"SaveToCollection"
     object:nil];
    
    [self initialize];
    [[self.colorNew_outlet imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.color_outlet imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.createShape imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.TextDoneOutlet imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.createText imageView] setContentMode: UIViewContentModeScaleAspectFit];
    self.widthValueIndicator.layer.cornerRadius=5;
    self.radiusValueIndicator.layer.cornerRadius=5;
    _widthValueIndicator.clipsToBounds = YES;
    _radiusValueIndicator.clipsToBounds = YES;
    
    [self.BorderSlider_outlet setThumbImage:[UIImage imageNamed:@"10-blue-dart"] forState:UIControlStateNormal];
    
    [self.size_Slider_Outlet setThumbImage:[UIImage imageNamed:@"10-blue-dart"] forState:UIControlStateNormal];
    
    [self.radius_Slider_outlet setThumbImage:[UIImage imageNamed:@"10-blue-dart"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *createShapeTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleCreateShape:)];
    [self.createShapeViewGesture addGestureRecognizer:createShapeTap];
    
    UITapGestureRecognizer *createTextTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleCreateText:)];
    [self.createTextViewGesture addGestureRecognizer:createTextTap];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"CreateButton"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    self.TableView.separatorColor = [UIColor clearColor];
    self.SearchBar.delegate = self;
    self.SearchBar.placeholder = @"Search font";
    self.SearchBar.searchBarStyle = UISearchBarStyleMinimal ;
    
    self.fontSelectionView .layer.shadowRadius = 1.5f;
    self.fontSelectionView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.fontSelectionView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.fontSelectionView.layer.shadowOpacity = 0.5f;
    self.fontSelectionView.layer.masksToBounds = NO;
    //self.fontSelectionView.layer.borderWidth=1.0f;
    //self.fontSelectionView.layer.borderColor=[UIColor blackColor ].CGColor;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    [_fontSelectionView addGestureRecognizer:tapRecognizer];
    [_blurView addGestureRecognizer:singleTapRecognizer];
    _fontSelectionView.tag=1;
    _blurView.tag=2;
    
    font_Search_Selecting_View = self.font_Search_Selecting_View.frame;
    [[self.TextDoneOutlet imageView] setContentMode:UIViewContentModeScaleAspectFit];
    _EnterTextField.delegate = self;
//    self.TextDoneOutlet.layer.shadowRadius = 2.0f;
//    self.TextDoneOutlet.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.TextDoneOutlet.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    self.TextDoneOutlet.layer.shadowOpacity = 0.5f;
//    self.TextDoneOutlet.layer.masksToBounds = NO;
    //self.TextDoneOutlet.layer.borderWidth=1.0f;
    allFonts = [[NSMutableArray alloc]init];
    [self loadFonts];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//
//    [dic setValue:@"SourceSansPro-Black" forKey:@"Font_Name"];
//    [dic setValue:@"0" forKey:@"Bold"];
//    [dic setValue:@"1" forKey:@"Italic"];
//    [dic setValue:@"0" forKey:@"BoldItalic"];
//    [dic setValue:@"23" forKey:@"Font_id"];
//     [allFonts addObject:dic];
//
//    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]init];
//
//    [dic2 setValue:@"SourceSansPro-ExtraLight" forKey:@"Font_Name"];
//    [dic2 setValue:@"1" forKey:@"Bold"];
//    [dic2 setValue:@"0" forKey:@"Italic"];
//    [dic2 setValue:@"0" forKey:@"BoldItalic"];
//    [dic2 setValue:@"23" forKey:@"Font_id"];
//    [allFonts addObject:dic2];
//
//    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
//
//    [dic1 setValue:@"SourceSansPro" forKey:@"Font_Name"];
//    [dic1 setValue:@"1" forKey:@"Bold"];
//    [dic1 setValue:@"1" forKey:@"Italic"];
//    [dic1 setValue:@"1" forKey:@"BoldItalic"];
//    [dic1 setValue:@"1" forKey:@"Font_id"];
//    [allFonts addObject:dic1];

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
        
        headerValue = textFontStyle;
        _contentTextView.font=[UIFont fontWithName:textFontStyle size:(int)self.contentTextView.font.pointSize];
        _font_style = textFontStyle;
        _SelectedFont_lbl.text = textFontStyle;//_fruits[indexPath.row];
        self.SelectedFont_lbl.font=[UIFont fontWithName:textFontStyle size:15];
        [hud hideAnimated:YES];
        
    });
}

-(void)gestureHandlerMethod:(UITapGestureRecognizer*)sender {
    
    if(sender.view.tag == 1){
        CGRect frame = CGRectMake(0, self.DrawingBoard.frame.size.height , self.view.frame.size.width, self.view.frame.size.height-self.DrawingBoard.frame.size.height);
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
        
        
        //NSString *fontType = _fruits[indexPath.row];
        //UIFont *font = [UIFont fontWithName:fontType size:15.0];
        cell.textLabel.text = textFontStyle;
        //cell.textLabel.font = font;
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
    
    
//    headerValue = [selectedDic valueForKey:@"Font_Name"];
//    _contentTextView.font=[UIFont fontWithName:self.fruits[indexPath.row] size:(int)self.contentTextView.font.pointSize];
//    _font_style = headerValue;
//    
//    
//    _SelectedFont_lbl.text = _fruits[indexPath.row];
//    self.SelectedFont_lbl.font=[UIFont fontWithName:_fruits[indexPath.row] size:15];
//    
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)handleCreateShape:(UITapGestureRecognizer *)recognizer
{
    [self createShapeFn];
}

- (void)handleCreateText:(UITapGestureRecognizer *)recognizer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callToAction" object:nil];
    [self ceateTextfn];
    
}

- (void)cancel:(NSNotification*)notification
{
    _contentTextView.text=@"";
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    
    [[self.TextDoneOutlet imageView] setContentMode:UIViewContentModeScaleAspectFit];
    
    
    
    _color_outlet.layer.cornerRadius = 4;//_color_outlet.frame.size.width/2;
    _color_outlet.layer.masksToBounds = YES;
    self.color_outlet.layer.shadowRadius = 1.5f;
    self.color_outlet.layer.shadowColor = [UIColor blackColor].CGColor;
    self.color_outlet.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.color_outlet.layer.shadowOpacity = 0.5f;
    self.color_outlet.layer.masksToBounds = NO;
    //self.color_outlet.layer.borderWidth=1.0f;
    //self.color_outlet.layer.borderColor=[UIColor blackColor ].CGColor;
    
    _colorNew_outlet.layer.cornerRadius = 4;//_colorNew_outlet.frame.size.width/2;
    _colorNew_outlet.layer.masksToBounds = YES;
    self.colorNew_outlet.layer.shadowRadius = 1.5f;
    self.colorNew_outlet.layer.shadowColor = [UIColor blackColor].CGColor;
    self.colorNew_outlet.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.colorNew_outlet.layer.shadowOpacity = 0.5f;
    self.colorNew_outlet.layer.masksToBounds = NO;
    self.colorNew_outlet.layer.borderWidth=2.0f;
    //self.colorNew_outlet.layer.borderColor=[UIColor blackColor ].CGColor;
    
    
    _TextColorPicker.layer.cornerRadius = 4;//_TextColorPicker.frame.size.width/2;
    _TextColorPicker.layer.masksToBounds = YES;
    self.TextColorPicker.layer.shadowRadius = 1.5f;
    self.TextColorPicker.layer.shadowColor = [UIColor blackColor].CGColor;
    self.TextColorPicker.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.TextColorPicker.layer.shadowOpacity = 0.5f;
    self.TextColorPicker.layer.masksToBounds = NO;
    //self.TextColorPicker.layer.borderWidth=1.0f;
    //self.TextColorPicker.layer.borderColor=[UIColor blackColor ].CGColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Reset:) name:@"ResetCreateButton" object:nil];
    [self createShapeFn];
}
-(void)Reset:(NSNotification *)notify{
    
    
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Do you want to reset?" withTitle:@"Reset" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.backgroundColor = [UIColor lightGreen];
    popUp.accessibilityHint = @"Reset";
    popUp.agreeBtn.hidden = YES;
    popUp.cancelBtn.hidden = YES;
    popUp.inputTextField.hidden = YES;
    [popUp show];
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"Reset"]){
        [_mainResizableView setFrame:CGRectMake(100, 100, 200, 100)];
        _mainResizableView.contentView.backgroundColor = [UIColor whiteColor];
        
        shapeBorderColor = [self hexStringFromColor:[UIColor grayColor]];
        _color_outlet.backgroundColor = [UIColor grayColor];
        
        
        _mainResizableView.contentView.layer.cornerRadius = 6;
        _radiusValueIndicator.text = @"3";
        [_radius_Slider_outlet setValue:3.0];
        
        
        [self.mainResizableView.contentView.layer
         setBorderWidth:2];
        self.mainResizableView.contentView.layer.borderColor=[UIColor grayColor].CGColor;
        _widthValueIndicator.text=@"2";
        [_BorderSlider_outlet setValue:2.0];
        _colorNew_outlet.backgroundColor = [UIColor blackColor];
        
        
        _sizeIndicator.text= @"15";
        _contentTextView.text = @"Click";
        [_size_Slider_Outlet setValue:15.0];
        _contentTextView.textColor = [UIColor redColor];
        _TextColorPicker.backgroundColor = [UIColor redColor];
        _EnterTextField.text = @"";

    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}
- (void)agreeCLicked:(CustomPopUp *)alertView{
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    NSLog(@"willAppear");
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"CreateButton"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"ReEdit"]){
        _isReEdit = YES;
        NSLog(@"ReEdit_YES");
        [self ReEdit];
        if(![self.text isEqualToString:@"Null"]){
            fontSize = _text_size;
            self.contentTextView.textColor = [UIColor colorWithCGColor:_text_color.CGColor];
            [self.contentTextView setFont:[UIFont fontWithName:_font_style size:_text_size]];
            self.contentTextView.text = _text;
            
            [self.contentTextView setFont:[UIFont fontWithName:_font_style size:_text_size]];
            [self ResizeText];
            //            fromTextDoneBtn = NO;
            //            [self ceateTextfn];
            //            [self TextDoneFn];
            _TextColorPicker.backgroundColor =_text_color;
        }
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ReEdit"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else{
        _isReEdit = NO;
        NSLog(@"ReEdit_NO");
    }
}

-(void)ReEdit{
    [self createShapeFn];
}
- (void)checkdel
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialize{
    NSLog(@"initialize");
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HideBorderColour"];
    _mainResizableView = [[SPUserResizableView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    
    // _TextViewSuperView = [[UIView alloc]initWithFrame:_mainResizableView.bounds];
    //UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    //    _textResizableView = [[SPUserResizableView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    //    self.ResizeTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //    self.textResizableView.accessibilityHint =@"TextView";
    
    self.contentTextView = [[UILabel alloc] initWithFrame:_mainResizableView.bounds];
    self.contentTextView.numberOfLines=0;
    self.contentTextView.lineBreakMode=YES;
    [self.contentTextView sizeToFit]; self.contentTextView.textAlignment=NSTextAlignmentCenter;
    self
    .contentTextView.userInteractionEnabled = NO;
    _mainResizableView.contentView = _contentTextView;
    [self.textFontSliderOutlet setValue:3.0 animated:YES];
    [self textFontSliderAction];
    _mainResizableView.delegate = self;
    _mainResizableView.contentView.backgroundColor = [UIColor clearColor];
    _mainResizableView.resizableStatus=YES;
    _mainResizableView.accessibilityHint = @"TextView";
    _contentTextView.textAlignment=NSTextAlignmentCenter;
    _text_color =[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    
    _contentTextView.textColor = [UIColor colorWithCGColor:_text_color.CGColor];
    ;
    _mainResizableView.contentView.layer.cornerRadius = 4;
    _mainResizableView.cancel.hidden = YES;
    [_DrawingBoard addSubview:_mainResizableView];
    //[_TextViewSuperView addSubview:_textResizableView];
}

-(void)createShapeFn{
    UIImage *createShapeBtnImage = [UIImage imageNamed:@"128-craete-button.png"];
    [self.createShape setImage:createShapeBtnImage forState:UIControlStateNormal];
    
    UIImage *createTextBtnImage = [UIImage imageNamed:@"128-edit-text-HO.png"];
    [self.createText setImage:createTextBtnImage forState:UIControlStateNormal];
    
    self.createTextView.hidden=YES;
    self.createBorderView.hidden=YES;
    self.createShapeView.hidden = NO;
    if(CreateShape)
    {
        if(_isReEdit){
            [_mainResizableView setFrame:CGRectMake(100, 100, _clip_layout_width, _clip_layout_height)];
            _mainResizableView.contentView.backgroundColor = _bg_color;
            _mainResizableView.contentView.layer.cornerRadius = _border_radius;
            [self.mainResizableView.contentView.layer
             setBorderWidth:_border_width];
            _mainResizableView.contentView.layer.masksToBounds = YES;
            [_widthValueIndicator setText:[NSString stringWithFormat:@"%f",_border_width]];
            
            //NEW Border
            //            CAShapeLayer *yourViewBorder = [CAShapeLayer layer];
            //            yourViewBorder.strokeColor = [UIColor redColor].CGColor;
            //            yourViewBorder.fillColor = nil;
            //            yourViewBorder.lineDashPattern = @[@2, @2];
            //            yourViewBorder.frame = self.mainResizableView.contentView.bounds;
            //            yourViewBorder.lineWidth=_border_width;
            //            yourViewBorder.path = [UIBezierPath bezierPathWithRect:self.mainResizableView.contentView.bounds].CGPath;
            //            [self.mainResizableView.contentView.layer addSublayer:yourViewBorder];
            //
            //NEWBorDER
            [self.radius_Slider_outlet setValue:_border_radius/2];
            [self.BorderSlider_outlet setValue:_border_width];
        }
        else{
            
            [_mainResizableView setFrame:CGRectMake(100, 100, 200, 100)];
            _mainResizableView.contentView.backgroundColor = [UIColor whiteColor];
            _color_outlet.backgroundColor = [UIColor grayColor];
            _mainResizableView.contentView.layer.cornerRadius = 9;
            [self.mainResizableView.contentView.layer
             setBorderWidth:2];
            _mainResizableView.contentView.layer.masksToBounds = YES;
            [self.radius_Slider_outlet setValue:2];
            [self.BorderSlider_outlet setValue:2];
            
            _sizeIndicator.text= @"15";
            _contentTextView.text = @"Click";
            
            [_contentTextView setFont:
             [UIFont fontWithName:@"Baskerville-SemiBold" size:15]];
            [_textFontSliderOutlet setValue:15.0];
            _contentTextView.textColor = [UIColor redColor];
            _TextColorPicker.backgroundColor = [UIColor redColor];
        }
        
        CreateShape=NO;
        _mainResizableView.delegate = self;
        
        //_mainResizableView.resizableStatus=YES;
        
        _mainResizableView.cancel.hidden = NO;
        
        [_mainResizableView showEditingHandles];
        
        // [_DrawingBoard addSubview:_mainResizableView];
    }
}

- (IBAction)createShape:(id)sender {
    [self createShapeFn];
}

-(void)ceateTextfn{
    NSLog(@"create text");
    self.createTextView.hidden=NO;
    self.createBorderView.hidden=YES;
    self.createShapeView.hidden = YES;
    
    UIImage *createShapeBtnImage = [UIImage imageNamed:@"128-craete-button-HO.png"];
    [self.createShape setImage:createShapeBtnImage forState:UIControlStateNormal];
    
    UIImage *createTextBtnImage = [UIImage imageNamed:@"128-edit-text.png"];
    [self.createText setImage:createTextBtnImage forState:UIControlStateNormal];
    
    if(CreateText){
        
    }else{
        //        [_textResizableView removeFromSuperview];
        //        [_TextViewSuperView addSubview:_textResizableView];
        //        [_TextViewSuperView setFrame:_mainResizableView.frame];
        //        [_textResizableView setFrame:CGRectMake(0, 0, _mainResizableView.frame.size.width, _mainResizableView.frame.size.height)];
        //        _TextViewSuperView.hidden = NO;
        //        _lastEditedView = _currentlyEditingView;
        //        _currentlyEditingView = _textResizableView;
        //        [_currentlyEditingView showEditingHandles];
        //        [_currentlyEditingView.cancel setHidden:YES];
        //        [_lastEditedView hideEditingHandles];
        //        [_lastEditedView.cancel setHidden:YES];
        [self ResizeText];
    }
}
- (IBAction)createText:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callToAction" object:nil];
    [self ceateTextfn];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = self.contentTextView.frame.size.width;
    CGSize newSize = [self.contentTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.contentTextView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    if (!CGRectEqualToRect(self.contentTextView.frame, newFrame))
    {
        CGRect frame = self.contentTextView.superview.frame;
        frame.size.height -= self.contentTextView.frame.size.height;
        frame.size.height += newSize.height;
        self.contentTextView.superview.frame = frame;
        self.contentTextView.frame = newFrame;
    }
}

-(void)ResizeText{
    _contentTextView.font = [UIFont fontWithName:_font_style size:fontSize];
    //setup text resizing check here
    CGSize textSize = [_contentTextView.text sizeWithAttributes:@{NSFontAttributeName: _contentTextView.font}];
    
    if (textSize.height> _contentTextView.frame.size.height-10 || textSize.width>_contentTextView.frame.size.width-10){
        int fontIncrement = 1;
        while (textSize.height> _contentTextView.frame.size.height-10 || textSize.width>_contentTextView.frame.size.width-10) {
            _contentTextView.font = [UIFont fontWithName:_font_style size:fontSize-fontIncrement];
            textSize = [_contentTextView.text sizeWithAttributes:@{NSFontAttributeName: _contentTextView.font}];
            fontIncrement++;
        }
    }
}

-(void)userResizableviewBeingResized:(SPUserResizableView *)userResizableView{
    
    if(_contentTextView.text.length>0)
        [self ResizeText];
}
- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView {
    
    NSLog(@"DIDBEGIN EDIT");
    // UserResizableView_currentTag=userResizableView.tag;
    
    [self.contentTextView resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"Responder Coming");
}

- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView
{
    //    _lastEditedView = userResizableView;
    //    _lastEditedView.resignFirstResponder;
    //    _currentlyEditingView.becomeFirstResponder;
}

- (IBAction)colorPicker:(id)sender {
    shapeColorPicker=YES;
    textcolorPicker=NO;
    borderColorPicker=NO;
    MSColorSelectionViewController *colorSelectionController = [[MSColorSelectionViewController alloc] init];
    
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:colorSelectionController];
    
    //        navCtrl.delegate = self;
    
    popoverController = [[WYPopoverController alloc ]initWithContentViewController:navCtrl];
    
    popoverController.delegate = self;
    
    colorSelectionController.delegate = self;
    
    colorSelectionController.color = [UIColor whiteColor];
    
    popoverController.popoverContentSize = CGSizeMake(250, 500);
    
    [popoverController presentPopoverFromRect:self.color_outlet.frame
                                       inView:self.color_outlet.superview
                     permittedArrowDirections:WYPopoverArrowDirectionAny
                                     animated:YES
                                      options:WYPopoverAnimationOptionFadeWithScale];
}
- (void)colorViewController:(MSColorSelectionViewController *)colorViewCntroller didChangeColor:(UIColor *)color
{
    if(textcolorPicker){
        selectedTextColor = color;
        self.EnterTextField.textColor = color; //]colorWithAlphaComponent:opacity];
        
        self.contentTextView.textColor=[UIColor colorWithCGColor:color.CGColor];
        
        self.TextColorPicker.backgroundColor = color;
        textBgColor = [self hexStringFromColor:color];
        
    }else if(borderColorPicker){
        selectedBorderColor = color;
        self.mainResizableView.contentView.layer.borderColor=color.CGColor;
        //self.colorNew_outlet.layer.borderColor=color;
        UIColor *new = (__bridge UIColor *)((__bridge CGColorRef)color);
        self.colorNew_outlet.layer.borderColor = new.CGColor;
        //shapeBorderColor = [self hexStringFromColor:color];
        //self.color_outlet.layer.borderColor = [self colorWithHexString:shapeBorderColor];
    }else{
        _mainResizableView.contentView.backgroundColor = color ;
        self.color_outlet.backgroundColor = color;
        shapeBgColor = [self hexStringFromColor:color];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.fontDropList closeAllComponentsAnimated:YES];
    CreateShape=YES;
    selectedTextColor=[UIColor blackColor];
    shapeBgColor = @"Null";
    textBgColor = @"Null";
    shapeBorderColor = @"Null";
    CreateText=YES;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"CreateButton"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)ms_dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)fontStyle:(id)sender
{
    
}

- (IBAction)Radius_slider:(id)sender {
    
    NSLog(@"Radius %f",self.radius_Slider_outlet.value);
    int val = self.radius_Slider_outlet.value;
    opacity=self.radius_Slider_outlet.value*2;
    [_radiusValueIndicator setText:[NSString stringWithFormat:@"%d",val]];
    //cornerradius= cornerradius+4;
    _mainResizableView.contentView.layer.cornerRadius = opacity;
    _mainResizableView.contentView.layer.masksToBounds = YES;
    
}

- (IBAction)Create_Logo:(id)sender {
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"callToAction" object:nil];
    //
    //    _TextViewSuperView.hidden = NO;
    //    [_textResizableView removeFromSuperview];
    //    [_mainResizableView addSubview:_textResizableView];
    //    [_currentlyEditingView hideEditingHandles];
}


- (void)SaveToCollection:(NSNotification* )notify
{
    [self takeScreenShot];
    
    
}





-(void)takeScreenShot
{
    //    [_TextViewSuperView removeFromSuperview];
    //    CGRect tempRect= CGRectMake(0, 0, _TextViewSuperView.frame.size.width, _TextViewSuperView.frame.size.height);
    //    [_TextViewSuperView setFrame:tempRect];
    //    [_mainResizableView addSubview:_TextViewSuperView];
    [_mainResizableView hideEditingHandles];
    _mainResizableView.cancel.hidden = YES;
    CGSize size = [_mainResizableView frame].size;
    UIGraphicsBeginImageContextWithOptions(size,NO,2.0);
    [[_mainResizableView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *drawingViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    img.image = drawingViewImage;
    //[_DrawingBoard addSubview:img];
    UIGraphicsEndImageContext();
    [self sendImageToServer:drawingViewImage];
    _mainResizableView.cancel.hidden = NO;
}

-(void)sendImageToServer:(UIImage *)img
{
    NSLog(@"");
    NSData *data = UIImagePNGRepresentation(img);
    if([self setImageParams:data])
    {
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
         {
             
             NSLog(@"added successfully:%@",data);
             NSLog(@"URLResponse:%@",urlResponse);
             
             NSDictionary *responseObject=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             
             NSLog(@"response for image:%@",responseObject);
             NSDictionary *dic = responseObject;
             NSString *status = [dic objectForKey:@"status"];
             if( [status isEqualToString:@"True"]){
                 
                 self.tabBarController.selectedViewController
                 = [self.tabBarController.viewControllers objectAtIndex:2];
             }
             
         }];
    }else{
        
    }
    
}
-(void)AllValuesToVar{
    
    _bg_color = _mainResizableView.contentView.backgroundColor;
    shapeBgColor = [self hexStringFromColor:_bg_color];
    //_border_color = selectedBorderColor;
    
    
    shapeBorderColor = [self hexStringFromColor:_border_color];
    if(shapeBorderColor == nil)
        shapeBorderColor = @"#000000";
    if(! (self.contentTextView.text.length > 0))
    {
        _text = @"Null";
        textBgColor = @"#000000";
        textFontStyle = @"Null";
        textFontSize = @"0";
        TextViewX = @"0";
        TextViewY = @"0";
        TextViewHeight =@"0";
        TextViewWidth = @"0";
        NSLog(@"within IF");
    }
    else
    {
        _text =  self.contentTextView.text;
        _text_size = self.contentTextView.font.pointSize;
        textFontSize = [NSString stringWithFormat:@"%f", _text_size];
        _font_style  = self.contentTextView.font.fontName;
        textFontStyle = self.contentTextView.font.fontName;
        
        _clip_text_left =_contentTextView.frame.origin.x;
        TextViewX = [NSString stringWithFormat:@"%f",_clip_text_left];
        
        _clip_text_top =_contentTextView.frame.origin.y;
        TextViewY = [NSString stringWithFormat:@"%f",_clip_text_top];
        
        _clip_text_height =_contentTextView.frame.size.height;
        TextViewHeight = [NSString stringWithFormat:@"%f",_clip_text_height];
        
        _clip_text_width =_contentTextView.frame.size.width;
        TextViewWidth = [NSString stringWithFormat:@"%f",_clip_text_width];
        _text_color = _contentTextView.textColor;
        textBgColor = [self hexStringFromColor:_text_color];
        _border_color = selectedBorderColor;
        shapeBorderColor = [self hexStringFromColor:_border_color];
        NSLog(@"within ELSE");
        
    }
    
    //        _text = @"Null";
    //        textBgColor = @"Null";
    //        textFontStyle = @"Null";
    //        textFontSize = @"0";
    //        TextViewX = @"0";
    //        TextViewY = @"0";
    //        TextViewHeight =@"0";
    //        TextViewWidth = @"0";
    
    _border_width = self.BorderSlider_outlet.value;
    
    borderWidth = [NSString stringWithFormat:@"%f", _border_width];
    _border_radius =self.radius_Slider_outlet.value*2;
    borderRadius = [NSString stringWithFormat:@"%f",_border_radius];
    
    _clip_layout_height =self.mainResizableView.frame.size.height;
    mainShapeHeight = [NSString stringWithFormat:@"%f",_clip_layout_height];
    _clip_layout_width =self.mainResizableView.frame.size.width;
    mainShapeWidth = [NSString stringWithFormat:@"%f",_clip_layout_width];
}

-(BOOL)setImageParams:(NSData *)imgData
{
    
    [self AllValuesToVar];
    
    @try
    {
        if (imgData!=nil)
        {
            NSLog(@"Enter Image send");
            request = [NSMutableURLRequest new];
            request.timeoutInterval = 20.0;
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
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_call_to_action_img\"; filename=\"%@.png\"\r\n", @"Uploaded_file"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imgData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[user_id dataUsingEncoding:NSUTF8StringEncoding]];

            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lang\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding]];
            
            //NEWWWWWWWWWW
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"bg_color\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[shapeBgColor dataUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@"shapeBgColor %@",shapeBgColor);
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"text\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[_text dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"text_color\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[textBgColor dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"text_size\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[textFontSize dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"border_color\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[shapeBorderColor dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"border_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Null" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"border_width\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[borderWidth dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"border_radius\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[borderRadius dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"font_style\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[textFontStyle dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"clip_layout_height\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[mainShapeHeight dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"clip_layout_width\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[mainShapeWidth dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"clip_layout_top\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Null" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"clip_layout_left\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Null" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"clip_text_height\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[TextViewHeight dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"clip_text_width\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[TextViewWidth dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"clip_text_top\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[TextViewY dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"clip_text_left\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[TextViewX dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"create_button" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"source_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"7" dataUsingEncoding:NSUTF8StringEncoding]];
            
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

-(void)loadTransitionData
{
    @try
    {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"('Content-type: application/json');"];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=view_user_call_to_action_image";
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    hud.mode = MBProgressHUDModeDeterminate;
        //    hud.progress = progress;
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        NSDictionary *params = @{@"user_id":user_id,@"lang":@"iOS"};
        
        [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
         {
             NSLog(@"Call_To_Action_Image = %@",responseObject);
             
             [hud hideAnimated:YES];
             
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error9: %@", error);
             
         }];
        
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}

- (IBAction)BorderChange:(id)sender {
    int val = self.BorderSlider_outlet.value;
    [self.mainResizableView.contentView.layer setBorderWidth:val];
    [_widthValueIndicator setText:[NSString stringWithFormat:@"%d",val]];
    
    /*CAShapeLayer *yourViewBorder = [CAShapeLayer layer];
     yourViewBorder.strokeColor = [UIColor redColor].CGColor;
     yourViewBorder.fillColor = nil;
     yourViewBorder.lineDashPattern = @[@2, @2];
     yourViewBorder.frame = self.mainResizableView.contentView.bounds;
     yourViewBorder.lineWidth=val;
     yourViewBorder.path = [UIBezierPath bezierPathWithRect:self.mainResizableView.contentView.bounds].CGPath;
     [self.mainResizableView.contentView.layer addSublayer:yourViewBorder];*/
    
}

- (IBAction)TextColorOutlet:(id)sender {
    shapeColorPicker=NO;
    borderColorPicker=NO;
    textcolorPicker=YES;
    MSColorSelectionViewController *colorSelectionController = [[MSColorSelectionViewController alloc] init];
    
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:colorSelectionController];
    
    // navCtrl.delegate = self;
    
    popoverController = [[WYPopoverController alloc ]initWithContentViewController:navCtrl];
    
    popoverController.delegate = self;
    colorSelectionController.delegate = self;
    colorSelectionController.color = [UIColor whiteColor];
    
    popoverController.popoverContentSize = CGSizeMake(250, 500);
    
    [popoverController presentPopoverFromRect:self.color_outlet.frame
                                       inView:self.color_outlet.superview
                     permittedArrowDirections:WYPopoverArrowDirectionAny
                                     animated:YES
                                      options:WYPopoverAnimationOptionFadeWithScale];
}

- (IBAction)TextDone:(id)sender {
    
    _contentTextView.text =self.EnterTextField.text;
    [_contentTextView setUserInteractionEnabled:NO];
    
}

-(void)TextDoneFn{
    
    if(!fromTextDoneBtn){
        
        //  [_textResizableView setFrame:CGRectMake(_clip_text_left, _clip_text_top, _clip_text_width,_clip_text_height )];
        self.contentTextView.textColor = [UIColor colorWithCGColor:_text_color.CGColor];
        [self.contentTextView setFont:[UIFont fontWithName:_font_style size:_text_size]];
        self.contentTextView.text = _text;
        [self.contentTextView setFont:[UIFont fontWithName:_font_style size:_text_size]];
        //        [_DrawingBoard addSubview:_TextViewSuperView];
        
        //self.ResizeTextView =[[UITextView alloc] init];
        //        [self.ResizeTextView setBackgroundColor:[UIColor clearColor]];
        //        [self.ResizeTextView setFrame:CGRectMake(0, 0, _textResizableView.frame.size.width, _textResizableView.frame.size.height)];
        //
        //        _textResizableView.contentView = self.ResizeTextView;
        //        _textResizableView.delegate = self;
        //
        //        _textResizableView.resizableStatus=YES;
        //
        //        _lastEditedView = _currentlyEditingView;
        //        _currentlyEditingView = _textResizableView;
        //        [_currentlyEditingView showEditingHandles];
        //        [_currentlyEditingView.cancel setHidden:YES];
        //        [_lastEditedView hideEditingHandles];
        //        [_lastEditedView.cancel setHidden:YES];
        
    }
    else{
        //        if(_contentTextView.text.length <= 0){
        //
        //            [_textResizableView setFrame:CGRectMake(0, 0, _mainResizableView.frame.size.width,_mainResizableView.frame.size.height )];
        //            self.contentTextView.textColor = [UIColor colorWithCGColor:selectedTextColor.CGColor];
        //            [self.contentTextView setFont:[UIFont boldSystemFontOfSize:25]];
        //
        //            [_DrawingBoard addSubview:_TextViewSuperView];
        //
        //            //self.ResizeTextView =[[UITextView alloc] init];
        //            [self.ResizeTextView setBackgroundColor:[UIColor clearColor]];
        //
        //            [self.ResizeTextView setFrame:CGRectMake(0, 0, _textResizableView.frame.size.width, _textResizableView.frame.size.height)];
        //
        //            _textResizableView.contentView = self.ResizeTextView;
        //            _textResizableView.delegate = self;
        //            _textResizableView.resizableStatus=YES;
        //            _lastEditedView = _currentlyEditingView;
        //            _currentlyEditingView = _textResizableView;
        //            [_currentlyEditingView showEditingHandles];
        //            [_currentlyEditingView.cancel setHidden:YES];
        //            [_lastEditedView hideEditingHandles];
        //            [_lastEditedView.cancel setHidden:YES];
        //        }
        //        self.ResizeTextView.text = self.EnterTextField.text;
    }
    
    // _ResizeTextView.editable = NO;
    // [self.ResizeTextView becomeFirstResponder];
    
    // [self ResizeText];
    
}

#pragma MKDropdownMenu Delegate

-(CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu
{
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component
{
    return [self.fruits count];
}


- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component
{
    
    UIFont *font = [UIFont fontWithName:headerValue size:14.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    
    NSAttributedString *attrString;
    
    attrString = [[NSAttributedString alloc] initWithString:headerValue attributes:attrsDictionary];
    return attrString;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *fontType = self.fruits[row];
    UIFont *font = [UIFont fontWithName:fontType size:14.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    
    NSAttributedString *attrString;
    
    attrString = [[NSAttributedString alloc] initWithString:self.fruits[row] attributes:attrsDictionary];
    
    return attrString;
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSLog(@"")
    
    headerValue = self.fruits[row];
    _contentTextView.font=[UIFont fontWithName:self.fruits[row] size:(int)self.contentTextView.font.pointSize];
    _font_style = headerValue;
    
    delay(0.15,
          ^{
              [dropdownMenu closeAllComponentsAnimated:YES];
              
              [self.fontDropList reloadAllComponents];
          });
    
}


static inline void delay(NSTimeInterval delay, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}
/*- (NSString *)hexStringFromColor:(UIColor *)color {
 const CGFloat *components = CGColorGetComponents(color.CGColor);
 
 CGFloat r = components[0];
 CGFloat g = components[1];
 CGFloat b = components[2];
 
 return [NSString stringWithFormat:@"%02lX%02lX%02lX",
 lroundf(r * 255),
 lroundf(g * 255),
 lroundf(b * 255)];
 }*/
-(NSString*)hexStringFromColor:(UIColor*)color
{
    NSString *webColor = nil;
    
    // This method only works for RGB colors
    if (color &&
        CGColorGetNumberOfComponents(color.CGColor) == 4)
    {
        // Get the red, green and blue components
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        
        // These components range from 0.0 till 1.0 and need to be converted to 0 till 255
        CGFloat red, green, blue;
        red = roundf(components[0] * 255.0);
        green = roundf(components[1] * 255.0);
        blue = roundf(components[2] * 255.0);
        
        // Convert with %02x (use 02 to always get two chars)
        webColor = [[NSString alloc]initWithFormat:@"#%02x%02x%02x", (int)red, (int)green, (int)blue];
    }
    return webColor;
}


- (IBAction)newColorPicker:(id)sender
{
    shapeColorPicker=NO;
    textcolorPicker=NO;
    borderColorPicker = YES;
    MSColorSelectionViewController *colorSelectionController = [[MSColorSelectionViewController alloc] init];
    
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:colorSelectionController];
    
    //        navCtrl.delegate = self;
    
    popoverController = [[WYPopoverController alloc ]initWithContentViewController:navCtrl];
    
    popoverController.delegate = self;
    
    colorSelectionController.delegate = self;
    
    colorSelectionController.color = [UIColor whiteColor];
    
    popoverController.popoverContentSize = CGSizeMake(250, 500);
    
    [popoverController presentPopoverFromRect:self.colorNew_outlet.frame
                                       inView:self.colorNew_outlet.superview
                     permittedArrowDirections:WYPopoverArrowDirectionAny
                                     animated:YES
                                      options:WYPopoverAnimationOptionFadeWithScale];
}

- (IBAction)textFontSlider:(id)sender {
    
    [self textFontSliderAction];
    //[textFontSliderOutlet setText:[NSString stringWithFormat:@"%d",val]];
}
- (void)textFontSliderAction{
    int val = self.textFontSliderOutlet.value;
    int font=self.textFontSliderOutlet.value*3;
    CGSize textSize = [_contentTextView.text sizeWithAttributes:@{NSFontAttributeName: _contentTextView.font}];
    
    if (textSize.height> _contentTextView.frame.size.height-15 || textSize.width>_contentTextView.frame.size.width-15){
        if(Flag){
            
            sliderValue = self.textFontSliderOutlet.value;
            Flag = NO;
        }
        
    }else{
        Flag=YES;
        _contentTextView.font = [UIFont fontWithName:textFontStyle size:font];
    }
    if(val<sliderValue)
        _contentTextView.font = [UIFont fontWithName:textFontStyle size:font];
    
    fontSize = font;
    self.sizeIndicator.text = [NSString stringWithFormat:@"%d",font];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }

    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 15;
}
- (IBAction)FontSelection:(id)sender {
    
}
- (IBAction)Bold:(id)sender {
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
}
- (IBAction)Italic:(id)sender {
    
    //textFontStyle = [selectedDic valueForKey:@"Font_Name"];
    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"-"];
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
@end

