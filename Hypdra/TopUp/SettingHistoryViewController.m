//
//  SettingHistoryViewController.m
//  Montage
//
//  Created by MacBookPro on 7/27/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "SettingHistoryViewController.h"
#import "AFNetworking.h"


@interface SettingHistoryViewController ()
{
    UISwipeGestureRecognizer *swipeLeft,*swipeRight;

    NSString *user_id;
    
    NSMutableArray *amunt,*dat,*pymtType,*prodct;
    
    int allCount,i;
}
@end

@implementation SettingHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.swipeView addGestureRecognizer:swipeLeft];
    
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.swipeView addGestureRecognizer:swipeRight];
    
    
    [[self.printBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    allCount = 0;
    
    i = 1;
    
    amunt = [[NSMutableArray alloc]init];
    dat = [[NSMutableArray alloc]init];
    pymtType = [[NSMutableArray alloc]init];
    prodct = [[NSMutableArray alloc]init];
    
    
    self.dateLabel.text = @"";
    
    self.amountLabel.text = @"";
    
    self.pTypeLabel.text = @"";
    
    self.productLabel.text = @"";

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    [self getSerevr];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    NSLog(@"viewWillLayoutSubviews");

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.topView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.topView.frame.size.width, self.topView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);

}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        
        i++;
        
        if (i <= amunt.count)
        {
            NSString *someString = [[NSString alloc] initWithFormat:@"%d", i];
            
            self.firstLabel.text = someString;
            
            
            [self makeValues];
        }
        else
        {
            i = (int)amunt.count;
        }
        
        
        
        
        
/*        allCount++;
        
        
        NSLog(@"Swipe Left = %d",allCount);

        if (allCount < amunt.count)
        {
            
            NSLog(@"Swipe Left True");

            NSString *someString = [[NSString alloc] initWithFormat:@"%d", (allCount + 1)];
            
            self.firstLabel.text = someString;

            
            [self makeValues];
        }
        else
        {
            allCount = (int)amunt.count;
            
            NSLog(@"Swipe Left False = %d",allCount);

        }*/
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        
        i--;
        
        if (i >= 1)
        {
            NSString *someString = [[NSString alloc] initWithFormat:@"%d", i];
            
            self.firstLabel.text = someString;
            
            
            [self makeValues];
        }
        else
        {
            i = 1;
        }


/*        allCount--;
        
        NSLog(@"Swipe Right = %d",allCount);

        if (allCount > 0)
        {
            
            NSLog(@"Swipe Right True");

            NSString *someString = [[NSString alloc] initWithFormat:@"%d", (allCount - 1)];
            
            self.firstLabel.text = someString;

            
            [self makeValues];
        }
        else
        {
            
            NSLog(@"Swipe Right False");

            allCount = 0;
        }
        */
        
    }
}

- (IBAction)print_Atn:(id)sender
{
    
}


- (void)getSerevr
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=advance_payment_status";
    
//    NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=PaymentHistory";
    
    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=PaymentHistory";

    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Json Payment Response:%@",responseObject);
         
         NSArray *ary = [responseObject objectForKey:@"PaymentHistory"];
         
         for (NSDictionary *dct in ary)
         {
             [amunt addObject:[dct objectForKey:@"Amount"]];
             [dat addObject:[dct objectForKey:@"Date"]];
             [pymtType addObject:[dct objectForKey:@"PaymentType"]];
             [prodct addObject:[dct objectForKey:@"Product"]];

         }
         
         NSString *someString = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)amunt.count];

         self.firstLabel.text = @"1";
         
         self.lastLabel.text = someString;
         
         [self makeValues];
         
     }
     failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
}


-(void)makeValues
{
    self.dateLabel.text = dat[(i-1)];
    
    self.amountLabel.text = amunt[(i-1)];
    
    self.pTypeLabel.text = pymtType[(i-1)];
    
    self.productLabel.text = prodct[(i-1)];
}


@end
