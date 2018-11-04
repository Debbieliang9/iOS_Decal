
#import "PopupViewController.h"

@interface PopupViewController ()

@end

@implementation PopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    viewAlert.layer.cornerRadius=10.0f;
    NSLog(@"Title:%@, Message:%@, Agree:%@, Cancel:%@",_alerTitle,_alertMessage,_buttonAgreeTitle,_buttonCancelTitle);
    
//    self.alertMessage=@"This service is unavailable in this salon";
   self.buttonAgreeTitle=@"Delete";
    self.buttonCancelTitle=@"Cancel";
    
    if(self.alertMessage.length>0){
        NSLog(@"Show message");
        //TODO set height labelMessage
        //set text frame
        
    
        CGSize labelSizeMessage = [self.alertMessage
                                   sizeWithFont:labelMessage.font //font you are using
                                   constrainedToSize:CGSizeMake(labelMessage.frame.size.width,9999)
                                   lineBreakMode:NSLineBreakByWordWrapping];
        
        
        CGRect frame = labelMessage.frame;
        frame.size.height = labelSizeMessage.height+20;
        labelMessage.frame = frame;
        viewContent.frame=CGRectMake(0,viewTitle.frame.size.height, viewContent.frame.size.width, frame.size.height+viewButton.frame.size.height);
        viewButton.frame=CGRectMake(0, frame.size.height, viewContent.frame.size.width, viewButton.frame.size.height);
        
        viewAlert.frame=CGRectMake(viewAlert.frame.origin.x, viewAlert.frame.origin.y, viewAlert.frame.size.width, viewButton.frame.size.height+viewContent.frame.size.height);
        //set text
        labelMessage.text=self.alertMessage;
        
    }
    else{
        NSLog(@"Show null message");
        //TODO hiden message
        //set frame
        viewContent.frame=CGRectMake(0,viewTitle.frame.size.height, viewContent.frame.size.width,viewButton.frame.size.height);
        
        viewAlert.frame=CGRectMake(viewAlert.frame.origin.x, viewAlert.frame.origin.y, viewAlert.frame.size.width, viewButton.frame.size.height+viewContent.frame.size.height);
        
        viewButton.frame=CGRectMake(0, 0, viewButton.frame.size.width, viewButton.frame.size.height);
        //set text
        labelMessage.text=self.alertMessage;
        
        
        //set up text message
        labelMessage.hidden=YES;
    }
    
    
    if (self.buttonCancelTitle) {
        //TODO button Agree and Cancel
        NSLog(@"button Agree and Cancel");
        //show button
        buttonCancel.hidden=NO;
        buttonAgreeForCancel.hidden=NO;
        buttonAgreeCenter.hidden=YES;
        
        //set up text frame
        //set button Cancel
        CGSize framButtonCancel = [self.buttonCancelTitle sizeWithFont:buttonCancel.titleLabel.font constrainedToSize:buttonCancel.intrinsicContentSize lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"framButtonCancel width:%f",framButtonCancel.width);
        buttonCancel.frame=CGRectMake(viewButton.frame.size.width-framButtonCancel.width, 0, framButtonCancel.width, viewButton.frame.size.height);
        
        CGSize framButtonAgree = [self.buttonAgreeTitle sizeWithFont:buttonAgreeForCancel.titleLabel.font constrainedToSize:buttonAgreeForCancel.intrinsicContentSize lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"framButtonAgree width:%f",framButtonAgree.width);
        buttonAgreeForCancel.frame=CGRectMake(viewButton.frame.size.width-(buttonAgreeForCancel.frame.size.width+5+framButtonAgree.width), 0, framButtonAgree.width+10, viewButton.frame.size.height);
        
        
        
        //set text
        buttonAgreeForCancel.titleLabel.text=self.buttonAgreeTitle;
        buttonCancel.titleLabel.text=self.buttonCancelTitle;
    }
    else{
        //TODO only button Agree
        NSLog(@"only button Agree");
        //show button
        buttonCancel.hidden=YES;
        buttonAgreeForCancel.hidden=YES;
        buttonAgreeCenter.hidden=NO;
        
        //set up text frame
        
        //set text

    }
    
    
    if (self.buttonAgreeTitle) {
        buttonAgreeCenter.titleLabel.text=self.buttonAgreeTitle;
    }
    else{
        buttonAgreeCenter.titleLabel.text=@"Alert";
    }
    
    UITapGestureRecognizer *gesRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]; // Declare the Gesture.
    gesRecognizer.delegate = self;
    [viewShadown addGestureRecognizer:gesRecognizer]; // Add Gesture to your view.
}

-(void)handleTap:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchPopupButtonAgree:)])
    {
        [self.delegate didTouchPopupButtonAgree:NO];
    }
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didTouchAgreeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchPopupButtonAgree:)])
    {
        [self.delegate didTouchPopupButtonAgree:YES];
    }
    [self.view removeFromSuperview];
    
}

- (IBAction)didTouchAgreeOfCancelButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchPopupButtonAgree:)])
    {
        [self.delegate didTouchPopupButtonAgree:YES];
    }
    [self.view removeFromSuperview];
}

- (IBAction)didTouchCancelButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchPopupButtonAgree:)])
    {
        [self.delegate didTouchPopupButtonAgree:NO];
    }
    [self.view removeFromSuperview];
}
@end
