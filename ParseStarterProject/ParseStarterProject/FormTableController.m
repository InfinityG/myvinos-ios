//
//  FormTableController.m
//  TableWithTextField
//
//  Created by Andrew Lim on 4/15/11.
#import "FormTableController.h"

@implementation FormTableController
@synthesize name = name_ ;
@synthesize surname = surname_ ;
@synthesize mobile = mobile_ ;
@synthesize password = password_ ;
@synthesize email = email_ ;
@synthesize reference = reference_ ;
@synthesize myDelegate;

#pragma mark -
#pragma mark Initialization

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
	
	self.name        = @"" ;
    self.surname     = @"" ;
    self.mobile     = @"" ;
	self.password    = @"" ;
    self.email = @"" ;
    self.reference = @"" ;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return 8;
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
    cell.backgroundColor = [UIColor clearColor];
	UITextField* tf = nil ;
    UILabel* myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height*0.65 , self.view.bounds.size.width, cell.bounds.size.height*0.35)];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.alpha = 1.0f;
    myLabel.textAlignment =  NSTextAlignmentCenter;
    myLabel.textColor = [UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f];
    myLabel.font = [UIFont fontWithName:@"SFUIText-Bold" size:(myLabel.bounds.size.height*0.5)];
    myLabel.userInteractionEnabled = FALSE;
    

	switch ( indexPath.row ) {
        case 0: {
            UILabel *memberTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height*0.0, self.view.superview.bounds.size.width, cell.bounds.size.height*0.9)];
            memberTitle.textAlignment =  NSTextAlignmentCenter;
            memberTitle.backgroundColor = [UIColor clearColor];
            memberTitle.textColor = [UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f];
            memberTitle.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(memberTitle.bounds.size.height*0.4)];
            memberTitle.userInteractionEnabled = FALSE;
            [memberTitle setText:@"PRIVATE CELLAR MEMBERSHIP"];
            [cell addSubview:memberTitle];
            break ;
        }
        case 1: {
			//cell.textLabel.text = @"Name" ;
			tf = nameField_ = [self makeTextField:self.name placeholder:@"Name"];
            tf.autocapitalizationType = UITextAutocapitalizationTypeWords;

			[cell addSubview:nameField_];
			break ;
		}
		case 2: {
			//cell.textLabel.text = @"surname" ;
			tf = surnameField_ = [self makeTextField:self.surname placeholder:@"Surname"];
            tf.autocapitalizationType = UITextAutocapitalizationTypeWords;

			[cell addSubview:surnameField_];
			break ;
		}		
        case 3: {
            //cell.textLabel.text = @"email" ;
            tf = mobileField_ = [self makeTextField:self.mobile placeholder:@"Mobile (+27831234567)"];
            tf.keyboardType = UIKeyboardTypePhonePad;
            [myLabel setText:@"Use the international format. ie. +27831234567"];
            [cell addSubview:mobileField_];
            break ;
        }
        case 4: {
            //cell.textLabel.text = @"email" ;
            tf = emailField_ = [self makeTextField:self.email placeholder:@"Email"];
            tf.keyboardType = UIKeyboardTypeEmailAddress;
            [myLabel setText:@""];
            [cell addSubview:emailField_];
            break ;
        }
        case 5: {
            //cell.textLabel.text = @"Password" ;
            tf = passwordField_ = [self makeTextField:self.password placeholder:@"1Passw0rd!"];
            tf.returnKeyType = UIReturnKeyNext;
            [myLabel setText:@"Secure password containing more than six characters."];
            [cell addSubview:passwordField_];
            break ;
        }
        case 6: {
            //cell.textLabel.text = @"Password" ;
            tf = referenceField_ = [self makeTextField:self.reference placeholder:@"MYVINOS"];
            tf.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            [myLabel setText:@"Use VOUCHER CODES for REWARDS"];
            tf.returnKeyType = UIReturnKeyDone;
            [cell addSubview:referenceField_];
            break ;
        }
        case 7: {
           
            //CANCEL BUTTON
            UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBut.frame = CGRectMake(cell.bounds.size.width*0.2,0,cell.bounds.size.width*0.3,cell.bounds.size.height);
            loginBut.backgroundColor = [UIColor clearColor];
            [loginBut setTitle:@"Back" forState:UIControlStateNormal];
            [loginBut setTitleColor:[UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            loginBut.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:(loginBut.bounds.size.height*0.4)];
            [loginBut addTarget:myDelegate action:@selector(closeForms) forControlEvents:UIControlEventTouchUpInside];
            loginBut.alpha = 1;
            [cell addSubview:loginBut];
            
            //SIGN UP BUTTON
            UIButton *signUpBut = [UIButton buttonWithType:UIButtonTypeCustom];
            signUpBut.frame = CGRectMake(cell.bounds.size.width*0.5,0,cell.bounds.size.width*0.3,cell.bounds.size.height);
            signUpBut.backgroundColor = [UIColor clearColor];
            [signUpBut setTitle:@"SIGN UP" forState:UIControlStateNormal];
            [signUpBut setTitleColor:[UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            signUpBut.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(signUpBut.bounds.size.height*0.4)];
            [signUpBut addTarget:myDelegate action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
            signUpBut.alpha = 1;
            [cell addSubview:signUpBut];
            
            
            
            break ;
        }
	}

	// Textfield dimensions
	tf.frame = CGRectMake(0, 0, self.view.superview.bounds.size.width, cell.bounds.size.height*0.65);
    tf.tag = indexPath.row;
    tf.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:(tf.bounds.size.height*0.8)];

	// Workaround to dismiss keyboard when Done/Return is tapped
	[tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];	
	
	// We want to handle textFieldDidEndEditing
	tf.delegate = self ;
    
    
    [cell addSubview:myLabel];
    
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
	tf.placeholder = placeholder ;
	tf.text = text ;
	tf.autocorrectionType = UITextAutocorrectionTypeNo ;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = YES;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.backgroundColor = [UIColor clearColor];
tf.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
	return tf ;
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    NSLog(@"textFieldFinished");
    // [sender resignFirstResponder];
}

// Textfield value changed, store the new value.
// Textfield value changed, store the new value.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    
    if ( textField == nameField_ ) {
        self.name = textField.text ;
    } else if ( textField == surnameField_ ) {
        self.surname = textField.text ;
    } else if ( textField == mobileField_ ) {
        if([textField.text isEqualToString:@""]) textField.text = @"+";
        if([textField.text isEqualToString:@"++"]) textField.text = @"+";
        self.mobile = textField.text ;
    } else if ( textField == passwordField_ ) {
        self.password = textField.text ;
    } else if ( textField == emailField_ ) {
        self.email = textField.text ;
    } else if ( textField == referenceField_ ) {
        if([string isEqualToString:@" "]){
            return NO;
        }
        else{
            self.reference = textField.text ;
        }
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

- (void)scrollToTheBottom:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
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
    if ( textField == mobileField_ ) {
        //SCROLL TO TOP
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollToTheBottom:YES];
        });
    }
    
    
    
    /*/SHOW INFO TO USER
    UIAlertView *alert;
    
    if ( textField == nameField_ ) {
    } else if ( textField == surnameField_ ) {
    } else if ( textField == mobileField_ ) {
        alert = [[UIAlertView alloc] initWithTitle:@"International Mobile Format"
                                           message:@"We use the international mobile format.\n\n+27 83 123 4567\nWe are expanding internationaly."
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];

    } else if ( textField == passwordField_ ) {
        alert = [[UIAlertView alloc] initWithTitle:@"Secure Password"
                                           message:@"Create a secure password containing at least 8 charachters, one number, one uppercase letter and a special character.\n\n1Passw0rd!\n\nWe follow all security measure to keep you safe."
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    } else if ( textField == emailField_ ) {
        alert = [[UIAlertView alloc] initWithTitle:@"Your Account"
                                           message:@"Your email will be used if  you ever need to reset your password and/or redeam you VINOS balance on another device."
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    } else if ( textField == referenceField_ ) {
        alert = [[UIAlertView alloc] initWithTitle:@"Voucher Codes"
                                           message:@"Voucher codes get you VINOS. Use the voucher codes from our partners and collaborators for various Private Cellar Benifits."
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    }
    
    [alert show];

*/
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"FINISH EDITING");
	if ( textField == nameField_ ) {
		self.name = textField.text ;
    } else if ( textField == surnameField_ ) {
        self.surname = textField.text ;
    } else if ( textField == mobileField_ ) {
        self.mobile = textField.text ;
    } else if ( textField == passwordField_ ) {
		self.password = textField.text ;
    } else if ( textField == emailField_ ) {
        self.email = textField.text ;
    } else if ( textField == referenceField_ ) {
        self.reference = textField.text ;
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
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)removeAllTextFields{
    NSLog(@"REMOVE ALL TEXT FIELDS");
    [[self view] endEditing:YES];
    
    
}

-(void)clearAllFields{
    nameField_.text = @"";
    surnameField_.text = @"";
    mobileField_.text = @"";
    referenceField_.text = @"";
    emailField_.text = @"";
    passwordField_.text = @"";
    
    name_ = @"";
    surname_ = @"";
    mobile_ = @"";
    reference_ = @"";
    email_ = @"";
    password_ = @"";
}

@end

