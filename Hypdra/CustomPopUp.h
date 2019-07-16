#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ClickDelegates;

@interface CustomPopUp : UIView{
    UIView *childPopUp,*FirstView,*secondView,*thirdView;
    UILabel *titleLbl;
    id<ClickDelegates> _click_delegate;
    UIViewController *_parent;
}

@property (nonatomic, retain) id<ClickDelegates> _click_delegate;
@property (nonatomic, retain) UIViewController *_parent;
@property (nonatomic,strong) UIImageView *alertIcon;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *okay;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UITextView *msgLabel;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, assign) BOOL outSideTap;

-(void) initAlertwithParent : (UIViewController *) parent withDelegate : (id<ClickDelegates>) theDelegate withMsg : (NSString *)msg withTitle : (NSString *)title withImage : (UIImage *)alertIcon;

-(IBAction)OnOKClick :(id) sender;

-(void) hide;

-(void) show;

@end


// Delegate

@protocol ClickDelegates<NSObject>

@optional

-(void) okClicked:(CustomPopUp *)alertView;
-(void) cancelClicked:(CustomPopUp *)alertView;
-(void) agreeCLicked:(CustomPopUp *)alertView;

@end

