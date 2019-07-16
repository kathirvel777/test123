//
//  AiStyleTabViewController.m
//  Hypdra
//
//  Created by Mac on 12/24/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import "AiStyleTabViewController.h"

@interface AiStyleTabViewController ()<UITabBarControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating,UISearchDisplayDelegate,UITextFieldDelegate>{
    BOOL enableSearch;
}

@end

@implementation AiStyleTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self initializeSearchBar];

    // Do any additional setup after loading the view.
    enableSearch = NO;
    _lbl1 = [[UILabel alloc] init];
    /*important--------- */_lbl1.textColor = [UIColor blackColor];
    [_lbl1 setFrame:self.navigationItem.titleView.frame];
    _lbl1.backgroundColor=[UIColor clearColor];
    _lbl1.textColor=[UIColor whiteColor];
    _lbl1.userInteractionEnabled=NO;
    _lbl1.text= @"Pre Style";
    [_lbl1 setFont:[UIFont fontWithName:@"FuturaT-Book" size:18.0]];
    _lbl1.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView= _lbl1;
}
-(void)initializeSearchBar{
    
_searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [_searchBar setFrame:self.navigationItem.titleView.frame];
    [_searchBar sizeToFit];
    _searchBar.placeholder = @"Search Style";
    self.searchBar.tintColor = [UIColor blackColor];
    _searchBar.delegate = self;
   // _searchBar.returnKeyType = .done

    //_searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = _searchBar;
    //_searchBar.searchBarStyle = UISearchBarStyleMinimal ;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSDictionary *userinfo=@{@"searchStyle":searchBar.text};
    NSLog(@"searchStyle %@",searchBar.text);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchNotify" object:self userInfo:userinfo];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSDictionary *userinfo=@{@"searchStyle":textField.text};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchNotify" object:self userInfo:userinfo];
    
 return YES;
}
- (IBAction)menu_actn:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    [self.frostedViewController presentMenuViewController];
}


- (IBAction)search_actn:(UIBarButtonItem *)sender {
    if(enableSearch){
        enableSearch = NO;
        self.navigationItem.titleView = _lbl1;
        sender.title = @"Search";

    }else{
        self.navigationItem.titleView = _searchBar;
        sender.title = @"Cancel";
        enableSearch = YES;
    }
    
}

- (IBAction)back_actn:(id)sender {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LiveEffects" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_23" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}
@end
