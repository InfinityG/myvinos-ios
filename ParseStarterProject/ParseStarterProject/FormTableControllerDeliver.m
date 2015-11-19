//
//  FormTableController.m
//  TableWithTextField
//
//  Created by Andrew Lim on 4/15/11.
#import "FormTableControllerDeliver.h"
#import <Deliver.h>

@implementation FormTableControllerDeliver
@synthesize name = name_ ;
@synthesize address = address_ ;
@synthesize notes = notes_ ;

@synthesize myDelegate;

#pragma mark -
#pragma mark Initialization

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
	
	self.name        = @"" ;
    self.address     = @"" ;
    self.notes     = @"" ;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size.height/9;
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
	switch ( indexPath.row ) {
        
        case 0: {
            UILabel *memberTitle = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width*0.05, 0 ,cell.bounds.size.width*0.9, cell.bounds.size.height)];
            memberTitle.textAlignment =  NSTextAlignmentLeft;
            memberTitle.backgroundColor = [UIColor clearColor];
            memberTitle.textColor = [UIColor whiteColor];
            memberTitle.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:(memberTitle.bounds.size.height*0.3)];
            memberTitle.userInteractionEnabled = FALSE;
            [memberTitle setText:@"Deliver To:"];
            [cell addSubview:memberTitle];
            break ;
        }
        case 1: {
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"first_name"]!=nil){
                self.name = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"first_name"],[[NSUserDefaults standardUserDefaults] stringForKey:@"last_name"]];
            }
            tf = nameField_ = [self makeTextField:self.name placeholder:@"Recipient Name"];
            tf.autocapitalizationType = UITextAutocapitalizationTypeWords;
            [cell addSubview:nameField_];
            break ;
        }
        case 2: {
            UILabel *memberTitle = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width*0.05, 0 ,cell.bounds.size.width*0.9, cell.bounds.size.height)];
            memberTitle.textAlignment =  NSTextAlignmentLeft;
            memberTitle.backgroundColor = [UIColor clearColor];
            memberTitle.textColor = [UIColor whiteColor];
            memberTitle.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:(memberTitle.bounds.size.height*0.3)];
            memberTitle.userInteractionEnabled = FALSE;
            [memberTitle setText:@"Address:"];
            [cell addSubview:memberTitle];
            break ;
        }
        case 3: {
            tf = addressField_ = [self makeTextField:self.address placeholder:@"Delivery Address"];
            tf.autocapitalizationType = UITextAutocapitalizationTypeWords;
            [cell addSubview:addressField_];
            break ;
        }
        case 4: {
            UILabel *memberTitle = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width*0.05, 0 ,cell.bounds.size.width*0.9, cell.bounds.size.height)];
            memberTitle.textAlignment =  NSTextAlignmentLeft;
            memberTitle.backgroundColor = [UIColor clearColor];
            memberTitle.textColor = [UIColor whiteColor];
            memberTitle.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:(memberTitle.bounds.size.height*0.3)];
            memberTitle.userInteractionEnabled = FALSE;
            [memberTitle setText:@"Notes for the Driver:"];
            [cell addSubview:memberTitle];
            break ;
        }
        case 5: {
            tf = notesField_ = [self makeTextField:self.notes placeholder:@"Details or instructions"];
            tf.returnKeyType = UIReturnKeyDone;
            tf.autocorrectionType = UITextAutocorrectionTypeYes ;
            tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf.adjustsFontSizeToFitWidth = YES;

            [cell addSubview:notesField_];
            break ;
        }
        case 6: {
            UILabel *memberTitle = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width*0.05, 0 ,cell.bounds.size.width*0.9, cell.bounds.size.height)];
            memberTitle.textAlignment =  NSTextAlignmentCenter;
            memberTitle.backgroundColor = [UIColor clearColor];
            memberTitle.textColor = [UIColor whiteColor];
            memberTitle.font = [UIFont fontWithName:@"SFUIText-Regular" size:(memberTitle.bounds.size.height*0.15)];
            memberTitle.userInteractionEnabled = FALSE;
            [memberTitle setText:@"Use your VINOS and confirm your on-demand delivery?"];
            [cell addSubview:memberTitle];
            break ;
        }
        case 7: {
            //CANCEL BUTTON
            UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBut.frame = CGRectMake(cell.bounds.size.width*0.0,0,cell.bounds.size.width*0.5,cell.bounds.size.height);
            loginBut.backgroundColor = [UIColor clearColor];
            [loginBut setTitle:@"BOTTLES" forState:UIControlStateNormal];
            [loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginBut.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:(loginBut.bounds.size.height*0.4)];
            [loginBut addTarget:myDelegate action:@selector(activateDeck) forControlEvents:UIControlEventTouchUpInside];
            loginBut.alpha = 1;
            [cell addSubview:loginBut];
            
            //SIGN UP BUTTON
            UIButton *signUpBut = [UIButton buttonWithType:UIButtonTypeCustom];
            signUpBut.frame = CGRectMake(cell.bounds.size.width*0.5,0,cell.bounds.size.width*0.5,cell.bounds.size.height);
            signUpBut.backgroundColor = [UIColor clearColor];
            [signUpBut setTitle:@"DELIVER NOW" forState:UIControlStateNormal];
            [signUpBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            signUpBut.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(signUpBut.bounds.size.height*0.4)];
            [signUpBut addTarget:myDelegate action:@selector(deliverNow) forControlEvents:UIControlEventTouchUpInside];
            signUpBut.alpha = 1;
            [cell addSubview:signUpBut];
            
            
            break ;
        }
        
	}

	// Textfield dimensions
	tf.frame = CGRectMake(self.view.bounds.size.width*0.05, cell.bounds.size.height*0.15, self.view.bounds.size.width*0.9, cell.bounds.size.height*0.7);
    tf.tag = indexPath.row;
    tf.layer.cornerRadius = 5;
    tf.textAlignment = NSTextAlignmentLeft;
    tf.backgroundColor = [UIColor whiteColor];
    tf.textColor = [UIColor blackColor];
    tf.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:(tf.bounds.size.height*0.8)];

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

-(void)setAddressDirect:(NSString *)address{
    addressField_.text = address;
}

-(UITextField*) makeTextField: (NSString*)text	
                  placeholder: (NSString*)placeholder  {
	UITextField *tf = [[UITextField alloc] init] ;
    tf.delegate = self;
    tf.returnKeyType = UIReturnKeyDone;
	tf.placeholder = placeholder ;
	tf.text = text ;
	tf.autocorrectionType = UITextAutocorrectionTypeNo ;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = NO;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.backgroundColor = [UIColor clearColor];
    //tf.textColor = [UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
    tf.textColor = [UIColor whiteColor];
    
	return tf ;
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    NSLog(@"textFieldFinished");
    // [sender resignFirstResponder];
}

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"FINISH EDITING");
	if ( textField == nameField_ ) {
		self.name = textField.text ;
    } else if ( textField == addressField_ ) {
        self.address = textField.text ;
        [(Deck*)myDelegate forwardLocateMe];
    } else if ( textField == notesField_ ) {
        self.notes = textField.text ;
    }
}

// Textfield value changed, store the new value.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
   
    if ( textField == nameField_ ) {
        self.name = textField.text ;
    } else if ( textField == addressField_ ) {
        self.address = textField.text ;
    } else if ( textField == notesField_ ) {
        self.notes = textField.text ;
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

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSLog(@"TEXT FIELD SHOULD RETURN");
    /*
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
    */
     [textField resignFirstResponder];
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)removeAllTextFields{
    NSLog(@"REMOVE ALL TEXT FIELDS");
    [[self view] endEditing:YES];
    
    
}

@end

