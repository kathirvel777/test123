//
//  WaterAndOrioViewController.h
//  Montage
//
//  Created by MacBookPro on 5/26/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKVideoPlayerViewController.h"
#import "VKVideoPlayerView.h"
#import "SPUserResizableView.h"
#import "CZPicker.h"
#import "MKDropdownMenu.h"
#import "SJVideoPlayer.h"


@interface WaterAndOrioViewController : UIViewController<SPUserResizableViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    SPUserResizableView *currentlyEditingView;
    SPUserResizableView *lastEditedView;
}

@property (atomic,strong) SJVideoPlayer *SJplayer;

@property (atomic,strong) VKVideoPlayerView *playerView;

@property (strong, nonatomic) NSString *playerURL;

@property (nonatomic, strong) NSString *currentLanguageCode;


@property (nonatomic, strong) NSString *playURL;
@property (nonatomic, readwrite) BOOL returnFromCLImage;


@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIView *textChange;

@property (strong, nonatomic) IBOutlet UIView *logoTopView;


@property (strong, nonatomic) IBOutlet UIView *logoBottomView;


@property (strong, nonatomic) IBOutlet UIView *OrientationView;

@property (strong, nonatomic) IBOutlet UIImageView *textImage;

@property (strong, nonatomic) IBOutlet UIImageView *logoImage;

@property (strong, nonatomic) IBOutlet UIImageView *orientationImage;


- (IBAction)textAction:(id)sender;


- (IBAction)logoAction:(id)sender;


- (IBAction)orientationAction:(id)sender;


//@property (strong, nonatomic) IBOutlet HoshiTextField *displayText;

@property (strong, nonatomic) IBOutlet UITextField *displayText;

@property (strong, nonatomic) IBOutlet UIButton *colorButton;


@property (strong, nonatomic) IBOutlet UIPickerView *languagePicker;


@property (strong, nonatomic) IBOutlet UIButton *alignText;


- (IBAction)Bold:(id)sender;


- (IBAction)Italic:(id)sender;


- (IBAction)Increase:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *videoResizable;


- (IBAction)Spacing:(id)sender;


- (IBAction)sizeChange:(id)sender;


- (IBAction)opacityChange:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *sizeDisplay;


@property (strong, nonatomic) IBOutlet UILabel *opacityDisplay;


@property (strong, nonatomic) IBOutlet UISlider *sizeSlider;


@property (strong, nonatomic) IBOutlet UISlider *opacitySlider;

- (IBAction)uploadImage:(id)sender;


@property (strong, nonatomic) IBOutlet UIImageView *Text_dot_icon;


- (IBAction)edit_Atn:(id)sender;


- (IBAction)ok_Atn:(id)sender;


- (IBAction)del_Atn:(id)sender;


- (IBAction)plus_Atn:(id)sender;


@property (strong, nonatomic) IBOutlet UIImageView *btnImgView;


- (IBAction)clockWise:(id)sender;

- (IBAction)antiClockWise:(id)sender;

- (IBAction)horizontal:(id)sender;

- (IBAction)vertical:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *text;

@property (strong, nonatomic) IBOutlet UIButton *logo;

@property (strong, nonatomic) IBOutlet UIButton *orientation;

@property(nonatomic, readwrite) CGSize naturalSize;

- (IBAction)languageAction:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *langSelection;


- (IBAction)colorPicker:(id)sender;

- (IBAction)addText:(id)sender;
- (IBAction)Done:(id)sender;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneBtn;



@property (strong, nonatomic) IBOutlet UIButton *clockWiseBtn;

@property (strong, nonatomic) IBOutlet UIButton *antiClockWiseBtn;

@property (strong, nonatomic) IBOutlet UIButton *horizontalBtn;

@property (strong, nonatomic) IBOutlet UIButton *verticalBtn;

@property (strong, nonatomic) IBOutlet UIButton *logoPlus;


@property (strong, nonatomic) IBOutlet UIButton *editBtn;


@property (strong, nonatomic) IBOutlet UIButton *okBtn;


@property (strong, nonatomic) IBOutlet UIButton *delBtn;

@property (strong, nonatomic) IBOutlet MKDropdownMenu *languageSelect;
@property (strong, nonatomic) IBOutlet UIImageView *Text_Image;
@property (strong, nonatomic) IBOutlet UIImageView *Orientation_img;
@property (strong, nonatomic) IBOutlet UILabel *Orientation_lbl;
@property (strong, nonatomic) IBOutlet UIImageView *logo_image;
@property (strong, nonatomic) IBOutlet UILabel *logo_lbl;
@property (strong, nonatomic) IBOutlet UILabel *Text_Label;
@property (strong, nonatomic) IBOutlet UIView *Text_Attributes_View;
@property (strong, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) IBOutlet UILabel *SelectedFont_lbl;
@property (strong, nonatomic) IBOutlet UIView *fontSelectionView;
@property (strong, nonatomic) IBOutlet UIView *font_Search_Selecting_View;

@property (strong, nonatomic) IBOutlet UIButton *text_done_outlet;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lowHeightConstraint;

@property (strong, nonatomic) IBOutlet UIButton *Bold_outlet;
@property (strong, nonatomic) IBOutlet UIButton *Italic_outlet;

@property (strong, nonatomic) IBOutlet UIButton *UpperCaseLowerCase_outlet;
- (IBAction)UpperLowerCase_btn:(id)sender;

@end

