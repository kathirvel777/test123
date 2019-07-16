//
//  LibraryButtonaViewController.h
//  Montage
//
//  Created by MacBookPro on 9/21/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDropdownMenu.h"
#import "MSColorSelectionViewController.h"
//#import "TextFieldValidator.h"

@interface LibraryButtonaViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UIView *editView;

@property (strong, nonatomic) IBOutlet UIButton *colorView;



@property (strong, nonatomic) IBOutlet UIButton *finishText;
- (IBAction)finishTextAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *fontNameView;

@property (strong, nonatomic) IBOutlet UISlider *sliderFontSize;

- (IBAction)SliderAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *enterText;



@property (strong, nonatomic) IBOutlet MKDropdownMenu *fontDropDownView;

@property (strong, nonatomic) NSMutableArray *buttonArray;

@property (strong, nonatomic) NSString  *editFrom;

- (IBAction)backAction:(id)sender;
- (IBAction)backColorPicker:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *textColorPicker;
- (IBAction)textColorPicker:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *fontSizelabel;
- (IBAction)doneEditing:(id)sender;
- (IBAction)boldAction:(id)sender;
- (IBAction)italicAction:(id)sender;
- (IBAction)upperCaseAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *TextAttributesView;
@property (strong, nonatomic) IBOutlet UIView *fontSevecton;
@property (strong, nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) IBOutlet UIView *font_search_Selecting_View;
@property (strong, nonatomic) IBOutlet UIView *fontSelectionView;
@property (strong, nonatomic) IBOutlet UILabel *SelectedFont_lbl;

@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) IBOutlet UISearchBar *SearchBar;

@property (strong, nonatomic) IBOutlet UIButton *Bold_outlet;
@property (strong, nonatomic) IBOutlet UIButton *Italic_outlet;

@property (strong, nonatomic) IBOutlet UIButton *UpperCaseLowerCase_outlet;

@end

