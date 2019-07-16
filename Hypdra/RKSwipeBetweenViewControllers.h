
#import <UIKit/UIKit.h>

@protocol RKSwipeBetweenViewControllersDelegate <NSObject>

@end

@interface RKSwipeBetweenViewControllers : UINavigationController <UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property (nonatomic, weak) id<RKSwipeBetweenViewControllersDelegate> navDelegate;
@property (nonatomic, strong) UIView *selectionBar;
@property (nonatomic, strong)UIPageViewController *pageController;
@property (nonatomic, strong)UIView *navigationView;
@property (nonatomic, strong)NSArray *buttonText,*imageText;


@property (nonatomic) UIScrollView *pageScrollView;
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) BOOL isPageScrollingFlag;
@property (nonatomic) BOOL hasAppearedFlag;


@end