#import "RKSwipeBetweenViewControllers.h"


//CGFloat X_BUFFER = 0.0;
//CGFloat Y_BUFFER = 14.0;
//CGFloat HEIGHT = 50.0;
//
//
//CGFloat BOUNCE_BUFFER = 10.0;
//CGFloat ANIMATION_SPEED = 0.2;
//CGFloat SELECTOR_Y_BUFFER = 60.0;
//CGFloat SELECTOR_HEIGHT = 4.0;
//
//CGFloat X_OFFSET = 8.0;


CGFloat X_BUFFER = 0.0;
CGFloat Y_BUFFER = 1.0;
CGFloat HEIGHT = 42.0;


CGFloat BOUNCE_BUFFER = 10.0;
CGFloat ANIMATION_SPEED = 0.2;
CGFloat SELECTOR_Y_BUFFER = 42.0;
CGFloat SELECTOR_HEIGHT = 2.0;

CGFloat X_OFFSET = 8.0;



@interface RKSwipeBetweenViewControllers ()



@end

@implementation RKSwipeBetweenViewControllers
@synthesize viewControllerArray;
@synthesize selectionBar;
@synthesize pageController;
@synthesize navigationView;
@synthesize buttonText;
@synthesize imageText;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.barTintColor = [UIColor colorWithRed:0.01 green:0.05 blue:0.06 alpha:1];
    self.navigationBar.translucent = NO;
    viewControllerArray = [[NSMutableArray alloc]init];
    self.currentPageIndex = 0;
    self.isPageScrollingFlag = NO;
    self.hasAppearedFlag = NO;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        X_OFFSET = 8.0 ;
    }
    else
    {
        X_OFFSET = 20.0 ;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MovePage:)
                                                 name:@"MovePage"
                                               object:nil];
}


- (void) MovePage:(NSNotification *) notification
{
    
    __weak typeof(self) weakSelf = self;

    [pageController setViewControllers:@[[viewControllerArray objectAtIndex:1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete)
     {
         
         if (complete)
         {
             [weakSelf updateCurrentPageIndex:1];
         }
     }];
}


#pragma mark Customizables

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)setupSegmentButtons
{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.navigationBar.frame.size.height)];
    
    NSInteger numControllers = [viewControllerArray count];
    
    if (!buttonText)
    {
         buttonText = [[NSArray alloc]initWithObjects: @"My Images",@"Wizard",@"Advanced",@"Professional",@"etc",@"etc",@"etc",@"etc",nil];
    }
    
    imageText = [[NSArray alloc]initWithObjects:@"ico-image.png",@"ico-wizard.png",@"ico-advanced.png",@"Professional.png", nil];
    
    NSLog(@"Count = %ld",(long)numControllers);
    
    for (int i = 0; i<numControllers; i++)
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(X_BUFFER+i*(self.view.frame.size.width-2*X_BUFFER)/numControllers-X_OFFSET, Y_BUFFER, (self.view.frame.size.width-2*X_BUFFER)/numControllers, HEIGHT)];
        
        
        [navigationView addSubview:button];
        
        
//        button.titleLabel.textAlignment =  NSTextAlignmentCenter; // if you want to
//
        button.tag = i;
        
//        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;

        button.backgroundColor = [self colorFromHexString:@"#DCE2EA"];
        
        [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [[button imageView] setContentMode: UIViewContentModeScaleAspectFit];

        UIImage *btnImage = [UIImage imageNamed:imageText[i]];
        [button setImage:btnImage forState:UIControlStateNormal];
        
        
        button.titleLabel.font = [UIFont systemFontOfSize:8.0];

        button.titleLabel.adjustsFontSizeToFitWidth = YES;

        
        button.titleLabel.textColor = [self colorFromHexString:@"#D1D7DE"];
        

        [button setTitle:[buttonText objectAtIndex:i] forState:UIControlStateNormal];
        
        
//        button.titleLabel.adjustsFontSizeToFitWidth = YES;

        
          }
    
    pageController.navigationController.navigationBar.topItem.titleView = navigationView;
    
    [self setupSelector];
}


- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


-(void)setupSelector
{
    selectionBar = [[UIView alloc]initWithFrame:CGRectMake(X_BUFFER-X_OFFSET, SELECTOR_Y_BUFFER,(self.view.frame.size.width-2*X_BUFFER)/[viewControllerArray count], SELECTOR_HEIGHT)];
    selectionBar.backgroundColor = [UIColor blueColor];
    selectionBar.alpha = 0.8;
    [navigationView addSubview:selectionBar];
}


#pragma mark Setup

-(void)viewWillAppear:(BOOL)animated
{

    if (!self.hasAppearedFlag)
    {
        [self setupPageViewController];
        [self setupSegmentButtons];
        self.hasAppearedFlag = YES;
    }

}

-(void)setupPageViewController
{
    
    pageController = (UIPageViewController*)self.topViewController;
    pageController.delegate = self;
    pageController.dataSource = self;
    
    [pageController setViewControllers:@[[viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
 
    [self syncScrollView];

}

-(void)syncScrollView
{
    for (UIView* view in pageController.view.subviews)
    {
        if([view isKindOfClass:[UIScrollView class]])
        {
            self.pageScrollView = (UIScrollView *)view;
            self.pageScrollView.delegate = self;
        }
    }
}


#pragma mark Movement

-(void)tapSegmentButtonAction:(UIButton *)button
{
    if (!self.isPageScrollingFlag)
    {
        NSInteger tempIndex = self.currentPageIndex;
        
        __weak typeof(self) weakSelf = self;
        
        if (button.tag > tempIndex)
        {
            for (int i = (int)tempIndex+1; i<=button.tag; i++)
            {
                [pageController setViewControllers:@[[viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete)
                {
                
                    if (complete)
                    {
                        [weakSelf updateCurrentPageIndex:i];
                    }
                }];
            }
        }
        
        else if (button.tag < tempIndex)
        {
             for (int i = (int)tempIndex-1; i >= button.tag; i--)
             {
                [pageController setViewControllers:@[[viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete)
                 {
                    if (complete)
                    {
                        [weakSelf updateCurrentPageIndex:i];
                    }
                }];
            }
        }
    }
}


-(void)updateCurrentPageIndex:(int)newIndex
{
    self.currentPageIndex = newIndex;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat xFromCenter = self.view.frame.size.width-scrollView.contentOffset.x;
    NSInteger xCoor = X_BUFFER+selectionBar.frame.size.width*self.currentPageIndex-X_OFFSET;
    
    selectionBar.frame = CGRectMake(xCoor-xFromCenter/[viewControllerArray count], selectionBar.frame.origin.y, selectionBar.frame.size.width, selectionBar.frame.size.height);
}

#pragma mark UIPageViewController Delegate Functions

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [viewControllerArray indexOfObject:viewController];

    if ((index == NSNotFound) || (index == 0))
    {
        return nil;
    }
    
    index--;
    return [viewControllerArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [viewControllerArray indexOfObject:viewController];

    if (index == NSNotFound)
    {
        return nil;
    }
    index++;
    
    if (index == [viewControllerArray count])
    {
        return nil;
    }
    return [viewControllerArray objectAtIndex:index];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        self.currentPageIndex = [viewControllerArray indexOfObject:[pageViewController.viewControllers lastObject]];
    }
}

#pragma mark - Scroll View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isPageScrollingFlag = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isPageScrollingFlag = NO;
}

@end
