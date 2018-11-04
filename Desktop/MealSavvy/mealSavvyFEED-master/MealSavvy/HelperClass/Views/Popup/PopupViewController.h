

#import <UIKit/UIKit.h>

@protocol PopupViewControllerDelegate;

@interface PopupViewController : UIViewController<UIGestureRecognizerDelegate>{
    
    __weak IBOutlet UILabel *labelTitle;
    __weak IBOutlet UILabel *labelMessage;
    __weak IBOutlet UIButton *buttonCancel;
    
    __weak IBOutlet UIButton *buttonAgreeForCancel;
    __weak IBOutlet UIButton *buttonAgreeCenter;
    
    __weak IBOutlet UIView *viewContent;
    __weak IBOutlet UIView *viewButton;
    __weak IBOutlet UIView *viewTitle;
    
    __weak IBOutlet UIView *viewAlert;
    __weak IBOutlet UIView *viewShadown;
}

@property(strong,nonatomic)NSString *alerTitle;
@property(strong,nonatomic)NSString *alertMessage;
@property(strong,nonatomic)NSString *buttonAgreeTitle;
@property(strong,nonatomic)NSString *buttonCancelTitle;

- (IBAction)didTouchAgreeButton:(id)sender;
- (IBAction)didTouchAgreeOfCancelButton:(id)sender;
- (IBAction)didTouchCancelButton:(id)sender;



@property (assign,nonatomic) id <PopupViewControllerDelegate> delegate;
@end


@protocol PopupViewControllerDelegate <NSObject>
@required
- (void)didTouchPopupButtonAgree:(BOOL)agree;

@end