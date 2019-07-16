//
//  CreateButtonsViewController.h
//  Montage
//
//  Created by MacBookPro on 6/29/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUserResizableView.h"
#import "MSColorSelectionViewController.h"
#import "MKDropdownMenu.h"

@interface CreateButtonsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
-(int)getRandomNumberBetween:(int)from to:(int)to;

- (IBAction)createShape:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *createShapeLabel;

- (IBAction)createText:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *createTextLabel;

- (IBAction)createBorder:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *createBorderLabel;

@property (strong, nonatomic) IBOutlet UIView *createShapeView;

@property (strong, nonatomic) IBOutlet UIView *createTextView;

@property (strong, nonatomic) IBOutlet UIView *createBorderView;

- (IBAction)colorPicker:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *color_outlet;
@property (strong, nonatomic) IBOutlet UIButton *TextColorPicker;
- (IBAction)TextColorOutlet:(id)sender;
- (IBAction)TextDone:(id)sender;

@property (strong, nonatomic) IBOutlet UISlider *radius_Slider_outlet;
@property (strong, nonatomic) IBOutlet UITextField *EnterTextField;
-(IBAction)fontStyle:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *fontStyle_Outlet;

- (IBAction)Radius_slider:(id)sender;
@property (strong,nonatomic)SPUserResizableView *mainResizableView;
@property (strong, nonatomic) UILabel *contentTextView;
@property (strong,nonatomic)  UIImageView *LogoImageView;
@property (strong, nonatomic) UIView *TextViewSuperView;
@property (strong, nonatomic) UIView *LogoViewSuperView;
@property (strong, nonatomic) UIView* BlurView;
@property (strong, nonatomic) UIWindow* currentWindow;
@property (strong, nonatomic) IBOutlet UIView *DrawingBoard;

@property (nonatomic, strong) UIColor *bg_color;
@property (nonatomic, strong) UIColor *border_color;
@property (nonatomic) CGFloat border_radius;

@property (nonatomic, strong) NSString *border_type;

@property (nonatomic) CGFloat border_width;

@property (nonatomic) CGFloat clip_layout_height;

@property (nonatomic) CGFloat clip_layout_width;

@property (nonatomic) CGFloat clip_text_height;

@property (nonatomic) CGFloat clip_text_left;

@property (nonatomic) CGFloat clip_text_top;

@property (nonatomic) CGFloat clip_text_width;

@property (nonatomic, strong) NSString *font_case_upper_lower;

@property (nonatomic, strong) NSString *font_style;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIColor *text_color;
@property (nonatomic) CGFloat text_size;

@property (assign, nonatomic) Boolean buttonExist,isReEdit,fromCollection;

- (IBAction)Create_Logo:(id)sender;

- (IBAction)SaveToCollection:(id)sender;
- (IBAction)UseForVideo:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *BorderSlider_outlet;

@property (strong, nonatomic) IBOutlet UISlider *size_Slider_Outlet;

- (IBAction)BorderChange:(id)sender;
@property (strong, nonatomic) IBOutlet MKDropdownMenu *fontDropList;

- (IBAction)newColorPicker:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *colorNew_outlet;
@property (strong, nonatomic) IBOutlet UILabel *widthValueIndicator;
@property (strong, nonatomic) IBOutlet UILabel *radiusValueIndicator;
@property (strong, nonatomic) IBOutlet UIButton *createShape;
@property (strong, nonatomic) IBOutlet UIButton *createText;

@property (strong, nonatomic) IBOutlet UIView *createShapeViewGesture;

@property (strong, nonatomic) IBOutlet UIView *createTextViewGesture;
@property (strong, nonatomic) IBOutlet UILabel *sizeIndicator;

- (IBAction)textFontSlider:(id)sender;

@property (strong, nonatomic) IBOutlet UISlider *textFontSliderOutlet;
@property (strong, nonatomic) IBOutlet UIButton *TextDoneOutlet;
@property (strong, nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) IBOutlet UIView *font_Search_Selecting_View;
@property (strong, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) IBOutlet UILabel *SelectedFont_lbl;
@property (strong, nonatomic) IBOutlet UIView *fontSelectionView;
- (IBAction)Bold:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *Bold_outlet;
@property (strong, nonatomic) IBOutlet UIButton *Italic_outlet;
- (IBAction)Italic:(id)sender;

@end

