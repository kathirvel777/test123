//
//  AddAdvanceCollectionViewController.m
//  Montage
//
//  Created by Mac on 5/12/17.
//  Copyright © 2017 sssn. All rights reserved.
//
#import "REFrostedViewController.h"
#import "PageSelectionViewController.h"
#import "DEMORootViewController.h"
#import "GetEffectsViewController.h"
#import "AdminMusicCategory.h"
#import "AFNetworking.h"
#import <ImageIO/ImageIO.h>
#import "AddAdvanceCollectionViewController.h"
#import "AddAdvanceCollectionViewCell.h"
#import "IGCMenu.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "MuiscTabViewController.h"
#import "MBProgressHUD.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface AddAdvanceCollectionViewController ()<UITextFieldDelegate,ClickDelegates>
{
    IGCMenu *igcMenu;
    BOOL isMenuActive;
    
    NSMutableArray *OnlyImages;
    NSMutableArray *MainArray;
    NSString *user_id,*albumName;
    UITextField *album;
    UITapGestureRecognizer *tapValue,*tapValue1;
    BOOL ReEdit;
    NSMutableArray *musicAry;
    NSMutableArray *musicTypeAry;
    NSMutableArray *musicColorAry;
    NSMutableArray *musicPosAry;
    NSMutableArray *musicColorIdentificationAry;
    MBProgressHUD *hud;
    
}

@end

@implementation AddAdvanceCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MainArray = [[NSMutableArray alloc]init];
    
    if (igcMenu == nil)
    {
        igcMenu = [[IGCMenu alloc] init];
    }
    
    OnlyImages = [[NSMutableArray alloc]init];
    
    igcMenu.delegate=self;
    
    _glcButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame),CGRectGetMidY(self.view.frame), 30, 30)];
    
    igcMenu.menuButton = _glcButton;
    //Pass refernce of menu button
    igcMenu.menuSuperView = self.view;      //Pass reference of menu button super view
    igcMenu.disableBackground = YES;        //Enable/disable menu background
    igcMenu.numberOfMenuItem = 5;           //Number of menu items to display
    igcMenu.menuItemsNameArray = [NSArray arrayWithObjects:@"Delete",@"Effects",@"Music",@"Title",@"Transition",nil];
    
    
    UIColor *deleteBGColor = [self colorFromHexString:@"#CE122B"];
    UIColor *effectBGColor = [self colorFromHexString:@"#E27C0E"];
    UIColor *musicBGColor = [self colorFromHexString:@"#0DC9D5"];
    //UIColor *userBackgroundColor = [UIColor clearColor];
    UIColor *titleBackgroundColor = [self colorFromHexString:@"#009900"];
    UIColor *transBackgroundColor = [self colorFromHexString:@"#017DF1"];
    
    UIColor *buyBackgroundColor = [UIColor clearColor];
    igcMenu.menuBackgroundColorsArray = [NSArray arrayWithObjects:deleteBGColor,effectBGColor,musicBGColor,titleBackgroundColor, transBackgroundColor,nil];
    igcMenu.menuImagesNameArray = [NSArray arrayWithObjects:@"126-delete.png",@"126-effect.png",@"126-music-1.png",@"title_icon.png",@"126-trans.png",nil];
    
    isMenuActive = NO;
    // Register cell classes
    //    [self.CollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //Chcking MainArray
    MainArray=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"MainArray"]];
    
    NSLog(@"Given Main Array = %@",MainArray);
    
    //   NSLog(@"MainArray_didLoad_1 %@",MainArray);
    
    if(MainArray == nil )
    {
        MainArray= [[NSMutableArray alloc]init];
    }
    
    //    NSLog(@"MainArray_didLoad_1 %@",MainArray);
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"CreateNewFinalDic"])
    {
        
        int cnt = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"shareArrayCount"];
        
        for (int i = 0; i<cnt; i++)
        {
            NSMutableDictionary *finalDic = [[NSMutableDictionary alloc]init];
            
            [finalDic setValue:@"NO" forKey:@"ReEdit"];
            [finalDic setValue:@"0" forKey:@"image_path"];
            [finalDic setValue:@"0" forKey:@"image_type"];
            [finalDic setValue:@"0" forKey:@"effect"];
            [finalDic setValue:@"0" forKey:@"transition"];
            [finalDic setValue:@"0" forKey:@"title_id"];
            [finalDic setValue:@"0" forKey:@"music_type"];
            [finalDic setValue:@"0" forKey:@"music"];
            [finalDic setValue:@"0" forKey:@"image_pos"];
            [finalDic setValue:@"0" forKey:@"music_pos"];
            [finalDic setValue:@"0" forKey:@"music_color"];
            [finalDic setValue:@"0" forKey:@"music_color_identification"];
            [finalDic setValue:@"0" forKey:@"title_one"];
            [finalDic setValue:@"0" forKey:@"title_two"];
            
            [MainArray addObject:finalDic];
        }
        
        NSLog(@"Cnt = %d",cnt);
        
        //Generating Final
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"CreateNewFinalDic"];
    }
    
    //    NSLog(@"MainArray_didLoaded_2  = %lu",(unsigned long)MainArray.count);
    user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_ID"];
    //    NSLog(@"MainArray %@",MainArray);
    
    
    CGSize screenSize = self.view.bounds.size;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //    [flowLayout setMinimumInteritemSpacing:4.0f];
    //
    //    [flowLayout setMinimumLineSpacing:10.0f];
    //
    //    //[self.collectionView setCollectionViewLayout:flowLayout];
    //
    //    [flowLayout setSectionInset:UIEdgeInsetsMake(12, 12, 12, 12)];
    
    
    /*    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
     [flowLayout setMinimumInteritemSpacing:2.0f];
     
     [flowLayout setMinimumLineSpacing:5.0f];
     
     [self.CollectionView setCollectionViewLayout:flowLayout];
     
     [flowLayout setSectionInset:UIEdgeInsetsMake(2, 2, 2, 2)];*/
    
    
    //   _previewAction = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-(screenSize.width *30/100)/2, CGRectGetMaxY(self.view.frame)-screenSize.width *20/100, screenSize.width *30/100 , screenSize.width *20/100)];
    //
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        _previewAction = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-(screenSize.width *30/100)/2, self.view.frame.size.height - screenSize.width *16/100, screenSize.width *30/100 , screenSize.width *15/100)];
    }
    else
    {
        NSLog(@"IpadAlbum");
        
        _previewAction = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-(screenSize.width *20/100)/2, self.view.frame.size.height - screenSize.width * 12/100, screenSize.width *20/100 , screenSize.width *10/100)];
    }
    
    UIImage *btnImage = [UIImage imageNamed:@"create-movie-2.png"];
    
    [[self.previewAction imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [_previewAction setImage:btnImage forState:UIControlStateNormal];
    // [_previewAction addTarget:self action:@selector(createAlbum:) forControlEvents:UIControlEventTouchUpInside];
    
    [_previewAction addTarget:self action:@selector(agreedTerms:) forControlEvents:UIControlEventTouchUpInside];
    
    _holdView =[[UIView alloc]initWithFrame:self.view.bounds];
    
    _EmptyImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    
    _EmptyImage.contentMode=UIViewContentModeScaleAspectFit;
    _EmptyImage.image = [UIImage imageNamed:@"500-advance-page-1.png"];
    
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapPosition:)];
    
    tapGesture1.numberOfTapsRequired = 1;
    
    [tapGesture1 setDelegate:self];
    [_holdView addGestureRecognizer:tapGesture1];
    
    [_holdView addSubview:_EmptyImage];
    [self.view addSubview:_holdView];
    [self.view addSubview:_previewAction];
    
    
    /*    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
     
     [flowLayout setMinimumInteritemSpacing:2.0f];
     
     [flowLayout setMinimumLineSpacing:2.0f];
     
     [self.CollectionView setCollectionViewLayout:flowLayout];*/
    
    
    /*    self.topView = [[UIView alloc]initWithFrame:self.view.frame];
     
     [self.view addSubview:self.topView];
     
     self.topView.backgroundColor = [UIColor blackColor];
     
     self.topView.alpha = 0.3;
     
     
     CGPoint f = self.topView.center;
     
     self.mainView = [[UIView alloc]init];
     
     
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
     
     self.mainView.frame = CGRectMake(f.x - (screenSize.width * 70/100)/2, f.y - (screenSize.height * 25/100)/2, screenSize.width * 70/100, screenSize.height * 20/100);
     }
     else
     {
     
     self.mainView.frame = CGRectMake(f.x - (screenSize.width * 40/100)/2, f.y - (screenSize.height * 15/100)/2, screenSize.width * 40/100, screenSize.height * 15/100);
     }
     
     //    self.mainView.layer.cornerRadius = 10;
     //    self.mainView.layer.masksToBounds = YES;
     
     [self.view addSubview:self.mainView];
     
     self.mainView.backgroundColor = [UIColor whiteColor];
     
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
     album = [[HoshiTextField alloc]initWithFrame:CGRectMake(20, 10, self.mainView.frame.size.width - 40, 50)];
     }
     else
     {
     album = [[HoshiTextField alloc]initWithFrame:CGRectMake(20, 15, self.mainView.frame.size.width - 40, 50)];
     }
     
     album.placeholder = @"Album Name";
     
     [self.mainView addSubview:album];
     
     
     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     
     
     button.layer.cornerRadius = 5;
     button.layer.masksToBounds = YES;
     
     button.backgroundColor = [self colorFromHexString:@"#409FE9"];
     
     [button addTarget:self
     action:@selector(sendAlbum:)
     forControlEvents:UIControlEventTouchUpInside];
     [button setTitle:@"Create" forState:UIControlStateNormal];
     
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
     button.frame = CGRectMake(self.mainView.frame.size.width*20/100,album.frame.origin.y + 70 , self.mainView.frame.size.width * 60/100, 30.0);
     }
     else
     {
     button.frame = CGRectMake(self.mainView.frame.size.width*20/100,album.frame.origin.y + 70 , self.mainView.frame.size.width * 60/100, 40.0);
     }
     
     [self.mainView addSubview:button];
     tapValue1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPosition1:)];
     [tapValue1 setNumberOfTapsRequired:1];
     tapValue1.delegate=self;
     
     [self.topView addGestureRecognizer:tapValue1];
     
     album.delegate = self;*/
    
    //    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //    [_CollectionView setMinimumInteritemSpacing:4.0f];
    //
    //    [_CollectionView setMinimumLineSpacing:10.0f];
    
    //    [self.collectionView setCollectionViewLayout:flowLayout];
    
    //    [flowLayout setSectionInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    
    _CollectionView.contentInset=UIEdgeInsetsMake(15, 15, 15, 15);
    
    // _CollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    musicAry = [[NSMutableArray alloc]init];
    musicTypeAry = [[NSMutableArray alloc]init];
    musicColorAry = [[NSMutableArray alloc]init];
    musicPosAry = [[NSMutableArray alloc]init];
    musicColorIdentificationAry = [[NSMutableArray alloc]init];
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

-(void)tapPosition1:(UITapGestureRecognizer *)recognizer
{
    self.mainView.hidden = true;
    self.topView.hidden = true;
}

-(void)tapPosition:(UITapGestureRecognizer *)recognizer
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_5" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _CollectionView.delegate = nil;
    _CollectionView.dataSource = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    [self getName];
    
    self.previewAction.hidden = YES;
    
    self.topView.hidden = true;
    self.mainView.hidden = true;
    
    NSString *cnt = @"0";
    
    for (NSDictionary *dct in MainArray)
    {
        cnt = [dct valueForKey:@"effect"];
        
        if (![cnt isEqualToString:@"0"])
        {
            break;
        }
        cnt = [dct valueForKey:@"title_id"];
        if (![cnt isEqualToString:@"0"])
        {
            break;
        }
        cnt = [dct valueForKey:@"music_type"];
        if (![cnt isEqualToString:@"0"])
        {
            break;
        }
    }
    
    NSLog(@"After cnt = %@",cnt);
    
    if (!(MainArray.count > 0))
    {
        self.previewAction.hidden = YES;
        
        // [self. setImage:nil];
        
        //        self.secondView.hidden = true;
        //        self.tabView.hidden = false;
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabClicked:)];
        //        [self.tabView addGestureRecognizer:tap];
    }
    else
    {
        self.previewAction.hidden = false;
    }
    
    if (OnlyImages.count == 0)
    {
        
    }
    else
    {
        self.holdView.hidden=true;
    }
}

-(void)getName
{
    NSLog(@"getname called");
    
    OnlyImages = [[NSMutableArray alloc]init];
    
    NSString *arraytag=[NSString stringWithFormat:@"ChoosenImagesandVideos"];
    
    NSLog(@"Onarraytag:%@",arraytag);
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:arraytag];
    
    NSLog(@"Data Images = %lu",(unsigned long)data.length);
    
    OnlyImages = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    //NSLog(@"Aray = %@",OnlyImages);
    
    // NSLog(@"Main arrays = %@",MainArray);
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource methods

-(NSInteger)collectionView:(UICollectionView *)theCollectionView numberOfItemsInSection:(NSInteger)theSectionIndex
{
    ReEdit = [[NSUserDefaults standardUserDefaults]boolForKey:@"ReEdit"];
    return [OnlyImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isScrolling = (_CollectionView.isDragging || _CollectionView.isDecelerating);
    if(isScrolling){
        AddAdvanceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *dic = [OnlyImages objectAtIndex:indexPath.row];
        
        // NSLog(@"OnlyImages = %@",dic);
        NSString *id1 = [dic valueForKey:@"Id"];
        NSString *type=[dic valueForKey:@"DataType"];
        
        NSString *lower = [type lowercaseString];
        
        //Generating Final
        
        NSDictionary *finalDic = [MainArray objectAtIndex:indexPath.row];
        
        [finalDic setValue:id1 forKey:@"image_path"];
        
        [finalDic setValue:lower forKey:@"image_type"];
        
        [finalDic setValue:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"image_pos"];
        
        int i = 0;
        if(![[finalDic valueForKey:@"effect"] isEqualToString:@"0"])
        {
            cell.indicator_img1.hidden=NO;
            cell.indicator_img1.image = [UIImage imageNamed:@"64-color-4"];
            i = 1;
        }
        
        if(![[finalDic valueForKey:@"transition"] isEqualToString:@"0"])
        {
            if(i == 0)
            {
                cell.indicator_img1.hidden =NO;
                cell.indicator_img1.image = [UIImage imageNamed:@"64-color-2"];
                
                i = 1;
            }
            else if(i == 1)
            {
                cell.indicator_img2.hidden =NO;
                cell.indicator_img2.image = [UIImage imageNamed:@"64-color-2"];
                i = 2;
            }
        }
        if(![[finalDic valueForKey:@"title_id"] isEqualToString:@"0"])
        {
            if(i == 0)
            {
                cell.indicator_img1.hidden =NO;
                cell.indicator_img1.image = [UIImage imageNamed:@"green_circle.png"];
                i = 1;
            }
            else if(i == 1)
            {
                cell.indicator_img2.hidden =NO;
                cell.indicator_img2.image = [UIImage imageNamed:@"green_circle.png"];
                i = 2;
            }else if(i == 2){
                cell.indicator_img3.hidden =NO;
                cell.indicator_img3.image = [UIImage imageNamed:@"green_circle.png"];
                i = 3;
            }
        }
        if(![[finalDic valueForKey:@"music"] isEqualToString:@"0"])
        {
            NSString *colorString =[finalDic valueForKey:@"music_color"];
            if(i == 0)
            {
                cell.indicator_img1.hidden =NO;
                cell.indicator_img1.image = [UIImage imageNamed:@"musicIndicatorIcon"];
                cell.indicator_img1.backgroundColor = [self colorWithHexString:colorString];
                i = 1;
            }
            else if(i == 1)
            {
                cell.indicator_img2.hidden =NO;
                cell.indicator_img2.image = [UIImage imageNamed:@"musicIndicatorIcon"];
                cell.indicator_img2.backgroundColor = [self colorWithHexString:colorString];
                i = 2;
            }
            else if(i == 2)
            {
                cell.indicator_img3.hidden = NO;
                cell.indicator_img3.image = [UIImage imageNamed:@"musicIndicatorIcon"];
                cell.indicator_img3.backgroundColor = [self colorWithHexString:colorString];
            }else if (i == 3){
                cell.indicator_img4.hidden = NO;
                cell.indicator_img4.image = [UIImage imageNamed:@"musicIndicatorIcon"];
                cell.indicator_img4.backgroundColor = [self colorWithHexString:colorString];
            }
            
            
            
        }
        
        if([[finalDic valueForKey:@"ReEdit"]isEqualToString:@"YES"])    {
            
            NSString *str  = [@"https://www.hypdra.com/api/"stringByAppendingString:[finalDic valueForKey:@"Full_Image_Path"]];
            
            NSURL *imgurl = [[NSURL alloc]initWithString:str];
            // pictureData = [[NSData alloc]initWithContentsOfURL:imgurl];
            [cell.addvance_ImgView sd_setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
            
        }else{
            
            NSURL *url = [NSURL URLWithString:[dic valueForKey:@"imagePath"]];
            
            
            [cell.addvance_ImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
            
            
        }
        cell.contentView.frame = [cell bounds];
        
        if([type isEqualToString:@"Video"])
        {
            
            cell.Video_icon.hidden=NO;
        }
        else
        {
            cell.Video_icon.hidden=YES;
            // cell.addvance_ImgView.image = originalImage;
        }
        
        // cell.BackGroundImageView.image = scaledBlurImage;
        
        return cell;
        
    }
    AddAdvanceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    //SHADOW WITH CORNER RADIUS
    
    cell.contentView.layer.cornerRadius = 12;
    cell.contentView.layer.masksToBounds = YES;
    cell.contentView.layer.borderWidth = 2;
    cell.contentView.layer.borderColor = [[UIColor clearColor]CGColor];
    cell.layer.shadowRadius = 2;
    cell.layer.cornerRadius = 12;
    cell.layer.masksToBounds = NO;
    [[cell layer] setShadowColor:[[UIColor darkGrayColor] CGColor]];
    
    [[cell layer] setShadowOffset:CGSizeMake(0,2)];
    [[cell layer] setShadowOpacity:1];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:12];
    [[cell layer] setShadowPath:[path CGPath]];
    //SHADOW WITH CORNER RADIUS
    //    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *DocDir = [ScreensDir objectAtIndex:0];
    //
    //    DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos"];
    
    NSDictionary *dic = [OnlyImages objectAtIndex:indexPath.row];
    
    // NSLog(@"OnlyImages = %@",dic);
    NSString *id1 = [dic valueForKey:@"Id"];
    NSString *type=[dic valueForKey:@"DataType"];
    
    NSString *lower = [type lowercaseString];
    
    //Generating Final
    
    NSDictionary *finalDic = [MainArray objectAtIndex:indexPath.row];
    // NSLog(@"Before Final Dic = %@",finalDic);
    //    if(!ReEdit)
    //    {
    [finalDic setValue:id1 forKey:@"image_path"];
    //  }else{
    //
    //  }
    [finalDic setValue:lower forKey:@"image_type"];
    
    [finalDic setValue:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"image_pos"];
    
    //NSLog(@"After Final Dic = %@",finalDic);
    int i = 0;
    
    // cell.indicator_img1 setFrame:CGRectMake(cell.indicator_img1.frame.origin.x, cell.indicator_img1.frame.origin.y, cell.indicator_img1.frame.size.width, <#CGFloat height#>)
    cell.indicator_img1.layer.cornerRadius = cell.indicator_img1.bounds.size.width/2;
    cell.indicator_img2.layer.cornerRadius = cell.indicator_img1.bounds.size.width/2;
    cell.indicator_img3.layer.cornerRadius = cell.indicator_img1.bounds.size.width/2;
    
    cell.indicator_img1.clipsToBounds = YES;
    cell.indicator_img2.clipsToBounds = YES;
    cell.indicator_img3.clipsToBounds = YES;
    cell.indicator_img4.clipsToBounds = YES;
    
    //    [self setRoundedView:cell.indicator_img1 toDiameter:50.0];
    //    [self setRoundedView:cell.indicator_img2 toDiameter:50.0];
    //    [self setRoundedView:cell.indicator_img3 toDiameter:50.0];
    
    if(![[finalDic valueForKey:@"effect"] isEqualToString:@"0"])
    {
        cell.indicator_img1.hidden=NO;
        cell.indicator_img1.image = [UIImage imageNamed:@"64-color-4"];
        i = 1;
    }
    
    if(![[finalDic valueForKey:@"transition"] isEqualToString:@"0"])
    {
        if(i == 0)
        {
            cell.indicator_img1.hidden =NO;
            cell.indicator_img1.image = [UIImage imageNamed:@"64-color-2"];
            
            i = 1;
        }
        else if(i == 1)
        {
            cell.indicator_img2.hidden =NO;
            cell.indicator_img2.image = [UIImage imageNamed:@"64-color-2"];
            i = 2;
        }
    }
    if(![[finalDic valueForKey:@"title_id"] isEqualToString:@"0"])
    {
        if(i == 0)
        {
            cell.indicator_img1.hidden =NO;
            cell.indicator_img1.image = [UIImage imageNamed:@"64-color-3"];
            i = 1;
        }
        else if(i == 1)
        {
            cell.indicator_img2.hidden =NO;
            cell.indicator_img2.image = [UIImage imageNamed:@"64-color-3"];
            i = 2;
        }else if(i == 2){
            cell.indicator_img3.hidden =NO;
            cell.indicator_img3.image = [UIImage imageNamed:@"64-color-3"];
            i = 3;
        }
    }
    if(![[finalDic valueForKey:@"music"] isEqualToString:@"0"])
    {
        NSString *colorString =[finalDic valueForKey:@"music_color"];
        if(i == 0)
        {
            cell.indicator_img1.hidden =NO;
            cell.indicator_img1.image = [UIImage imageNamed:@"musicIndicatorIcon"];
            cell.indicator_img1.backgroundColor = [self colorWithHexString:colorString];
            i = 1;
        }
        else if(i == 1)
        {
            cell.indicator_img2.hidden =NO;
            cell.indicator_img2.image = [UIImage imageNamed:@"musicIndicatorIcon"];
            cell.indicator_img2.backgroundColor = [self colorWithHexString:colorString];
            i = 2;
        }
        else if(i == 2)
        {
            cell.indicator_img3.hidden = NO;
            cell.indicator_img3.image = [UIImage imageNamed:@"musicIndicatorIcon"];
            cell.indicator_img3.backgroundColor = [self colorWithHexString:colorString];
        }else if (i == 3){
            cell.indicator_img4.hidden = NO;
            cell.indicator_img4.image = [UIImage imageNamed:@"musicIndicatorIcon"];
            cell.indicator_img4.backgroundColor = [self colorWithHexString:colorString];
        }
        
    }
    
    
    // [MainArray replaceObjectAtIndex:indexPath.row withObject:finalDic];
    
    //NSLog(@"Main Arrays = %@",MainArray);
    
    //Generating Final
    
    //UPDAteMainArrayUserDefaults
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:MainArray]  forKey:@"MainArray"];
    [defaults synchronize];
    
    if([[finalDic valueForKey:@"ReEdit"]isEqualToString:@"YES"])    {
        
        NSString *str  = [@"https://www.hypdra.com/api/"stringByAppendingString:[finalDic valueForKey:@"Full_Image_Path"]];
        
        NSURL *imgurl = [[NSURL alloc]initWithString:str];
        // pictureData = [[NSData alloc]initWithContentsOfURL:imgurl];
        [cell.addvance_ImgView sd_setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
        
    }else{
        
        NSURL *url = [NSURL URLWithString:[dic valueForKey:@"imagePath"]];
        
        
        [cell.addvance_ImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
        
    }
    
    
    cell.contentView.frame = [cell bounds];
    
    if([type isEqualToString:@"Video"])
    {
        
        cell.Video_icon.hidden=NO;
    }
    else
    {
        cell.Video_icon.hidden=YES;
        // cell.addvance_ImgView.image = originalImage;
    }
    
    // cell.BackGroundImageView.image = scaledBlurImage;
    
    return cell;
    
}

#pragma mark - LXReorderableCollectionViewDataSource methods
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    
}
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    
    
    NSLog(@"willMoveToIndexPath");
    NSMutableDictionary *dic = OnlyImages[fromIndexPath.item];
    
    [OnlyImages removeObjectAtIndex:fromIndexPath.item];
    [OnlyImages insertObject:dic atIndex:toIndexPath.item];
    
    NSMutableDictionary *dic1 = MainArray[fromIndexPath.item];
    
    [MainArray removeObjectAtIndex:fromIndexPath.item];
    [MainArray insertObject:dic1 atIndex:toIndexPath.item];
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"canMoveItemAtIndexPath");
    for(NSDictionary *miniDic in MainArray){
        [musicAry addObject:[miniDic valueForKey:@"music"]];
        [musicTypeAry addObject:[miniDic valueForKey:@"music_type"]];
        [musicColorAry addObject:[miniDic valueForKey:@"music_color"]];
        [musicPosAry addObject:[miniDic valueForKey:@"music_pos"]];
        [musicColorIdentificationAry addObject:[miniDic valueForKey:@"music_color_identification"]];
    }
    
    //#if LX_LIMITED_MOVEMENT == 1
    //    PlayingCard *playingCard = self.deck[indexPath.item];
    //
    //    switch (playingCard.suit) {
    //        case PlayingCardSuitSpade:
    //        case PlayingCardSuitClub: {
    //            return YES;
    //        } break;
    //        default: {
    //            return NO;
    //        } break;
    //    }
    //#else
    return YES;
    //#endif
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    NSLog(@"canMoveToIndexPath");
    return YES;
    
}
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    for(int i =0;i<MainArray.count;i++){
        NSMutableDictionary *miniDic = [MainArray objectAtIndex:i];
        [miniDic setValue:[musicAry objectAtIndex:i] forKey:@"music"];
        [miniDic setValue:[musicTypeAry objectAtIndex:i] forKey:@"music_type"];
        [miniDic setValue:[musicColorAry objectAtIndex:i] forKey:@"music_color"];
        [miniDic setValue:[musicPosAry objectAtIndex:i] forKey:@"music_pos"];
        [miniDic setValue:[musicColorIdentificationAry objectAtIndex:i] forKey:@"music_color_identification"];
        [MainArray replaceObjectAtIndex:i withObject:miniDic];
    }
    
    
    NSArray *visiblePaths = [self.collectionView indexPathsForVisibleItems];
    
    for (NSIndexPath *indexPath in visiblePaths) {
        NSDictionary *finalDic = [MainArray objectAtIndex:indexPath.row];
        int i =0;
        AddAdvanceCollectionViewCell* cell =
        [self.collectionView cellForItemAtIndexPath:indexPath];
        
        if(![[finalDic valueForKey:@"effect"] isEqualToString:@"0"])
        {
            cell.indicator_img1.hidden=NO;
            cell.indicator_img1.image = [UIImage imageNamed:@"64-color-4"];
            i = 1;
        }
        
        if(![[finalDic valueForKey:@"title_id"] isEqualToString:@"0"])
        {
            if(i == 0)
            {
                cell.indicator_img1.hidden =NO;
                cell.indicator_img1.image = [UIImage imageNamed:@"64-color-2"];
                i = 1;
            }
            else if(i == 1)
            {
                cell.indicator_img2.hidden =NO;
                cell.indicator_img2.image = [UIImage imageNamed:@"64-color-2"];
                i = 2;
            }
        }
        
        if(![[finalDic valueForKey:@"music"] isEqualToString:@"0"])
        {
            NSString *colorString =[finalDic valueForKey:@"music_color"];
            if(i == 0)
            {
                cell.indicator_img1.hidden =NO;
                cell.indicator_img1.image = [UIImage imageNamed:@"musicIndicatorIcon"];
                cell.indicator_img1.backgroundColor = [self colorWithHexString:colorString];
                i = 1;
            }
            else if(i == 1)
            {
                cell.indicator_img2.hidden =NO;
                cell.indicator_img2.image = [UIImage imageNamed:@"musicIndicatorIcon"];
                cell.indicator_img2.backgroundColor = [self colorWithHexString:colorString];
                i = 2;
            }
            else if(i == 2)
            {
                cell.indicator_img3.hidden = NO;
                cell.indicator_img3.image = [UIImage imageNamed:@"musicIndicatorIcon"];
                cell.indicator_img3.backgroundColor = [self colorWithHexString:colorString];
            }
        }
        
    }
    
    [hud hideAnimated:YES];
    //[collectionView reloadData];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //        indexPath.row;
    
    NSLog(@"Menu Button");
    
    /*    if (isMenuActive)
     {
     
     NSLog(@"isMenuActive");
     
     
     [igcMenu hideCircularMenu];
     NSLog(@"igcMenu hideCircularMenu]");
     
     isMenuActive = NO;
     }
     else
     {
     
     [igcMenu showCircularMenu];
     NSLog(@"[igcMenu showCircularMenu]");
     isMenuActive = YES;
     }*/
    
    [igcMenu showCircularMenu];
    
    [[NSUserDefaults standardUserDefaults]setInteger:indexPath.row forKey:@"SelectedIndex"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)clearAllData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    MainArray = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"MainArray"]];
    NSMutableDictionary *subDic = [MainArray objectAtIndex:[defaults integerForKey:@"SelectedIndex"]];
    if([[subDic valueForKey:@"ReEdit"] isEqualToString:@"YES"]){
        
        NSMutableArray *multiplDeleteItemsAry = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"MultiplDeleteItemsAry"]];
        if(multiplDeleteItemsAry == nil)
            multiplDeleteItemsAry = [[NSMutableArray alloc]init];
        [multiplDeleteItemsAry addObject:[subDic valueForKey:@"image_path"]];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:multiplDeleteItemsAry]  forKey:@"MultiplDeleteItemsAry"];
    }
    [MainArray removeObjectAtIndex:[defaults integerForKey:@"SelectedIndex"]];
    NSLog(@"AfterDeleteMainArray %@",MainArray);
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:MainArray]  forKey:@"MainArray"];
    
    NSMutableArray *temArray = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"ChoosenImagesandVideos"]];
    
    [temArray removeObjectAtIndex:[defaults integerForKey:@"SelectedIndex"]];
    
    NSLog(@"AfterDeleteChoosenImagesandVideos %@",temArray);
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:temArray]  forKey:@"ChoosenImagesandVideos"];
    
    [defaults synchronize];
    [self getName];
}



- (void)igcMenuSelected:(NSString *)selectedMenuName atIndex:(NSInteger)index
{
    [igcMenu hideCircularMenu];
    isMenuActive = NO;
    // self.blurView.hidden=YES;
    
    NSLog(@"selected menu name = %@ at index = %ld",selectedMenuName,(long)index);
    
    NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
    [defaults setInteger:index forKey:@"SelectedMenu"];
    
    
    //    igcMenu.menuImagesNameArray = [NSArray arrayWithObjects:@"126-delete.png",@"126-effect.png",@"126-music-1.png",@"126-trans.png",nil];
    
    if (index == 0)
    {
        /*  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         MainArray = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"MainArray"]];
         
         NSLog(@"MainArrays = %d",MainArray.count);
         
         
         [MainArray removeObjectAtIndex:[defaults integerForKey:@"SelectedIndex"]];
         [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:MainArray]forKey:@"MainArray"];
         
         NSMutableArray *temArray = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"ChoosenImagesandVideos"]];
         
         NSLog(@"MainArrays = %d",temArray.count);
         
         
         [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:temArray]  forKey:@"ChoosenImagesandVideos"];
         
         
         [defaults synchronize];
         //        [_collectionView reloadData];
         
         [self getName];*/
        
        
        
        //        UIAlertController * alert = [UIAlertController
        //                                     alertControllerWithTitle:@"Alert"
        //                                     message:@"Are you sure to delete!"
        //                                     preferredStyle:UIAlertControllerStyleAlert];
        //
        //Add Buttons
        
        //        UIAlertAction* yesButton = [UIAlertAction
        //                                    actionWithTitle:@"Yes"
        //                                    style:UIAlertActionStyleDefault
        //                                    handler:^(UIAlertAction * action)
        //                                    {
        //                                        //Handle your yes please button action here
        //                                        [self clearAllData];
        //                                    }];
        //
        //        UIAlertAction* noButton = [UIAlertAction
        //                                   actionWithTitle:@"No"
        //                                   style:UIAlertActionStyleDefault
        //                                   handler:^(UIAlertAction * action) {
        //                                       //Handle no, thanks button
        //                                   }];
        //
        //        //Add your buttons to alert controller
        //
        //        [alert addAction:yesButton];
        //        [alert addAction:noButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure to delete ?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"ConfirmToDelete";
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
        [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
        popUp.inputTextField.hidden = YES;
        [popUp show];
        //ChoosenImagesandVideos
    }
    else if(index == 1)
    {
        //used for nav title
        [[NSUserDefaults standardUserDefaults] setObject:@"Butterfly" forKey:@"effectMenuType"];
        
        //tells effects or titles
        [[NSUserDefaults standardUserDefaults] setObject:@"Effects" forKey:@"menuType"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
        
        GetEffectsViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"effectsSideMenu"];
        
        //To display rear view as frontview
        [[NSUserDefaults standardUserDefaults]setObject:@"fromAdvance" forKey:@"MenuFrontPage"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:nil];
        
    }
    else if(index == 2)
    {
        NSLog(@"MuiscTabViewController");
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        MuiscTabViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MuiscTab"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:nil];
        
    }
    
    else if(index == 3)
    {
        //used for nav title
        [[NSUserDefaults standardUserDefaults] setObject:@"Holliday" forKey:@"effectMenuType"];
        
        //tells effects or titles
        [[NSUserDefaults standardUserDefaults] setObject:@"Titles" forKey:@"menuType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
        
        GetEffectsViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"effectsSideMenu"];
        
        //To display rear view as frontview
        
        [[NSUserDefaults standardUserDefaults]setObject:@"fromAdvance" forKey:@"MenuFrontPage"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if (index == 4)
    {
        //used for nav title
        [[NSUserDefaults standardUserDefaults] setObject:@"Bang" forKey:@"effectMenuType"];
        
        //tells effects or titles
        [[NSUserDefaults standardUserDefaults] setObject:@"Transitions" forKey:@"menuType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
        
        GetEffectsViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"effectsSideMenu"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        //To display rear view as frontview
        [[NSUserDefaults standardUserDefaults]setObject:@"fromAdvance" forKey:@"MenuFrontPage"];
        
        [self presentViewController:vc animated:YES completion:nil];
        
    }
}

#pragma mark <UICollectionViewDelegate>

- (void)sendAlbum
{
    NSLog(@"CreateAlbum");
    
    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"videoStatus"];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"videoStatus"])
    {
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Making your Movie... it may take a few moments. You will be notified when your video is ready" withTitle:@"Thanks" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
        popUp.accessibilityHint = @"VideoGenerated";
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please check your video duration" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Please check your video duration" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ReEdit"];
}

- (void)createAlbum
{
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"" withTitle:@"Album Name" withImage:[UIImage imageNamed:@"textfield_alert.png"]];
    popUp.accessibilityHint = @"EnteringTitle";
    popUp.okay.backgroundColor = [UIColor navyBlue];
    [popUp.okay setTitle:@"Create" forState:UIControlStateNormal]; popUp.agreeBtn.hidden = YES;
    
    popUp.inputTextField.delegate=self;
    popUp.inputTextField.placeholder = @"Title";
    popUp.cancelBtn.hidden = YES;
    popUp.msgLabel.hidden = YES;
    popUp.outSideTap = NO;
    [popUp show];
    
}

-(void)checkAlert
{
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"You forget to enter album title" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.backgroundColor = [UIColor lightGreen];
    popUp.agreeBtn.hidden = YES;
    popUp.cancelBtn.hidden = YES;
    popUp.inputTextField.hidden = YES;
    [popUp show];
}

-(void)setParams
{
    NSString *current_Pos,*next_Pos,*music_Pos = @"0";
    NSLog(@"Send Album");
    
    NSString *jsonString;
    NSError *error;
    NSMutableDictionary *Dic =[MainArray objectAtIndex:0];
    current_Pos = [Dic valueForKey:@"music"];
    
    for(int i=0;i<MainArray.count;i++)
    {
        NSMutableDictionary *sbDic = [MainArray objectAtIndex:i];
        if(![[sbDic valueForKey:@"music"]  isEqual: @"0"]){
            next_Pos = [sbDic valueForKey:@"music_pos"];
            if(current_Pos == next_Pos){
                [sbDic setValue:music_Pos forKey:@"music_pos"];
            }else{
                if([music_Pos isEqualToString:@"0"])
                    music_Pos = @"1";
                else
                    music_Pos = @"0";
                
                [sbDic setValue:music_Pos forKey:@"music_pos"];
            }
        }
        current_Pos = next_Pos;
        [sbDic removeObjectForKey:@"ReEdit"];
        // [sbDic removeObjectForKey:@"MusicApplied"];
    }
    
    NSDictionary *fDict = @{@"FinalTemplates":MainArray};
    NSString *TempThumb = [[MainArray objectAtIndex:0] valueForKey:@"image_path"];
    NSString *TempThumbType =[[MainArray objectAtIndex:0] valueForKey:@"image_type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:fDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    } else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer setTimeoutInterval:150];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    NSLog(@"User Id %@",user_id);
    NSDictionary *params;
    if(ReEdit){
        NSString * selectedItemString;
        NSMutableArray *multiplDeleteItemsAry = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"MultiplDeleteItemsAry"]];
        
        if(multiplDeleteItemsAry == nil)
            multiplDeleteItemsAry = [[NSMutableArray alloc]init];
        
        for(NSString *deleteID in multiplDeleteItemsAry){
            //NSString *deleteID =  [dic objectForKey:@"Id"];
            if(!(selectedItemString == nil))
                selectedItemString = [NSString stringWithFormat:@"%@'%@',",selectedItemString,deleteID];
            else{
                selectedItemString = [NSString stringWithFormat:@"'%@',",deleteID];
            }
        }
        if(selectedItemString == nil)
            selectedItemString = @"";
        else
            selectedItemString = [selectedItemString substringToIndex:[selectedItemString length]-1];
        
        [multiplDeleteItemsAry removeAllObjects];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:multiplDeleteItemsAry]  forKey:@"MultiplDeleteItemsAry"];
        NSString *editId = [[NSUserDefaults standardUserDefaults]valueForKey:@"EdtVdoId"];
        params = @{@"Dictionary":jsonString,@"User_ID": user_id,@"album_name":albumName,@"video_id":user_id,@"lang":@"iOS",@"edit_rand_id":editId,@"TempThumb":TempThumb,@"TempThumbType":TempThumbType,@"DeleteIds":selectedItemString};
        
    }else{
        params = @{@"Dictionary":jsonString,@"User_ID": user_id,@"album_name":albumName,@"video_id":user_id,@"lang":@"iOS",@"edit_rand_id":@"",@"DeleteIds":@"",@"TempThumb":TempThumb,@"TempThumbType":TempThumbType};
    }
    
    NSLog(@"NSData %@",jsonString);
    [manager POST:@"https://www.hypdra.com/api/api.php?rquest=test_advance" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"Advance Success = %@", responseObject);
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"Advance Error Video = %@", error);
     }];
    
}

- (IBAction)back:(id)sender
{
    
    if(OnlyImages.count!=0)
    {
        /*
        //        UIAlertController * alert=[UIAlertController
        //                                   alertControllerWithTitle:@"Remove \"Image\"?" message:@"Chosen Image will discarded"preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction
        //                                    actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
        //                                    handler:^(UIAlertAction * action)
        //                                    {
        //
        //                                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ChoosenImagesandVideos"];
        //
        //                                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"MainArray"];
        //
        //                                        [[NSUserDefaults standardUserDefaults]synchronize];
        //
        //                                        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //
        //                                        PageSelectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PageSelection"];
        //
        //                                        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //
        //                                        [self presentViewController:vc animated:YES completion:NULL];
        //                                        NSMutableArray *MultiplDeleteItemsAry = [[NSMutableArray alloc]init];
        //                                        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:MultiplDeleteItemsAry]  forKey:@"MultiplDeleteItemsAry"];
        //                                    }];
        //
        //        UIAlertAction* noButton = [UIAlertAction
        //                                   actionWithTitle:@"cancel"
        //                                   style:UIAlertActionStyleDefault
        //                                   handler:^(UIAlertAction * action)
        //                                   {
        //
        //                                   }];
        //
        //        [alert addAction:yesButton];
        //        [alert addAction:noButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        */
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Would you like to discard this change ?" withTitle:@"Discard" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"RemoveImages";
        
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
        [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DEMORootViewController *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc1 awakeFromNib:@"demo_pageselection" arg:@"menuController"];
        
        vc1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc1 animated:YES completion:nil];
    }
    
    /*    NSMutableArray *emptyArray;
     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
     [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:emptyArray]  forKey:@"MainArray"];
     [defaults synchronize];*/
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ReEdit"];
    
}

- (IBAction)menu:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    // Present the view controller
    
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)add:(id)sender
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:MainArray]  forKey:@"MainArray"];
    
    [defaults synchronize];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_5" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}

/*
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
 CGFloat picDimension = self.view.frame.size.width / 2.02f;
 return CGSizeMake(picDimension, picDimension);
 }*/

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"collectionView layout");
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    float cellWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellWidth = screenWidth / 2.5;
        
    }
    else
    {
        cellWidth = screenWidth / 3.5;
    }
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
}

- (void) agreedTerms:(id)sender
{
    //    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"ACCEPT TERMS"
    //                                                                  message:@"By creating an video, you agree to the Hypdra Terms of Service and Privacy Policy."
    //                                                           preferredStyle:UIAlertControllerStyleAlert];
    //
    //    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"I Agree"
    //                                                 style:UIAlertActionStyleDefault
    //                                               handler:^(UIAlertAction * action)
    //                         {
    //                             [self createAlbum];
    //                         }];
    //
    //    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Cancel"
    //                                                       style:UIAlertActionStyleDefault
    //                                                     handler:nil];
    //
    //    [alert addAction:ok];
    //    [alert addAction:noButton];
    //
    //    [self presentViewController:alert animated:YES completion:nil];
    
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"By creating a video you agree to the Hypdra Terms of Service and Privacy Policy." withTitle:@"ACCEPT TERMS" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.hidden = YES;
    popUp.accessibilityHint =@"AcceptTerms";
    
    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
    popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
    [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
    [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
    popUp.inputTextField.hidden = YES;
    [popUp show];
    
    /*    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Do you agree to the terms and conditions" preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* ok = [UIAlertAction
     actionWithTitle:@"YES"
     style:UIAlertActionStyleDefault
     handler:^(UIAlertAction * action)
     {
     //Handle your yes please button action here
     [self createAlbum:ok];
     }];
     
     UIAlertAction* cancel = [UIAlertAction
     actionWithTitle:@"NO"
     style:UIAlertActionStyleDefault
     handler:^(UIAlertAction * action)
     {
     
     }];
     
     [alertController addAction:ok];
     [alertController addAction:cancel];
     
     [self presentViewController:alertController animated:YES completion:nil];*/
}
- (UIColor *) colorWithHexString: (NSString *) hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    
    NSLog(@"colorString :%@",colorString);
    CGFloat alpha, red, blue, green;
    
    // #RGB
    alpha = 1.0f;
    red   = [self colorComponentFrom: colorString start: 0 length: 2];
    green = [self colorComponentFrom: colorString start: 2 length: 2];
    blue  = [self colorComponentFrom: colorString start: 4 length: 2];
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

- (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}
-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

-(void) okClicked:(CustomPopUp *)alertView{
    
    if([alertView.accessibilityHint isEqualToString:@"EnteringTitle"]){
        
        
        if (alertView.inputTextField.text.length == 0)
        {
            [alertView hide];
            alertView = nil;
            [self checkAlert];
        }
        else
        {
            albumName = alertView.inputTextField.text;
            
            [self sendAlbum];
        }
        NSLog(@"%@",alertView.inputTextField.text);
    }else if([alertView.accessibilityHint isEqualToString:@"VideoGenerated"])
    {
        [self setParams];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ChoosenImagesandVideos"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"MainArray"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        int count = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"AlbumCount"];
        if(count==0)
        {
            [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"AlbumCount"];
        }
        
        // if (IS_PAD)
        //        {
        //            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbumiPad" bundle:nil];
        //
        //            DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        //
        //            [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
        //
        //            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //
        //            [self presentViewController:vc animated:YES completion:NULL];
        //        }
        //        else
        //        {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        //   }
    }
    [alertView hide];
    alertView = nil;
}



-(void) cancelClicked:(CustomPopUp *)alertView{
    
    [alertView hide];
    alertView = nil;
}

- (void)agreeCLicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"AcceptTerms"]){
        [self createAlbum];
        
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToDelete"]){
        [self clearAllData];
    }else if([alertView.accessibilityHint isEqualToString:@"RemoveImages"]){
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ChoosenImagesandVideos"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"MainArray"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DEMORootViewController *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc1 awakeFromNib:@"demo_pageselection" arg:@"menuController"];
        
        vc1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc1 animated:YES completion:nil];
        
        NSMutableArray *MultiplDeleteItemsAry = [[NSMutableArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:MultiplDeleteItemsAry]  forKey:@"MultiplDeleteItemsAry"];
        
    }
    [alertView hide];
    alertView = nil;
}
@end


