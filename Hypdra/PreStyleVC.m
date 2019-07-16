//  PreStyleVC.m
//  Hypdra
//  Created by Mac on 12/26/18.
//  Copyright © 2018 sssn. All rights reserved.

#import "AFNetworking.h"
#import "CvCellImgEditor.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "PreStyleVC.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"
#import "AdvancedCollectionCell.h"
#import "DEMORootViewController.h"

@interface PreStyleVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ClickDelegates,UISearchBarDelegate>{
    
    NSMutableArray *categoryMain,*finalItems,*previewMain,*idValue,*actionType;
    NSString *mainCategoryValue,*actionID,*user_id;
    int mainCatCount,subCatCount;
    MBProgressHUD *hud;
    BOOL isFirstTimeLoadMainCat;
    
}

@end

@implementation PreStyleVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    categoryMain =[[NSMutableArray alloc]init];
    finalItems = [[NSMutableArray alloc]init];
    
    mainCatCount=1;
    user_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_ID"];
    isFirstTimeLoadMainCat =YES;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:5.0f];
    
    [self.AiItemCollectionView setCollectionViewLayout:flowLayout];
    
    _AiItemCollectionView.contentInset=UIEdgeInsetsMake(15, 15, 15, 15);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchStyle:)
                                                 name:@"SearchNotify" object:nil];
    
    [self loadMainCategory];
}

-(void)searchStyle:(NSNotification *)notify{
    NSDictionary* userInfo = notify.userInfo;
   NSString *searchString =  [userInfo valueForKey:@"searchStyle"];
    [self searchString:searchString];
    NSLog(@"Search Notification %@",searchString);
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SearchNotify" object:nil];
}
-(void)loadMainCategory
{
    if([mainCategoryValue isEqualToString:@"Artwork"]){
}
    NSString *URL,*JsonKey;
    NSDictionary *parameters;
    @try
    {
        if(mainCatCount == 1){

        URL = @"https://www.hypdra.com/api/api.php?rquest=PS_MainCategory";
            JsonKey = @"MainCat";
           parameters=@{@"User_Id":user_id};
            
        }else{

            JsonKey = @"SubCat"; parameters=@{@"cat":mainCategoryValue,@"lang":@"iOS"};
            URL = @"https://www.hypdra.com/api/api.php?rquest=PS_SubCategory";
        }
        NSLog(@"parameters %@",parameters);
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:parameters error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
        
        // add paramerets to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  NSLog(@"the resp 123%@",responseObject);
                 
                  NSArray *mainCategory=[responseObject objectForKey:JsonKey];
                  NSString *category,*preview,*id_value,*action_type;

                  for(int i=0;i<mainCategory.count;i++)
                  {
    NSDictionary *dic=[mainCategory objectAtIndex:i];
    preview=[dic objectForKey:@"Preview"];
                      
    if(mainCatCount == 1){

    category = [dic objectForKey:@"Category"];
        if([category isEqualToString:@"Artwork"]){
    [categoryMain insertObject:dic atIndex:0];
        }else
            [categoryMain addObject:dic];
    }else if([mainCategoryValue isEqualToString:@"Artwork"]){
        
                          category=[dic objectForKey:@"SubCategory"];
                          id_value = [dic objectForKey:@"id"];
                          action_type = [dic objectForKey:@"action_type"];
                          [previewMain addObject:preview];
                          [idValue addObject:id_value];
                          [actionType addObject:action_type];
                          [categoryMain addObject:dic];
        
    }else{
        [finalItems addObject:dic];
    }
                }
                  if(mainCatCount == 1){

                      [self.AiCategoryCollectionView reloadData];
                      if(isFirstTimeLoadMainCat)
                      [self loadFinalItemsFirstTime:nil];

                  }else if([mainCategoryValue isEqualToString:@"Artwork"]){
[self.AiCategoryCollectionView reloadData];                  }else{
                      
                      [self.AiItemCollectionView reloadData];
                  }
                  [hud hideAnimated:YES];
              }
              else
              {
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
                  [hud hideAnimated:YES];
              }
          }]resume];
    }@catch(NSException *exception)
    {
        
    }
}
-(void)loadFinalItemsFirstTime:(NSDictionary*)selectedDic
{
    NSString *URL,*JsonKey;
    NSDictionary *parameters;
    @try
    {
        NSDictionary *dic = [categoryMain objectAtIndex:0];
        NSString *cat = [dic objectForKey:@"Category"];
        if (selectedDic) {
            cat = [selectedDic objectForKey:@"SubCategory"];
        }
        
       
            JsonKey = @"SubCat"; parameters=@{@"cat":cat,@"lang":@"iOS"};
            URL = @"https://www.hypdra.com/api/api.php?rquest=PS_SubCategory";
        NSLog(@"parameters123 %@",parameters);
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:parameters error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
        
        // add paramerets to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  NSLog(@"the resp %@",responseObject);
                  isFirstTimeLoadMainCat = NO;
                  [finalItems removeAllObjects];
                  NSArray *mainCategory=[responseObject objectForKey:JsonKey];
                  NSString *category,*preview,*id_value,*action_type;
                  
                  for(int i=0;i<mainCategory.count;i++)
                  {
                      NSDictionary *dic=[mainCategory objectAtIndex:i];
                      preview=[dic objectForKey:@"Preview"];
                      
                     
                          [finalItems addObject:dic];
                  
                  }
                 
                      [self.AiItemCollectionView reloadData];
                  
                  [hud hideAnimated:YES];
              }
              else
              {
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
                  [hud hideAnimated:YES];
              }
          }]resume];
    }@catch(NSException *exception)
    {
        
    }
}
-(void)searchString:(NSString *)searchText
{
hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *URL,*JsonKey;
    NSDictionary *parameters;
    @try
    {
        NSDictionary *dic = [categoryMain objectAtIndex:0];
        NSString *cat = [dic objectForKey:@"Category"];
        JsonKey = @"SubCat"; parameters=@{@"search_str":searchText};
        URL = @"https://www.hypdra.com/api/api.php?rquest=PS_Search";
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:parameters error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
        
        // add paramerets to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  NSLog(@"the search resp %@",responseObject);
                  
                  NSArray *mainCategory=[responseObject objectForKey:JsonKey];
                  NSString *category,*preview,*id_value,*action_type;
                  [finalItems removeAllObjects];
                  for(int i=0;i<mainCategory.count;i++)
                  {
                      NSDictionary *dic=[mainCategory objectAtIndex:i];
                      preview=[dic objectForKey:@"Preview"];
                    [finalItems addObject:dic];
                  }
                  
                  [self.AiItemCollectionView reloadData];
                  
                  [hud hideAnimated:YES];
              }
              else
              {
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
                  [hud hideAnimated:YES];
              }
          }]resume];
    }@catch(NSException *exception)
    {
        
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.AiCategoryCollectionView){
return categoryMain.count;
    }else{
        return finalItems.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AdvancedCollectionCell *itemCell;
    CvCellImgEditor *categoryCell;

    if(collectionView == self.AiCategoryCollectionView){
 
     NSString *cellIdentifier=@"CvCellImgEditor";
     categoryCell =[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    categoryCell.layer.cornerRadius=10.0f;
    NSDictionary *dic =[categoryMain objectAtIndex:indexPath.row];
     NSURL *imageURL = [NSURL URLWithString:[dic objectForKey:@"Preview"]];
   // if(!([mainCategoryValue isEqualToString:@"Artwork"]))
        if(mainCatCount == 1)
    {
    categoryCell.mainCategoryName.text=[dic objectForKey:@"Category"];

    [dic objectForKey:@"id"];
    [dic objectForKey:@"action_type"];
        
    [categoryCell.imgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
        categoryCell.frontView.hidden=NO;
        categoryCell.backView.hidden=YES;
        categoryCell.subViewSticker.hidden=YES;
    }
   // else if([mainCategoryValue isEqualToString:@"Artwork"])
         else if(subCatCount == 1)
    {
        if(indexPath.row==0)
        {
            categoryCell.frontView.hidden=YES;
            categoryCell.backView.hidden=NO;
            categoryCell.subViewSticker.hidden=YES;
        }
        else
        {
            [categoryCell.imgViewSub sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
            categoryCell.subCategoryName.text=[dic objectForKey:@"SubCategory"];
            
            categoryCell.frontView.hidden=YES;
            categoryCell.backView.hidden=YES;
            categoryCell.subViewSticker.hidden=NO;
        }
    }
      return categoryCell;
 }else if(collectionView == self.AiItemCollectionView){

     static NSString *CellIdentifier = @"AdvancedCollectionCell";
     
     itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
     
     itemCell.layer.borderWidth = 0.2f;
     itemCell.alpha = 1.0;
     
     NSDictionary *dic =[finalItems objectAtIndex:indexPath.row];
    
     NSURL *imageURL = [NSURL URLWithString:[dic objectForKey:@"Preview"]];
     itemCell.fileName.text = [dic objectForKey:@"SubCategory"];
     itemCell.AboveTopView.hidden = NO;

     [itemCell.ImgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"place_holder_simple.png"]];
     
     itemCell.contentView.layer.cornerRadius = 12;
     itemCell.contentView.layer.masksToBounds = YES;
     itemCell.contentView.layer.borderWidth = 2;
     itemCell.contentView.layer.borderColor = [[UIColor clearColor]CGColor];
     itemCell.layer.shadowRadius = 2;
     itemCell.layer.cornerRadius = 12;
     itemCell.layer.masksToBounds = NO;
     [[itemCell layer] setShadowColor:[[UIColor darkGrayColor] CGColor]];
     
     [[itemCell layer] setShadowOffset:CGSizeMake(0,2)];
     [[itemCell layer] setShadowOpacity:1];

     UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:itemCell.bounds cornerRadius:12];
     [[itemCell layer] setShadowPath:[path CGPath]];
 }
    return itemCell;
}
-(void)viewDidAppear:(BOOL)animated{
    //[self loadFinalItemsFirstTime:nil];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic =[categoryMain objectAtIndex:indexPath.row];

    if(collectionView == self.AiCategoryCollectionView){
        //if(mainCatCount == 1)
        if([[dic objectForKey:@"is_parent"] isEqualToString:@"1"]){
            mainCategoryValue=[dic objectForKey:@"SubCategory"];
        }else{
            mainCategoryValue=[dic objectForKey:@"Category"];
        }
        mainCatCount = 0;
        
        if(subCatCount == 1){
            if(indexPath.row==0)
            {
                mainCatCount = 1;
                subCatCount=0;
                [categoryMain removeAllObjects];
            }else{
                [finalItems removeAllObjects];
            }
        }else{
            if([mainCategoryValue isEqualToString:@"Artwork"])
            {
                 subCatCount=1;
                [categoryMain removeAllObjects];
                
            }else{
                [finalItems removeAllObjects];
            }
        }
        [self loadMainCategory];
     
    }else{
        dic = [finalItems objectAtIndex:indexPath.row];
        if([[dic objectForKey:@"is_parent"] isEqualToString:@"1"]){
            mainCategoryValue=[dic objectForKey:@"SubCategory"];
            //subCatCount=1;
            [self loadFinalItemsFirstTime:dic];
        }else{
            //dic = [finalItems objectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:dic]  forKey:@"AIStyleDic"];
            
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LiveEffects" bundle:nil];
            
            DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
            
            [vc awakeFromNib:@"contentController_23" arg:@"menuController"];
            
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:vc animated:YES completion:NULL];
        }
      
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
     if(collectionView == self.AiItemCollectionView){
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
         {
             return CGSizeMake((collectionView.frame.size.width/3)-20, (collectionView.frame.size.width/3)-20);
         }
         else
         {
             return CGSizeMake((collectionView.frame.size.width/2)-20, (collectionView.frame.size.width/2)-20);
         }
     }else{
         return CGSizeMake(80, 80);
     }
 
}
@end
