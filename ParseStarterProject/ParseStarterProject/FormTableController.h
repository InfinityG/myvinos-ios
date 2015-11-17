//
//  FormTableController.h
//  TableWithTextField
//
//  Created by Andrew Lim on 4/15/11.
#import <UIKit/UIKit.h>

@interface FormTableController : UITableViewController<UITextFieldDelegate,UIAlertViewDelegate> {
	id myDelegate;
    
    NSString* name_ ;
    NSString* surname_ ;
    NSString* mobile_ ;
	NSString* password_ ;
    NSString* email_ ;
    NSString* reference_ ;
	
	UITextField* nameField_ ;
    UITextField* surnameField_ ;
    UITextField* mobileField_ ;
	UITextField* passwordField_ ;
    UITextField* emailField_ ;
    UITextField* referenceField_ ;
}

// Creates a textfield with the specified text and placeholder text
-(UITextField*) makeTextField: (NSString*)text	
                  placeholder: (NSString*)placeholder  ;

// Handles UIControlEventEditingDidEndOnExit
- (IBAction)textFieldFinished:(id)sender ;

@property (strong, nonatomic) id myDelegate;
@property (nonatomic,copy) NSString* name ;
@property (nonatomic,copy) NSString* surname ;
@property (nonatomic,copy) NSString* mobile ;
@property (nonatomic,copy) NSString* password ;
@property (nonatomic,copy) NSString* email ;
@property (nonatomic,copy) NSString* reference ;

-(void)removeAllTextFields;

-(void)clearAllFields;

@end
