//
//  FormTableControllerLogIn.h
//  TableWithTextField
//
//  Created by Andrew Lim on 4/15/11.
#import <UIKit/UIKit.h>

@interface FormTableControllerLogIn : UITableViewController<UITextFieldDelegate> {
	id myDelegate;
    
	NSString* password_ ;
	NSString* email_ ;	
	
	UITextField* passwordField_ ;
	UITextField* emailField_ ;	
}

// Creates a textfield with the specified text and placeholder text
-(UITextField*) makeTextField: (NSString*)text	
                  placeholder: (NSString*)placeholder  ;

// Handles UIControlEventEditingDidEndOnExit
- (IBAction)textFieldFinished:(id)sender ;

@property (strong, nonatomic) id myDelegate;
@property (nonatomic,copy) NSString* password ;
@property (nonatomic,copy) NSString* email ;

-(void)removeAllTextFields;
-(void)clearAllFields;
@end
