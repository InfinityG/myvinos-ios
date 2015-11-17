//
//  FormTableController.m
//  TableWithTextField
//
//  Created by Andrew Lim on 4/15/11.
#import "FormTableControllerLogIn.h"

@implementation FormTableControllerLogIn

@synthesize password = password_ ;
@synthesize email = email_ ;
@synthesize myDelegate;

#pragma mark -
#pragma mark Initialization

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
	
	
	self.password    = @"" ;
	self.email = @"" ;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
				 cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;

    // Make cell unselectable
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UITextField* tf = nil ;	
	switch ( indexPath.row ) {
        case 0: {
           UILabel *memberTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 ,cell.bounds.size.width, cell.bounds.size.height)];
            memberTitle.textAlignment =  NSTextAlignmentCenter;
            memberTitle.backgroundColor = [UIColor clearColor];
            memberTitle.textColor = [UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f];
            memberTitle.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(memberTitle.bounds.size.height*0.3)];
            memberTitle.userInteractionEnabled = FALSE;
            [memberTitle setText:@"PRIVATE CELLAR MEMBERS"];
            [cell addSubview:memberTitle];
            break ;
        }
        case 1: {
            //cell.textLabel.text = @"email" ;
            tf = emailField_ = [self makeTextField:self.email placeholder:@"Email"];
            tf.keyboardType = UIKeyboardTypeEmailAddress;
            [cell addSubview:emailField_];
            break ;
        }
        case 2: {
            //cell.textLabel.text = @"Password" ;
            tf = passwordField_ = [self makeTextField:self.password placeholder:@"Password"];
            tf.returnKeyType = UIReturnKeyDone;
            [cell addSubview:passwordField_];
            break ;
        }
        case 3: {
           
            //CANCEL BUTTON
            UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBut.frame = CGRectMake(cell.bounds.size.width*0.05,0,cell.bounds.size.width*0.3,cell.bounds.size.height);
            loginBut.backgroundColor = [UIColor clearColor];
            [loginBut setTitle:@"CANCEL" forState:UIControlStateNormal];
            [loginBut setTitleColor:[UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            loginBut.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:(loginBut.bounds.size.height*0.4)];
            [loginBut addTarget:myDelegate action:@selector(closeForms) forControlEvents:UIControlEventTouchUpInside];
            loginBut.alpha = 1;
            [cell addSubview:loginBut];
            
            //FORGOT PASSWORD BUTTON
            UIButton *forgotBut = [UIButton buttonWithType:UIButtonTypeCustom];
            forgotBut.frame = CGRectMake(cell.bounds.size.width*0.35,0,cell.bounds.size.width*0.3,cell.bounds.size.height);
            forgotBut.backgroundColor = [UIColor clearColor];
            [forgotBut setTitle:@"FORGOT" forState:UIControlStateNormal];
            [forgotBut setTitleColor:[UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            forgotBut.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:(loginBut.bounds.size.height*0.4)];
            [forgotBut addTarget:myDelegate action:@selector(forgotPassword) forControlEvents:UIControlEventTouchUpInside];
            forgotBut.alpha = 1;
            [cell addSubview:forgotBut];
            
            //LOG IN BUTTON
            UIButton *signUpBut = [UIButton buttonWithType:UIButtonTypeCustom];
            signUpBut.frame = CGRectMake(cell.bounds.size.width*0.65,0,cell.bounds.size.width*0.3,cell.bounds.size.height);
            signUpBut.backgroundColor = [UIColor clearColor];
            [signUpBut setTitle:@"LOG IN" forState:UIControlStateNormal];
            [signUpBut setTitleColor:[UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            signUpBut.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(signUpBut.bounds.size.height*0.4)];
            [signUpBut addTarget:myDelegate action:@selector(loginFromForm) forControlEvents:UIControlEventTouchUpInside];
            signUpBut.alpha = 1;
            [cell addSubview:signUpBut];
            
            
            
            break ;
        }
	}

	// Textfield dimensions
	tf.frame = CGRectMake(0, 0, self.view.superview.bounds.size.width, cell.bounds.size.height);
    tf.tag = indexPath.row;
    tf.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:(tf.bounds.size.height*0.4)];
	// Workaround to dismiss keyboard when Done/Return is tapped
	[tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];	
	
	// We want to handle textFieldDidEndEditing
	tf.delegate = self ;
    
  return cell;
}

#pragma mark -
#pragma mark Table view delegate

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in vieswDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
   // [super dealloc];
}

-(UITextField*) makeTextField: (NSString*)text	
                  placeholder: (NSString*)placeholder  {
	UITextField *tf = [[UITextField alloc] init] ;
    tf.delegate = self;
    tf.returnKeyType = UIReturnKeyNext;
    tf.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:(tf.bounds.size.height*0.8)];
    tf.placeholder = placeholder ;
	tf.text = text ;
	tf.autocorrectionType = UITextAutocorrectionTypeNo ;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = YES;
    tf.textAlignment = NSTextAlignmentCenter;
	tf.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
	return tf ;
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    NSLog(@"textFieldFinished");
    // [sender resignFirstResponder];
}

// Textfield value changed, store the new value.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    
    if ( textField == passwordField_ ) {
        self.password = textField.text ;
    } else if ( textField == emailField_ ) {
        self.email = textField.text ;
    }
    
    /* RESTRICT KEYS
     
     if ([string isEqualToString:@"#"]) {
     return NO;
     }
     else {
     return YES;
     }
     */
    
    return YES;
}
// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"FINISH EDITING");
	if ( textField == passwordField_ ) {
		self.password = textField.text ;
	} else if ( textField == emailField_ ) {
		self.email = textField.text ;		
	}
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSLog(@"TEXT FIELD SHOULD RETURN");
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [self.view viewWithTag:nextTag];
    if (nextResponder) {
        NSLog(@"NEXT FIELD");
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        NSLog(@"FIELD DONE");
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    if (self.view.alpha == 0.0f) {
        return YES;
    }
    else{
    return NO; // We do not want UITextField to insert line-breaks.

    }
}
    
-(void)removeAllTextFields{
    
     NSLog(@"REMOVE ALL TEXT FIELDS");
    
    [[self view] endEditing:YES];
    
}

-(void)clearAllFields{
    emailField_.text = @"";
    passwordField_.text = @"";
    email_ = @"";
    password_ = @"";
}

- (void)scrollToTheBottom:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

//INFO POP UP
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    // textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    if ( textField == emailField_ ) {
        //SCROLL TO TOP
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollToTheBottom:YES];
        });
    }
   
    
    
    
    
    return YES;
}

@end

