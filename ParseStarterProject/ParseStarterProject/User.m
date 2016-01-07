//
//  User.m
//  colorgameapp
//
//  Created by Herman Coetzee on 2012/10/07.
//  Copyright (c) 2012 Color Game App. All rights reserved.
//

#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

#define CARDHEIGHT self.bounds.size.height*0.95
#define DISPLAYHEIGHT self.bounds.size.height*0.595

#define CARDRECT self.bounds.size.width*0.000, self.bounds.size.height*0.000 ,self.bounds.size.width*1.0, CARDHEIGHT
#define DISPLAYRECT self.bounds.size.width*0.005, self.bounds.size.height*0.395 ,self.bounds.size.width*0.99, DISPLAYHEIGHT
#define CARDSTART -CARDHEIGHT
#define CARDEND CARDHEIGHT*0.5

#define URLEMail @"mailto:support@myvinos.club?subject=MyVinos APP request&body=Hello, I am interested in "

#import "GMEllipticCurveCrypto.h"
#import <Parse/Parse.h>
#import "User.h"
#import "FormTableController.h"
#import "FormTableControllerLogIn.h"
#import "FormTableControllerForgot.h"
#import "ParseStarterProjectViewController.h"


#define CARDDELAY 0.6f
#define CARDANIMATION 0.15f

#define SHADOWRADIUS 2.5f;

//#define IDIOSERVER @"https://id-io-myvinos-test.infinity-g.com"
//#define MYVINOSSERVER @"https://myvinos-test-api.infinity-g.com"
#define IDIOSERVER @"https://id-io-myvinos.infinity-g.com"
#define MYVINOSSERVER @"https://myvinos-api.infinity-g.com"


void freeRawData(void *info, const void *data, size_t size);


@implementation User

@synthesize myDelegate,vinosButs,memberView,buttonsView,userButs,signUpView,signUpTable,jsonDataSignUp;
@synthesize dataSignUp,connectionSignUp,connectionLogIn,dataLogIn,jsonDataLogIn,connectionUser,dataUser,jsonDataUser,connectionToken,dataToken,jsonDataToken;
@synthesize memberTitle,refCode,topUps,jsonDataTopUp,connectionTopUp,dataTopUp,jsonDataHistory,connectionHistory,dataHistory,myPaymentPage,topUpsToBuy,summeryLabel,summeryPurchase;
@synthesize creditHistoryView,logInTable,welcomeTxt,welcomeTxtArr,creditInfoView,paymentTimeLimitTimer,historyBut,tokenTimer,QRcodeImg,highlightView,infoBut,contactInfoView,loginButM,signUpButM,deliveryHistoryView;

@synthesize forgotTable,connectionForgot,dataForgot,jsonDataForgot,connectionReset,dataReset,jsonDataReset,goToCollection,menuView,userMenuView,menuCloseBut;

@synthesize membershipView,membershipViewText,membershipToGet,membershipViewTextSummary,membershipButs,membershipToBuyDict,membershipInfoView,connectionMembership,dataMembership,jsonDataMembership,bkLayer;

int amountToBuy = 0;
int membershipToGetAmount = 0;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"HELLO USER SCREEN");
        userOpen = FALSE;
        userFound = FALSE;
        userJustSignedUp = FALSE;
        //DESIGN User
        //BACK GROUND
        bkLayer = [[UIView alloc] initWithFrame:frame];
        bkLayer.backgroundColor = [UIColor clearColor];
        bkLayer.alpha = 1.0f;
        bkLayer.userInteractionEnabled = YES;
        [self addSubview:bkLayer];
        
        
        //ADD TOCH TO CLOSE LAYER
        UITapGestureRecognizer *tappedbkLayer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCloseUserForce)];
        tappedbkLayer.numberOfTapsRequired = 1;
        [bkLayer addGestureRecognizer:tappedbkLayer];
        
        
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.5f;
        
        vinosButs = [[NSMutableArray alloc] init];
        membershipButs = [[NSMutableArray alloc] init];
        userButs = [[NSMutableArray alloc] init];
        topUps = [[NSMutableArray alloc] init];
        topUpsToBuy = [[NSMutableArray alloc] init];
        welcomeTxtArr = [[NSArray alloc] initWithObjects:@"GET VINOS\n\Get VINOS to have wine delivered on-demand. ",@"SELECT\n\nYour wines from awesome cellar collections curated by professional sommeliers.",@"DELIVER\n\nYour selected wines on-demand, at the perfect temperature, directly from the cellar to wherever you choose.",@"JOIN AS A MEMBER\n\nSign up to own your share of the private cellar. Get your wine on-demand for no extra charge, including after-hours.", nil];
        [self addMemberView];
        
        [self addUserMenuView];
        
        [self addCreditsView];
        
        [self addMembershipView];
        
        //ADD SIGN UP VIEW
         [self addMenuView];
        
        [self addSignUpView];
        
       
    
        
    }
    return self;
}

-(void)openCloseUserForce{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2f];
    self.alpha = 0.0f;
    [UIView commitAnimations];

    [myDelegate openCloseUser];
}

-(void)checkForAutoUserLogIn{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"username"] && [defaults objectForKey:@"password"]){
        //USER EXISTS
        userFound = false;
        NSLog(@"USER EXISTS");
        
        //SET LOGIN DEFAULTS
        logInTable.email = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        forgotTable.email = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        logInTable.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
        
        //LOGIN
        [self loginUser];
        
        
    }
    else{
        //DO NOTHING ------> FROM TUTORIAL SHOW SIGN UP SCREEN...
        
        //animate welcome text
        [NSTimer scheduledTimerWithTimeInterval:3.75
                                         target:self
                                       selector:@selector(showTutNextText)
                                       userInfo:nil
                                        repeats:YES];
        
    }
    
}

int welcomeTxtCount = 0;

-(void)showTutNextText{
    welcomeTxtCount++;
    if ([welcomeTxtArr count] > welcomeTxtCount) {
        welcomeTxt.text = [welcomeTxtArr objectAtIndex:welcomeTxtCount];
    }
    else{
        welcomeTxtCount = 0;
         welcomeTxt.text = [welcomeTxtArr objectAtIndex:welcomeTxtCount];
    }
}

-(BOOL)isUserLoggedIn{
    return userLoggedIn;
}

-(void)addSignUpView{
    
    signUpView = [[UIView alloc]initWithFrame:CGRectMake(0,0,memberView.bounds.size.width,memberView.bounds.size.height)];
    signUpView.alpha = 1.0f;
    signUpView.backgroundColor = [UIColor whiteColor];
    signUpView.layer.cornerRadius = 5;
    signUpView.layer.masksToBounds = YES;
    signUpView.userInteractionEnabled = TRUE;
    [memberView addSubview:signUpView];
    
    
    /*/CREATE WELCOME SCREEN
    UIView *welcomeView = [[UIView alloc]initWithFrame:CGRectMake(0,0,memberView.bounds.size.width,memberView.bounds.size.height)];
    welcomeView.alpha = 1.0f;
    welcomeView.backgroundColor = [UIColor whiteColor];
    welcomeView.userInteractionEnabled = TRUE;
    welcomeView.layer.cornerRadius = 5;
    welcomeView.layer.masksToBounds = YES;
   [memberView addSubview:welcomeView];
     */
    
    //WELCOME LOGO
   UIImageView *logoMini = [[UIImageView alloc] init];
    logoMini.frame = CGRectMake(signUpView.bounds.size.width*0.4,signUpView.bounds.size.height*0.1,signUpView.bounds.size.width*0.2,signUpView.bounds.size.height*0.225);
    logoMini.contentMode = UIViewContentModeScaleAspectFit;
    logoMini.image = [UIImage imageNamed:@"logoMini.png"];
    logoMini.userInteractionEnabled = false;
    logoMini.backgroundColor = [UIColor clearColor];
    [signUpView addSubview:logoMini];

    
    //WELCOME TEXT
    welcomeTxt=[[UITextView alloc] initWithFrame:CGRectMake(signUpView.bounds.size.width*0.15, signUpView.bounds.size.height*0.33, signUpView.bounds.size.width*0.7, signUpView.bounds.size.height*0.43)];
    welcomeTxt.backgroundColor = [UIColor clearColor];
    welcomeTxt.textAlignment = NSTextAlignmentCenter;
    welcomeTxt.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:(welcomeTxt.bounds.size.height*0.14)];
    welcomeTxt.alpha = 1.0f;
    welcomeTxt.userInteractionEnabled = FALSE;
    welcomeTxt.text = [welcomeTxtArr objectAtIndex:0 ];
    [signUpView addSubview:welcomeTxt];
    
  
    //LOGIN BUTTON
    loginButM = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButM.frame = CGRectMake(signUpView.bounds.size.width*0.15,signUpView.bounds.size.height*0.8,signUpView.bounds.size.width*0.35,signUpView.bounds.size.height*0.125);
    loginButM.backgroundColor = [UIColor clearColor];
    [loginButM setTitle:@"Log In" forState:UIControlStateNormal];
    
    [loginButM setTitleColor:[UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    loginButM.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:(loginButM.bounds.size.height*0.6)];
    [loginButM addTarget:self action:@selector(showLogInForm) forControlEvents:UIControlEventTouchUpInside];
    loginButM.alpha = 1;
    [signUpView addSubview:loginButM];
    
    //SIGN UP BUTTON
    signUpButM = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpButM.frame = CGRectMake(signUpView.bounds.size.width*0.5,signUpView.bounds.size.height*0.8,signUpView.bounds.size.width*0.35,signUpView.bounds.size.height*0.125);
    //signUpButM.backgroundColor = [UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f];
    signUpButM.backgroundColor = [UIColor whiteColor];
    [signUpButM setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [signUpButM setTitleColor:[UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
   // [signUpButM setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signUpButM.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(signUpButM.bounds.size.height*0.65)];
    [signUpButM addTarget:self action:@selector(showSignUpForm) forControlEvents:UIControlEventTouchUpInside];
    signUpButM.alpha = 1;
    [signUpView addSubview:signUpButM];
    
    
    
    /*/ADD MEMBER REFERENCE
    UILabel *memberRef = [[UILabel alloc] initWithFrame:CGRectMake(memberView.bounds.size.width*0.075, memberView.bounds.size.height*0.05 ,memberView.bounds.size.width*0.85, memberView.bounds.size.height*0.15)];
    memberRef.textAlignment =  NSTextAlignmentCenter;
    memberRef.backgroundColor = [UIColor clearColor];
    memberRef.textColor = [UIColor blackColor];
    memberRef.font = [UIFont systemFontOfSize:(memberRef.bounds.size.height*0.8)];
    memberRef.userInteractionEnabled = TRUE;
    [memberRef setText:@"Sign Up"];
    [signUpView addSubview:memberRef];
    */
    
    
    
    signUpTable = [[FormTableController alloc ]initWithStyle: UITableViewStyleGrouped];
    signUpTable.myDelegate = self;
    signUpTable.view.alpha = 0.0f;
    signUpTable.view.backgroundColor = [UIColor whiteColor];
    signUpTable.view.frame = CGRectMake(DISPLAYRECT);
    signUpTable.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //signUpTable.tableView.backgroundColor = [UIColor clearColor];
    //[self insertSubview:signUpTable.view atIndex:0];
    signUpTable.view.frame = self.bounds;
    [self addSubview:signUpTable.view];
    
    
    
    //[self insertSubview:goToCollection atIndex:0];
    //[self insertSubview:deckBut atIndex:0];
    
    
    
    logInTable = [[FormTableControllerLogIn alloc ]initWithStyle: UITableViewStyleGrouped];
    logInTable.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    logInTable.myDelegate = self;
    logInTable.view.alpha = 0.0f;
    logInTable.view.frame = CGRectMake(0,0,signUpView.bounds.size.width,signUpView.bounds.size.height);
    logInTable.tableView.contentInset = UIEdgeInsetsMake(logInTable.tableView.bounds.size.height*0.1, 0, 0, 0);
    logInTable.view.backgroundColor = [UIColor whiteColor];
    [signUpView addSubview:logInTable.view];
    
    //FORGOT PASSWORD FORM
    forgotTable = [[FormTableControllerForgot alloc ]initWithStyle: UITableViewStyleGrouped];
    forgotTable.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    forgotTable.myDelegate = self;
    forgotTable.view.alpha = 0.0f;
    forgotTable.view.frame = CGRectMake(0,0,signUpView.bounds.size.width,signUpView.bounds.size.height);
    forgotTable.tableView.contentInset = UIEdgeInsetsMake(logInTable.tableView.bounds.size.height*0.1, 0, 0, 0);
    forgotTable.view.backgroundColor = [UIColor whiteColor];
    [signUpView addSubview:forgotTable.view];
    
    
}

-(void)addMenuView{
    menuView = [[UIView alloc]initWithFrame:CGRectMake(0,0,memberView.bounds.size.width,memberView.bounds.size.height)];
    menuView.alpha = 0.0f;
    menuView.backgroundColor = [UIColor whiteColor];
    menuView.layer.cornerRadius = 5;
    menuView.layer.masksToBounds = YES;
    menuView.userInteractionEnabled = TRUE;
    [self insertSubview:menuView atIndex:0];
    
    //ADD GO HOME BUT
    //SIGN UP BUTTON
    goToCollection = [UIButton buttonWithType:UIButtonTypeCustom];
    goToCollection.frame = CGRectMake(self.bounds.size.width*0.05,self.bounds.size.height*0.9,self.bounds.size.width*0.9,self.bounds.size.height*0.1);
    goToCollection.backgroundColor = [UIColor clearColor];
    [goToCollection setTitle:@"Show Membership Card" forState:UIControlStateNormal];
    [goToCollection setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goToCollection.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(goToCollection.bounds.size.height*0.25)];
    [goToCollection addTarget:myDelegate action:@selector(openCloseUser) forControlEvents:UIControlEventTouchUpInside];
    goToCollection.alpha = 1;
    [menuView addSubview:goToCollection];
    
    //DECK BUTS
    UIButton *deckBut = [UIButton buttonWithType:UIButtonTypeCustom];
    deckBut.frame = CGRectMake(self.bounds.size.width*0.05, self.bounds.size.height*0.01  ,self.bounds.size.width*0.155, self.bounds.size.height*0.06);
    [deckBut setBackgroundImage:[[UIImage imageNamed:@"filterBut.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [deckBut addTarget:myDelegate action:@selector(openCloseUser) forControlEvents:UIControlEventTouchUpInside];
    deckBut.alpha = 1;
    deckBut.center = CGPointMake(goToCollection.center.x, goToCollection.center.y-deckBut.bounds.size.height);
    [menuView addSubview:deckBut];
    
}


-(void)showSignUpForm{
    NSLog(@"SHOW SIGN UP");
    
    //welcomeTxt.text = [welcomeTxtArr objectAtIndex:1 ];

    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    signUpTable.view.alpha = 1.0f;
    signUpButM.alpha = 0.0f;
    loginButM.alpha = 0.0f;
    [UIView commitAnimations];
    
}



-(void)signUp{
    NSLog(@"SIGN UP");
    [signUpTable removeAllTextFields];
    [logInTable removeAllTextFields];
    
    //VALIDATE FORM
    
    //POST DATA
    [self signUpUser];
    
}
-(void)showLogInForm{
    NSLog(@"SHOW LOG IN FORM");
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    logInTable.view.alpha = 1.0f;
    signUpButM.alpha = 0.0f;
    loginButM.alpha = 0.0f;
    [UIView commitAnimations];

    
}

-(void)closeForms{
   // welcomeTxt.text = [welcomeTxtArr objectAtIndex:0 ];
    
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    forgotTable.view.alpha = 0.0f;
    logInTable.view.alpha = 0.0f;
    signUpTable.view.alpha = 0.0f;
    signUpButM.alpha = 1.0f;
    loginButM.alpha = 1.0f;
    [UIView commitAnimations];
    
    [signUpTable removeAllTextFields];
    [logInTable removeAllTextFields];
    [forgotTable removeAllTextFields];
    
}

-(void)loginFromForm{
    NSLog(@"LOG IN FROM FORM");
    
    [signUpTable removeAllTextFields];
    [logInTable removeAllTextFields];
    
    //VALIDATE FORM
    
    //POST DATA
    [self loginUser];
    
}

-(void)forgotPassword{
    NSLog(@"FORGOT PASSWORD");
    //SEND FORGOT PASSWORD REQUEST
    [self sendOTP];
    
   // [signUpTable removeAllTextFields];
    [logInTable removeAllTextFields];
    forgotTable.email = logInTable.email;
    [forgotTable setEmailField:logInTable.email];
    //SHOW LOADING...
    
    
}

-(void)forceKeyboardClose{
    NSLog(@"FORCE KEYBOARD CLOSE");
    [signUpTable removeAllTextFields];
}

-(void)addMemberView{
    //ADD MEMBER INFO
    memberView = [[UIView alloc]initWithFrame:CGRectMake(CARDRECT)];
    memberView.center = CGPointMake(self.center.x, CARDSTART);
    memberView.backgroundColor = [UIColor whiteColor];
    memberView.layer.cornerRadius = 5;
    memberView.userInteractionEnabled = YES;
    memberView.layer.masksToBounds = NO;
    memberView.layer.shadowColor = [UIColor blackColor].CGColor;
    memberView.layer.shadowOffset = CGSizeMake(0, 0);
    memberView.layer.shadowOpacity = 0.75f;
    memberView.layer.shadowRadius = SHADOWRADIUS;
    
    //MEMBER VIEW CLOSE KEYBOARD IN SIGN UP
   // UITapGestureRecognizer *tapped22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forceKeyboardClose)];
    //tapped22.numberOfTapsRequired = 1;
    //[memberView addGestureRecognizer:tapped22];
    
    //CARD TITLE
    UILabel *memberTit = [[UILabel alloc] initWithFrame:CGRectMake(0, memberView.bounds.size.height*0.1 ,memberView.bounds.size.width, memberView.bounds.size.height*0.08)];
    memberTit.textAlignment =  NSTextAlignmentCenter;
    memberTit.backgroundColor = [UIColor clearColor];
    memberTit.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    memberTit.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(memberTit.bounds.size.height*0.8)];
    memberTit.userInteractionEnabled = TRUE;
    [memberTit setText:@"MEMBERSHIP CARD"];
    [memberView addSubview:memberTit];
    
   
    
    //ADD MEMBER VINOS -refCode
    refCode = [[UILabel alloc] initWithFrame:CGRectMake(0, memberView.bounds.size.height*0.62 ,memberView.bounds.size.width, memberView.bounds.size.height*0.06)];
    refCode.textAlignment =  NSTextAlignmentCenter;
    refCode.backgroundColor = [UIColor clearColor];
    refCode.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    refCode.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(refCode.bounds.size.height*0.8)];
    refCode.userInteractionEnabled = TRUE;
    [refCode setText:@""];
    [memberView addSubview:refCode];
    
    //MEMEBER TITLE
    memberTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, memberView.bounds.size.height*0.72 ,memberView.bounds.size.width, memberView.bounds.size.height*0.12)];
    memberTitle.textAlignment =  NSTextAlignmentCenter;
    memberTitle.backgroundColor = [UIColor clearColor];
    memberTitle.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    memberTitle.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(memberTitle.bounds.size.height*0.8)];
    memberTitle.userInteractionEnabled = TRUE;
    [memberTitle setText:@""];
    [memberView addSubview:memberTitle];
    
   
    
    
    //ADD MEMBER REFERENCE
    UILabel *memberRef = [[UILabel alloc] initWithFrame:CGRectMake(memberView.bounds.size.width*0.075, memberView.bounds.size.height*0.85 ,memberView.bounds.size.width*0.85, memberView.bounds.size.height*0.06)];
    memberRef.textAlignment =  NSTextAlignmentCenter;
    memberRef.backgroundColor = [UIColor clearColor];
    memberRef.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    memberRef.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(memberRef.bounds.size.height*0.8)];
    memberRef.userInteractionEnabled = TRUE;
    [memberRef setText:@"Member of the Private Cellar"];
    //[memberView addSubview:memberRef];
    
    //ADD MEMBERSHIP VIEW BUTTON
    UIButton *membershipViewBut = [UIButton buttonWithType:UIButtonTypeCustom];
    membershipViewBut.frame = CGRectMake(memberView.bounds.size.width*0.025, memberView.bounds.size.height*0.8 , memberView.bounds.size.width*0.95, memberView.bounds.size.height*0.2);
    membershipViewBut.tag = 1;
    [membershipViewBut setTitle:@"UPGRADE MEMBERSHIP" forState:UIControlStateNormal];
    [membershipViewBut setTitleColor:[UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    membershipViewBut.font = [UIFont systemFontOfSize:(membershipViewBut.bounds.size.height*0.3)];
    [membershipViewBut addTarget:self action:@selector(openUserMembership) forControlEvents:UIControlEventTouchUpInside];
    [memberView addSubview:membershipViewBut];
    
   //ADD INFO BUTTONS ON MEMBER VIEW
    //ADD SETTINGS BUTTON
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.frame = CGRectMake(memberView.bounds.size.width*0.025, memberView.bounds.size.height*0.025 , memberView.bounds.size.width*0.1, memberView.bounds.size.width*0.1);
    settingsButton.tag = 55;
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"infoBut.png"]  forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(openCloseMenu:) forControlEvents:UIControlEventTouchUpInside];
    [memberView addSubview:settingsButton];
    
   

    
    //ADD HIGHIGHT VIEW
    highlightView = [[UIView alloc]initWithFrame:memberView.bounds];
    highlightView.alpha = 0;
    highlightView.backgroundColor = [UIColor whiteColor];
    highlightView.layer.cornerRadius = 5;
    highlightView.layer.masksToBounds = NO;
    [memberView addSubview:highlightView];
    
    
    
    
    //ADD CREDIT BUTTON
    UIButton *infoCreditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    infoCreditButton.frame = CGRectMake(contactInfoView.bounds.size.width - contactInfoView.bounds.size.width*0.125, contactInfoView.bounds.size.width*0.025 , contactInfoView.bounds.size.width*0.095, contactInfoView.bounds.size.width*0.095);
    infoCreditButton.tag = 1;
    [infoCreditButton setBackgroundImage:[UIImage imageNamed:@"vinosBut.png"]  forState:UIControlStateNormal];
    [infoCreditButton addTarget:self action:@selector(openUserBuy) forControlEvents:UIControlEventTouchUpInside];
    [memberView addSubview:infoCreditButton];
    
    
    
    
    
    
    //FLIP CARD OPEN
    //UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipOpenCard)];
    //tapped.numberOfTapsRequired = 1;
    //[memberView addGestureRecognizer:tapped];
    
    [self addSubview:memberView];
    
    
    

}

-(void)updateUserStats{
    NSLog(@"UPDATE USER STATS");
    
    //TITLE
    [memberTitle setText:[NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"first_name"],[[NSUserDefaults standardUserDefaults] stringForKey:@"last_name"]]];
    
    //CREDITS
    [refCode setText:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"email"]]];
    
    //BUY BALANCE
    [ self.myDelegate performSelector: @selector( updateUserMainStats ) ];
    
    //CREATE QR CODE
    if(!QRcodeImg){
    QRcodeImg = [[UIImageView alloc]initWithImage:[self quickResponseImageForString:[[NSUserDefaults standardUserDefaults] stringForKey:@"email"] withDimension:memberView.bounds.size.height*0.4]];
    //QRcodeImg.frame = CGRectMake(0, 0, memberView.bounds.size.height*0.4, memberView.bounds.size.height*0.4);
    QRcodeImg.center = CGPointMake(memberView.bounds.size.width*0.5, memberView.bounds.size.height*0.4);
    QRcodeImg.backgroundColor = [UIColor whiteColor];
        QRcodeImg.tag = 1;
        QRcodeImg.userInteractionEnabled = TRUE;
    [memberView insertSubview:QRcodeImg atIndex:0];
    
    /*/ADD FULLSCREEN CARD TAP
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCloseCardDisplay)];
    tapped.numberOfTapsRequired = 1;
    [QRcodeImg addGestureRecognizer:tapped];
      */
     }
        //SET CARD BK
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        
        NSLog(@"WHAT THE FUCK2 %@",[defaults objectForKey:@"membership_type"]);
        
        if ([[[defaults objectForKey:@"membership_type"] uppercaseString] isEqualToString:@"BASIC"]) {
           deliveryHistoryView.backgroundColor = creditHistoryView.backgroundColor = creditInfoView.backgroundColor = membershipInfoView.backgroundColor = contactInfoView.backgroundColor = userMenuView.backgroundColor = membershipView.backgroundColor = buttonsView.backgroundColor = memberView.backgroundColor = [UIColor whiteColor];
            NSLog(@"BASIC MEM_TYPEE");
        }
        else if ([[[defaults objectForKey:@"membership_type"] uppercaseString] isEqualToString:@"SILVER"]){
             deliveryHistoryView.backgroundColor = creditHistoryView.backgroundColor = creditInfoView.backgroundColor = membershipInfoView.backgroundColor = contactInfoView.backgroundColor = userMenuView.backgroundColor = membershipView.backgroundColor = buttonsView.backgroundColor = memberView.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:223.0f/255.0f blue: 223.0f/255.0f alpha:1.0f];
            NSLog(@"SILVER MEM_TYPEE");
            
        }
        else if ([[[defaults objectForKey:@"membership_type"] uppercaseString] isEqualToString:@"GOLD"]){
             deliveryHistoryView.backgroundColor = creditHistoryView.backgroundColor = creditInfoView.backgroundColor = membershipInfoView.backgroundColor = contactInfoView.backgroundColor = userMenuView.backgroundColor = membershipView.backgroundColor = buttonsView.backgroundColor = memberView.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:176.0f/255.0f blue: 91.0f/255.0f alpha:1.0f];
            NSLog(@"GOLD MEM_TYPEE");
            
        }
        else if ([[[defaults objectForKey:@"membership_type"] uppercaseString] isEqualToString:@"PLATINUM"]){
             deliveryHistoryView.backgroundColor = creditHistoryView.backgroundColor = creditInfoView.backgroundColor = membershipInfoView.backgroundColor = contactInfoView.backgroundColor = userMenuView.backgroundColor = membershipView.backgroundColor = buttonsView.backgroundColor = memberView.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:212.0f/255.0f blue: 212.0f/255.0f alpha:1.0f];
            NSLog(@"PLATINUM MEM_TYPEE");
            
        }
        else{
            NSLog(@"WHAT THE FUCK %@ %@",[defaults objectForKey:@"membership_type"],[[defaults objectForKey:@"membership_type"] uppercaseString]);
        }
        
    
    
}


//TAP GESTURE TO PREVIEW QR CODE FULLSCREEN - FUTURE USE
-(void)openCloseCardDisplay{
    if(QRcodeImg.tag == 0){
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.25f];
        //
        highlightView.alpha = 0.0f;
       memberView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        memberView.frame = CGRectMake(CARDRECT);
        [UIView commitAnimations];
        
        QRcodeImg.tag = 1;
    }else{
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.25f];
         highlightView.alpha = 1.0f;
        memberView.transform = CGAffineTransformMakeScale(3.2f, 3.2f);
        memberView.center = CGPointMake(self.center.x, self.center.y-self.bounds.size.height*0.15);
        [UIView commitAnimations];
        QRcodeImg.tag = 0;
    }
}


-(void)addUserMenuView{
    //USER BUTTONS VIEW
    userMenuView = [[UIView alloc]initWithFrame:CGRectMake(CARDRECT)];
    userMenuView.alpha = 0.0f;
    userMenuView.backgroundColor = [UIColor whiteColor];
    userMenuView.layer.cornerRadius = 5;
    userMenuView.layer.masksToBounds = YES;
    
    //BUY CREDITS BUTTON
    UIButton *userBut1 = [UIButton buttonWithType:UIButtonTypeCustom];
    userBut1.frame = CGRectMake(userMenuView.bounds.size.width*0.1, userMenuView.bounds.size.height*0.1 , userMenuView.bounds.size.width*0.8, userMenuView.bounds.size.height*0.15);
    userBut1.backgroundColor = [UIColor clearColor];
    [userBut1 setTitle:@"DELIVERIES" forState:UIControlStateNormal];
    [userBut1 setTitleColor:[UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    userBut1.font = [UIFont systemFontOfSize:(userBut1.bounds.size.height*0.5)];
    userBut1.tag = 1;
    [userBut1 addTarget:self action:@selector(userButtonsH:) forControlEvents:UIControlEventTouchUpInside];
    userBut1.alpha = 1;
    [userMenuView addSubview:userBut1];
    [userButs addObject:userBut1];
    
    //RECENT DELIVERIES BUTTON
    UIButton *userBut2 = [UIButton buttonWithType:UIButtonTypeCustom];
    userBut2.frame = CGRectMake(userMenuView.bounds.size.width*0.1, userMenuView.bounds.size.height*0.3 , userMenuView.bounds.size.width*0.8, userMenuView.bounds.size.height*0.15);
    userBut2.backgroundColor = [UIColor clearColor];
    [userBut2 setTitle:@"PAYMENTS" forState:UIControlStateNormal];
    [userBut2 setTitleColor:[UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    userBut2.font = [UIFont systemFontOfSize:(userBut2.bounds.size.height*0.5)];
    userBut2.tag = 2;
    [userBut2 addTarget:self action:@selector(userButtonsH:) forControlEvents:UIControlEventTouchUpInside];
    userBut2.alpha = 1;
    [userMenuView addSubview:userBut2];
    [userButs addObject:userBut2];
    
    //VINOS BUTTON
    UIButton *userBut3 = [UIButton buttonWithType:UIButtonTypeCustom];
    userBut3.frame = CGRectMake(userMenuView.bounds.size.width*0.1, userMenuView.bounds.size.height*0.5 , userMenuView.bounds.size.width*0.8, userMenuView.bounds.size.height*0.15);
    userBut3.backgroundColor = [UIColor clearColor];
    [userBut3 setTitle:@"LOG OUT" forState:UIControlStateNormal];
    [userBut3 setTitleColor:[UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    userBut3.font = [UIFont systemFontOfSize:(userBut3.bounds.size.height*0.5)];
    userBut3.tag = 3;
    [userBut3 addTarget:self action:@selector(userButtonsH:) forControlEvents:UIControlEventTouchUpInside];
    userBut3.alpha = 1;
    [userMenuView addSubview:userBut3];
    [userButs addObject:userBut3];
    
    //MESSAGES BUTTON
    UIButton *userBut4 = [UIButton buttonWithType:UIButtonTypeCustom];
    userBut4.frame = CGRectMake(userMenuView.bounds.size.width*0.1, userMenuView.bounds.size.height*0.7 , userMenuView.bounds.size.width*0.8, userMenuView.bounds.size.height*0.15);
    userBut4.backgroundColor = [UIColor clearColor];
    [userBut4 setTitle:@"BACK" forState:UIControlStateNormal];
    [userBut4 setTitleColor:[UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    userBut4.font = [UIFont boldSystemFontOfSize:(userBut4.bounds.size.height*0.5)];
    userBut4.tag = 0;
    [userBut4 addTarget:self action:@selector(userButtonsH:) forControlEvents:UIControlEventTouchUpInside];
    userBut4.alpha = 1;
    [userMenuView addSubview:userBut4];
    [userButs addObject:userBut4];
    
    
    ///////////
    //ADD CREDIT INFO
    ///////////
    
    contactInfoView = [[UIView alloc] initWithFrame:CGRectMake(CARDRECT)];
    contactInfoView.backgroundColor = [UIColor whiteColor];
    contactInfoView.alpha = 0.0f;
    contactInfoView.layer.cornerRadius = 5;
    contactInfoView.userInteractionEnabled = YES;
    [userMenuView addSubview:contactInfoView];
    
    //CREDIT TITLE
    UILabel *creditTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, contactInfoView.bounds.size.height*0.1 ,contactInfoView.bounds.size.width, contactInfoView.bounds.size.height*0.08)];
    creditTopLabel.textAlignment =  NSTextAlignmentCenter;
    creditTopLabel.backgroundColor = [UIColor clearColor];
    creditTopLabel.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    creditTopLabel.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(creditTopLabel.bounds.size.height*0.8)];
    creditTopLabel.userInteractionEnabled = FALSE;
    [creditTopLabel setText:@"HOW MAY WE HELP YOU?"];
    [contactInfoView addSubview:creditTopLabel];
    
    
    
    //CREDIT DESCRIPTION
    UITextView *creditDes=[[UITextView alloc] initWithFrame:CGRectMake(contactInfoView.bounds.size.width*0.1, contactInfoView.bounds.size.height*0.2, contactInfoView.bounds.size.width*0.8, contactInfoView.bounds.size.height*0.6)];
    creditDes.backgroundColor = [UIColor clearColor];
    creditDes.textAlignment = NSTextAlignmentCenter;
    creditDes.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:(creditDes.bounds.size.height*0.11)];
    creditDes.alpha = 1.0f;
    creditDes.userInteractionEnabled = FALSE;
    creditDes.text = @"Please email, send a text or call us for immediate assistance during the cellar operating hours (12:00 - 22:00 daily).\n\nVisit myvinos.club/about for more information.\n\nIn Vinos Veritas!";
    [contactInfoView addSubview:creditDes];
    
    
    //CALL
    UILabel *callBut = [[UILabel alloc] initWithFrame:CGRectMake(contactInfoView.bounds.size.width*0.05, contactInfoView.bounds.size.height*0.85 ,contactInfoView.bounds.size.width*0.5, contactInfoView.bounds.size.height*0.08)];
    callBut.textAlignment =  NSTextAlignmentLeft;
    callBut.backgroundColor = [UIColor clearColor];
    callBut.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    callBut.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(callBut.bounds.size.height*0.8)];
    callBut.userInteractionEnabled = TRUE;
    [callBut setText:@"+27 (78) 7860307"];
    [contactInfoView addSubview:callBut];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeCall)];
    tapped.numberOfTapsRequired = 1;
    [callBut addGestureRecognizer:tapped];
    
    //MAIL
    UILabel *mailbut = [[UILabel alloc] initWithFrame:CGRectMake(contactInfoView.bounds.size.width*0.50, contactInfoView.bounds.size.height*0.85 ,contactInfoView.bounds.size.width*0.45, contactInfoView.bounds.size.height*0.08)];
    mailbut.textAlignment =  NSTextAlignmentRight;
    mailbut.backgroundColor = [UIColor clearColor];
    mailbut.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    mailbut.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(mailbut.bounds.size.height*0.8)];
    mailbut.userInteractionEnabled = TRUE;
    [mailbut setText:@"SUPPORT@myvinos.club"];
    [contactInfoView addSubview:mailbut];
    
    UITapGestureRecognizer *tapped2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeMail)];
    tapped2.numberOfTapsRequired = 1;
    [mailbut addGestureRecognizer:tapped2];
    

    
    
    //ADD CONTACT INFO BUTTON
    infoBut = [UIButton buttonWithType:UIButtonTypeCustom];
    infoBut.frame = CGRectMake(contactInfoView.bounds.size.width*0.025, contactInfoView.bounds.size.width*0.025 , contactInfoView.bounds.size.width*0.1, contactInfoView.bounds.size.width*0.1);
    infoBut.tag = 1;
    [infoBut setBackgroundImage:[UIImage imageNamed:@"infoBut.png"]  forState:UIControlStateNormal];
    [infoBut addTarget:self action:@selector(openCloseContact:) forControlEvents:UIControlEventTouchUpInside];
    [userMenuView addSubview:infoBut];
    
    
    //ADD CREDIT HISTORY
    creditHistoryView = [[UIScrollView alloc] initWithFrame:userMenuView.frame];
    creditHistoryView.delegate = self;
    creditHistoryView.backgroundColor = [UIColor whiteColor];
    creditHistoryView.alpha = 0.0f;
    creditHistoryView.clipsToBounds = TRUE;
    creditHistoryView.layer.cornerRadius = 5;
    [userMenuView addSubview:creditHistoryView];
    
    //ADD CREDIT HISTORY
    deliveryHistoryView = [[UIScrollView alloc] initWithFrame:userMenuView.frame];
    deliveryHistoryView.delegate = self;
    deliveryHistoryView.backgroundColor = [UIColor whiteColor];
    deliveryHistoryView.alpha = 0.0f;
    deliveryHistoryView.clipsToBounds = TRUE;
    deliveryHistoryView.layer.cornerRadius = 5;
    [userMenuView addSubview:deliveryHistoryView];

    //ADD CLOSE BUTTON
    menuCloseBut = [UIButton buttonWithType:UIButtonTypeCustom];
    menuCloseBut.frame = CGRectMake(contactInfoView.bounds.size.width*0.025, contactInfoView.bounds.size.height*0.025 , contactInfoView.bounds.size.width*0.095, contactInfoView.bounds.size.width*0.095);
    menuCloseBut.tag = 65;
    menuCloseBut.alpha = 0;
    [menuCloseBut setBackgroundImage:[UIImage imageNamed:@"closeBut.png"]  forState:UIControlStateNormal];
    [menuCloseBut addTarget:self action:@selector(userButtonsH:) forControlEvents:UIControlEventTouchUpInside];
    [userMenuView addSubview:menuCloseBut];
    
    [memberView addSubview:userMenuView];
    

}

-(void)addMembershipView
{
    NSLog(@"BUILD MEMBERSHIP VIEW");
    
    //MEMEEBRSHIP TO GET
    membershipToGet = [[NSString alloc] init];
    
    //ADD MEMBERSHIP VIEW
    membershipView = [[UIView alloc]initWithFrame:CGRectMake(CARDRECT)];
    membershipView.alpha = 0.0f;
    membershipView.backgroundColor = [UIColor whiteColor];
    
    //ADD TOP LABEL
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, memberView.bounds.size.height*0.1 ,memberView.bounds.size.width, memberView.bounds.size.height*0.08)];
    topLabel.textAlignment =  NSTextAlignmentCenter;
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    topLabel.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(topLabel.bounds.size.height*0.8)];
    topLabel.userInteractionEnabled = FALSE;
    [topLabel setText:@"SELECT YOUR MEMBERSHIP"];
    [membershipView addSubview:topLabel];
    
    //ADD TOTAL LABEL
    membershipViewText = [[UILabel alloc] initWithFrame:CGRectMake(membershipView.bounds.size.width*0.0, membershipView.bounds.size.height*0.6 ,membershipView.bounds.size.width, membershipView.bounds.size.height*0.1)];
    membershipViewText.textAlignment =  NSTextAlignmentCenter;
    membershipViewText.backgroundColor = [UIColor clearColor];
    membershipViewText.textColor = [UIColor blackColor];
    membershipViewText.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(membershipViewText.bounds.size.height*0.8)];
    membershipViewText.userInteractionEnabled = FALSE;
    [membershipViewText setText:@"CHANGE YOUR MEMBERSHIP"];
    [membershipView addSubview:membershipViewText];
    
    //ADD SUMMMERY LABEL
    membershipViewTextSummary = [[UILabel alloc] initWithFrame:CGRectMake(0, membershipView.bounds.size.height*0.7 ,membershipView.bounds.size.width, membershipView.bounds.size.height*0.08)];
    membershipViewTextSummary.textAlignment =  NSTextAlignmentCenter;
    membershipViewTextSummary.backgroundColor = [UIColor clearColor];
    membershipViewTextSummary.textColor = [UIColor blackColor];
    membershipViewTextSummary.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(membershipViewTextSummary.bounds.size.height*0.8)];
    membershipViewTextSummary.userInteractionEnabled = FALSE;
    [membershipViewTextSummary setText:[NSString stringWithFormat:@"(You will be charged in ZAR)"]];
    [membershipView addSubview:membershipViewTextSummary];
    
    
    //ADD MEMBERSHIP BUTTONS
    UIButton *selectButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton1.frame = CGRectMake(membershipView.bounds.size.width*0.05, membershipView.bounds.size.height*0.22 , membershipView.bounds.size.width*0.225, membershipView.bounds.size.width*0.225);
    [[selectButton1 imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [selectButton1 setBackgroundImage:[UIImage imageNamed:@"memButBASIC.png"]  forState:UIControlStateNormal];
    selectButton1.tag = 1;
    selectButton1.alpha = 0.85f;
    [selectButton1 addTarget:self action:@selector(butMembershipSelected:) forControlEvents:UIControlEventTouchUpInside];
    //selectButton1.contentMode = UIViewContentModeScaleAspectFit;
    [membershipView addSubview:selectButton1];
    [membershipButs addObject:selectButton1];
    
    UIButton *selectButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton2.frame = CGRectMake(membershipView.bounds.size.width*0.275, membershipView.bounds.size.height*0.22 , membershipView.bounds.size.width*0.225, membershipView.bounds.size.width*0.225);
    [[selectButton2 imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [selectButton2 setBackgroundImage:[UIImage imageNamed:@"memButSILVER.png"]  forState:UIControlStateNormal];
    selectButton2.tag = 2;
    selectButton2.alpha = 0.85f;
    [selectButton2 addTarget:self action:@selector(butMembershipSelected:) forControlEvents:UIControlEventTouchUpInside];
    //selectButton2.contentMode = UIViewContentModeScaleAspectFit;
    [membershipView addSubview:selectButton2];
    [membershipButs addObject:selectButton2];
    
    UIButton *selectButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton3.frame = CGRectMake(membershipView.bounds.size.width*0.5, membershipView.bounds.size.height*0.22 , membershipView.bounds.size.width*0.225, membershipView.bounds.size.width*0.225);
    [[selectButton3 imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [selectButton3 setBackgroundImage:[UIImage imageNamed:@"memButGOLD.png"]  forState:UIControlStateNormal];
    selectButton3.tag = 3;
    selectButton3.alpha = 0.85f;
    [selectButton3 addTarget:self action:@selector(butMembershipSelected:) forControlEvents:UIControlEventTouchUpInside];
    //selectButton3.contentMode = UIViewContentModeScaleAspectFit;
    [membershipView addSubview:selectButton3];
    [membershipButs addObject:selectButton3];
    
    UIButton *selectButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton4.frame = CGRectMake(membershipView.bounds.size.width*0.725, membershipView.bounds.size.height*0.22 , membershipView.bounds.size.width*0.225, membershipView.bounds.size.width*0.225);
    [[selectButton4 imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [selectButton4 setBackgroundImage:[UIImage imageNamed:@"memButPLATINUM.png"]  forState:UIControlStateNormal];
    selectButton4.tag = 4;
    selectButton4.alpha = 0.85f;
    [selectButton4 addTarget:self action:@selector(butMembershipSelected:) forControlEvents:UIControlEventTouchUpInside];
    //selectButton4.contentMode = UIViewContentModeScaleAspectFit;
    [membershipView addSubview:selectButton4];
    [membershipButs addObject:selectButton4];
    
    //INFO BUTTON
    
    //CANCEL BUTTON
    UIButton *buyMemebrshipCancelIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    buyMemebrshipCancelIcon.frame = CGRectMake(membershipView.bounds.size.width*0.2,membershipView.bounds.size.height*0.8,membershipView.bounds.size.width*0.3,membershipView.bounds.size.height*0.12);
    buyMemebrshipCancelIcon.backgroundColor = [UIColor clearColor];
    [buyMemebrshipCancelIcon setTitle:@"BACK" forState:UIControlStateNormal];
    [buyMemebrshipCancelIcon setTitleColor:[UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    buyMemebrshipCancelIcon.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(buyMemebrshipCancelIcon.bounds.size.height*0.6)];
    [buyMemebrshipCancelIcon addTarget:self action:@selector(cancelMembership) forControlEvents:UIControlEventTouchUpInside];
    buyMemebrshipCancelIcon.alpha = 1;
    buyMemebrshipCancelIcon.tag = 0;
    buyMemebrshipCancelIcon.titleLabel.textAlignment = NSTextAlignmentLeft;
    [membershipView addSubview:buyMemebrshipCancelIcon];
    
    //SIGN UP BUTTON
    UIButton *signUpBut = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpBut.frame = CGRectMake(membershipView.bounds.size.width*0.5,membershipView.bounds.size.height*0.8,membershipView.bounds.size.width*0.3,membershipView.bounds.size.height*0.12);
    signUpBut.backgroundColor = [UIColor clearColor];
    [signUpBut setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [signUpBut setTitleColor:[UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    signUpBut.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(signUpBut.bounds.size.height*0.6)];
    [signUpBut addTarget:self action:@selector(confirmMembership:) forControlEvents:UIControlEventTouchUpInside];
    signUpBut.alpha = 1;
    signUpBut.tag = 0;
    [membershipView addSubview:signUpBut];
    
    
    
    
    
    //ADD CREDIT INFO
    membershipInfoView = [[UIView alloc] initWithFrame:CGRectMake(CARDRECT)];
    membershipInfoView.backgroundColor = [UIColor whiteColor];
    membershipInfoView.alpha = 0.0f;
    membershipInfoView.layer.cornerRadius = 5;
    [membershipView addSubview:membershipInfoView];
    
    //CREDIT TITLE
    UILabel *creditTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, memberView.bounds.size.height*0.1 ,memberView.bounds.size.width, memberView.bounds.size.height*0.08)];
    creditTopLabel.textAlignment =  NSTextAlignmentCenter;
    creditTopLabel.backgroundColor = [UIColor clearColor];
    creditTopLabel.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    creditTopLabel.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(topLabel.bounds.size.height*0.8)];
    creditTopLabel.userInteractionEnabled = FALSE;
    [creditTopLabel setText:@"ABOUT MEMBERSHIPS"];
    [membershipInfoView addSubview:creditTopLabel];
    
    
    //CREDIT DESCRIPTION
    UITextView *creditDes=[[UITextView alloc] initWithFrame:CGRectMake(membershipInfoView.bounds.size.width*0.1, membershipInfoView.bounds.size.height*0.2, membershipInfoView.bounds.size.width*0.8, membershipInfoView.bounds.size.height*0.6)];
    creditDes.backgroundColor = [UIColor clearColor];
    creditDes.textAlignment = NSTextAlignmentCenter;
    creditDes.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:(creditDes.bounds.size.height*0.1)];
    creditDes.alpha = 1.0f;
    creditDes.userInteractionEnabled = FALSE;
    creditDes.text = @"JOIN AS A MEMBER\n\nOwn your share of the private cellar. Get your wine delivered for no extra charge, including after-hours.\n\nYour VINOS will be automatically topped up.";
    [membershipInfoView addSubview:creditDes];
    
    
    //TERMS LINK
    UILabel *termsBut = [[UILabel alloc] initWithFrame:CGRectMake(0, memberView.bounds.size.height*0.85 ,memberView.bounds.size.width, memberView.bounds.size.height*0.08)];
    termsBut.textAlignment =  NSTextAlignmentCenter;
    termsBut.backgroundColor = [UIColor clearColor];
    termsBut.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    termsBut.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(topLabel.bounds.size.height*0.8)];
    termsBut.userInteractionEnabled = TRUE;
    [termsBut setText:@"TERMS AND CONDITIONS"];
    [membershipInfoView addSubview:termsBut];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTermsAndConditions)];
    tapped.numberOfTapsRequired = 1;
    [termsBut addGestureRecognizer:tapped];
    
    
    //ADD HISTORY BUT
    UIButton *historyMembersBut = [UIButton buttonWithType:UIButtonTypeCustom];
    historyMembersBut.frame = CGRectMake(membershipView.bounds.size.width*0.025, membershipView.bounds.size.width*0.025 , membershipView.bounds.size.width*0.1, membershipView.bounds.size.width*0.1);
    historyMembersBut.tag = 1;
    [historyMembersBut setBackgroundImage:[UIImage imageNamed:@"infoBut.png"]  forState:UIControlStateNormal];
    [historyMembersBut addTarget:self action:@selector(openCloseMemberInfoView:) forControlEvents:UIControlEventTouchUpInside];
    [membershipView addSubview:historyMembersBut];
    
    [buttonsView addSubview:membershipView];
    
    
}

-(void)updateMembershipView{
    NSLog(@"UPDATE MEMBERSHIP VIEW");
    
    //UPDATE SUMMARY LABEL
    NSString *sumTxt = [NSString stringWithFormat:@"UPDATE TO %@ MEMBERSHIP",membershipToGet];
    if ([membershipViewText respondsToSelector:@selector(setAttributedText:)])
    {
        // Create the attributes
        const CGFloat fontSize = 10;
        NSDictionary *attrs = @{
                                NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(membershipViewText.bounds.size.height*0.8)],
                                NSForegroundColorAttributeName:[UIColor blackColor]
                                };
        NSDictionary *subAttrs = @{
                                   NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Bold" size:(membershipViewText.bounds.size.height*0.8)]
                                   };
        
        // Range of " 2012/10/14 " is (8,12). Ideally it shouldn't be hardcoded
        // This example is about attributed strings in one label
        // not about internationalization, so we keep it simple :)
        const NSRange range = [sumTxt rangeOfString:[NSString stringWithFormat:@"%@",membershipToGet]];
        //NSMakeRange(2,4);
        
        // Create the attributed string (text + attributes)
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:sumTxt
                                               attributes:attrs];
        [attributedText setAttributes:subAttrs range:range];
        
        // Set it in our UILabel and we are done!
        [membershipViewText setAttributedText:attributedText];
    } else {
        // iOS5 and below
        [membershipViewText setText:sumTxt];
    }
    
    //UPDATE PURCHASE
    [membershipViewTextSummary setText: [NSString stringWithFormat:@"(You will be charged ZAR %i)",membershipToGetAmount]];
    
    //TEMP SET AMOUNT OF CREDITS
    [myDelegate updateTempVinosAmount:membershipToGetAmount];
    
}


-(void)addCreditsView{
    
    //USER BUTTONS VIEW
    buttonsView = [[UIView alloc]initWithFrame:CGRectMake(CARDRECT)];
    buttonsView.alpha = 0.0f;
    buttonsView.backgroundColor = [UIColor whiteColor];
    buttonsView.layer.cornerRadius = 5;
    buttonsView.layer.masksToBounds = NO;
    buttonsView.layer.shadowColor = [UIColor blackColor].CGColor;
    buttonsView.layer.shadowOffset = CGSizeMake(0, 0);
    buttonsView.layer.shadowOpacity = 0.75f;
    buttonsView.layer.shadowRadius = SHADOWRADIUS;
    
    /*/BUY CREDITS VIEW
    buyCredits = [[UIView alloc]initWithFrame:CGRectMake(CARDRECT)];
    buyCredits.alpha = 0.0f;
    buyCredits.backgroundColor = [UIColor whiteColor];
    buyCredits.layer.cornerRadius = 5;
    buyCredits.layer.masksToBounds = YES;
    */
    
    //ADD TOP LABEL
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, memberView.bounds.size.height*0.1 ,memberView.bounds.size.width, memberView.bounds.size.height*0.08)];
    topLabel.textAlignment =  NSTextAlignmentCenter;
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    topLabel.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(topLabel.bounds.size.height*0.8)];
    topLabel.userInteractionEnabled = FALSE;
    [topLabel setText:@"GET MORE VINOS FOR YOUR MEMBERSHIP"];
    [buttonsView addSubview:topLabel];
    
    //ADD TOTAL LABEL
    summeryPurchase = [[UILabel alloc] initWithFrame:CGRectMake(buttonsView.bounds.size.width*0.0, buttonsView.bounds.size.height*0.6 ,buttonsView.bounds.size.width, buttonsView.bounds.size.height*0.1)];
    summeryPurchase.textAlignment =  NSTextAlignmentCenter;
    summeryPurchase.backgroundColor = [UIColor clearColor];
    summeryPurchase.textColor = [UIColor blackColor];
    summeryPurchase.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(summeryPurchase.bounds.size.height*0.8)];
    summeryPurchase.userInteractionEnabled = FALSE;
    [summeryPurchase setText:@"Purchase VINOS"];
    [buttonsView addSubview:summeryPurchase];
    
    //ADD SUMMMERY LABEL
    summeryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonsView.bounds.size.height*0.7 ,buttonsView.bounds.size.width, buttonsView.bounds.size.height*0.08)];
    summeryLabel.textAlignment =  NSTextAlignmentCenter;
    summeryLabel.backgroundColor = [UIColor clearColor];
    summeryLabel.textColor = [UIColor blackColor];
    summeryLabel.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(summeryLabel.bounds.size.height*0.8)];
    summeryLabel.userInteractionEnabled = FALSE;
    [summeryLabel setText:[NSString stringWithFormat:@"(You will be charged ZAR 10 for 1 VINOS)"]];
    [buttonsView addSubview:summeryLabel];
    
    
    //ADD AMOUNT BUTTONS
    UIButton *selectButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton1.frame = CGRectMake(buttonsView.bounds.size.width*0.05, buttonsView.bounds.size.height*0.22 , buttonsView.bounds.size.width*0.225, buttonsView.bounds.size.width*0.225);
    [[selectButton1 imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [selectButton1 setBackgroundImage:[UIImage imageNamed:@"vinosBut10.png"]  forState:UIControlStateNormal];
    selectButton1.tag = 1;
    [selectButton1 addTarget:self action:@selector(butSelected:) forControlEvents:UIControlEventTouchUpInside];
    //selectButton1.contentMode = UIViewContentModeScaleAspectFit;
    [buttonsView addSubview:selectButton1];
    [vinosButs addObject:selectButton1];
    
    UIButton *selectButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton2.frame = CGRectMake(buttonsView.bounds.size.width*0.275, buttonsView.bounds.size.height*0.22 , buttonsView.bounds.size.width*0.225, buttonsView.bounds.size.width*0.225);
    [[selectButton2 imageView] setContentMode: UIViewContentModeScaleAspectFit];
[selectButton2 setBackgroundImage:[UIImage imageNamed:@"vinosBut50.png"]  forState:UIControlStateNormal];
selectButton2.tag = 2;
    [selectButton2 addTarget:self action:@selector(butSelected:) forControlEvents:UIControlEventTouchUpInside];
//selectButton2.contentMode = UIViewContentModeScaleAspectFit;
    [buttonsView addSubview:selectButton2];
    [vinosButs addObject:selectButton2];
    
    UIButton *selectButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton3.frame = CGRectMake(buttonsView.bounds.size.width*0.5, buttonsView.bounds.size.height*0.22 , buttonsView.bounds.size.width*0.225, buttonsView.bounds.size.width*0.225);
    [[selectButton3 imageView] setContentMode: UIViewContentModeScaleAspectFit];
[selectButton3 setBackgroundImage:[UIImage imageNamed:@"vinosBut100.png"]  forState:UIControlStateNormal];
selectButton3.tag = 3;
    [selectButton3 addTarget:self action:@selector(butSelected:) forControlEvents:UIControlEventTouchUpInside];
 //selectButton3.contentMode = UIViewContentModeScaleAspectFit;
    [buttonsView addSubview:selectButton3];
    [vinosButs addObject:selectButton3];
    
    UIButton *selectButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton4.frame = CGRectMake(buttonsView.bounds.size.width*0.725, buttonsView.bounds.size.height*0.22 , buttonsView.bounds.size.width*0.225, buttonsView.bounds.size.width*0.225);
    [[selectButton4 imageView] setContentMode: UIViewContentModeScaleAspectFit];
[selectButton4 setBackgroundImage:[UIImage imageNamed:@"vinosBut200.png"]  forState:UIControlStateNormal];
selectButton4.tag = 4;
    [selectButton4 addTarget:self action:@selector(butSelected:) forControlEvents:UIControlEventTouchUpInside];
    //selectButton4.contentMode = UIViewContentModeScaleAspectFit;
    [buttonsView addSubview:selectButton4];
    [vinosButs addObject:selectButton4];
    
    //INFO BUTTON
   
    //CANCEL BUTTON
    buyCreditsCCbut = [UIButton buttonWithType:UIButtonTypeCustom];
    buyCreditsCCbut.frame = CGRectMake(buttonsView.bounds.size.width*0.2,buttonsView.bounds.size.height*0.8,buttonsView.bounds.size.width*0.3,buttonsView.bounds.size.height*0.12);
    buyCreditsCCbut.backgroundColor = [UIColor clearColor];
    [buyCreditsCCbut setTitle:@"BACK" forState:UIControlStateNormal];
    [buyCreditsCCbut setTitleColor:[UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    buyCreditsCCbut.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(buyCreditsCCbut.bounds.size.height*0.6)];
    [buyCreditsCCbut addTarget:self action:@selector(cancelCredits) forControlEvents:UIControlEventTouchUpInside];
    buyCreditsCCbut.alpha = 1;
    buyCreditsCCbut.tag = 0;
    buyCreditsCCbut.titleLabel.textAlignment = NSTextAlignmentRight;
    [buttonsView addSubview:buyCreditsCCbut];
    
    //SIGN UP BUTTON
    UIButton *signUpBut = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpBut.frame = CGRectMake(buttonsView.bounds.size.width*0.5,buttonsView.bounds.size.height*0.8,buttonsView.bounds.size.width*0.3,buttonsView.bounds.size.height*0.12);
    signUpBut.backgroundColor = [UIColor clearColor];
    [signUpBut setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [signUpBut setTitleColor:[UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    signUpBut.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(signUpBut.bounds.size.height*0.6)];
    [signUpBut addTarget:self action:@selector(confirmVinos:) forControlEvents:UIControlEventTouchUpInside];
    signUpBut.alpha = 1;
    signUpBut.tag = 0;
    buyCreditsCCbut.titleLabel.textAlignment = NSTextAlignmentLeft;
    [buttonsView addSubview:signUpBut];
    
    
    
    
    
    //ADD CREDIT INFO
    creditInfoView = [[UIView alloc] initWithFrame:CGRectMake(CARDRECT)];
    creditInfoView.backgroundColor = [UIColor whiteColor];
    creditInfoView.alpha = 0.0f;
    creditInfoView.layer.cornerRadius = 5;
    [buttonsView addSubview:creditInfoView];
    
    //CREDIT TITLE
    UILabel *creditTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, memberView.bounds.size.height*0.1 ,memberView.bounds.size.width, memberView.bounds.size.height*0.08)];
    creditTopLabel.textAlignment =  NSTextAlignmentCenter;
    creditTopLabel.backgroundColor = [UIColor clearColor];
    creditTopLabel.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    creditTopLabel.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(topLabel.bounds.size.height*0.8)];
    creditTopLabel.userInteractionEnabled = FALSE;
    [creditTopLabel setText:@"ABOUT VINOS"];
    [creditInfoView addSubview:creditTopLabel];
    
    
    //CREDIT DESCRIPTION
    UITextView *creditDes=[[UITextView alloc] initWithFrame:CGRectMake(creditInfoView.bounds.size.width*0.1, creditInfoView.bounds.size.height*0.2, creditInfoView.bounds.size.width*0.8, creditInfoView.bounds.size.height*0.6)];
    creditDes.backgroundColor = [UIColor clearColor];
    creditDes.textAlignment = NSTextAlignmentCenter;
    creditDes.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:(creditDes.bounds.size.height*0.1)];
    creditDes.alpha = 1.0f;
    creditDes.userInteractionEnabled = FALSE;
    creditDes.text = @"VINOS is the new global currency of wine.\nPurchase VINOS to get your share of Private Cellar wines.\nUse VINOS for your wines to be collected from the cellar and delivered anywhere in the delivery zone during hours of operation (12h00 to 22h00 daily). VINOS can also be exchanged for wine experiences.\nVINOS purchased outside of regulated liquor trading hours can be used the following day.";
    [creditInfoView addSubview:creditDes];

    
    //TERMS LINK
    UILabel *termsBut = [[UILabel alloc] initWithFrame:CGRectMake(0, memberView.bounds.size.height*0.85 ,memberView.bounds.size.width, memberView.bounds.size.height*0.08)];
    termsBut.textAlignment =  NSTextAlignmentCenter;
    termsBut.backgroundColor = [UIColor clearColor];
    termsBut.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    termsBut.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(topLabel.bounds.size.height*0.8)];
    termsBut.userInteractionEnabled = TRUE;
    [termsBut setText:@"TERMS AND CONDITIONS"];
    [creditInfoView addSubview:termsBut];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTermsAndConditions)];
    tapped.numberOfTapsRequired = 1;
    [termsBut addGestureRecognizer:tapped];
    
    
    //ADD HISTORY BUT
    historyBut = [UIButton buttonWithType:UIButtonTypeCustom];
    historyBut.frame = CGRectMake(buttonsView.bounds.size.width*0.025, buttonsView.bounds.size.width*0.025 , buttonsView.bounds.size.width*0.1, buttonsView.bounds.size.width*0.1);
    historyBut.tag = 1;
    [historyBut setBackgroundImage:[UIImage imageNamed:@"infoBut.png"]  forState:UIControlStateNormal];
    [historyBut addTarget:self action:@selector(openCloseCreditHistory:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:historyBut];
    
    [self addSubview:buttonsView];

    
}

-(void)makeCall{
    NSLog(@"MAKE CALL");
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+27787860307"]];
    
}


-(void)makeMail{
    NSLog(@"SEND MAIL");
    
    
    NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
    
}

-(void)showTermsAndConditions{
    NSLog(@"SHOW TERMS AND CONDITIONS");
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.myvinos.club/terms"]];
    
}

-(void)buildDeliveryHistoryDisplay{
    NSLog(@"\n\nBUILD DELIVERY HISTORY - %@",@"START");
    
    
    
    //REMOVE ALL VIEWS OF SUBVIEW
    
    for (UIView *view in [deliveryHistoryView subviews])
    {
        [view removeFromSuperview];
    }
    
    
    //CREDIT HISTORY TITLE
    UILabel *creditTopLabelHistory = [[UILabel alloc] initWithFrame:CGRectMake(0, deliveryHistoryView.bounds.size.height*0.08 ,deliveryHistoryView.bounds.size.width, deliveryHistoryView.bounds.size.height*0.08)];
    creditTopLabelHistory.textAlignment =  NSTextAlignmentCenter;
    creditTopLabelHistory.backgroundColor =  [UIColor clearColor];
    creditTopLabelHistory.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    creditTopLabelHistory.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(creditTopLabelHistory.bounds.size.height*0.8)];
    creditTopLabelHistory.userInteractionEnabled = FALSE;
    [creditTopLabelHistory setText:@"DELIVERY HISTORY"];
    [deliveryHistoryView addSubview:creditTopLabelHistory];
    
    
    
    //BUILD SCROLL VIEW
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(deliveryHistoryView.bounds.size.width*0.005, deliveryHistoryView.bounds.size.height*0.2, deliveryHistoryView.bounds.size.width*0.99, deliveryHistoryView.bounds.size.height*0.75)];
    
    
    
    //ADD TO VIEW
    int i = 0;
    CGFloat barHeight = deliveryHistoryView.frame.size.height*0.12;
    
    
    //CREATE AND SORT HISTORY
    NSMutableArray *mySortedArray = [[NSMutableArray alloc] initWithArray:jsonDataHistory copyItems:YES];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"transaction.created_at"  ascending:NO];
    mySortedArray=[mySortedArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    
    
    for (NSDictionary *dictionary in mySortedArray) {
          NSLog(@"\n\nTRANSACTION HISTORY FOUND - %@",dictionary);
        if ([[dictionary objectForKey:@"type"] isEqualToString:@"vin_redemption"]) {
            //BUILD HISTORY SCROLL
            
            //ADD TO SCROLL VIEW AND ADD
            CGFloat y = i * barHeight;
            
            
            
            UILabel *hist0 = [[UILabel alloc] initWithFrame:CGRectMake(0, y ,scrollview.bounds.size.width * 0.2, barHeight*0.5)];
            hist0.textAlignment =  NSTextAlignmentCenter;
            hist0.backgroundColor = [UIColor clearColor];
            hist0.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
            hist0.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(hist0.bounds.size.height*0.8)];
            hist0.userInteractionEnabled = FALSE;
            [hist0 setText:[[[[dictionary objectForKey:@"transaction"] objectForKey:@"created_at"] componentsSeparatedByString:@"T"] objectAtIndex:0]];
            [scrollview addSubview:hist0];
            
            UILabel *hist00 = [[UILabel alloc] initWithFrame:CGRectMake(0, y + barHeight*0.5 ,scrollview.bounds.size.width * 0.2, barHeight*0.5)];
            hist00.textAlignment =  NSTextAlignmentCenter;
            hist00.backgroundColor = [UIColor clearColor];
            hist00.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
            hist00.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(hist00.bounds.size.height*0.8)];
            hist00.userInteractionEnabled = FALSE;
            [hist00 setText:[[[[[[dictionary objectForKey:@"transaction"] objectForKey:@"created_at"] componentsSeparatedByString:@"T"] objectAtIndex:1] componentsSeparatedByString:@"."] objectAtIndex:0]];
            [scrollview addSubview:hist00];
            
            //ADD TO SCROLL VIEW AND ADD
            UILabel *hist1 = [[UILabel alloc] initWithFrame:CGRectMake( scrollview.bounds.size.width*0.2 , y ,scrollview.bounds.size.width*0.55, barHeight)];
            hist1.textAlignment =  NSTextAlignmentCenter;
            hist1.backgroundColor = [UIColor clearColor];
            hist1.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
            hist1.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(hist1.bounds.size.height*0.6)];
            hist1.userInteractionEnabled = FALSE;
            [hist1 setText:[NSString stringWithFormat:@"Delivery for %@ VINOS",[[dictionary objectForKey:@"transaction"] objectForKey:@"amount"]]];
            [scrollview addSubview:hist1];
            
            
            //ADD TO SCROLL VIEW AND ADD
            UILabel *hist2 = [[UILabel alloc] initWithFrame:CGRectMake( scrollview.bounds.size.width*0.75 , y ,scrollview.bounds.size.width*0.25, barHeight)];
            hist2.textAlignment =  NSTextAlignmentCenter;
            hist2.backgroundColor = [UIColor clearColor];
            hist2.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
            hist2.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(hist2.bounds.size.height*0.5)];
            hist2.userInteractionEnabled = FALSE;
            [hist2 setText:[[dictionary objectForKey:@"transaction"] objectForKey:@"status"]];
            [scrollview addSubview:hist2];
            
            
            
            i++;
        }
        
    }
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, barHeight *i);
    scrollview.backgroundColor = [UIColor clearColor];
    [deliveryHistoryView addSubview:scrollview];
    
    //[transactionHistoryTxt sizeToFit]; //added
    //[transactionHistoryTxt layoutIfNeeded]; //added
    
    //CGRect frame = transactionHistoryTxt.frame;
    

}

-(void)buildCreditHistoryDisplay{
    NSLog(@"\n\nBUILD HISTORY - %@",@"START");
    
    
    
   //REMOVE ALL VIEWS OF SUBVIEW
    
    for (UIView *view in [creditHistoryView subviews])
    {
        [view removeFromSuperview];
    }
    
    
    //CREDIT HISTORY TITLE
    UILabel *creditTopLabelHistory = [[UILabel alloc] initWithFrame:CGRectMake(0, creditHistoryView.bounds.size.height*0.08 ,creditHistoryView.bounds.size.width, creditHistoryView.bounds.size.height*0.08)];
    creditTopLabelHistory.textAlignment =  NSTextAlignmentCenter;
    creditTopLabelHistory.backgroundColor =  [UIColor clearColor];
    creditTopLabelHistory.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    creditTopLabelHistory.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(creditTopLabelHistory.bounds.size.height*0.8)];
    creditTopLabelHistory.userInteractionEnabled = FALSE;
    [creditTopLabelHistory setText:@"TRANSACTION HISTORY"];
    [creditHistoryView addSubview:creditTopLabelHistory];
    
    
    
    //BUILD SCROLL VIEW
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(creditHistoryView.bounds.size.width*0.005, creditHistoryView.bounds.size.height*0.2, creditHistoryView.bounds.size.width*0.99, creditHistoryView.bounds.size.height*0.75)];
    
    
    
    //ADD TO VIEW
    int i = 0;
    CGFloat barHeight = creditHistoryView.frame.size.height*0.12;
    
    
    //CREATE AND SORT HISTORY
    NSMutableArray *mySortedArray = [[NSMutableArray alloc] initWithArray:jsonDataHistory copyItems:YES];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"transaction.created_at"  ascending:NO];
    mySortedArray=[mySortedArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    

    for (NSDictionary *dictionary in mySortedArray) {
      //  NSLog(@"\n\nTRANSACTION HISTORY FOUND - %@",dictionary);
        if ([[dictionary objectForKey:@"type"] isEqualToString:@"vin_purchase"]) {
            //BUILD HISTORY SCROLL
            
            //ADD TO SCROLL VIEW AND ADD
            CGFloat y = i * barHeight;
            
            
            
            UILabel *hist0 = [[UILabel alloc] initWithFrame:CGRectMake(0, y ,scrollview.bounds.size.width * 0.2, barHeight*0.5)];
            hist0.textAlignment =  NSTextAlignmentCenter;
            hist0.backgroundColor = [UIColor clearColor];
            hist0.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
            hist0.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(hist0.bounds.size.height*0.8)];
            hist0.userInteractionEnabled = FALSE;
            [hist0 setText:[[[[dictionary objectForKey:@"transaction"] objectForKey:@"created_at"] componentsSeparatedByString:@"T"] objectAtIndex:0]];
            [scrollview addSubview:hist0];
            
            UILabel *hist00 = [[UILabel alloc] initWithFrame:CGRectMake(0, y + barHeight*0.5 ,scrollview.bounds.size.width * 0.2, barHeight*0.5)];
            hist00.textAlignment =  NSTextAlignmentCenter;
            hist00.backgroundColor = [UIColor clearColor];
            hist00.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
            hist00.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(hist00.bounds.size.height*0.8)];
            hist00.userInteractionEnabled = FALSE;
            [hist00 setText:[[[[[[dictionary objectForKey:@"transaction"] objectForKey:@"created_at"] componentsSeparatedByString:@"T"] objectAtIndex:1] componentsSeparatedByString:@"."] objectAtIndex:0]];
            [scrollview addSubview:hist00];
            
            //ADD TO SCROLL VIEW AND ADD
            UILabel *hist1 = [[UILabel alloc] initWithFrame:CGRectMake( scrollview.bounds.size.width*0.2 , y ,scrollview.bounds.size.width*0.55, barHeight)];
            hist1.textAlignment =  NSTextAlignmentCenter;
            hist1.backgroundColor = [UIColor clearColor];
            hist1.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
            hist1.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(hist1.bounds.size.height*0.6)];
            hist1.userInteractionEnabled = FALSE;
            [hist1 setText:[NSString stringWithFormat:@"Purchased %@ VINOS",[[dictionary objectForKey:@"transaction"] objectForKey:@"amount"]]];
            [scrollview addSubview:hist1];
            
            
            //ADD TO SCROLL VIEW AND ADD
            UILabel *hist2 = [[UILabel alloc] initWithFrame:CGRectMake( scrollview.bounds.size.width*0.75 , y ,scrollview.bounds.size.width*0.25, barHeight)];
            hist2.textAlignment =  NSTextAlignmentCenter;
            hist2.backgroundColor = [UIColor clearColor];
            hist2.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
            hist2.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(hist2.bounds.size.height*0.5)];
            hist2.userInteractionEnabled = FALSE;
            [hist2 setText:[[dictionary objectForKey:@"transaction"] objectForKey:@"status"]];
            [scrollview addSubview:hist2];
            
        

            i++;
        }
  
    }
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, barHeight *i);
    scrollview.backgroundColor = [UIColor clearColor];
    [creditHistoryView addSubview:scrollview];
    
    //[transactionHistoryTxt sizeToFit]; //added
    //[transactionHistoryTxt layoutIfNeeded]; //added
    
    //CGRect frame = transactionHistoryTxt.frame;

    
}

-(void)openCloseContact:(UIButton*)sender{
    NSLog(@"OPEN CLOSE CONTACT");
    
    //OPEN OR CLOSE CREDIT HISTORY
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    if(sender.tag == 1){
        contactInfoView.alpha = 1.0f;
        sender.tag = 0;
    }
    else{
        contactInfoView.alpha = 0.0f;
        sender.tag = 1;
    }
    [UIView commitAnimations];
}

-(void)openCloseMenu:(UIButton*)sender{
    NSLog(@"OPEN CLOSE CONTACT");
    
    //OPEN OR CLOSE CREDIT HISTORY
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
        userMenuView.alpha = 1.0f;
       [UIView commitAnimations];
}



-(void)openCloseCreditHistory:(UIButton*)sender{
    NSLog(@"OPEN CLOSE HISTORY");
    
    //OPEN OR CLOSE CREDIT HISTORY
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    if(sender.tag == 1){
        creditInfoView.alpha = 1.0f;
        sender.tag = 0;
    }
    else{
        creditInfoView.alpha = 0.0f;
        sender.tag = 1;
    }
    [UIView commitAnimations];
}

-(void)openCloseMemberInfoView:(UIButton*)sender{
    NSLog(@"OPEN CLOSE MEMBERSHIP INFO");
    
    //OPEN OR CLOSE CREDIT HISTORY
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    if(sender.tag == 1){
        membershipInfoView.alpha = 1.0f;
        sender.tag = 0;
    }
    else{
        membershipInfoView.alpha = 0.0f;
        sender.tag = 1;
    }
    [UIView commitAnimations];
}

-(void)updateCreditsView{
    NSLog(@"UPDATE CREDITS VIEW");
    
    //UPDATE SUMMARY LABEL
    NSString *sumTxt = [NSString stringWithFormat:@"Purchase %i VINOS",amountToBuy];
    if ([summeryPurchase respondsToSelector:@selector(setAttributedText:)])
    {
        // iOS6 and above : Use NSAttributedStrings
        
        //termsBut.font = ;

        
        // Create the attributes
        const CGFloat fontSize = 10;
        NSDictionary *attrs = @{
                                NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(summeryPurchase.bounds.size.height*0.8)],
                                NSForegroundColorAttributeName:[UIColor blackColor]
                                };
        NSDictionary *subAttrs = @{
                                   NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Bold" size:(summeryPurchase.bounds.size.height*0.8)]
                                   };
        
        // Range of " 2012/10/14 " is (8,12). Ideally it shouldn't be hardcoded
        // This example is about attributed strings in one label
        // not about internationalization, so we keep it simple :)
        const NSRange range = [sumTxt rangeOfString:[NSString stringWithFormat:@"%i",amountToBuy]];
        //NSMakeRange(2,4);
        
        // Create the attributed string (text + attributes)
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:sumTxt
                                               attributes:attrs];
        [attributedText setAttributes:subAttrs range:range];
        
        // Set it in our UILabel and we are done!
        [summeryPurchase setAttributedText:attributedText];
    } else {
        // iOS5 and below
        [summeryPurchase setText:sumTxt];
    }
    
    //UPDATE PURCHASE
    [summeryLabel setText: [NSString stringWithFormat:@"(You will be charged ZAR %i)",amountToBuy*10]];
    [buyCreditsCCbut setTitle:@"START AGAIN" forState:UIControlStateNormal];
    
    //TEMP SET AMOUNT OF CREDITS
    [myDelegate updateTempVinosAmount:amountToBuy];

}



-(void)flipOpenCard{
    NSLog(@"\nFLIP OPEN CARD");
    
    //CLOSE MEMBERVIEW
    CALayer *layerMember = memberView.layer;
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 90.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    
    //HIDE BUTTON VIEW
    CALayer *layerButs = buttonsView.layer;
    CATransform3D rotationAndPerspectiveTransformB = CATransform3DIdentity;
    rotationAndPerspectiveTransformB.m34 = 1.0 / -500;
    rotationAndPerspectiveTransformB = CATransform3DRotate(rotationAndPerspectiveTransformB, 0.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    
    //float timing = 0.15f;
    
    //FLIP CARDS
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromLeft];
    [UIView setAnimationDuration:CARDDELAY];
    [UIView setAnimationDelay:0.0f];
    buttonsView.alpha = 1.0f;
    [UIView commitAnimations];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromLeft];
    [UIView setAnimationDuration:CARDANIMATION];
    [UIView setAnimationDelay:0.0f];
    buttonsView.alpha = 1.0f;
    layerMember.transform = rotationAndPerspectiveTransform;
    [UIView commitAnimations];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromRight];
    [UIView setAnimationDuration:CARDANIMATION];
    [UIView setAnimationDelay:CARDANIMATION];
    buttonsView.alpha = 1.0f;
    layerButs.transform = rotationAndPerspectiveTransformB;
    [UIView commitAnimations];
    
    [self promptVinosSelection];
    
}

-(void)flipCloseCard{
    NSLog(@"\nFLIP CLOSE CARD");
    
    //CLOSE MEMBERVIEW
    CALayer *layerMember = memberView.layer;
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    
    //HIDE BUTTON VIEW
    CALayer *layerButs = buttonsView.layer;
    CATransform3D rotationAndPerspectiveTransformB = CATransform3DIdentity;
    rotationAndPerspectiveTransformB.m34 = 1.0 / -500;
    rotationAndPerspectiveTransformB = CATransform3DRotate(rotationAndPerspectiveTransformB, -90.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
     
    
    //float timing = 0.15f;
    
    //FLIP CARDS
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromRight];
    [UIView setAnimationDuration:CARDDELAY];
    memberView.alpha = 1.0f;
    buttonsView.alpha = 0.0f;
    [UIView commitAnimations];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromRight];
    [UIView setAnimationDuration:CARDANIMATION];
    //buttonsView.alpha = 0.0f;
    layerButs.transform = rotationAndPerspectiveTransformB;
    [UIView commitAnimations];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromLeft];
    [UIView setAnimationDuration:CARDANIMATION];
    [UIView setAnimationDelay:CARDANIMATION];
    //buttonsView.alpha = 0.0f;
    layerMember.transform = rotationAndPerspectiveTransform;
    [UIView commitAnimations];
    
}

-(void)openUser{
    NSLog(@"\nOPEN USER");
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    self.alpha = 1.0f;
    [UIView commitAnimations];
    
    bkLayer.frame = ((ParseStarterProjectViewController*)myDelegate).view.frame;
    
    //SHOW MEMBER VIEW
    CALayer *layerMember = memberView.layer;
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    
    
    //HIDE BUTTON VIEW
    CALayer *layerButs = buttonsView.layer;
    CATransform3D rotationAndPerspectiveTransformB = CATransform3DIdentity;
    rotationAndPerspectiveTransformB.m34 = 1.0 / -500;
    rotationAndPerspectiveTransformB = CATransform3DRotate(rotationAndPerspectiveTransformB, -90.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);

    layerMember.transform = rotationAndPerspectiveTransform;
    layerButs.transform = rotationAndPerspectiveTransformB;
    
    if(!userFound)signUpView.alpha = 1.0f; else signUpView.alpha = 0.0f;
    buttonsView.alpha = 0.0f;
    //buyCredits.alpha = 0.0f;
    signUpTable.view.alpha = 0.0f;
    logInTable.view.alpha = 0.0f;
    highlightView.alpha = 0.0f;
     myPaymentPage.alpha = 0.0f;
    
    memberView.center = CGPointMake(self.center.x, CARDSTART);
    buttonsView.center = CGPointMake(self.center.x, CARDSTART);
    //buyCredits.center = CGPointMake(self.center.x, CARDSTART);
    
    //FLY CARD IN
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDelay:CARDDELAY];
    memberView.center = CGPointMake(self.center.x, CARDEND);
    menuView.alpha = 0;
    buttonsView.center = CGPointMake(self.center.x, CARDEND);
    //buyCredits.center = CGPointMake(self.center.x, CARDEND);
    [UIView commitAnimations];
    

}



-(void)closeUser{
    NSLog(@"\nCLOSE USER");
    
    //FLY CARD OUT

    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.225f];
    memberView.center = CGPointMake(self.center.x, CARDSTART);
    buttonsView.center = CGPointMake(self.center.x, CARDSTART);
    //buyCredits.center = CGPointMake(self.center.x, CARDSTART);
    creditHistoryView.alpha = 0.0f;
    deliveryHistoryView.alpha = 0.0f;
    creditInfoView.alpha = 0.0f;
    contactInfoView.alpha = 0.0f;
    myPaymentPage.alpha = 0.0f;
    userMenuView.alpha = 0.0f;
    menuView.alpha = 0.0f;
    historyBut.tag = 1;
    infoBut.tag = 1;
    [UIView commitAnimations];
    
    //RESET VINOS COUNTERS
    [topUpsToBuy removeAllObjects];
    amountToBuy = 0;
    [summeryLabel setText:[NSString stringWithFormat:@"(You will be charged in ZAR)"]];
    [summeryPurchase setText:@"Purchase VINOS"];

    //CLOSE KEYBOARDS
    [self closeForms];
    
}


#pragma mark - CREDITS

-(void)openUserBuy{
    NSLog(@"\nOPEN USER BUY");
    
    //open direct view
    if (userFound) {
        [self flipOpenCard];
        /*
         [UIView beginAnimations:NULL context:NULL];
         [UIView setAnimationDelegate:self];
         [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
         [UIView setAnimationDelay:0.35f];
         [UIView setAnimationDuration:0.15f];
         buyCredits.alpha = 1.0f;
         [UIView commitAnimations];
         */
    }
    else{
        /*/SHOW INFO TO USER
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Private Membership"
                                                        message:@"Sign up for FREE to GET VINOS and use them to have your items delivered to you till late."
                                                       delegate:self
                                              cancelButtonTitle:@"Thanks"
                                              otherButtonTitles:nil];
        [alert show];
         */
    }
    
    
    
}

-(void)openUserMembership{
    NSLog(@"\nOPEN USER MEMBERSHIP");
    
    //open direct view
    if (userFound) {
        buttonsView.alpha = 0.0f;
        membershipView.alpha = 1.0f;
        [self flipOpenCard];
        
        [self promptMembershipSelection];
        /*
         [UIView beginAnimations:NULL context:NULL];
         [UIView setAnimationDelegate:self];
         [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
         [UIView setAnimationDelay:0.35f];
         [UIView setAnimationDuration:0.15f];
         buyCredits.alpha = 1.0f;
         [UIView commitAnimations];
         */
    }
    else{
        /*/SHOW INFO TO USER
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Private Membership"
                                                        message:@"Sign up for FREE and GET VINOS and use them to have your items delivered to you till late."
                                                       delegate:self
                                              cancelButtonTitle:@"Thanks"
                                              otherButtonTitles:nil];
        [alert show];
         */
    }
    
    
    
}

-(void)cancelCredits{
    NSLog(@"\nCANCEL CREDITS ");
    
    
    if(amountToBuy == 0){
        buttonsView.alpha = 1.0f;
        //buyCredits.alpha = 0.0f;
        //[buyCreditsCCbut setTitle:@"CANCEL" forState:UIControlStateNormal];
        
        //SHOW
        [self flipCloseCard];
        //[ self.myDelegate performSelector: @selector( openCloseUser ) ];
    }
    else{
        [topUpsToBuy removeAllObjects];
        amountToBuy = 0;
        
        
        [self updateCreditsView];
        
        [buyCreditsCCbut setTitle:@"BACK" forState:UIControlStateNormal];
        [summeryLabel setText:[NSString stringWithFormat:@"(You will be charged ZAR 10 for 1 VINOS)"]];
        [summeryPurchase setText:@"Purchase VINOS"];
        
    }
    
}

-(void)cancelMembership{
    NSLog(@"\nCANCEL MEMBERSHIP ");
    
    buttonsView.alpha = 1.0f;
    membershipView.alpha = 0.0f;
     membershipToGet = @"";
    membershipToGetAmount = 0;
     [self flipCloseCard];
    
    [membershipViewTextSummary setText:[NSString stringWithFormat:@"(You will be charged in ZAR)"]];
    [membershipViewText setText:@"SELECT MEMBERSHIP TO BUY"];
    
    [myDelegate updateTempVinosAmount:membershipToGetAmount];
    
    [self updateUserStats];
}


-(void)userButtonsH:(UIButton *) sender{
    NSLog(@"\nUSER BUT %i",sender.tag);
    
    //HIDE BUTTON SCREEN
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    
    //SET VINOS AMOUNT
    switch (sender.tag) {
        case 0:
        {
            NSLog(@"\nCANCEL VIEWS ");
            userMenuView.alpha = 0;

            break;
        }
        case 1:
        {
            NSLog(@"\nDELIVERY");
            deliveryHistoryView.alpha = 1.0f;
            menuCloseBut.alpha = 1.0f;
            break;
        }
        case 2:
        {
            NSLog(@"\nVINOS");
            creditHistoryView.alpha = 1.0f;
            menuCloseBut.alpha = 1.0f;
            break;
    }
        case 3:
        {
            
        
            NSLog(@"\nLog Out ");
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log Out?" message:@"Are you sure you would like to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log out", nil];
            alertView.tag = 72;
            [alertView show];

            
            
            
            break;
        }
        case 65:
        {
            NSLog(@"\CLOSE MENU VIEWS INSIDE");
 deliveryHistoryView.alpha = 0.0f;
            creditHistoryView.alpha = 0.0f;
            menuCloseBut.alpha = 0.0f;

            break;
        }
            
        default:
            break;
    }
    [UIView commitAnimations];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (alertView.tag == 72) {
        if (buttonIndex == 0)
        {
            
            NSLog(@"cancel");
            
            
        }
        else
        {
            NSLog(@"LOG OUT USER");
            
            //REMOVE STANDARD USER DEFAULTS
            userFound = false;
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            
            //SET LOGIN DEFAULTS
            
            
            [logInTable clearAllFields];
            [forgotTable clearAllFields];
            [signUpTable clearAllFields];
            
            [self closeForms];

            
            //HIDE MENU
            userMenuView.alpha = 0;
            
            
            //SHOW FORMS
            //REMOVE SIGN UP VIEW
            signUpView.alpha = 1.0f;
            [memberView addSubview:signUpView];
            
        }
    }
    
    
}

-(void)promptVinosSelection{
    NSLog(@"PROMPT VINOS SELECTION");
    
    float delay = CARDANIMATION + CARDDELAY;
    for(UIButton *deck in vinosButs) {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.15f];
        [UIView setAnimationDelay:delay];
        deck.transform = CGAffineTransformMakeScale(0.85, 0.85);
        [UIView commitAnimations];
        
        delay=delay+0.05f;
    }
    
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(promptVinosSelectionEnd) userInfo:nil repeats:NO];
    
    //[NSTimer timerWithTimeInterval:delay target:self selector:@selector(promptSelection:) userInfo:NULL repeats:NO];
    
}

-(void)promptVinosSelectionEnd{
    
    
    float delay = 0.0f;
    for(UIButton *deck in vinosButs) {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.15f];
        [UIView setAnimationDelay:delay];
        deck.transform = CGAffineTransformMakeScale(1, 1);
        [UIView commitAnimations];
        
        delay=delay+0.05f;
        
        NSLog(@"PROMPT VINOS SELECTION DOEN");
    }
    
    
    
}



-(void)promptMembershipSelection{
    NSLog(@"PROMPT MEMBERSHIP SELECTION");
    
    float delay = CARDANIMATION + CARDDELAY;
    for(UIButton *memButs in membershipButs) {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.15f];
        [UIView setAnimationDelay:delay];
        memButs.transform = CGAffineTransformMakeScale(0.85, 0.85);
        [UIView commitAnimations];
        
        delay=delay+0.05f;
    }
    
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(promptMembershipSelectionEnd) userInfo:nil repeats:NO];
    
    //[NSTimer timerWithTimeInterval:delay target:self selector:@selector(promptSelection:) userInfo:NULL repeats:NO];
    
}

-(void)promptMembershipSelectionEnd{
    
    
    float delay = 0.0f;
    for(UIButton *memButs in membershipButs) {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.15f];
        [UIView setAnimationDelay:delay];
        memButs.transform = CGAffineTransformMakeScale(1, 1);
        [UIView commitAnimations];
        
        delay=delay+0.05f;
        
        NSLog(@"PROMPT MEMBERSHIP BUTS SELECTION DOEN");
    }
    
    
    
}



-(void)butMembershipSelected:(UIButton *) sender{
    NSLog(@"\nSELECT MEMBERSHIP LEVEL %i",sender.tag);
    
    //UNSELECT ALL BUTTONS EXCEPT SELECTED ONE
     [UIView beginAnimations:NULL context:NULL];
     [UIView setAnimationDelegate:self];
     [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
     [UIView setAnimationDuration:0.15f];
     for(UIButton *but in [membershipButs reverseObjectEnumerator]) {
     if(but.tag == sender.tag) but.alpha = 1.0f;
     else but.alpha = 0.85f;
     }
     [UIView commitAnimations];
    
    
    //FADE BUTTON
    sender.alpha = 0.7f;
    [UIView animateWithDuration:0.25 animations:^{sender.alpha = 1.0f;}];
    
    
    //SET MEMEBRSHIP LEVEL
    switch (sender.tag) {
        case 1:
        {
            //FREE
            NSLog(@"\nGET FREE MEMBERSHIP ");
            membershipToGetAmount = 0;
             membershipToGet = @"FREE";
            
            membershipInfoView.backgroundColor = membershipView.backgroundColor = buttonsView.backgroundColor = memberView.backgroundColor = [UIColor whiteColor];

            
            //CREATE
            membershipToBuyDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              @"72684", @"product_id",
                                              @"1", @"quantity",
                                              nil];
            
            
            break;
        }
            
        case 2:
        {
            //SILVER
            NSLog(@"\nGET SILVER MEMBERSHIP ");
            membershipToGetAmount = 15;
            membershipToGet = @"SILVER";
            
            membershipInfoView.backgroundColor = membershipView.backgroundColor = buttonsView.backgroundColor = memberView.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:223.0f/255.0f blue: 223.0f/255.0f alpha:1.0f];

            //CREATE
            membershipToBuyDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              @"72685", @"product_id",
                                              @"1", @"quantity",
                                              nil];
            
            
            break;
        }
        case 3:
        {
            //GOLD
            NSLog(@"\nGET GOLD MEMBERSHIP ");
            membershipToGetAmount = 45;
            membershipToGet = @"GOLD";

            membershipInfoView.backgroundColor = membershipView.backgroundColor = buttonsView.backgroundColor = memberView.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:176.0f/255.0f blue: 91.0f/255.0f alpha:1.0f];

            //CREATE
           membershipToBuyDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              @"72690", @"product_id",
                                              @"1", @"quantity",
                                              nil];
            
            
            
            break;
        }
        case 4:
        {
            //PLATINUM
            NSLog(@"\nGET PLATINUM MEMBERSHIP ");
            membershipToGetAmount = 250;
            membershipToGet = @"PLATINUM";
            
            membershipInfoView.backgroundColor = membershipView.backgroundColor = buttonsView.backgroundColor = memberView.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:212.0f/255.0f blue: 212.0f/255.0f alpha:1.0f];

            //CREATE
            membershipToBuyDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              @"72813", @"product_id",
                                              @"1", @"quantity",
                                              nil];
            
            
            break;
        }
        default:
            break;
    }
    
    //PRINT RESULT
    NSLog(@"\n\n MEMEBRSHIP TO BUY UPDATED %@ \n\n",membershipToBuyDict);
    
    //UPDATE PURCHASE CARD
    [self updateMembershipView];
    
}


-(void)butSelected:(UIButton *) sender{
    NSLog(@"\nSELECT VINOS %i",sender.tag);
    
    /*/UNSELECT ALL BUTTONS EXCEPT SELECTED ONE
     [UIView beginAnimations:NULL context:NULL];
     [UIView setAnimationDelegate:self];
     [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
     [UIView setAnimationDuration:0.15f];
     for(UIButton *but in [vinosButs reverseObjectEnumerator]) {
     if(but.tag == sender.tag) but.alpha = 1.0f;
     else but.alpha = 0.5f;
     }
     [UIView commitAnimations];
     */
    
    //FADE BUTTON
    sender.alpha = 0.7f;
    [UIView animateWithDuration:0.15 animations:^{sender.alpha = 1.0f;}];

    BOOL foundKey = FALSE;

    //SET VINOS AMOUNT
    switch (sender.tag) {
        case 1:
        {
            //GET 20 VINOS
            NSLog(@"\nGET 10 VINOS ");
            amountToBuy = amountToBuy + 10;
            
            //CHECK IF EXISTS IN TOP UPS TO BUY
            for(NSMutableDictionary *myDict in topUpsToBuy){
                if ([[myDict objectForKey:@"product_id"] isEqualToString:@"72340"]) {
                    [myDict setObject:[NSString stringWithFormat:@"%i",[[myDict objectForKey:@"quantity"] integerValue] + 1] forKey:@"quantity"];
                    foundKey = TRUE;
                }
            }
            if (!foundKey) {
                //CREATE
                NSMutableDictionary *myTopDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                  @"72340", @"product_id",
                                                  @"1", @"quantity",
                                                  nil];
                [topUpsToBuy addObject:myTopDict];
            }
            
            
            
            break;
        }
        
        case 2:
        {
            //GET 50 VINOS
            NSLog(@"\nGET 50 VINOS ");
            amountToBuy = amountToBuy + 50;
            
            //CHECK IF EXISTS IN TOP UPS TO BUY
            for(NSMutableDictionary *myDict in topUpsToBuy){
                if ([[myDict objectForKey:@"product_id"] isEqualToString:@"71160"]) {
                    [myDict setObject:[NSString stringWithFormat:@"%i",[[myDict objectForKey:@"quantity"] integerValue] + 1] forKey:@"quantity"];
                    foundKey = TRUE;
                }
            }
            if (!foundKey) {
                //CREATE
                NSMutableDictionary *myTopDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                  @"71160", @"product_id",
                                                  @"1", @"quantity",
                                                  nil];
                [topUpsToBuy addObject:myTopDict];
            }

            
            break;
        }
        case 3:
        {
            //GET 100 VINOS
            NSLog(@"\nGET 100 VINOS ");
            amountToBuy = amountToBuy + 100;
            
            //CHECK IF EXISTS IN TOP UPS TO BUY
            for(NSMutableDictionary *myDict in topUpsToBuy){
                if ([[myDict objectForKey:@"product_id"] isEqualToString:@"71227"]) {
                    [myDict setObject:[NSString stringWithFormat:@"%i",[[myDict objectForKey:@"quantity"] integerValue] + 1] forKey:@"quantity"];
                    foundKey = TRUE;
                }
            }
            if (!foundKey) {
                //CREATE
                NSMutableDictionary *myTopDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                  @"71227", @"product_id",
                                                  @"1", @"quantity",
                                                  nil];
                [topUpsToBuy addObject:myTopDict];
            }
            
            
            break;
        }
        case 4:
        {
            //GET 200 VINOS
            NSLog(@"\nGET 200 VINOS ");
            amountToBuy = amountToBuy + 200;
            
            //CHECK IF EXISTS IN TOP UPS TO BUY
            for(NSMutableDictionary *myDict in topUpsToBuy){
                if ([[myDict objectForKey:@"product_id"] isEqualToString:@"72350"]) {
                    [myDict setObject:[NSString stringWithFormat:@"%i",[[myDict objectForKey:@"quantity"] integerValue] + 1] forKey:@"quantity"];
                    foundKey = TRUE;
                }
            }
            if (!foundKey) {
                //CREATE
                NSMutableDictionary *myTopDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                  @"72350", @"product_id",
                                                  @"1", @"quantity",
                                                  nil];
                [topUpsToBuy addObject:myTopDict];
            }

            
            break;
        }
        default:
        break;
    }
    
    //PRINT RESULT
    NSLog(@"\n\n KEYS UPDATED %@ \n\n",topUpsToBuy);
    
    //UPDATE PURCHASE CARD
    [self updateCreditsView];

}


-(void)confirmMembership:(UIButton *) sender{
    NSLog(@"\nCONFIRM MEMBERSHIP");
    
        //SHOW LOADING
        [myDelegate startLoadingNow:@"Changing Membership"];
        
        
        //CALL API AND CHECK FOR USER UPDATE AFTER CONFIRM MESSAGE
        dataMembership = [[NSMutableData alloc] init];
        
        //NSURL *url = [NSURL URLWithString:@"https://myvinos-api.infinity-g.com/orders"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MYVINOSSERVER,@"/orders"]];
        
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:1820.0];
        
        NSArray *myTempArrP = [[NSArray alloc] initWithObjects:membershipToBuyDict, nil];
        
        //CREATE PRODUCTS ARRAY
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"mem_purchase", @"type",
                                     myTempArrP, @"products",
                                     nil];
        
        
        
        NSLog(@"\n\nSENDING MEMBERSHIP REQUEST \n %@",requestData);
        
        NSString* aStr;
        NSError *error;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:NSJSONReadingMutableLeaves error:&error];
        aStr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        
        NSLog(@"MEMBERSHIP DATA %@",aStr);
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencode" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"token"] forHTTPHeaderField:@"Authorization"];
        [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[aStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        connectionMembership = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}


-(void)confirmVinos:(UIButton *) sender{
    NSLog(@"\nCONFIRM VINOS");
    
    if([topUpsToBuy count]>0){
        //SHOW LOADING
        [myDelegate startLoadingNow:@"Processing VINOS"];
        
        [buyCreditsCCbut setTitle:@"BACK" forState:UIControlStateNormal];
        
        
        //CALL API AND CHECK FOR USER UPDATE AFTER CONFIRM MESSAGE
        dataTopUp = [[NSMutableData alloc] init];
        
        //NSURL *url = [NSURL URLWithString:@"https://myvinos-api.infinity-g.com/orders"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MYVINOSSERVER,@"/orders"]];
        
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:1820.0];
        
        //CREATE PRODUCTS ARRAY
        
        
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"vin_purchase", @"type",
                                     @"ZAR", @"currency",
                                     topUpsToBuy, @"products",
                                     nil];
        
        
        
        NSLog(@"\n\nSENDING TOP UP REQUEST \n %@",requestData);
        
        NSString* aStr;
        NSError *error;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:NSJSONReadingMutableLeaves error:&error];
        aStr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        
        NSLog(@"NONNONONONONONONON %@",aStr);
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencode" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"token"] forHTTPHeaderField:@"Authorization"];
        [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[aStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        connectionTopUp = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        
        //STORE TO PARSE VINOS REQUEST
        PFObject *testObject = [PFObject objectWithClassName:@"VINOS_TOPUP"];
        testObject[@"products"] = topUpsToBuy;
        testObject[@"price"] = [NSString stringWithFormat:@"%i",amountToBuy] ;
        testObject[@"username"] = [[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
        [testObject saveInBackground];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select VINOS"
                                                        message:@"Tap the icons to select the amount of VINOS to GET."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    
}


-(void)addTopUp:(NSDictionary*)foundTopUp{
   // NSLog(@"TOP UP ADDED %@",foundTopUp);
    
    [topUps addObject:foundTopUp];
}

#pragma mark - TOUCHES


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touched in UseR");
   
    
    
}



#pragma mark - DATA CONTROLLER

//PUBLIC KEY GENI
NSString *letters = @"abc4-32+defg-23-4hijk1lmn+o124p+2134+12eDaFaWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

-(void)signUpUser{
    
    //LOADING IMAGE
    [(ParseStarterProjectViewController*)myDelegate startLoadingNow:@"Signing Up"];
    
    signUpTable.view.alpha = 0;
    
    //GET DATA
    dataSignUp = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IDIOSERVER,@"/users"]];
    
    NSLog(@"CHECK SIGN UP URL %@",[NSString stringWithFormat:@"%@%@",IDIOSERVER,@"/users"]);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:1820.0];
    
    //PUBLIC KEYS
    GMEllipticCurveCrypto *crypto = [GMEllipticCurveCrypto generateKeyPairForCurve:
                                     GMEllipticCurveSecp256r1];
    NSLog(@"Public Key: %@", crypto.publicKeyBase64);
    NSLog(@"Private Key: %@", crypto.privateKeyBase64);
    
    [[NSUserDefaults standardUserDefaults] setObject:crypto.publicKeyBase64 forKey:@"public_key"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 signUpTable.name, @"first_name",
                                 signUpTable.surname, @"last_name",
                                 signUpTable.email, @"email",
                                 signUpTable.email, @"username",
                                 signUpTable.mobile, @"mobile_number",
                                 signUpTable.password, @"password",
                                 signUpTable.reference, @"meta",
                                 crypto.publicKeyBase64, @"public_key",
                                 nil];
  
    
    NSLog(@"\n\nSENDING SIGN UP \n %@",requestData);
    
    NSString* aStr;
    NSError *error;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:NSJSONReadingMutableLeaves error:&error];
    aStr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
   
    
    NSLog(@"NONNONONONONONONON %@",aStr);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencode" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[aStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    connectionSignUp = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}


//CHECK IF TOKEN IS STILL ACTIVE - 120 SECONDS
-(void)loginUser{
    NSLog(@"LOG IN USER");
    
    if([logInTable.password length] > 0 && [logInTable.email length] > 0){
        //LOADING IMAGE
        [(ParseStarterProjectViewController*)myDelegate startLoadingNow:@"Logging In"];
        
        
        //GET DATA
        dataLogIn = [[NSMutableData alloc] init];
        
       // NSURL *url = [NSURL URLWithString:@"https://id-io-myvinos.infinity-g.com/login"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IDIOSERVER,@"/login"]];

        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:2820.0];
        
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     logInTable.email, @"username",
                                     logInTable.password, @"password",
                                     @"myvinos",@"domain",
                                     [[NSUserDefaults standardUserDefaults] stringForKey:@"challenge"], @"fingerprint",
                                     nil];
        
        
        
        NSLog(@"\n\nLOG IN \n %@",requestData);
        
        NSString* aStr;
        NSError *error;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:NSJSONReadingMutableLeaves error:&error];
        aStr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSLog(@"NONNONONONONONONON %@",aStr);
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencode" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[aStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        connectionLogIn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check your details"
                                                        message:@"Enter your username and password to gain access to your membership to use your VINOS to have your items delivered to you."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}
-(void)getToken{
    
    NSLog(@"TOKEN IN USER");
    //GET DATA
    dataToken = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MYVINOSSERVER,@"/tokens"]];
    //NSURL *url = [NSURL URLWithString:@"https://myvinos-api.infinity-g.com/tokens"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:2820.0];
    
    //REQUEST DATA IS WHAT IS RETURNED FROM LOGIN
    
    
    NSLog(@"\n\nGET TOKEN FROM LOGIN \n %@",jsonDataLogIn);
    
    NSString* aStr;
    NSError *error;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonDataLogIn options:NSJSONReadingMutableLeaves error:&error];
    aStr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    NSLog(@"NONNONONONONONONON %@",aStr);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencode" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[aStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    connectionToken = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)getUser{
   
    //LOADING IMAGE
    [(ParseStarterProjectViewController*)myDelegate startLoadingNow:@"Refreshing"];
    
    //REMOVE SIGN UP VIEW
    signUpView.alpha = 0.0f;
    [signUpView removeFromSuperview];
    userFound = TRUE;
    
    //GET DATA
    dataUser = [[NSMutableData alloc] init];
    NSString* urlString = [NSString stringWithFormat:@"%@%@%@",MYVINOSSERVER,@"/users/",[[NSUserDefaults standardUserDefaults] stringForKey:@"username"]] ;
    NSLog(@"GET USER %@ ----",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:1820.0];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"token"] forHTTPHeaderField:@"Authorization"];
    
    connectionUser = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)getHistory{
    
    
    //GET HISTORY - CHANGE URL
    dataHistory = [[NSMutableData alloc] init];
    //NSString* urlString = [NSString stringWithFormat:@"https://myvinos-api.infinity-g.com/orders"] ;
    NSString* urlString = [NSString stringWithFormat:@"%@%@",MYVINOSSERVER,@"/orders"] ;
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MYVINOSSERVER,@"/orders"]];

    NSLog(@"GET ORDER HISTORY %@ ----",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:1820.0];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"token"] forHTTPHeaderField:@"Authorization"];
    
    connectionHistory = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)sendOTP{
    NSLog(@"SEND OTP");
    
    //LOADING IMAGE
    [(ParseStarterProjectViewController*)myDelegate startLoadingNow:@"Sending SMS"];
    
        //GET DATA
    dataForgot = [[NSMutableData alloc] init];
    
    //NSURL *url = [NSURL URLWithString:@"https://id-io-myvinos.infinity-g.com/users/otp"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IDIOSERVER,@"/users/otp"]];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:2820.0];
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 logInTable.email, @"username",
                                 @"myvinos",@"domain",
                                 nil];
    
    
    
    NSLog(@"\n\nSEND OTP \n %@",requestData);
    
    NSString* aStr;
    NSError *error;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:NSJSONReadingMutableLeaves error:&error];
    aStr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    NSLog(@"NONNONONONONONONON %@",aStr);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencode" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[aStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    connectionForgot = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)resetPassword{
    NSLog(@"RESET PASSWORD WITH OTP");
    
    NSLog(@"SEND RESET PASSWORD");
    //GET DATA
    dataReset = [[NSMutableData alloc] init];
    
    //NSURL *url = [NSURL URLWithString:@"https://id-io-myvinos.infinity-g.com/users/reset"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IDIOSERVER,@"/users/reset"]];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:2820.0];
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 forgotTable.email, @"username",
                                 forgotTable.otp, @"otp",
                                 forgotTable.password, @"password",
                                 [jsonDataForgot objectForKey:@"nonce"], @"nonce",
                                 @"myvinos",@"domain",
                                 nil];
    
    
    
    NSLog(@"\n\nSEND OTP \n %@",requestData);
    
    NSString* aStr;
    NSError *error;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:NSJSONReadingMutableLeaves error:&error];
    aStr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    NSLog(@"NONNONONONONONONON %@",aStr);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencode" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[aStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    connectionReset = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = [httpResponse statusCode];
    NSLog(@"URL RESPONSE %i",responseStatusCode);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == self.connectionSignUp) {
        [self.dataSignUp appendData:data];
    }
    else if(connection == self.connectionLogIn) {
        [self.dataLogIn appendData:data];
    }
    else if(connection == self.connectionToken) {
        [self.dataToken appendData:data];
    }
    else if(connection == self.connectionUser) {
        [self.dataUser appendData:data];
    }
    else if(connection == self.connectionTopUp) {
        [self.dataTopUp appendData:data];
    }else if(connection == self.connectionHistory) {
        [self.dataHistory appendData:data];
    }else if(connection == self.connectionForgot) {
        [self.dataForgot appendData:data];
    }else if(connection == self.connectionReset) {
        [self.dataReset appendData:data];
    }else if(connection == self.connectionMembership) {
        [self.dataMembership appendData:data];
    }
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
   // NSLog(@"data recieved %@",data);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Did fail with error %@" , [error localizedDescription]);
   
    //LOADING IMAGE
    [(ParseStarterProjectViewController*)myDelegate stopLoading];
    
    //ALERT VIEW PROMPT
    //SHOW INFO TO USER
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong."
                                                    message:@"Check your connection settings or try again. If the problem persits try closing the app properly and starting again."
                                                   delegate:self
                                          cancelButtonTitle:@"Thanks"
                                          otherButtonTitles:nil];
    alert.tag = 69;
    [alert show];
    
    
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection == self.connectionSignUp) {
        //GET STRING FROM DATA RETURNED
        NSString *responseString = [[NSString alloc] initWithData:dataSignUp encoding:NSUTF8StringEncoding];
        NSLog(@"data done %@",responseString);
        NSError *e = nil;
        
        //BUILD JSON DATA
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        //CREATE DICTIONARY
        jsonDataSignUp = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error: &e];
       // NSLog(@"USER DATA DONE:\n %@",jsonDataSignUp);
        //CHECK IF ERROR EXISTS AS KEY
        if ([jsonDataSignUp objectForKey:@"errors"]) {
            signUpTable.view.alpha = 1;
            //NOT SUCESS
            NSLog(@"ERROR %@",[[jsonDataSignUp objectForKey:@"errors"] objectAtIndex:0]);
            
            //BUILD UP ARRAY OF ERRORS
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check your details"
                                                            message:[[jsonDataSignUp objectForKey:@"errors"] componentsJoinedByString:@"\n"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            //LOADING IMAGE
            [(ParseStarterProjectViewController*)myDelegate stopLoading];
            
        }
        else{
            //WORKED
            NSLog(@"USER CREATED %@",[[jsonDataSignUp objectForKey:@"challenge"] objectForKey:@"data"]);
            
            //SAVE USER
            [[NSUserDefaults standardUserDefaults] setObject:signUpTable.password forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:signUpTable.email forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:signUpTable.email forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:[[jsonDataSignUp objectForKey:@"challenge"] objectForKey:@"data"] forKey:@"challenge"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //SET LOGIN DEFAULTS
            logInTable.email = signUpTable.email;
             logInTable.password = signUpTable.password;
            
            
            
            
            //SAVE REF TO DATABASE
            PFObject *testObject = [PFObject objectWithClassName:@"userSignUp"];
            testObject[@"first_name"] = signUpTable.name;
            testObject[@"last_name"] = signUpTable.surname;
            testObject[@"email"] = signUpTable.email;
            testObject[@"username"] = signUpTable.email;
            testObject[@"mobile"] = signUpTable.mobile;
            testObject[@"ref"] = signUpTable.reference;
            [testObject saveInBackground];
            
            
            
            
            userJustSignedUp = TRUE;
            
            //LOGIN
            [self loginUser];
            
        }
        
        
    }
    else if(connection == self.connectionLogIn) {
        //GET STRING FROM DATA RETURNED
        NSString *responseString = [[NSString alloc] initWithData:dataLogIn encoding:NSUTF8StringEncoding];
        NSLog(@"data done %@",responseString);
        NSError *e = nil;
        
        //BUILD JSON DATA
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        //CREATE DICTIONARY
        jsonDataLogIn = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error: &e];
        NSLog(@"LOGIN DATA DONE:\n %@",jsonDataLogIn);
        //CHECK IF ERROR EXISTS AS KEY
        if ([jsonDataLogIn objectForKey:@"errors"]) {
            //NOT SUCESS
            NSLog(@"ERROR %@",[[jsonDataLogIn objectForKey:@"errors"] objectAtIndex:0]);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Again"
                                                            message:[[jsonDataLogIn objectForKey:@"errors"] componentsJoinedByString:@"\n"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            //LOADING IMAGE
            [(ParseStarterProjectViewController*)myDelegate stopLoading];
            
        }
        else{
            //WORKED
            NSLog(@"LOGGED IN %@",jsonDataLogIn);
            userLoggedIn = TRUE;
            
            [[NSUserDefaults standardUserDefaults] setObject:logInTable.email forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:logInTable.email forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:logInTable.password forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //START TOKEN TIMER
            if(tokenTimer){
                [tokenTimer invalidate];
                tokenTimer = NULL;
            }
            
            tokenTimer = [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(loginUser) userInfo:nil repeats:FALSE];
            
            
            //GET TOKEN
            [self getToken];
        }
    }
    else if(connection == self.connectionToken) {
        //GET STRING FROM DATA RETURNED
        NSString *responseString = [[NSString alloc] initWithData:dataToken encoding:NSUTF8StringEncoding];
       // NSLog(@"data done %@",responseString);
        NSError *e = nil;
        
        //BUILD JSON DATA
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        //CREATE DICTIONARY
        jsonDataToken = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error: &e];
        //NSLog(@"USER DATA DONE:\n %@",jsonDataToken);
        //CHECK IF ERROR EXISTS AS KEY
        if ([jsonDataToken objectForKey:@"errors"]) {
            //NOT SUCESS
            NSLog(@"ERROR %@",[[jsonDataToken objectForKey:@"errors"] objectAtIndex:0]);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Again"
                                                            message:[[jsonDataToken objectForKey:@"errors"] componentsJoinedByString:@"\n"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            //LOADING IMAGE
            [(ParseStarterProjectViewController*)myDelegate stopLoading];
            
        }
        else{
            //WORKED
            NSLog(@"TOKEN RECIEVED %@",jsonDataToken);
            
            //SAVE CHALLENGE
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataToken objectForKey:@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //GET USER INFO
            [self getUser];
        }
    }
    else if(connection == self.connectionUser) {
        //GET STRING FROM DATA RETURNED
        NSString *responseString = [[NSString alloc] initWithData:dataUser encoding:NSUTF8StringEncoding];
       // NSLog(@"USER data done %@",responseString);
        NSError *e = nil;
        
        //BUILD JSON DATA
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        //CREATE DICTIONARY
        jsonDataUser = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error: &e];
       // NSLog(@"USER DATA DONE:\n %@",jsonDataUser);
        //CHECK IF ERROR EXISTS AS KEY
        if ([jsonDataUser objectForKey:@"errors"]) {
            //NOT SUCESS
            NSLog(@"ERROR %@",[[jsonDataUser objectForKey:@"errors"] objectAtIndex:0]);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Again"
                                                            message:[[jsonDataUser objectForKey:@"errors"] componentsJoinedByString:@"\n"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            //LOADING IMAGE
            [(ParseStarterProjectViewController*)myDelegate stopLoading];
            
        }
        else{
            //WORKED
            NSLog(@"GET USER %@",jsonDataUser);
            
            //UPDATE CARD AND SAVE ALL INFO
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataUser objectForKey:@"id"] forKey:@"id"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataUser objectForKey:@"username"] forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataUser objectForKey:@"first_name"] forKey:@"first_name"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataUser objectForKey:@"last_name"] forKey:@"last_name"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataUser objectForKey:@"email"] forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataUser objectForKey:@"balance"] forKey:@"balance"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataUser objectForKey:@"third_party_id"] forKey:@"third_party_id"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataUser objectForKey:@"membership_type"] forKey:@"membership_type"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataUser objectForKey:@"pending_balance"] forKey:@"pending_balance"];

            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //CHECK FOR PENDING BALANCE
            if ([[jsonDataUser objectForKey:@"pending_balance"] integerValue] >= 1) {
                //PROMPT
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PENDING BALANCE"
                                                                message:@"Out of hours purchase. Your VINOS will be available from the start of the next business day. (Due to liquor regulations)"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
            //UPDATE TO PARSE LATEST USER INFO
            PFObject *testObject = [PFObject objectWithClassName:@"USER_RECORD"];
            testObject[@"id"] = [jsonDataUser objectForKey:@"id"];
            testObject[@"first_name"] = [jsonDataUser objectForKey:@"first_name"];
            testObject[@"last_name"] = [jsonDataUser objectForKey:@"last_name"];
            testObject[@"email"] = [jsonDataUser objectForKey:@"email"];
            testObject[@"username"] = [jsonDataUser objectForKey:@"username"];
            if ([jsonDataUser objectForKey:@"membership_type"]) {
                testObject[@"membership_type"] = [jsonDataUser objectForKey:@"membership_type"];
            }
            else{
                testObject[@"membership_type"] = @"BASIC";
            }
            testObject[@"balance"] = [jsonDataUser objectForKey:@"balance"];
            testObject[@"pending_balance"] = [jsonDataUser objectForKey:@"pending_balance"];
            testObject[@"third_party_id"] = [jsonDataUser objectForKey:@"third_party_id"];
            [testObject saveInBackground];
            
            //UPDATE USER STATS
            [self updateUserStats];
            
            //GET USER HISTORY
            [self getHistory];
            
            //CHECK IF USER JUST SIGNED UP
            if(userJustSignedUp){
                //PROMPT MEMBERSHIP
                [self openUserMembership];
                
                
                //SHOW REWARD POINTS
                UIAlertView *alert ;
                //CHECK IF REF BLANK
                if([signUpTable.reference isEqualToString:@""]){
                    alert = [[UIAlertView alloc] initWithTitle: [NSString stringWithFormat:@"%@ FREE VINOS",[[NSUserDefaults standardUserDefaults] stringForKey:@"balance"] ]
                                                       message:[NSString stringWithFormat:@"You were AWARDED %@ VINOS",[[NSUserDefaults standardUserDefaults] stringForKey:@"balance"] ]
                                                      delegate:nil
                                             cancelButtonTitle:@"Thanks"
                                             otherButtonTitles:nil   ];

                }
                else{
                    alert = [[UIAlertView alloc] initWithTitle: [NSString stringWithFormat:@"%@ FREE VINOS",[[NSUserDefaults standardUserDefaults] stringForKey:@"balance"] ]
                                                       message:[NSString stringWithFormat:@"You were AWARDED %@ VINOS for using %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"balance"], signUpTable.reference ]
                                                      delegate:nil
                                             cancelButtonTitle:@"Thanks"
                                             otherButtonTitles:nil   ];

                }
                
                //SHOW ALERT WITH AMOUNT OF VINOS RECIEVED
                                [alert show];
                
            }
            userJustSignedUp = false;
            
        }
    }
    else if(connection == self.connectionTopUp) {
        //GET STRING FROM DATA RETURNED
        NSString *responseString = [[NSString alloc] initWithData:dataTopUp encoding:NSUTF8StringEncoding];
        NSLog(@"TOP UP data done %@",responseString);
        NSError *e = nil;
        
        //BUILD JSON DATA
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        //CREATE DICTIONARY
        jsonDataTopUp = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error: &e];
        NSLog(@"TOP UP DATA DONE:\n %@",jsonDataTopUp);
        //CHECK IF ERROR EXISTS AS KEY
        if ([jsonDataTopUp objectForKey:@"errors"]) {
            //NOT SUCESS
            NSLog(@"ERROR %@",[[jsonDataTopUp objectForKey:@"errors"] objectAtIndex:0]);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try again"
                                                            message:[[jsonDataTopUp objectForKey:@"errors"] componentsJoinedByString:@"\n"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            //LOADING IMAGE
            [(ParseStarterProjectViewController*)myDelegate stopLoading];
            
        }
        else{
            //WORKED
            NSLog(@"TOP UP WORKED %@",jsonDataTopUp);
            
            //GET CHECKOUT ID
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataTopUp objectForKey:@"checkout_id"] forKey:@"checkout_id"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataTopUp objectForKey:@"checkout_uri"] forKey:@"checkout_uri"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //CREATE WEB VIEW WITH CHECKOUT ID
            myPaymentPage = [[UIWebView alloc] initWithFrame:self.bounds];
            myPaymentPage.delegate = self;
            myPaymentPage.backgroundColor = [UIColor whiteColor];
            //NSString *myHTML = [NSString stringWithFormat:@"<html><head><script src=\"https://code.jquery.com/jquery.js\" type=\"text/javascript\"></script><script type=\"text/javascript\">var wpwlOptions = {onReady: function(){var createRegistrationHtml = '<div class=\"customLabel\">Store card?</div><div class=\"customInput\"><input type=\"checkbox\" name=\"createRegistration\" value=\"true\" /></div>';$('form.wpwl-form-card').find('.wpwl-button').before(createRegistrationHtml); }}</script><script async src=\"%@%@\" type=\"text/javascript\"></script></head><body><form action=\"http://www.myvinos.club\" class=\"paymentWidgets\">VISA MASTER AMEX</form></body></html>",[[NSUserDefaults standardUserDefaults] stringForKey:@"checkout_uri"],[[NSUserDefaults standardUserDefaults] stringForKey:@"checkout_id"]];
            
            
            
            
            NSString *myHTML = [NSString stringWithFormat:@"<html><head><script src=\"%@%@\"></script><style>html,body  {background-color:white;}.wpwl-container  {background-color:white;color: black;}.wpwl-form { color: black;background-color:white;font-family: Helvetica, Arial, sans-serif !important;}</style></head><body><form action=\"http://www.myvinos.club\" class=\"paymentWidgets\">VISA MASTER AMEX</form></body></html>",[[NSUserDefaults standardUserDefaults] stringForKey:@"checkout_uri"],[[NSUserDefaults standardUserDefaults] stringForKey:@"checkout_id"]];
            
           
            
            [myPaymentPage loadHTMLString:myHTML baseURL:nil];
            /*
             CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = myPaymentPage.bounds;
            gradient.startPoint = CGPointMake(0.5, 0);
            gradient.endPoint = CGPointMake(0.5,1);
            gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor purpleColor] CGColor], (id)[[UIColor colorWithRed:75.0f/255.0f green:12.0f/255.0f blue: 39.0f/255.0f alpha:1.0f] CGColor], nil];
            [myPaymentPage.layer insertSublayer:gradient atIndex:0];
             */
            [self addSubview:myPaymentPage];
            
            [self cancelCredits];
            
            //START FAIL TIMER
            //UPDATE USER DETAILS - 30secs
            paymentTimeLimitTimer = [NSTimer scheduledTimerWithTimeInterval:3000.0
                                             target:self
                                           selector:@selector(paymentTimeExpired)
                                           userInfo:nil
                                            repeats:NO];
            
        }
    }
    else if(connection == self.connectionHistory) {
        //GET STRING FROM DATA RETURNED
        NSString *responseString = [[NSString alloc] initWithData:dataHistory encoding:NSUTF8StringEncoding];
       // NSLog(@"HISTORY data done %@",responseString);
        NSError *e = nil;
        
        //BUILD JSON DATA
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        //CREATE DICTIONARY
        jsonDataHistory = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error: &e];
       // NSLog(@"HISTORY DATA DONE:\n %@",jsonDataHistory);
        
        //CHECK FOR ARRAY
        if ([jsonDataHistory isKindOfClass:[NSArray class]]){//Added instrospection as suggested in comment.
            for (NSDictionary *dictionary in jsonDataHistory) {
                //NSLog(@"\n\nTRANSACTION HISTORY FOUND - %@",dictionary);
                
                //ADD TO SCROLL VIEW AND ADD
                
                
            }
            
            [self buildCreditHistoryDisplay];
             [self buildDeliveryHistoryDisplay];
        }
        else {
            NSLog(@"NO HISTORY FOUND");
        }
        
        //LOADING IMAGE
        [(ParseStarterProjectViewController*)myDelegate stopLoading];
        
        /*/CHECK IF ERROR EXISTS AS KEY
        if ([jsonDataHistory objectForKey:@"errors"]) {
            //NOT SUCESS
           // NSLog(@"ERROR %@",[[jsonDataHistory objectForKey:@"errors"] objectAtIndex:0]);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS"
                                                            message:[[jsonDataHistory objectForKey:@"errors"] objectAtIndex:0]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        else{
            //WORKED
            NSLog(@"HISTORY WORKED %@",jsonDataHistory);
            
            //UPDATE SCREENS
            
        }
        */
        
        
        
        //REMOVE ALL VIEWS
        
        
        
    }else if(connection == self.connectionForgot) {
        //GET STRING FROM DATA RETURNED
        NSString *responseString = [[NSString alloc] initWithData:dataForgot encoding:NSUTF8StringEncoding];
        NSLog(@"data done %@",responseString);
        NSError *e = nil;
        
        //BUILD JSON DATA
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        //CREATE DICTIONARY
        jsonDataForgot = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error: &e];
        NSLog(@"OTP DATA DONE:\n %@",jsonDataForgot);
        //CHECK IF ERROR EXISTS AS KEY
        if ([jsonDataForgot objectForKey:@"errors"]) {
            //NOT SUCESS
            NSLog(@"ERROR %@",[[jsonDataForgot objectForKey:@"errors"] objectAtIndex:0]);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try again"
                                                            message:[[jsonDataForgot objectForKey:@"errors"] componentsJoinedByString:@"\n"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            //REMOVE FORGOT TABLE
            //SHOW TABLE
            [UIView beginAnimations:NULL context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration:0.15f];
            forgotTable.view.alpha = 0.0f;
            [UIView commitAnimations];
            
            //LOADING IMAGE
            [(ParseStarterProjectViewController*)myDelegate stopLoading];
            
        }
        else{
            //WORKED
            NSLog(@"FORGOT WORKED %@",jsonDataForgot);
            
            
            //SHOW TABLE
            [UIView beginAnimations:NULL context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration:0.15f];
            forgotTable.view.alpha = 1.0f;
            [UIView commitAnimations];
            
            //LOADING IMAGE
            [(ParseStarterProjectViewController*)myDelegate stopLoading];
            
            //INFORM USER
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We sent you a SMS"
                                                            message:@"Check your SMS and enter your pin to reset your password."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }
    }else if(connection == self.connectionReset) {
        //GET STRING FROM DATA RETURNED
        NSString *responseString = [[NSString alloc] initWithData:dataReset encoding:NSUTF8StringEncoding];
        NSLog(@"data done %@",responseString);
        NSError *e = nil;
        
        //BUILD JSON DATA
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        //CREATE DICTIONARY
        jsonDataReset = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error: &e];
        NSLog(@"RESET DATA DONE:\n %@",jsonDataReset);
        //CHECK IF ERROR EXISTS AS KEY
        if ([jsonDataReset objectForKey:@"errors"]) {
            //NOT SUCESS
            NSLog(@"ERROR %@",[[jsonDataReset objectForKey:@"errors"] objectAtIndex:0]);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try again"
                                                            message:[[jsonDataReset objectForKey:@"errors"] componentsJoinedByString:@"\n"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            //LOADING IMAGE
            [(ParseStarterProjectViewController*)myDelegate stopLoading];
            
        }
        else{
            //WORKED
            NSLog(@"RESET IN %@",jsonDataReset);
            
            //SAVE USER
            [[NSUserDefaults standardUserDefaults] setObject:forgotTable.password forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:forgotTable.email forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:forgotTable.email forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done"
                                                            message:@"Your password has been reset, we will log you in."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            //HIDE TABLE
            [UIView beginAnimations:NULL context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration:0.15f];
            forgotTable.view.alpha = 0.0f;
            [UIView commitAnimations];
            
            //LOADING IMAGE
            [(ParseStarterProjectViewController*)myDelegate stopLoading];
            
            //AUTO LOGIN
            //SET LOGIN DEFAULTS
            logInTable.email = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
            forgotTable.email = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
            logInTable.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
            
            //LOGIN
            [self loginUser];
            
            
        }
    }else if(connection == self.connectionMembership) {
        //GET STRING FROM DATA RETURNED
        NSString *responseString = [[NSString alloc] initWithData:dataMembership encoding:NSUTF8StringEncoding];
        NSLog(@"MEMBERSHIP data done %@",responseString);
        NSError *e = nil;
        
        //BUILD JSON DATA
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        //CREATE DICTIONARY
        jsonDataMembership = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error: &e];
        NSLog(@"MEMEBRSHIP DATA DONE:\n %@",jsonDataMembership);
        //CHECK IF ERROR EXISTS AS KEY
        if ([jsonDataMembership objectForKey:@"errors"]) {
            //NOT SUCESS
            NSLog(@"ERROR %@",[[jsonDataMembership objectForKey:@"errors"] objectAtIndex:0]);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try again"
                                                            message:[[jsonDataMembership objectForKey:@"errors"] componentsJoinedByString:@"\n"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            //LOADING IMAGE
            [(ParseStarterProjectViewController*)myDelegate stopLoading];
            
        }
        if ([[jsonDataMembership objectForKey:@"checkout_uri"] isKindOfClass:[NSNull class]]) {
            //MEMBERSHIP WORKED AND USER SELECTED FREE SO NO PAYMENT TO SHOW
            NSLog(@"MEMBERSHIP WORKED NO PAYMENT NEEDED");
            
            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DONE"
                                                            message:[jsonDataMembership objectForKey:@"memo"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            */
            
            //LOADING IMAGE
            [(ParseStarterProjectViewController*)myDelegate stopLoading];
            
            //UPDATE USER STATS
            [self getUser];
        }
        else{
            //WORKED
            NSLog(@"MEMEBERSHIP WORKED %@",jsonDataMembership);
            
            //GET CHECKOUT ID
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataMembership objectForKey:@"checkout_id"] forKey:@"checkout_id"];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonDataMembership objectForKey:@"checkout_uri"] forKey:@"checkout_uri"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //CREATE WEB VIEW WITH CHECKOUT ID
            myPaymentPage = [[UIWebView alloc] initWithFrame:self.bounds];
            myPaymentPage.delegate = self;
            myPaymentPage.backgroundColor = [UIColor whiteColor];
            
            NSString *myHTML = [NSString stringWithFormat:@"<html><head><script src=\"%@%@\"></script><style>html,body  {background-color:white;}.wpwl-container  {background-color:white;color: black;}.wpwl-form { color: black;background-color:white;font-family: Helvetica, Arial, sans-serif !important;}</style></head><body><form action=\"http://www.myvinos.club\" class=\"paymentWidgets\">VISA MASTER AMEX</form></body></html>",[[NSUserDefaults standardUserDefaults] stringForKey:@"checkout_uri"],[[NSUserDefaults standardUserDefaults] stringForKey:@"checkout_id"]];
            
            
            
            [myPaymentPage loadHTMLString:myHTML baseURL:nil];
            
            [self addSubview:myPaymentPage];
            
            [self cancelMembership];
            
            //START FAIL TIMER
            //UPDATE USER DETAILS - 30secs
            paymentTimeLimitTimer = [NSTimer scheduledTimerWithTimeInterval:3000.0
                                                                     target:self
                                                                   selector:@selector(paymentTimeExpired)
                                                                   userInfo:nil
                                                                    repeats:NO];
            
        }
    }
    
   
    
}



-(void)paymentTimeExpired{
    NSLog(@"PAYMENT TIME EXPIRED");
    [paymentTimeLimitTimer invalidate];
    paymentTimeLimitTimer = NULL;
    
    //REMOVE WEB VIEW
    [myPaymentPage removeFromSuperview];
    myPaymentPage = NULL;
    
    //SHOW ALERT
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment time expired"
                                                    message:@"For your security, please try again and have your payment details at hand\n\nOr call us for personal assistance on +27 (78) 7860307."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"SHOULD START LOADING %@",request.URL.host);
    
    if([request.URL.host isEqualToString:@"www.myvinos.club"]){
        NSLog(@"PAYMENT PENDING");
        //STOP TIMER
        [paymentTimeLimitTimer invalidate];
        paymentTimeLimitTimer = NULL;
        
        //REMOVE WEBVIEW
        [myPaymentPage removeFromSuperview];
        myPaymentPage = nil;
        
        //SHOW LOADING SCREEN
        [myDelegate startLoadingNow:@"Processing Payment"];
        
        //UPDATE USER DETAILS - 30secs
        [NSTimer scheduledTimerWithTimeInterval:35.0
                                         target:self
                                       selector:@selector(getUser)
                                       userInfo:nil
                                        repeats:NO];
        
        return NO;
    }
    else{
        return YES;
    }
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"WEBVIEW START LOADING %@",webView.request.URL.absoluteString);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"WEBVIEW FINISH LOADING %@",webView.request.URL.absoluteString);
    
    [(ParseStarterProjectViewController*)myDelegate stopLoading];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        // do something here...
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   
    
    
}



void freeRawData(void *info, const void *data, size_t size) {
    free((unsigned char *)data);
}

- (UIImage *)quickResponseImageForString:(NSString *)dataString withDimension:(int)imageWidth {
    
    QRcode *resultCode = QRcode_encodeString([dataString UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    
    unsigned char *pixels = (*resultCode).data;
    int width = (*resultCode).width;
    int len = width * width;
    
    if (imageWidth < width)
        imageWidth = width;
    
    // Set bit-fiddling variables
    int bytesPerPixel = 4;
    int bitsPerPixel = 8 * bytesPerPixel;
    int bytesPerLine = bytesPerPixel * imageWidth;
    int rawDataSize = bytesPerLine * imageWidth;
    
    int pixelPerDot = imageWidth / width;
    int offset = (int)((imageWidth - pixelPerDot * width) / 2);
    
    // Allocate raw image buffer
    unsigned char *rawData = (unsigned char*)malloc(rawDataSize);
    memset(rawData, 0xFF, rawDataSize);
    
    // Fill raw image buffer with image data from QR code matrix
    int i;
    for (i = 0; i < len; i++) {
        char intensity = (pixels[i] & 1) ? 0x00 : 0xFF;
        
        int y = i / width;
        int x = i - (y * width);
        
        int startX = pixelPerDot * x * bytesPerPixel + (bytesPerPixel * offset);
        int startY = pixelPerDot * y + offset;
        int endX = startX + pixelPerDot * bytesPerPixel;
        int endY = startY + pixelPerDot;
        
        int my;
        for (my = startY; my < endY; my++) {
            int mx;
            for (mx = startX; mx < endX; mx += bytesPerPixel) {
                rawData[bytesPerLine * my + mx    ] = intensity;    //red
                rawData[bytesPerLine * my + mx + 1] = intensity;    //green
                rawData[bytesPerLine * my + mx + 2] = intensity;    //blue
                rawData[bytesPerLine * my + mx + 3] = 255;          //alpha
            }
        }
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rawData, rawDataSize, (CGDataProviderReleaseDataCallback)&freeRawData);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(imageWidth, imageWidth, 8, bitsPerPixel, bytesPerLine, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    UIImage *quickResponseImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    QRcode_free(resultCode);
    
    return quickResponseImage;
}


@end
