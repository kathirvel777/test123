//
//  LibraryButtonaViewController.m
//  Montage
//
//  Created by MacBookPro on 9/21/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "LibraryButtonaViewController.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "MSColorPicker.h"
#import "WYPopoverController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIColor+Utils.h"
#import "CallToActionTabViewController.h"
#import "UIView+Toast.h"
#import <CoreText/CoreText.h>
#import "CustomPopUp.h"



//#define REGEX_PASS @"[A-Za-z]{0,15}"
@interface LibraryButtonaViewController ()<UITextFieldDelegate>
{
    NSString *userID,*id1,*backgroundColor,*fontStyle,*imageIcon,*templateText,*textColor,*headerValue,*textSize,*editID,*textFontStyle;
    NSURL *url;
    UIColor *bgColor,*txtColor,*bgColor2;
    int txtSize,sliderValue;
    NSArray *fontNames;
    WYPopoverController *popoverController;
    BOOL isView,isText,boldSelected,italicSelected,Flag;
    UIView *parentView,*subView1,*subView2;
    UILabel *txtlabel;
    UIImageView *img;
    int isIncrease;
    
    MSColorSelectionViewController *colorSelectionController;
    
    UIFont *boldFont,*italicFont;
    BOOL boldStatus,italicStatus,isFiltered;
    NSDictionary *selectedDic;
    NSMutableArray *filteredFonts,*allFonts;
    CGRect font_Search_Selecting_View;
    MBProgressHUD *hud;
}

@end

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation LibraryButtonaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isView=YES;
    
    NSLog(@"editFrom:%@",_editFrom);
    NSLog(@"Button Array:%@",_buttonArray);
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    userID = [defaults valueForKey:@"USER_ID"];
    
    if([_editFrom isEqualToString:@"Lib"])
    {
        id1=[_buttonArray valueForKey:@"icon_compare_id"];
        backgroundColor=[_buttonArray valueForKey:@"background_color"];
        fontStyle=[_buttonArray valueForKey:@"font_style"];
        url=[_buttonArray valueForKey:@"image_icon"];
        templateText=[_buttonArray valueForKey:@"template_txt"];
        textColor=[_buttonArray valueForKey:@"text_color"];
        txtSize=18;
        editID=[_buttonArray valueForKey:@"id"];
    }
    else
    {
        id1=[_buttonArray valueForKey:@"source_id"];
        backgroundColor=[_buttonArray valueForKey:@"bg_color"];
        fontStyle=[_buttonArray valueForKey:@"font_style"];
        url=[_buttonArray valueForKey:@"logo_image"];
        templateText=[_buttonArray valueForKey:@"text"];
        textColor=[_buttonArray valueForKey:@"text_color"];
        txtSize=[[_buttonArray valueForKey:@"text_size"] intValue];
        editID=[_buttonArray valueForKey:@"id"];
        
    }
    
    imageIcon=[NSString stringWithFormat:@"%@",url];
    textSize=[NSString stringWithFormat:@"%f",txtSize];
    
    bgColor =  [self getUIColorObjectFromHexString:backgroundColor alpha:.5];
    bgColor2 =  [self getUIColorObjectFromHexString:backgroundColor alpha:1];
    txtColor=[self getUIColorObjectFromHexString:textColor alpha:1];
    headerValue=@"Choose font";
    
    fontNames = @[@"Baskerville",@"Baskerville-SemiBold",@"Baskerville-Italic",@"BodoniOrnamentsITCTT",@"BodoniSvtyTwoITCTT-BookIta",@"Baskerville-Bold",@"ChalkboardSE-Light",@"Chalkduster",@"Cochin",@"Copperplate",@"Courier",@"Damascus",@"DevanagariSangamMN",@"Farah",@"Helvetica-Light",@"Helvetica-Oblique",@"HelveticaNeue-Italic",@"HelveticaNeue",@"IowanOldStyle",@"Kailasa",@"ArialMT",@"Arial-BoldItalicMT",@"Arial-ItalicMT",@"ArialHebrew",@"ArialHebrew-Bold",@"AmericanTypewriter-Bold",@"AmericanTypewriter-CondensedBold",@"AmericanTypewriter-Light"];
    
    //int val = self.BorderSlider_outlet.value;
    self.fontSizelabel.text=[NSString stringWithFormat:@"%d",txtSize ];
    self.fontSizelabel.layer.cornerRadius = 5;
    self.fontSizelabel.layer.masksToBounds = YES;
    
    [self.sliderFontSize setValue:txtSize animated:YES];
    
    [self.sliderFontSize addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    boldFont=[UIFont fontWithName:fontStyle size:txtSize];
    italicFont=[UIFont fontWithName:fontStyle size:txtSize];
    
    boldStatus=true;
    italicStatus=true;
    isIncrease=1;
    
    [self.textColorPicker setBackgroundColor:txtColor];
    [self.colorView setBackgroundColor:bgColor2];
    
    allFonts = [[NSMutableArray alloc]init];
    [self loadFonts];
    
    // button.imageView.layer.cornerRadius = 7.0f;
    
    
    // button.imageView.layer.cornerRadius = 7.0f;
    
    
    self.TextAttributesView.layer.shadowRadius = 3.0f;
    self.TextAttributesView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.TextAttributesView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.TextAttributesView.layer.shadowOpacity = 0.5f;
    self.TextAttributesView.layer.masksToBounds = NO;
    //self.TextAttributesView.layer.borderWidth=1.0f;
    //self.TextAttributesView.layer.borderColor=[UIColor blackColor ].CGColor;
    
    self.fontDropDownView.layer.shadowRadius = 3.0f;
    self.fontDropDownView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.fontDropDownView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.fontDropDownView.layer.shadowOpacity = 0.5f;
    self.fontDropDownView.layer.masksToBounds = NO;
    self.fontDropDownView.layer.borderWidth=1.0f;
    self.fontDropDownView.layer.borderColor=[UIColor blackColor ].CGColor;
    
    /* CALayer *border = [CALayer layer];
     CGFloat borderWidth = 2;
     border.borderColor = [UIColor darkGrayColor].CGColor;
     border.frame = CGRectMake(0, _enterText.frame.size.height - borderWidth, _enterText.frame.size.width, _enterText.frame.size.height);
     border.borderWidth = borderWidth;
     [_enterText.layer addSublayer:border];
     _enterText.layer.masksToBounds = YES;*/
    
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
    
    self.fontSelectionView .layer.shadowRadius = 1.5f;
    self.fontSelectionView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.fontSelectionView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.fontSelectionView.layer.shadowOpacity = 0.5f;
    self.fontSelectionView.layer.masksToBounds = NO;
    //self.fontSelectionView.layer.borderWidth=1.0f;
    //    self.fontSelectionView.layer.borderColor=[UIColor blackColor ].CGColor;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    [_fontSelectionView addGestureRecognizer:tapRecognizer];
    [_blurView addGestureRecognizer:singleTapRecognizer];
    _fontSelectionView.tag=1;
    _blurView.tag=2;
    
    font_Search_Selecting_View = self.font_search_Selecting_View.frame;
    [[self.finishText imageView] setContentMode:UIViewContentModeScaleAspectFit];
    self.finishText.layer.shadowRadius = 2.0f;
    self.finishText.layer.shadowColor = [UIColor blackColor].CGColor;
    self.finishText.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.finishText.layer.shadowOpacity = 0.5f;
    self.finishText.layer.masksToBounds = NO;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    _enterText.delegate = self;
    //[self.navigationController.navigationBar setHidden:YES];   // [_enterText addRegx:REGEX_PASS withMsg:@"can have upto 15 characters only"];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
   [self.navigationController.navigationBar setHidden:YES];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self.navigationController.navigationBar setHidden:NO]; 
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // [txtField addObserver:self forKeyPath:templateText options:(NSKeyValueObservingOptionNew) context:NULL];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    self.textColorPicker.layer.cornerRadius =4;// self.textColorPicker.frame.size.width/2;
    self.textColorPicker.layer.masksToBounds = YES;
    self.textColorPicker.layer.shadowRadius = 3.0f;
    self.textColorPicker.layer.shadowColor = [UIColor blackColor].CGColor;
    self.textColorPicker.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.textColorPicker.layer.shadowOpacity = 0.5f;
    self.textColorPicker.layer.masksToBounds = NO;
    //    self.textColorPicker.layer.borderWidth=1.0f;
    //    self.textColorPicker.layer.borderColor=[UIColor blackColor ].CGColor;
    //
    self.colorView.layer.cornerRadius = 4;//self.colorView.frame.size.width/2;
    self.colorView.layer.masksToBounds = YES;
    self.colorView.layer.shadowRadius = 3.0f;
    self.colorView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.colorView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.colorView.layer.shadowOpacity = 0.5f;
    self.colorView.layer.masksToBounds = NO;
    //    self.colorView.layer.borderWidth=1.0f;
    //    self.colorView.layer.borderColor=[UIColor blackColor ].CGColor;
    [self chooseType];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // [txtField removeObserver:self forKeyPath:templateText];
    [self.editView willRemoveSubview:parentView];
    
}
-(void)gestureHandlerMethod:(UITapGestureRecognizer*)sender {
    
    if(sender.view.tag == 1){
        CGRect frame = CGRectMake(0, self.editView.frame.size.height , self.view.frame.size.width, self.view.frame.size.height-self.editView.frame.size.height);
        //frame.size.height = self.view.frame.size.height/2;
        [UIView animateWithDuration:0.5
                         animations:^{
                             _font_search_Selecting_View.frame = frame;
                             [_SearchBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.font_search_Selecting_View.frame.size.height/8)];
                             [_TableView setFrame:CGRectMake(0, _SearchBar.frame.size.height, self.view.frame.size.width, self.font_search_Selecting_View.frame.size.height-_SearchBar.frame.size.height)];
                             
                             _blurView.hidden=NO;
                         }];
    }else{
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.view endEditing:YES];
                             [_font_search_Selecting_View setFrame:font_Search_Selecting_View];
                             [self.SearchBar setFrame:CGRectMake(0, 0, self.SearchBar.frame.size.width, 0)];
                             _blurView.hidden=YES;
                         }
                         completion:^(BOOL finished){
                         }];
    }
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0){
        isFiltered = false;
    }else{
        isFiltered = true;
        filteredFonts = [[NSMutableArray alloc]init];
        
        for(NSString *font in fontNames){
            NSRange nameRange = [font rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
                [filteredFonts addObject:font];
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
    
    
    
    
    
   /* fontStyle=fontNames[indexPath.row];
    txtlabel.font= [UIFont fontWithName:fontStyle size:txtSize];
    
    boldFont=[UIFont fontWithName:fontStyle size:txtSize];
    italicFont=[UIFont fontWithName:fontStyle size:txtSize];
    
    headerValue = fontNames[indexPath.row];
    
    fontStyle = headerValue;
    
    _SelectedFont_lbl.text = fontNames[indexPath.row];
    self.SelectedFont_lbl.font=[UIFont fontWithName:fontNames[indexPath.row] size:15];*/
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view endEditing:YES];
                         [_font_search_Selecting_View setFrame:font_Search_Selecting_View];
                         [self.SearchBar setFrame:CGRectMake(0, 0, self.SearchBar.frame.size.width, 0)];                         _blurView.hidden=YES;
                     }
                     completion:^(BOOL finished){
                     }];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    CGFloat rounded_down =  ceilf(sender.value * 100)/ 100;
    
    NSLog(@"slider value1 = %f", rounded_down);
    txtSize=sender.value;
    CGSize TextSize = [txtlabel.text sizeWithAttributes:@{NSFontAttributeName: txtlabel.font}];
    
    if (TextSize.height> txtlabel.frame.size.height-15 || TextSize.width>txtlabel.frame.size.width-15){
        if(Flag){
            
            sliderValue = sender.value;
            Flag = NO;
        }
        
    }else{
        Flag=YES;
        txtlabel.font = [UIFont fontWithName:textFontStyle size:txtSize];
    }
    if(txtSize<sliderValue)
        txtlabel.font = [UIFont fontWithName:textFontStyle size:txtSize];
    
   // fontSize = font;
    self.fontSizelabel.text = [NSString stringWithFormat:@"%d",txtSize];
    
    
    
    
    
    NSLog(@"slider value = %f", sender.value);
    
   // CGFloat rounded_down =  ceilf(sender.value * 100)/ 100;
    
    NSLog(@"slider value1 = %f", rounded_down);
    //txtSize=sender.value;
    //self.fontSizelabel.text=[NSString stringWithFormat:@"%d",txtSize];
    [self.sliderFontSize setValue:rounded_down animated:YES];
    
   // txtlabel.font =[UIFont fontWithName:textFontStyle size:txtSize];
    textSize=[NSString stringWithFormat:@"%d",txtSize];
    
//    boldFont=[UIFont fontWithName:textFontStyle size:txtSize];
//    italicFont=[UIFont fontWithName:textFontStyle size:txtSize];
    
}

-(void)chooseType
{
    NSLog(@"type begin");
    
    // bgColor=[backgroundColor intValue];
    
    if([id1 isEqualToString:@"1"])
    {
        [self Type1];
    }
    else if([id1 isEqualToString:@"2"])
    {
        [self Type2];
    }
    else if([id1 isEqualToString:@"3"])
    {
        [self Type3];
    }
    else if([id1 isEqualToString:@"4"])
    {
        [self Type4];
    }
    else if([id1 isEqualToString:@"5"])
    {
        [self Type5];
    }
    else if([id1 isEqualToString:@"6"])
    {
        [self Type6];
    }
    else if([id1 isEqualToString:@"7"])
    {
        [self Type7];
    }
    else if([id1 isEqualToString:@"8"])
    {
        [self Type8];
    }
    else if([id1 isEqualToString:@"9"])
    {
        [self Type9];
    }
    else if([id1 isEqualToString:@"10"])
    {
        [self Type10];
    }
    else if([id1 isEqualToString:@"11"])
    {
        [self Type11];
    }
    else if([id1 isEqualToString:@"12"])
    {
        [self type12];
    }
    else if([id1 isEqualToString:@"13"])
    {
        [self type13];
    }
    else if([id1 isEqualToString:@"14"])
    {
        [self type14];
    }
    else if([id1 isEqualToString:@"15"])
    {
        [self type15];
    }
    
}

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishTextAction:(id)sender
{
    if(![_enterText.text isEqual:[NSNull null]] || _enterText.text == nil){
        
     templateText=self.enterText.text;
    txtlabel.text=templateText;
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    txtlabel.textAlignment=NSTextAlignmentCenter;
    
    }
    [self.view endEditing:YES];
    
}

-(void)Type1
{
    NSLog(@"type1");
    
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0,0, 210,70)];
    isView=NO;
    
    parentView.layer.cornerRadius=10;
    parentView.layer.masksToBounds = true;
    parentView.backgroundColor=bgColor;
    
    subView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, parentView.frame.size.width*20/100,parentView.frame.size.height)];
    subView1.backgroundColor=[UIColor clearColor];
    
    img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40,40)];
    
    [img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"buket.png"]];
    img.center=subView1.center;
    
    [subView1 addSubview:img];
    
    [parentView addSubview:subView1];
    
    subView2=[[UIView alloc]initWithFrame:CGRectMake(subView1.frame.origin.x+subView1.frame.size.width,subView1.frame.origin.y+4, (parentView.frame.size.width*80/100)-4,parentView.frame.size.height-8)];
    
    subView2.backgroundColor = bgColor2;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:subView2.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = subView2.bounds;
    maskLayer.path  = maskPath.CGPath;
    subView2.layer.mask = maskLayer;
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 0, subView2.bounds.size.width-4,subView2.bounds.size.height)];
    
    txtlabel.text=templateText;
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    
    txtlabel.textAlignment=NSTextAlignmentCenter;
    txtlabel.textColor=txtColor;
    
    txtlabel.backgroundColor=[UIColor clearColor];
    [txtlabel setFont:[UIFont fontWithName:fontStyle size:txtSize]];
    
    
    [subView2 addSubview:txtlabel];
    [parentView addSubview:subView2];
    
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    //self.editView.center;
    
    [self.editView addSubview:parentView];
    
}

-(void)Type2
{
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0,0, 180,50)];
    parentView.backgroundColor=bgColor2;
    
    subView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, parentView.frame.size.width*70/100,parentView.frame.size.height)];
    
    subView1.backgroundColor=bgColor2;
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, subView1.frame.size.width,subView1.frame.size.height)];
    
    txtlabel.text=templateText;
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    txtlabel.textAlignment=NSTextAlignmentCenter;
    txtlabel.backgroundColor=[UIColor clearColor];
    txtlabel.textColor=txtColor;
    
    [txtlabel setFont:[UIFont fontWithName:fontStyle size:txtSize]];
    [subView1 addSubview:txtlabel];
    [parentView addSubview:subView1];
    
    
    subView2=[[UIView alloc]initWithFrame:CGRectMake(subView1.frame.origin.x+subView1.frame.size.width, 0, parentView.frame.size.width*30/100,parentView.frame.size.height)];
    
    subView2.backgroundColor = bgColor2;//UIColorFromRGB(0x3D5C9B);
    
    img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32,32)];
    [img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"buket.png"]];
    img.contentMode=UIViewContentModeScaleAspectFit;
    img.center = CGPointMake(subView2.frame.size.width/2, subView2.frame.size.height/2);
    
    [subView2 addSubview:img];
    [parentView addSubview:subView2];
    //  parentView.center=self.editView.center;
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview:parentView];
    
}

-(void)Type3
{
    NSLog(@"type 3 begin");
    
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0,0,180 ,60 )];
    
    parentView.backgroundColor=bgColor2;
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(0,10, parentView.frame.size.width,parentView.frame.size.height)];
    parentView.layer.cornerRadius=10;
    
    txtlabel.text  = templateText;
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    txtlabel.textAlignment=NSTextAlignmentCenter;
    txtlabel.backgroundColor=[UIColor clearColor];
    [txtlabel setFont:[UIFont fontWithName:fontStyle size:txtSize]];
    
    txtlabel.textColor=txtColor;
    txtlabel.backgroundColor=[UIColor clearColor];
    
    [parentView addSubview:txtlabel];
    // parentView.center=self.editView.center;
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview:parentView];
}

-(void)Type4
{
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0,0,200,50)];
    parentView.backgroundColor=[UIColor lightGrayColor];//UIColorFromRGB(0x006cc4);
    parentView.layer.borderWidth=2;
    parentView.layer.borderColor=[UIColor lightGrayColor].CGColor;//[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.9].CGColor;
    
    parentView.layer.cornerRadius=20;
    parentView.layer.masksToBounds=true;
    
    subView2=[[UIView alloc]initWithFrame:CGRectMake(4, 4, parentView.frame.size.width-8,parentView.frame.size.height-8)];
    subView2.layer.borderWidth=0.5;
    subView2.layer.borderColor=[UIColor blueColor].CGColor;//[UIColor colorWithRed:15.0f green:29.0f blue:66.0f alpha:1].CGColor;
    
    subView2.backgroundColor = bgColor2;
    subView2.layer.cornerRadius=20;
    subView2.layer.masksToBounds=true;
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0,parentView.frame.size.width,parentView.frame.size.height)];
    
    txtlabel.text=templateText;//@"Book Online Now";
    txtlabel.font=[UIFont fontWithName:fontStyle size:txtSize];
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    txtlabel.textAlignment=NSTextAlignmentCenter;
    txtlabel.textColor=txtColor;//[UIColor whiteColor];
    txtlabel.backgroundColor=[UIColor clearColor];
    
    [subView2 addSubview:txtlabel];
    [parentView addSubview:subView2];
    // parentView.center=self.editView.center;
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview:parentView];
    
}

-(void)Type5
{
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0,0, 160,60)];
    parentView.layer.cornerRadius=30;
    parentView.layer.masksToBounds=true;
    
    
    subView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, parentView.frame.size.width*30/100,parentView.frame.size.height)];
    
    subView1.backgroundColor=bgColor2;//UIColorFromRGB(0xcf61bb);
    
    img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40,40)];
    
    [img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"buket.png"]];
    img.center = CGPointMake(subView1.frame.size.width/2, subView1.frame.size.height/2);
    
    [subView1 addSubview:img];
    
    [parentView addSubview:subView1];
    
    subView2=[[UIView alloc]initWithFrame:CGRectMake(subView1.frame.origin.x+subView1.frame.size.width,subView1.frame.origin.y, parentView.frame.size.width*70/100,parentView.frame.size.height)];
    
    subView2.backgroundColor = bgColor2;
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, subView2.frame.size.width,subView2.frame.size.height)];
    txtlabel.text=templateText;//@"ADD TO CART";
    txtlabel.textColor=txtColor;//[UIColor whiteColor];
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    txtlabel.textAlignment=NSTextAlignmentCenter;
    [txtlabel setFont:[UIFont fontWithName:fontStyle size:txtSize]];
    
    [subView2 addSubview:txtlabel];
    [parentView addSubview:subView2];
    // parentView.center=self.editView.center;
    
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview:parentView];
}

-(void)Type6
{
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 80)];
    parentView.backgroundColor=bgColor2;
    
    subView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0,parentView.frame.size.width, parentView.frame.size.height)];
    
    CGFloat borderWidth = 2.0f;
    
    subView1.layer.borderColor = [UIColor grayColor].CGColor;
    subView1.layer.borderWidth = borderWidth;
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,150, 80)];
    txtlabel.text=templateText;
    txtlabel.textColor=txtColor;//[UIColor darkGrayColor];
    txtlabel.textAlignment=NSTextAlignmentCenter;
    [txtlabel setFont:[UIFont fontWithName:fontStyle size:txtSize]];
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    
    [txtlabel sizeToFit];
    txtlabel.textAlignment=NSTextAlignmentCenter;
    txtlabel.backgroundColor=[UIColor clearColor];
    
    subView1.frame=txtlabel.frame;
    
    [subView1 addSubview:txtlabel];
    [parentView addSubview:subView1];
    // parentView.center=self.editView.center;
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview:parentView];
}

-(void)Type7
{
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 80)];
    
    CGFloat borderWidth = 2.0f;
    parentView.backgroundColor=bgColor2;
    
    parentView.layer.borderColor = [UIColor grayColor].CGColor;
    parentView.layer.borderWidth = borderWidth;
    parentView.layer.cornerRadius=10.0f;
    
    subView1=[[UIView alloc]initWithFrame:CGRectMake(parentView.    frame.size.width*2.5/100, parentView.frame.size.height*7.5/100,parentView.frame.size.width*95/100, parentView.frame.size.height*85/100)];
    subView1.backgroundColor=[UIColor clearColor];
    subView1.layer.cornerRadius=10.0f;
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,subView1.frame.size.width, subView1.frame.size.height)];
    
    txtlabel.font= [UIFont fontWithName:fontStyle size:txtSize];
    txtlabel.text=templateText;
    
    txtlabel.backgroundColor=[UIColor clearColor];
    txtlabel.textColor=txtColor;
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    txtlabel.textAlignment=NSTextAlignmentCenter;
    [subView1 addSubview:txtlabel];
    
    [parentView addSubview:subView1];
    //parentView.center=self.editView.center;
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview:parentView];
}

-(void)Type8
{
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,200, 60)];
    parentView.backgroundColor=bgColor2;
    parentView.layer.cornerRadius=10.0f;
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,parentView.frame.size.width, parentView.frame.size.height)];
    
    txtlabel.font= [UIFont fontWithName:fontStyle size:txtSize];
    txtlabel.text=templateText;
    txtlabel.backgroundColor=[UIColor clearColor];
    txtlabel.textColor=txtColor;
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    txtlabel.textAlignment=NSTextAlignmentCenter;
    [parentView addSubview:txtlabel];
    
    //  parentView.center=self.editView.center;
    
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview:parentView];
}

-(void)Type9
{
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,200, 80)];
    parentView.backgroundColor=bgColor2;
    
    subView1=[[UIView alloc]initWithFrame:CGRectMake(parentView.frame.size.width*5/100, parentView.frame.size.height*15/100,parentView.frame.size.width*30/100, parentView.frame.size.height*70/100)];
    subView1.backgroundColor=bgColor2;
    
    img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"buket.png"]];
    img.center = CGPointMake(subView1.frame.size.width/2, subView1.frame.size.height/2);
    [subView1 addSubview:img];
    
    [parentView addSubview:subView1];
    
    subView2=[[UIView alloc]initWithFrame:CGRectMake(parentView.frame.origin.x+subView1.frame.size.width+ parentView.frame.size.width*5/100,0,parentView.frame.size.width*60/100, parentView.frame.size.height)];
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, subView2.frame.size.width, subView2.frame.size.height)];
    txtlabel.textAlignment=NSTextAlignmentCenter;
    txtlabel.backgroundColor=[UIColor clearColor];
    txtlabel.text=templateText;
    txtlabel.textColor=txtColor;
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    txtlabel.textAlignment=NSTextAlignmentCenter;
    
    txtlabel.font= [UIFont fontWithName:fontStyle size:txtSize];
    
    [subView2 addSubview:txtlabel];
    [parentView addSubview:subView2];
    // parentView.center=self.editView.center;
    
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview:parentView];
}

-(void)Type10
{
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,200, 100)];
    parentView.backgroundColor=bgColor2;
    
    subView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0,parentView.frame.size.width, parentView.frame.size.height/2)];
    subView1.backgroundColor=[UIColor clearColor];
    
    img=[[UIImageView alloc]initWithFrame:CGRectMake((subView1.frame.size.width/2)-20,(subView1.frame.size.height/2)-10, 40, 40)];
    [img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"buket.png"]];
    [subView1 addSubview:img];
    
    [parentView addSubview:subView1];
    
    subView2=[[UIView alloc]initWithFrame:CGRectMake(parentView.frame.origin.x,subView1.frame.origin.y+subView1.frame.size.height ,parentView.frame.size.width, parentView.frame.size.height/2)];
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, subView2.frame.size.width, subView2.frame.size.height)];
    txtlabel.textAlignment=NSTextAlignmentCenter;
    txtlabel.backgroundColor=[UIColor clearColor];
    txtlabel.text=templateText;
    txtlabel.textColor=txtColor;
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    txtlabel.textAlignment=NSTextAlignmentCenter;
    txtlabel.font= [UIFont fontWithName:fontStyle size:txtSize];
    
    [subView2 addSubview:txtlabel];
    [parentView addSubview:subView2];
    // parentView.center=self.editView.center;
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview:parentView];
}

-(void)Type11
{
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,150, 150)];
    parentView.backgroundColor=bgColor2;
    
    parentView.layer.cornerRadius=parentView.frame.size.height/2;
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(2, parentView.frame.size.height/4, parentView.frame.size.width-4, parentView.frame.size.height/2)];
    txtlabel.textAlignment=NSTextAlignmentCenter;
    
    txtlabel.backgroundColor=[UIColor clearColor];
    txtlabel.text=templateText;
    txtlabel.textColor=txtColor;
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    txtlabel.textAlignment=NSTextAlignmentCenter;
    // [txtlabel addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    txtlabel.font= [UIFont fontWithName:fontStyle size:txtSize];
    [parentView addSubview:txtlabel];
    // parentView.center=self.editView.center;
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview: parentView];
}

-(void)type12
{
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,120, 120)];
    parentView.backgroundColor=bgColor2;
    
    parentView.layer.cornerRadius=parentView.frame.size.height/2;
    img=[[UIImageView alloc]initWithFrame:CGRectMake((parentView.frame.size.width/2)-20,(parentView.frame.size.height/2)-20, 40, 40)];
    [img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"buket.png"]];
    [parentView addSubview:img];
    // parentView.center=self.editView.center;
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview: parentView];
}

-(void)type13
{
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,220, 60)];
    parentView.backgroundColor=bgColor2;
    parentView.layer.cornerRadius=30;
    
    subView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,(parentView.frame.size.width*75/100), parentView.frame.size.height)];
    subView1.backgroundColor=[UIColor clearColor];
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, subView1.frame.size.width-10, subView1.frame.size.height)];
    txtlabel.textAlignment=NSTextAlignmentCenter;
    txtlabel.backgroundColor=[UIColor clearColor];
    txtlabel.text=templateText;
    txtlabel.textColor=txtColor;
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    txtlabel.textAlignment=NSTextAlignmentCenter;
    txtlabel.font= [UIFont fontWithName:fontStyle size:txtSize];
    
    [subView1 addSubview:txtlabel];
    
    [parentView addSubview:subView1];
    
    subView2=[[UIView alloc]initWithFrame:CGRectMake(subView1.frame.origin.x+subView1.frame.size.width, 0,parentView.frame.size.width*25/100, parentView.frame.size.height)];
    subView2.backgroundColor=[UIColor clearColor];
    
    img=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,50,50)];
    [img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"buket.png"]];
    
    img.center= CGPointMake(subView2.frame.size.width/2, subView2.frame.size.height/2);
    [subView2 addSubview:img];
    
    [parentView addSubview:subView2];
    // parentView.center=self.editView.center;
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview:parentView];
}

-(void)type14
{
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,180, 60)];
    parentView.backgroundColor=bgColor2;
    parentView.layer.cornerRadius=10.0f;
    
    subView1=[[UIView alloc]initWithFrame:CGRectMake(2,2,parentView.frame.size.width-4, parentView.frame.size.height-4)];
    
    CAShapeLayer *yourViewBorder = [CAShapeLayer layer];
    yourViewBorder.strokeColor = [UIColor whiteColor].CGColor;
    yourViewBorder.fillColor = [[UIColor clearColor] CGColor];
    [yourViewBorder setLineWidth:3.0f];
    yourViewBorder.lineDashPattern = @[@6, @6];
    yourViewBorder.frame = subView1.bounds;
    yourViewBorder.path = [UIBezierPath bezierPathWithRect:subView1.bounds].CGPath;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:subView1.bounds cornerRadius:10.0];
    [yourViewBorder setPath:path.CGPath];
    [subView1.layer addSublayer:yourViewBorder];
    
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, subView1.frame.size.width, subView1.frame.size.height)];
    txtlabel.textAlignment=NSTextAlignmentCenter;
    txtlabel.backgroundColor=[UIColor clearColor];
    txtlabel.text=templateText;
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    txtlabel.textAlignment=NSTextAlignmentCenter;
    
    txtlabel.textColor=txtColor;
    
    txtlabel.font= [UIFont fontWithName:fontStyle size:txtSize];
    
    [subView1 addSubview:txtlabel];
    
    [parentView addSubview:subView1];
    //parentView.center=self.editView.center;
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview:parentView];
}

-(void)type15
{
    parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,250, 80)];
    parentView.backgroundColor=bgColor;
    parentView.layer.cornerRadius=10.0f;
    
    subView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0,parentView.frame.size.width*25/100, parentView.frame.size.height)];
    subView1.backgroundColor=[UIColor clearColor];
    
    img=[[UIImageView alloc]initWithFrame:CGRectMake((subView1.frame.size.width/2)-20,(subView1.frame.size.height/2)-20, 40, 40)];
    [img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"buket.png"]];
    [subView1 addSubview:img];
    
    [parentView addSubview:subView1];
    
    subView2=[[UIView alloc]initWithFrame:CGRectMake(subView1.frame.origin.x+subView1.frame.size.width+5,5,(parentView.frame.size.width*75/100)-10, (parentView.frame.size.height-10))];
    subView2.backgroundColor=bgColor2;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:subView2.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path  = maskPath.CGPath;
    subView2.layer.mask = maskLayer;
    
    txtlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, subView2.frame.size.width, subView2.frame.size.height)];
    txtlabel.textAlignment=NSTextAlignmentCenter;
    txtlabel.backgroundColor=[UIColor clearColor];
    txtlabel.text=templateText;
    txtlabel.textColor=txtColor;
    txtlabel.numberOfLines=0;
    txtlabel.lineBreakMode=YES;
    txtlabel.textAlignment=NSTextAlignmentCenter;
    
    txtlabel.font= [UIFont fontWithName:fontStyle size:txtSize];
    
    [subView2 addSubview:txtlabel];
    [parentView addSubview:subView2];
    //  parentView.center=self.editView.center;
    parentView.center=CGPointMake(self.editView.frame.size.width/2, self.editView.frame.size.height/2);
    
    [self.editView addSubview:parentView];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
         [self.navigationController.view makeToast:@"Ypu can type only 15 characters"];
        return NO;
       
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 15;
}
#pragma MKDropdownMenu Delegate

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component
{
    return 50;
}


- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu
{
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component
{
    return [fontNames count];
}


- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component
{
    
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    NSAttributedString *attrString;
    attrString = [[NSAttributedString alloc] initWithString:headerValue attributes:attrsDictionary];
    
    return attrString;
    
}


- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    NSAttributedString *attrString;
    
    attrString = [[NSAttributedString alloc] initWithString:fontNames[row] attributes:attrsDictionary];
    
    return attrString;
    
}


- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    headerValue = fontNames[row];
    fontStyle=fontNames[row];
    txtlabel.font= [UIFont fontWithName:fontStyle size:txtSize];
    
    boldFont=[UIFont fontWithName:fontStyle size:txtSize];
    italicFont=[UIFont fontWithName:fontStyle size:txtSize];
    
    delay(0.15,
          ^{
              [dropdownMenu closeAllComponentsAnimated:YES];
              
              [self.fontDropDownView reloadAllComponents];
          });
}


static inline void delay(NSTimeInterval delay, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)backColorPicker:(id)sender
{
    isView=YES;
    isText=NO;
    [self colorPicker];
}

-(void)colorPicker
{
    
    //        navCtrl.delegate = self;
    
    if(isView==YES)
    {
        [popoverController presentPopoverFromRect:self.colorView.frame  inView:self.colorView.superview
                         permittedArrowDirections:WYPopoverArrowDirectionAny
                                         animated:YES options:WYPopoverAnimationOptionFadeWithScale];
    }
    else if (isText==YES)
    {
        [popoverController presentPopoverFromRect:self.textColorPicker.frame  inView:self.textColorPicker.superview permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES
                                          options:WYPopoverAnimationOptionFadeWithScale];
    }
    
}

- (void)colorViewController:(MSColorSelectionViewController *)colorViewCntroller didChangeColor:(UIColor *)color
{
    NSLog(@"selected color:%@",color);
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    if(isView==YES)
    {
        NSLog(@"color if called");
        backgroundColor=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
        backgroundColor=[NSString stringWithFormat:@"#%@",backgroundColor];
        
        bgColor2=color;
        bgColor=color;
        bgColor=[bgColor colorWithAlphaComponent:.5];
        if([id1 isEqualToString:@"1"] || [id1 isEqualToString:@"15"])
        {
            parentView.backgroundColor=bgColor;
        }
        else
        {
            parentView.backgroundColor=bgColor2;
        }
        
        if([img isDescendantOfView:subView1])
        {
            NSLog(@"its img");
            subView1.backgroundColor=[UIColor clearColor];
        }
        if([txtlabel isDescendantOfView:subView2])
        {
            NSLog(@"its label");
            subView2.backgroundColor=bgColor2;
        }
        
        if([img isDescendantOfView:subView2])
        {
            NSLog(@"its img1");
            subView2.backgroundColor=[UIColor clearColor];
        }
        if([txtlabel isDescendantOfView:subView1])
        {
            NSLog(@"its label1");
            subView1.backgroundColor=bgColor2;
        }
        [self.colorView setBackgroundColor:bgColor2];
        
    }
    else if(isText==YES)
    {
        NSLog(@"color else called");
        textColor=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
        textColor=[NSString stringWithFormat:@"#%@",textColor];
        txtColor=color;
        txtlabel.textColor=txtColor;
        
        [self.textColorPicker setBackgroundColor:txtColor];
        
    }
}

- (IBAction)textColorPicker:(id)sender
{
    isText=YES;
    isView=NO;
    
    [self colorPicker];
    
    //    MSColorSelectionViewController *colorSelectionController = [[MSColorSelectionViewController alloc] init];
    //
    //    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:colorSelectionController];
    //
    //    //        navCtrl.delegate = self;
    //
    //    popoverController = [[WYPopoverController alloc ]initWithContentViewController:navCtrl];
    //
    //    popoverController.delegate = self;
    //
    //    colorSelectionController.delegate = self;
    //
    //    colorSelectionController.color = [UIColor whiteColor];
    //
    //    popoverController.popoverContentSize = CGSizeMake(250, 500);
    //
    //        [popoverController presentPopoverFromRect:self.textColorPicker.frame  inView:self.textColorPicker.superview permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES
    //             options:WYPopoverAnimationOptionFadeWithScale];
}

- (IBAction)doneEditing:(id)sender
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    CGSize size = [parentView frame].size;
    UIGraphicsBeginImageContextWithOptions(size,NO,2.0);
    [[parentView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *drawingViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data=[NSData dataWithData:UIImagePNGRepresentation(drawingViewImage)];
    
    UIImage *img=[UIImage imageNamed:@"refresh.png"];
    NSData *d=[NSData dataWithData:UIImagePNGRepresentation(img)];
    
    
    NSLog(@"imgData:%@",data);
    NSLog(@"SourceID:%@",id1);
    NSLog(@"fontStyle:%@",fontStyle);
    NSLog(@"FontSize:%@",textSize);
    NSLog(@"TextColor:%@",textColor);
    NSLog(@"BackgroundColor:%@",backgroundColor);
    NSLog(@"TemplateText:%@",templateText);
    NSString *postURL;
    if([_editFrom isEqualToString:@"reEdit"])
    {
        postURL=@"https://www.hypdra.com/api/api.php?rquest=edit_user_call_to_action_button";
    }
    else
    {
        postURL=@"https://www.hypdra.com/api/api.php?rquest=user_call_to_action_button";
    }
    
    NSMutableURLRequest *requests = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:postURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                     {
                                         
                                         // [formData appendPartWithFileData:data name:@"Uploaded_file" fileName:@"user_call_to_action_img.png" mimeType:@"image/png"];
                                         
                                         [formData appendPartWithFileData:data name:@"user_call_to_action_img" fileName:@"user_call_to_action_img.png" mimeType:@"image/jpeg"];
                                         
                                         [formData appendPartWithFormData:[userID dataUsingEncoding:NSUTF8StringEncoding] name:@"user_id"];
                                         
                                         [formData appendPartWithFormData:[imageIcon dataUsingEncoding:NSUTF8StringEncoding] name:@"logo_image"];
                                         
                                         [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding] name:@"lang"];
                                         
                                         [formData appendPartWithFormData:[backgroundColor dataUsingEncoding:NSUTF8StringEncoding] name:@"bg_color"];
                                         
                                         [formData appendPartWithFormData:[templateText dataUsingEncoding:NSUTF8StringEncoding] name:@"text"];
                                         
                                         [formData appendPartWithFormData:[textColor dataUsingEncoding:NSUTF8StringEncoding] name:@"text_color"];
                                         
                                         [formData appendPartWithFormData:[textSize dataUsingEncoding:NSUTF8StringEncoding] name:@"text_size"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"border_color"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"border_type"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"border_width"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"border_radius"];
                                         
                                         [formData appendPartWithFormData:[fontStyle dataUsingEncoding:NSUTF8StringEncoding] name:@"font_style"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"font_case_upper_lower"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"clip_layout_height"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"clip_layout_width"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"clip_layout_top"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"clip_layout_left"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"clip_text_height"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"clip_text_width"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"clip_text_top"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"clip_text_left"];
                                         
                                         [formData appendPartWithFormData:[@"Library" dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
                                         
                                         [formData appendPartWithFormData:[id1 dataUsingEncoding:NSUTF8StringEncoding] name:@"source_id"];
                                         
                                         if([_editFrom isEqualToString:@"reEdit"])
                                         {
                                             [formData appendPartWithFormData:[editID dataUsingEncoding:NSUTF8StringEncoding] name:@"edit_id"];
                                             
                                         }
                                         
                                     } error:nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:requests
                  progress:^(NSProgress * _Nonnull uploadProgress)
                  {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(),
                                     ^{
                                         //Update the progress view
                                         //                          [progressView setProgress:uploadProgress.fractionCompleted];
                                     });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                  {
                      if (error)
                      {
                          NSLog(@"Error For Image: %@", error);
                          [hud hideAnimated:YES];
                      }
                      else
                      {
                          NSDictionary *responsseObject=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                          
                          NSLog(@"Response For Image:%@",responsseObject);
                          
                          NSLog(@"Response For Image123:%@",responseObject);
                          
                          NSLog(@"Response For:%@",response);
                          
                          if (responseObject == NULL)
                          {
                              
                          }
                          else
                          {
                              
//                              UIStoryboard *mainSB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//                              CallToActionTabViewController *vc=[mainSB instantiateViewControllerWithIdentifier:@"Call to action"];
//
//                              vc.calledVC=@"fromCTAEdit";
//
//                              [self.navigationController pushViewController:vc animated:YES];
                            
                              [self.navigationController popViewControllerAnimated:YES];
                              
                             // [[self.tabBarController.viewControllers objectAtIndex:1] popToRootViewControllerAnimated:NO];

                              //                              UITabBarController *loadTabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"Call to action"];
                              //                              loadTabBar.selectedIndex=0;
                              //
                              //                              UINavigationController *nav=[[[UINavigationController alloc]init]initWithRootViewController:loadTabBar];
                              //
                              //                              [nav.navigationBar setBarTintColor:UIColorFromRGB(0x4186F2)];
                              //
                              //                              [self presentViewController:nav animated:YES completion:nil];
                              
                          }
                          [hud hideAnimated:YES];
                      }
                  }];
    
    [uploadTask resume];
    
}

- (IBAction)boldAction:(id)sender
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

- (IBAction)italicAction:(id)sender
{
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

- (IBAction)upperCaseAction:(id)sender
{
    /*if(isIncrease==1)
{
    NSString *txt=txtlabel.text;
    txtlabel.text=[txt lowercaseString];
    
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
}*/
    
    
    
    
    
    
    if(isIncrease==1)
    {
        NSString *txt=templateText;
        txtlabel.text=[txt lowercaseString];
        isIncrease=2;
    }
    else if(isIncrease==2)
    {
        NSString *txt=templateText;
        txtlabel.text=[txt uppercaseString];
        isIncrease=3;
    }
    else if (isIncrease==3)
    {
        NSString *txt=templateText;
        txtlabel.text= [txt capitalizedString];
        isIncrease=1;
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
       // lang = textFontStyle;
        
        _SelectedFont_lbl.text = textFontStyle;
        self.SelectedFont_lbl.font=[UIFont fontWithName:textFontStyle size:15];
        txtlabel.font = [UIFont fontWithName:textFontStyle size:txtlabel.font.pointSize];
        
        [hud hideAnimated:YES];
        
    });
}


@end

