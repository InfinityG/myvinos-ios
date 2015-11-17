//
//  FormTableController.h
//  TableWithTextField
//
//  Created by Andrew Lim on 4/15/11.
#import <UIKit/UIKit.h>

@interface FormTableControllerDeliver : UITableViewController<UITextFieldDelegate> {
	id myDelegate;
    
    NSString* name_ ;
    NSString* address_ ;
    NSString* notes_ ;
	
	UITextField* nameField_ ;
    UITextField* addressField_ ;
    UITextField* notesField_ ;
	}

// Creates a textfield with the specified text and placeholder text
-(UITextField*) makeTextField: (NSString*)text	
                  placeholder: (NSString*)placeholder  ;

// Handles UIControlEventEditingDidEndOnExit
- (IBAction)textFieldFinished:(id)sender ;

@property (strong, nonatomic) id myDelegate;
@property (nonatomic,copy) NSString* name ;
@property (nonatomic,copy) NSString* address ;
@property (nonatomic,copy) NSString* notes ;

@property (nonatomic,copy) UITextField* addressField_ ;


-(void)removeAllTextFields;
-(void)setAddressDirect:(NSString *)address;

@end
