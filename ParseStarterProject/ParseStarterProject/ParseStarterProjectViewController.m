//
//  ParseStarterProjectViewController.m
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

/*

 
 
 
 
 - BIGGER BOTTLES, MAX 6 
 - ALWAYS SHOW TEXT DESCRIPTION
 - FAVOURTIES PACK
 - move icons up for order
 
 
 */

#import "ParseStarterProjectViewController.h"
#import <Parse/Parse.h>
#import "Deck.h"
#import "Card.h"
#import "User.h"
#import "Deliver.h"
#import "DeliveryDeck.h"
#import "Reachability.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioSession.h>


#define MYVINOSSERVER @"https://myvinos-api.infinity-g.com"


#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)


#define TOPNAVHEIGHT screenSize.height*0.11
#define SELECTIONSCREENSIZE screenSize.height*0.89
#define TOPNAV CGRectMake(0,0,screenSize.width,TOPNAVHEIGHT)
#define CONTENTVIEW CGRectMake(0,TOPNAVHEIGHT,screenSize.width,SELECTIONSCREENSIZE)
#define DELIVERVIEW CGRectMake(screenSize.width*0.025,screenSize.height*0.1,screenSize.width*0.95,SELECTIONSCREENSIZE*0.75)

#define USERVIEW CGRectMake(0,TOPNAVHEIGHT,screenSize.width,SELECTIONSCREENSIZE*0.4)




@interface ParseStarterProjectViewController (){
    
    NSMutableDictionary *jsonDataProduct;
    
    
    CGSize screenSize;
    NSMutableData *collectionData;
    BOOL splashComplete;
    BOOL userOpen;
    BOOL inAppLoading;
    
    //MAIN DATA
    NSMutableArray *cardDecks;
    
    //SELECTION SCREEN
    UIView *selectionScreen;
    
    UIView *topNavHolder;
    
    UIImageView *logo;
    
    //USER SCREEN
    User *user;
    UILabel *userVinosLabel;
    UILabel *userVinosLabelTxt;
    
    Deliver *deliver;
    Deck *deliveryDeck;
    
    UIButton *deliverButton;
    UILabel *deliverLabel;
    
    UIView *loadingScreen2;
    UILabel *loadingLabel;
    UILabel *loadingLabel2;

    id lastOpenDeck;
  
    BOOL isStillLoading;
    
    BOOL connectionRequired;
    
    UIButton *fullscreenCloseBut;
    
    UITapGestureRecognizer *logoTapped;
    
}

@property (retain, nonatomic) NSMutableDictionary *jsonDataProduct;

@property (retain, nonatomic) NSMutableData *collectionData;
@property (retain, nonatomic) NSMutableArray *cardDecks;

@property (retain, nonatomic) UIView *selectionScreen;

@property (retain, nonatomic) UIView *topNavHolder;

@property (retain, nonatomic) UIImageView *logo;

@property (retain, nonatomic) User *user;
@property (retain, nonatomic) UILabel *userVinosLabel;
@property (retain, nonatomic) UILabel *userVinosLabelTxt;

@property (retain, nonatomic) Deliver *deliver;
@property (retain, nonatomic) Deck *deliveryDeck;

@property (strong, nonatomic) UIView *loadingScreen2;
@property (strong, nonatomic) UILabel *loadingLabel;
@property (strong, nonatomic) UILabel *loadingLabel2;

@property (strong, nonatomic) UIButton *deliverButton;
@property (retain, nonatomic) UILabel *deliverLabel;

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@property (strong, nonatomic)  UIButton *fullscreenCloseBut;

@property (strong, nonatomic) UITapGestureRecognizer *logoTapped;

@end



@implementation ParseStarterProjectViewController

@synthesize loadingScreen2,deliverLabel;

#pragma mark - UIViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSLog(@"Hello APP LAUNCH");
    isStillLoading = FALSE;
     splashComplete = FALSE;
    userOpen = FALSE;
    connectionRequired = FALSE;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //REACHABILITY
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.myvinos.club";
    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    //self.remoteHostLabel.text = [NSString stringWithFormat:remoteHostLabelFormatString, remoteHostName];
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [self updateInterfaceWithReachability:self.wifiReachability];

    
    /*
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5,1);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor purpleColor] CGColor], (id)[[UIColor colorWithRed:75.0f/255.0f green:12.0f/255.0f blue: 39.0f/255.0f alpha:1.0f] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    */
    
    
    //WAIT FOR CONNECTION
    
    
    
    
    
    //GET SCREEN SIZE
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    screenSize = CGSizeMake(screenBounds.size.width, screenBounds.size.height);
    NSLog(@"screenSize width %f height %f",screenBounds.size.width,screenBounds.size.height);
    
    //CREATE MEMORY ARRAYS
    cardDecks = [[NSMutableArray alloc] init];
    collectionData = [[NSMutableData alloc] init];
    
    //TOP NAV
    topNavHolder = [[UIView alloc] initWithFrame:TOPNAV];
    topNavHolder.backgroundColor = [UIColor whiteColor];
    topNavHolder.alpha = 0.0f;
    
    /*
     CAGradientLayer *gradientNav = [CAGradientLayer layer];
    gradientNav.frame = topNavHolder.bounds;
    gradientNav.startPoint = CGPointMake(0.5, 0);
    gradientNav.endPoint = CGPointMake(0.5,10);
    gradientNav.colors = [NSArray arrayWithObjects:(id)[[UIColor purpleColor] CGColor], (id)[[UIColor colorWithRed:75.0f/255.0f green:12.0f/255.0f blue: 39.0f/255.0f alpha:1.0f] CGColor], nil];
    [topNavHolder.layer insertSublayer:gradientNav atIndex:0];
    */
    
    
    
   
    
    
    
   
    //BUILD SHIT
   
    [self loadDelivery];
    
    //SET UP LOADING SCREEN
    loadingScreen2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    loadingScreen2.alpha = 1.0f;
    loadingScreen2.userInteractionEnabled = FALSE;
    loadingScreen2.backgroundColor = [UIColor whiteColor];
   
     [self showLogo];
    
    
    
    
     [self.view addSubview:topNavHolder];
    [self loadUser];
     [self createSelectionScreen];
    
    //CHECK TO END SPLASH
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(endLoadandStartAPP:)
                                   userInfo:nil
                                    repeats:NO];
    
    
    
    //ADD DEVICE STATS TO PARSE
    PFObject *testObject = [PFObject objectWithClassName:@"APP_LAUNCH"];
    testObject[@"device"] = @"iOS";
    testObject[@"version"] = @"2.85";
    
    
    //CHECK FOR USER
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"SAVING DATA %@ %@",[defaults stringForKey:@"username"],[defaults stringForKey:@"balance"]);
    if([defaults objectForKey:@"id"]){
        testObject[@"id"] = [defaults stringForKey:@"id"];
    }
    if([defaults objectForKey:@"first_name"]){
        testObject[@"first_name"] = [defaults stringForKey:@"first_name"];
    }
    if([defaults objectForKey:@"last_name"]){
        testObject[@"last_name"] = [defaults stringForKey:@"last_name"];
    }
    if([defaults objectForKey:@"email"]){
        testObject[@"email"] = [defaults stringForKey:@"email"];
    }
    if([defaults objectForKey:@"username"]){
        testObject[@"username"] = [defaults stringForKey:@"username"];
    }
    if([defaults objectForKey:@"balance"]){
        testObject[@"balance"] = [defaults stringForKey:@"balance"];
    }
    if([defaults objectForKey:@"pending_balance"]){
        testObject[@"pending_balance"] = [defaults stringForKey:@"pending_balance"];
    }
    if([defaults objectForKey:@"third_party_id"]){
        testObject[@"third_party_id"] = [defaults stringForKey:@"third_party_id"];
    }
    
    
    
    
    
    
        [testObject saveInBackground];
    
    
    
    [self.view addSubview:loadingScreen2];
    [self.view addSubview:logo];
    
    
     NSLog(@"VIEW DONE");
    
   
    
    //SET UP FULLSCREEN CLOSE BUT
    fullscreenCloseBut = [UIButton buttonWithType:UIButtonTypeCustom];
    fullscreenCloseBut.frame = CGRectMake(0, screenSize.height-TOPNAVHEIGHT , screenSize.width, TOPNAVHEIGHT);
    fullscreenCloseBut.backgroundColor = [UIColor clearColor];
    fullscreenCloseBut.alpha = 0;
    fullscreenCloseBut.userInteractionEnabled = TRUE;
    [fullscreenCloseBut addTarget:self action:@selector(closeFullscreenCardBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fullscreenCloseBut];
    
    
    
    /* [NSTimer scheduledTimerWithTimeInterval:2.0
     target:nil
     selector:@selector(waitForConnectionForAppStart)
     userInfo:nil
     repeats:NO];
     
     
     */
    
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(waitForConnectionForAppStart) userInfo:nil repeats:NO];

    
   // [self waitForConnectionForAppStart];
}

-(void)waitForConnectionForAppStart{
    
    NSLog(@"WAIT FOR CONNECTION APP START %i",connectionRequired);
    
    //CHECK FOR INTERNET
    if(connectionRequired){
        NSLog(@"CONENCTION FOUND");
        
        
        //LOAD PRODUCT DATA
        [self loadCollectionData];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"On-Demand Delivery"
                                                        message:@"This app requires an internet connection to retrieve the latest items from your Wine Cellar.\n\nCheck your connection setting and try agian."
                                                       delegate:self
                                              cancelButtonTitle:@"Try Again"
                                              otherButtonTitles:nil];
        alert.tag = 99;
        [alert show];
        
    }

}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 99){
        NSLog(@"TRY PRODUCTS AGAIN");
        [self waitForConnectionForAppStart];
    }
    else if(alertView.tag == 11){
        if (buttonIndex == 0) {
            NSLog(@"CLEAR DELIVERY");
        }
        else{
            NSLog(@"MAKE DELIVERY");
            [deliver makeDelivery];
        }
        
    }
    else if(alertView.tag == 41){
        [self closeFullscreenCardBut];
        [self showSelectionScreen];
    }
   
    
    
}


-(void)startLoadingNow:(NSString*)lStatus{
    NSLog(@"START LOADING");
    
    //SET LOADING LABEL
    loadingLabel.text = lStatus;
    
    if(!inAppLoading){
        //START LOADING
        inAppLoading = TRUE;
        
        [logo removeGestureRecognizer:logoTapped];
        [self.view bringSubviewToFront:loadingScreen2];
        [self.view addSubview:logo];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.15f];
        //MOVE/SET LOGO SIZE..
        logo.frame = CGRectMake(screenSize.width*0.325, 0, screenSize.width*0.35, screenSize.height);
        loadingScreen2.layer.opacity = 1.0f;
        loadingScreen2.alpha = 1.0f;
        loadingLabel.alpha = 1.0f;
        loadingLabel2.alpha = 1.0f;
        [UIView commitAnimations];
        
        //START ANIMATION TIMER
        [NSTimer scheduledTimerWithTimeInterval:0.5
                                         target:self
                                       selector:@selector(endInAppLoading:)
                                       userInfo:nil
                                        repeats:NO];
        
    }
    else{
        //ALREADY LOADING
        
    }
    
    
   

    
    
}

-(void)stopLoading{
    NSLog(@"STOP LOADING");
    
    inAppLoading = FALSE;
    
   

    
}

-(void)endInAppLoading:(NSTimer*)myTimer{
    NSLog(@"CHECK TO END APP?? ");
    
    [myTimer invalidate];
    myTimer = nil;
    
    if(!inAppLoading){
        //UPDATE LOGO
        [topNavHolder addSubview:logo];
        [logo stopAnimating];
        [logo setImage:[UIImage imageNamed:@"VinosBlank_00085.png"]];
        
        [logo addGestureRecognizer:logoTapped];
        
        //SHOW SCREEN - REMOVE LOADING SCREEN
        //[topNavHolder addSubview:logo];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.05f];
        //MOVE/SET LOGO SIZE..
        logo.frame = CGRectMake(screenSize.width*0.35f, 0, screenSize.width*0.3, TOPNAVHEIGHT);
        //logo.frame = CGRectMake(screenSize.width*0.325, 0, screenSize.width*0.35, screenSize.height);
        loadingScreen2.alpha = 0.0f;
        loadingLabel.alpha = 0.0f;
        loadingLabel2.alpha = 0.0f;
        loadingScreen2.layer.opacity = 0.0f;
        [UIView commitAnimations];
        
        
    }
    else{
        
        
        //REVERSE ANIMATION IMAGES
        logo.animationDuration=1.1;
        logo.animationRepeatCount=0;
        NSMutableArray *imgListArray = [NSMutableArray array];
        for (int i=85; i >= 50; i--) {
            NSString *strImgeName = [NSString stringWithFormat:@"VinosBlank_%05d.png", i];
            UIImage *image = [UIImage imageNamed:strImgeName];
            if (!image) {
                NSLog(@"Could not load image named: %@", strImgeName);
            }
            else {
                [imgListArray addObject:image];
            }
        }
        
        [logo setAnimationImages:imgListArray];
        if([ logo isAnimating]){[logo stopAnimating];}
        [logo startAnimating];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(reverseLogoLoading:)
                                       userInfo:nil
                                        repeats:NO];
    }
}

-(void)endLoadandStartAPP:(NSTimer*)myTimer{
    NSLog(@"CHECK TO END APP?? ");
    
    [myTimer invalidate];
    myTimer = nil;
    
    if(splashComplete){
        //UPDATE LOGO
        [self.view addSubview:logo];
        [logo stopAnimating];
        [logo setImage:[UIImage imageNamed:@"VinosBlank_00085.png"]];
        
        //ANIMATE LOGO
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDidStopSelector:@selector(logoDone)];
        [UIView setAnimationDuration:0.9f];
        [UIView setAnimationDelay:0.0f];
         topNavHolder.alpha = 1.0f;
        logo.frame = CGRectMake(screenSize.width*0.35f, 0, screenSize.width*0.3, TOPNAVHEIGHT);
        loadingLabel.alpha = 0.0f;
        loadingLabel2.alpha = 0.0f;
        [UIView commitAnimations];
        
        
        
     

    }
    else{
       
        
        //REVERSE ANIMATION IMAGES
        logo.animationDuration=1.1;
        logo.animationRepeatCount=0;
        NSMutableArray *imgListArray = [NSMutableArray array];
        for (int i=85; i >= 50; i--) {
            NSString *strImgeName = [NSString stringWithFormat:@"VinosBlank_%05d.png", i];
            UIImage *image = [UIImage imageNamed:strImgeName];
            if (!image) {
                NSLog(@"Could not load image named: %@", strImgeName);
            }
            else {
                [imgListArray addObject:image];
            }
        }
        
        [logo setAnimationImages:imgListArray];
        if([ logo isAnimating]){[logo stopAnimating];}
        [logo startAnimating];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(reverseLogoAnimation:)
                                       userInfo:nil
                                        repeats:NO];
    }
}

-(void)logoDone{
    NSLog(@"LOGO DONE");
    
    //ADD LOGO TAP
    loadingScreen2.alpha = 0.0f;
    logoTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCloseUser)];
    logoTapped.numberOfTapsRequired = 1;
    [logo addGestureRecognizer:logoTapped];
    
    
     [topNavHolder addSubview:logo];
    
    //CREATE DECKS
    [self createAllDecks];
    
    //ANIMATE NAVBAR
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.9f];
    selectionScreen.alpha = 1.0f;
    //deckBut.alpha = 0.0f;
    //filterTxt.alpha = 1.0f;
    //filterBut.alpha = 0.0f;
    [UIView commitAnimations];
    
    //SHOW USER SCREEN
   // [self openCloseUser];
    
    //CHECK IF USER IS LOGGED IN AND LOG IN
    [user checkForAutoUserLogIn];

}

-(void)reverseLogoAnimation:(NSTimer*)myTimer{
    [myTimer invalidate];
    myTimer = NULL;
    
    //RE-REVERSE ANIMATION IMAGES
    logo.animationDuration=1.1;
    logo.animationRepeatCount=0;
    NSMutableArray *imgListArray = [NSMutableArray array];
    for (int i=50; i <= 84; i++) {
        NSString *strImgeName = [NSString stringWithFormat:@"VinosBlank_%05d.png", i];
        UIImage *image = [UIImage imageNamed:strImgeName];
        if (!image) {
            NSLog(@"Could not load image named: %@", strImgeName);
        }
        else {
            [imgListArray addObject:image];
        }
    }
    // [logo stopAnimating];
    [logo setAnimationImages:imgListArray];
    if([ logo isAnimating]){[logo stopAnimating];}
    [logo startAnimating];
    
    

    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(endLoadandStartAPP:)
                                   userInfo:nil
                                    repeats:NO];
    
    
    
    
}

-(void)reverseLogoLoading:(NSTimer*)myTimer{
    [myTimer invalidate];
    myTimer = NULL;
    
    //RE-REVERSE ANIMATION IMAGES
    logo.animationDuration=1.1;
    logo.animationRepeatCount=0;
    NSMutableArray *imgListArray = [NSMutableArray array];
    for (int i=50; i <= 84; i++) {
        NSString *strImgeName = [NSString stringWithFormat:@"VinosBlank_%05d.png", i];
        UIImage *image = [UIImage imageNamed:strImgeName];
        if (!image) {
            NSLog(@"Could not load image named: %@", strImgeName);
        }
        else {
            [imgListArray addObject:image];
        }
    }
    // [logo stopAnimating];
    [logo setAnimationImages:imgListArray];
    if([ logo isAnimating]){[logo stopAnimating];}
    [logo startAnimating];
    
    
    //CHECK IF APP ALREADY LOADED
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(endInAppLoading:)
                                   userInfo:nil
                                    repeats:NO];
    
   
    
    
    
}

#pragma mark -
#pragma mark SELECTION SCREEN

-(void)createSelectionScreen{
    
    //CREATE CONTAINER
    selectionScreen = [[UIView alloc] initWithFrame:CONTENTVIEW];
    selectionScreen.backgroundColor = [UIColor clearColor];;
    selectionScreen.alpha = 1.0f;
    selectionScreen.frame = CGRectMake(0, TOPNAVHEIGHT, selectionScreen.bounds.size.width, selectionScreen.bounds.size.height);
    //selectionScreen.transform = CGAffineTransformMakeScale(0.55, 0.55);
    //selectionScreen.backgroundColor=[UIColor colorWithRed:163/255.0f green:118/255.0f blue:163/255.0f alpha:1.0f];
    
    //CREATE HEADINGS
    
    //WINE COLLECTIONS
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(selectionScreen.bounds.size.width*0.05, 0 ,screenSize.width*0.9, selectionScreen.bounds.size.height*0.05)];
    //tf.textColor = [UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
    tf.textColor = [UIColor blackColor];
    tf.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:(tf.bounds.size.height*0.5)];
    tf.backgroundColor=[UIColor clearColor];
    tf.userInteractionEnabled = FALSE;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.text=@"Your Wine Collections:";
    //[selectionScreen addSubview:tf];
 
    
    [self.view addSubview:selectionScreen];
   
    
}


#pragma mark -
#pragma mark USER
- (void)loadUser {
     NSLog(@"LOAD USER");
    
    
    user = [[User alloc] initWithFrame:USERVIEW];
    user.myDelegate = self;
    //user.alpha = 0.0f;
    //user.frame = CONTENTVIEW;
    user.frame = CGRectMake(0,-screenSize.height,screenSize.width,SELECTIONSCREENSIZE);
    

    [self.view addSubview:user];
    
    
    //SHOW USER LABEL
    //userVinosLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width*0.62, 0, screenSize.width*0.22, TOPNAVHEIGHT)];
    userVinosLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width*0.005, 0, screenSize.width*0.14, TOPNAVHEIGHT)];
    userVinosLabel.textAlignment =  NSTextAlignmentRight;
    userVinosLabel.backgroundColor = [UIColor clearColor];
    userVinosLabel.textColor = [UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
    userVinosLabel.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(TOPNAVHEIGHT*0.23)];
    userVinosLabel.alpha = 1.0f;
   // userVinosLabel.font = [UIFont boldSystemFontOfSize:(userVinosLabel.bounds.size.height*0.22)];
    userVinosLabel.userInteractionEnabled = TRUE;
    [userVinosLabel setText:@"GET"];
    [topNavHolder addSubview:userVinosLabel];
    
    //VINOS TXT
    //userVinosLabelTxt = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width*0.85, 0, screenSize.width*0.18, TOPNAVHEIGHT)];
    userVinosLabelTxt = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width*0.145, 0, screenSize.width*0.18, TOPNAVHEIGHT)];
    userVinosLabelTxt.textAlignment =  NSTextAlignmentLeft;
    userVinosLabelTxt.backgroundColor = [UIColor clearColor];
    userVinosLabelTxt.textColor = [UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
    userVinosLabelTxt.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(TOPNAVHEIGHT*0.23)];
    userVinosLabelTxt.userInteractionEnabled = TRUE;
    userVinosLabelTxt.alpha = 1.0f;
    [userVinosLabelTxt setText:@"VINOS"];
    [topNavHolder addSubview:userVinosLabelTxt];
    
    //ADD BUY CREDITS
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCloseUserBuy)];
    tapped.numberOfTapsRequired = 1;
    [userVinosLabel addGestureRecognizer:tapped];
    
    UITapGestureRecognizer *tapped2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCloseUserBuy)];
    tapped2.numberOfTapsRequired = 1;
    [userVinosLabelTxt addGestureRecognizer:tapped2];
    
}

-(void)updateUserMainStats{
    NSLog(@"UPDATE USER MAIN STATS");
    
    //BALANCE
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.usesGroupingSeparator = YES;
    numberFormatter.groupingSeparator = @",";
    numberFormatter.groupingSize = 3;
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithInteger: [[[NSUserDefaults standardUserDefaults] stringForKey:@"balance"] integerValue] - [deliveryDeck getOrderPrice]]];
    
    NSLog(@"UPDATE USER MAIN STATS %@",numberString);
        if([[[NSUserDefaults standardUserDefaults] stringForKey:@"balance"] integerValue] == 0) [userVinosLabel setText:@"GET"];
    else [userVinosLabel setText:numberString];
    
    //SHOW IF HIDDEN
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.45f];
    userVinosLabel.alpha = 1.0f;
    userVinosLabelTxt.alpha = 1.0f;
    //deliverButton.alpha = 1.0f;
    [UIView commitAnimations];
    
    
    
    
}

-(void)updateTempVinosAmount:(int)amount{
    
    //int tempAmount = [[[NSUserDefaults standardUserDefaults] stringForKey:@"balance"] integerValue];
    
    //BALANCE
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.usesGroupingSeparator = YES;
    numberFormatter.groupingSeparator = @",";
    numberFormatter.groupingSize = 3;
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithInteger: [[[NSUserDefaults standardUserDefaults] stringForKey:@"balance"] integerValue] - [deliveryDeck getOrderPrice] + amount]];
    
    NSLog(@"UPDATE USER MAIN STATS %@",numberString);
    
    [userVinosLabel setText:numberString];
    
}

-(void)openDeliveryCard{
    [(Deck*)deliveryDeck showBlackCard];
}



#pragma mark -
#pragma mark LOGO

- (void)showLogo {
    NSLog(@"SHOW LOGO");
    
   //END POS - screenSize.width*0.35f
    
    logo = [[UIImageView alloc] init];
    logo.frame = CGRectMake(screenSize.width*0.325, 0, screenSize.width*0.35, screenSize.height);
    //logo.center = CGPointMake(selectionScreen.center.x*0.5, selectionScreen.center.y-screenSize.height*0.2);
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.userInteractionEnabled = TRUE;
    logo.backgroundColor = [UIColor clearColor];
    logo.animationDuration=3.0;
    logo.animationRepeatCount=1;
    
    //LOADING TEXT
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height*0.15 , self.view.bounds.size.width, self.view.bounds.size.height*0.8)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.alpha = 1.0f;
    loadingLabel.textAlignment =  NSTextAlignmentCenter;
    loadingLabel.textColor = [UIColor blackColor];
    loadingLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:(loadingLabel.bounds.size.height*0.0175)];
    loadingLabel.userInteractionEnabled = FALSE;
    [loadingLabel setText:@"Joy of Wine delivered On-Demand"];
    [loadingScreen2 addSubview:loadingLabel];
    
    //LOADING TEXT 2
    loadingLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height*0.175 , self.view.bounds.size.width, self.view.bounds.size.height*0.8)];
    loadingLabel2.backgroundColor = [UIColor clearColor];
    loadingLabel2.alpha = 1.0f;
    loadingLabel2.textAlignment =  NSTextAlignmentCenter;
    loadingLabel2.textColor = [UIColor blackColor];
    loadingLabel2.font = [UIFont fontWithName:@"SFUIText-Regular" size:(loadingLabel.bounds.size.height*0.0175)];
    loadingLabel2.userInteractionEnabled = FALSE;
    [loadingLabel2 setText:@"ON-DEMAND"];
    //[loadingScreen2 addSubview:loadingLabel2];
    
    
    //START ANIMATING
    NSMutableArray *imgListArray = [NSMutableArray array];
    for (int i=1; i <= 85; i++) {
        NSString *strImgeName = [NSString stringWithFormat:@"VinosBlank_%05d.png", i];
        UIImage *image = [UIImage imageNamed:strImgeName];
        if (!image) {
            NSLog(@"Could not load image named: %@", strImgeName);
        }
        else {
            [imgListArray addObject:image];
        }
    }
    [logo setAnimationImages:imgListArray];
    
    [logo startAnimating];
    [self.view addSubview:logo];
}

- (void)openCloseUserBuy
{
     NSLog(@"OPEN CLOSE USER BUY SCREEN");
    
    if(!userOpen){
    [self openCloseUser];
    }
    
    if(userOpen){
        [user openUserBuy];
    }
}

- (void)openCloseUser
{
    NSLog(@"OPEN CLOSE USER SCREEN");
    
    //CHECK IF DELIVERY SCREEN OPEN
    
    
    //CHECK IF USER OPEN OR CLOSED
    if(userOpen){
        
        //FADE AWAY USER SCREENS
        [user closeUser];
       
        //[deliveryDeck deactivateDeck];
        
        //FILTER ANI
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.15f];
        //filterTxt.alpha = 1;
        //filterBut.alpha = 1.0f;
        //deckBut.alpha = 1.0f;
        //deliver.alpha = 0.0f;
        deliverButton.alpha = 1.0f;
        deliverLabel.alpha = 1.0f;
        //logo.alpha = 1.0f;
        selectionScreen.alpha = 1.0f;
        user.frame = CGRectMake(0,-screenSize.height,screenSize.width,SELECTIONSCREENSIZE);
        //selectionScreen.center = CGPointMake(selectionScreen.center.x, selectionScreen.center.y - screenSize.height);
        //deliveryDeck.transform = CGAffineTransformMakeScale(0.15f, 0.15f);
        //deliveryDeck.center = CGPointMake(screenSize.width * 0.2,screenSize.height * 0.2);

        [UIView commitAnimations];
        
        
       // [self showSelectionScreen];
        
    }
    else{
        //SHOW CARD ON TOP
        [self.view addSubview:user];
        
        //OPEN USER SCREENS
        [user openUser];
        
        //FILTER ANI
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.25f];
        //filterTxt.alpha = 0;
        //filterBut.alpha = 0.0f;
        //deckBut.alpha = 0.0f;
        //deliver.alpha = 0.0f;
        //deliverButton.alpha = 0.0f;
        //deliverLabel.alpha = 0.0f;
        //logo.alpha = 0.0f;
        //selectionScreen.alpha = 0.0f;
        user.frame = CONTENTVIEW;
        //user.center = CGPointMake(user.center.x, user.center.y + SELECTIONSCREENSIZE);
        //selectionScreen.center = CGPointMake(selectionScreen.center.x, selectionScreen.center.y + screenSize.height);
        [UIView commitAnimations];
        
        
               
    }
    userOpen = !userOpen;
    
    
}



#pragma mark -
#pragma mark DEACTIVATE ALL DECKS

- (void) showSelectionScreen
{
    
    //Code to handle the gesture
     NSLog(@"SELECTION SCREEN - SHOW");
    
    /*/CLOSE ALL DECKS
    for(Deck *deck in cardDecks) {
        [deck removeFromSuperview];
        
    }
    */
    
    //CLOSE PREVIOUS DECK - WHATEVER IT IS...
    if(lastOpenDeck != NULL){
        //[selectionScreen addSubview:lastOpenDeck];
        [ lastOpenDeck performSelector: @selector( deactivateDeck ) withObject:NULL];
        
        //DO ONLY IF DECK IS NOT DELIVERY
        deliverLabel.alpha = 1.0f;
        deliverButton.alpha = 1.0f;
        
        lastOpenDeck = NULL;
    }

    
    //SHOW BUTTONS
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    deliverButton.alpha = 1.0f;
    deliverLabel.alpha = 1.0f;
    [UIView commitAnimations];
    
    
    /*/MOVE SELECTION SCREEN BACK TO BOTTOM
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.7f];
    [UIView setAnimationDelay:0.3f];
    selectionScreen.frame = CGRectMake(0, screenSize.height*0.45, selectionScreen.bounds.size.width, selectionScreen.bounds.size.height);
    [UIView commitAnimations];
   */
    
    /*/SHOW CARD
    userOpen = false;
    [self openCloseUser];
    */
    
    deliverButton.tag = 0;

    //REPOSITION ALL DEACTIVATED DECKS
    [self animateInDecks];
    
    /*
    float wid=screenSize.width/3;
    int hei=selectionScreen.bounds.size.height/3 - TOPNAVHEIGHT;
    int colum=0;
    int row=0;
    int columM=3;
    
    for(Deck *deck in cardDecks) {
        if(colum>=columM){ colum = 0; row++;}
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDelay:0.35f];
        [UIView setAnimationDuration:0.75f];
        //deck.frame = CGRectMake(colum*wid, row*hei, wid, hei);
        deck.transform = CGAffineTransformMakeScale(0.275, 0.275);
        deck.center = CGPointMake(colum*wid + wid*0.5, row*hei + hei*0.5 + TOPNAVHEIGHT);
        [UIView commitAnimations];
        
        colum++;
    }
     */
}









#pragma mark -
#pragma mark DECKS


-(void)createAllDecks{
    NSLog(@"\nCREATE ALL DECKS FROM PRODUCTS JSON DATA");

    //CHECK FOR DECKS ARRAY
    if ([jsonDataProduct isKindOfClass:[NSArray class]]){//Added instrospection as suggested in comment.
        for (NSMutableDictionary *dictionary in jsonDataProduct) {
          //  NSLog(@"\n\nDECK FOUND - %@",dictionary);
            
            //CHECK FOR TYPE
            if([[dictionary objectForKey:@"product_type"] isEqualToString:@"Top-up"]){
                [user addTopUp:dictionary];
                //NSLog(@"TOP UP ADDED %@",dictionary);
            }
            else if ([[dictionary objectForKey:@"product_type"] isEqualToString:@"Wine"] && ![[dictionary objectForKey:@"product_id"] isEqualToString:@"72684"] && ![[dictionary objectForKey:@"product_id"] isEqualToString:@"72685"] && ![[dictionary objectForKey:@"product_id"] isEqualToString:@"72690"]){
               // NSLog(@"WINE FOUND %@",dictionary);
                
                ////////////////////
                // ADD MISSING DATA
                ////////////////////
                //NOTES
                [dictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"notes",nil]];
                //QUANTITY
                [dictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"quantity",nil]];
                
                
                ////////////////////
                // ADD SAVED DATA
                ////////////////////
                //FAVOURITE
                if([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pId%@fav",[dictionary objectForKey:@"product_id"]]] != nil){
                    [dictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pId%@fav",[dictionary objectForKey:@"product_id"]]],@"favourite",nil]];
                }
                else{
                [dictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"favourite",nil]];
                }
                

                ////////////////////
                // FIND DATA
                ////////////////////
                //COLLECTION
                for (NSDictionary *collectionF in [dictionary objectForKey:@"categories"]) {
                    
                    //CHECK IF TYPE collections
                    if([[collectionF objectForKey:@"slug"] isEqualToString:@"collections" ]){
                        if ([[collectionF objectForKey:@"categories"] isKindOfClass:[NSArray class]]){
                            for (NSDictionary *myColArray in [collectionF objectForKey:@"categories"]) {
                                if([myColArray objectForKey:@"name"]){
                                    //NSLog(@"NAME FOUND %@",[myColArray objectForKey:@"name"]);
                                    //NSLog(@"1");
                                    //COLLECTION TITLE
                                    [dictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[myColArray objectForKey:@"name"],@"collection_title",nil]];
                                    //NSLog(@"1");
                                    //COLLECTION IMG URL
                                    [dictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[myColArray objectForKey:@"image_url"],@"collection_image_url",nil]];
                                    //NSLog(@"1");
                                    //COLLECTION DESCRIPTION
                                    [dictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[myColArray objectForKey:@"description"],@"collection_description",nil]];
                                }
                            }
                        }
                    }
                    //COLOR
                    else if([[collectionF objectForKey:@"slug"] isEqualToString:@"winetypes" ]){
                        if ([[collectionF objectForKey:@"categories"] isKindOfClass:[NSArray class]]){
                            for (NSDictionary *myColArray in [collectionF objectForKey:@"categories"]) {
                                if([myColArray objectForKey:@"name"]){
                                   // NSLog(@"COLOR FOUND %@",[myColArray objectForKey:@"name"]);
                                    
                                    //COLOR
                                    [dictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[myColArray objectForKey:@"name"],@"color",nil]];
                                }
                            }
                        }
                        
                    }
                    //MOOD
                    else if([[collectionF objectForKey:@"slug"] isEqualToString:@"cellar-filters" ]){
                        if ([[collectionF objectForKey:@"categories"] isKindOfClass:[NSArray class]]){
                            for (NSDictionary *myColArray in [collectionF objectForKey:@"categories"]) {
                                if([[myColArray objectForKey:@"slug"] isEqualToString:@"moods"]){
                                     //NSLog(@"MOOD FOUND");
                                    if ([[myColArray objectForKey:@"categories"] isKindOfClass:[NSMutableArray class]]){
                                        NSMutableArray *myMoodArr = [[NSMutableArray alloc] initWithArray:[myColArray objectForKey:@"categories"]];
                                       // NSLog(@"MOOD ARR %@",myMoodArr);
                                        if([myMoodArr count]>0){
                                            //NSLog(@"cat2 %@",[[myMoodArr objectAtIndex:0]objectForKey:@"name"]);
                                            //FILTER TYPE FOUND
                                           
                                            //NSLog(@"MOOD FOUND %@",[[myMoodArr objectAtIndex:0]objectForKey:@"name"]);

                                            [dictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[[myMoodArr objectAtIndex:0]objectForKey:@"name"],@"moods",nil]];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
                //CHECK IF DECK EXISTS WITH TITLE
                BOOL found = false;
                for (Deck *existingDeck in cardDecks) {
                    if([[existingDeck getTitle] isEqualToString:[dictionary objectForKey:@"collection_title"] ]){
                        //NSLog(@"CARD ADDED TO EXISTING DECK");
                        //ADD TO DECK
                        [existingDeck addCardData:dictionary];
                        found = TRUE;
                        break;
                    }
                }
                if (!found) {
                    //CREATE NEW DECK
                    Deck *myDeck = [[Deck alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, SELECTIONSCREENSIZE) setTitle:[dictionary objectForKey:@"collection_title"] setImageUrl:[dictionary objectForKey:@"collection_image_url"] setImageDes:[dictionary objectForKey:@"collection_description"] setType:@"COLLECTION" ];
                    myDeck.myDelegate = self;
                    myDeck.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.3, 0.3), CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(285))) ;
                    [myDeck addCardData:dictionary];
                    
                    [cardDecks addObject:myDeck];
                    [selectionScreen addSubview:myDeck];
                }
                
            }
            else {
                NSLog(@"UNKNOW PRODUCT");
            }
        }
    }
    else{
        NSLog(@"NO CORRECT DATA");
    }
    
    //ANIMATE IN DECKS
    [self animateInDecks];
    
    /*/OPEN FIRST IN ARRAY
    if ([cardDecks count] > 0) {
        //OPEN FIRST DECK
        [self openDeck:((Deck*)[cardDecks objectAtIndex:0])];
        [((Deck*)[cardDecks objectAtIndex:0]) openCloseDeck];
    }
     */
    
    //ADD DELIVERY DECK TO DECKS
    //[cardDecks addObject:deliveryDeck];
    
}

-(void)promptSelection{
    NSLog(@"PROMPT SELECTION");
    
    float delay = 0.0f;
    for(Deck *deck in cardDecks) {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.15f];
        [UIView setAnimationDelay:delay];
        deck.transform = CGAffineTransformMakeScale(0.28, 0.28);
        [UIView commitAnimations];
        
        delay=delay+0.15f;
    }
    
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(promptSelectionEnd) userInfo:nil repeats:NO];

    //[NSTimer timerWithTimeInterval:delay target:self selector:@selector(promptSelection:) userInfo:NULL repeats:NO];

}

-(void)promptSelectionEnd{
    
    
    float delay = 0.0f;
    for(Deck *deck in cardDecks) {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.1f];
        [UIView setAnimationDelay:delay];
        deck.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView commitAnimations];
        
        delay=delay+0.1f;
        
         NSLog(@"PROMPT SELECTION DOEN");
    }
    
    
    
}

-(void)animateInDecks{
    NSLog(@"ANIMATE IN DECKS");
    
    //ANIMATE DECKS IN
    float wid=screenSize.width/3;
    int hei=selectionScreen.bounds.size.height*0.9/3;
    int colum=0;
    int row=0;
    int columM=3;
    
    for(Deck *deck in cardDecks) {
        if(colum>=columM){ colum = 0; row++;}
        
        
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.75f];
        [UIView setAnimationDelay:0.5f];
        //deck.frame = CGRectMake(colum*wid, row*hei, wid, hei);
        deck.transform = CGAffineTransformMakeScale(0.3, 0.3);
        deck.center = CGPointMake(colum*wid + wid*0.5, (row*hei + hei*0.5 + selectionScreen.bounds.size.height*0.05)+(row*selectionScreen.bounds.size.height*0.05));
        colum++;
        
        [UIView commitAnimations];
        
        
    }
    
    //pLACE DELIVERY DECK
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.75f];
    [UIView setAnimationDelay:0.5f];
    //deliveryDeck.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.105, 0.105), CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0))) ;
    //deliveryDeck.center = CGPointMake(screenSize.width*0.9, -screenSize.height*0.065);
    deliveryDeck.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.3, 0.3), CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0))) ;
    deliveryDeck.center = CGPointMake(screenSize.width*0.5, selectionScreen.bounds.size.height*0.85);
    [UIView commitAnimations];
    
    [selectionScreen addSubview:deliveryDeck];
   // [selectionScreen insertSubview:deliveryDeck atIndex:0];
    
    
    
    
    
    //DEACTIVATE DELIVERY
    [deliveryDeck deactivateDeck];
   
}


-(void)openDeck:(Deck*)myDeck{
    
    //LAST DECK
    if(![myDeck.type isEqualToString:@"DELIVERY"])lastOpenDeck = myDeck;
    
    NSLog(@"DELEGATE - OPEN DECK");

    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:myDeck];
    //[selectionScreen addSubview:myDeck];
    
    //HIDE DELIVER DECK
    if(![myDeck.type isEqualToString:@"DELIVERY"]){
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.55f];
        //deliveryDeck.center = CGPointMake(screenSize.width*0.5, selectionScreen.bounds.size.height*1.5);
        [UIView commitAnimations];
        
        [self.view addSubview:selectionScreen];
        
        /*/HIDE CARD
        userOpen = true;
        [self openCloseUser];
         */
    }
    else{
        /*/SHOW CARD
        userOpen = false;
        [self openCloseUser];
         */
        
        [selectionScreen bringSubviewToFront:deliveryDeck];
        [self.view addSubview:user];
    }
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.55f];
    //filterBut.alpha = 1.0f;
    
    //deliverLabel.alpha = 0.0f;
    //deliverButton.alpha = 0.0f;
    //deckBut.alpha = 1.0f;
    //filterTxt.alpha = 1.0f;
    myDeck.center = CGPointMake(screenSize.width*0.5, selectionScreen.bounds.size.height*0.5);
    myDeck.transform = CGAffineTransformMakeScale(0.95,0.95);
    //topNavHolder.center = CGPointMake(topNavHolder.center.x, topNavHolder.bounds.size.height*0.5);
    //selectionScreen.frame = CGRectMake(-screenSize.width, screenSize.height - SELECTIONSCREENSIZE, selectionScreen.bounds.size.width, SELECTIONSCREENSIZE);
     [UIView commitAnimations];
    
    
   
    
}

-(void)closeDeck:(id)myDeck{
    NSLog(@"DELEGATE - CLOSE DECKS");
    
    /*/CLOSE DECKS
    int di = 0;
    float delay = 0.15f;
    for(Deck *deck in cardDecks) {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.75f];
        [UIView setAnimationDelay:delay];
        if([deck isEqual:myDeck]){
            //deck.transform = CGAffineTransformMakeScale( 0.8, 0.8);
        }
        deck.center = CGPointMake(screenSize.width*0.5, screenSize.height*0.5 + deck.frame.size.height*0.1*di);
        [UIView commitAnimations];
        delay = delay + 0.1f;
        di++;
        
    }
     */
    
}



#pragma mark -
#pragma mark CARDS

-(void)fullScreenCard{
    NSLog(@"FULLSCREEN CARD");
    //SCROLLBAR TO TOP
    
    [deliver showCardView];
    
    /*/CLOSE USER IF OPEN
    userOpen = TRUE;
    [self openCloseUser];
     */
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35f];
    topNavHolder.frame = CGRectMake(0, -TOPNAV.size.height, screenSize.width, TOPNAV.size.height);
    selectionScreen.frame = CGRectMake(0, 0, selectionScreen.bounds.size.width, SELECTIONSCREENSIZE);
    //deliver.frame = CGRectMake(0, 0, deliver.bounds.size.width, SELECTIONSCREENSIZE);
   // deckBut.alpha = 0;
    user.alpha = 0;
    fullscreenCloseBut.alpha = 1;
    [UIView commitAnimations];
    
    [self.view addSubview:fullscreenCloseBut];
    

    

}

-(void)closeFullscreenCardBut{
    NSLog(@"closeFullscreenCardBut");
    if (lastOpenDeck != NULL) {
        [ lastOpenDeck performSelector: @selector( forceCloseCardAndActiveDeck ) withObject:NULL];
        
        if ([((Deck*)lastOpenDeck).type isEqualToString:@"DELIVERY"] ) {
            [ deliveryDeck performSelector: @selector( forceCloseCardAndActiveDeck ) withObject:NULL];

        }

    }
    else{
        [ deliveryDeck performSelector: @selector( forceCloseCardAndActiveDeck ) withObject:NULL];
    }
   // [ deliveryDeck performSelector: @selector( activateDeck ) withObject:NULL];

}

-(void)closeFullscreenCard{
    NSLog(@"CLOSE FULLSCREEN CARD");
    
    [deliver showCardView];

    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35f];
    topNavHolder.frame = TOPNAV;
    selectionScreen.frame = CGRectMake(0, screenSize.height - SELECTIONSCREENSIZE, selectionScreen.bounds.size.width, SELECTIONSCREENSIZE);
    //deliver.frame = CGRectMake(0, screenSize.height - SELECTIONSCREENSIZE, deliver.bounds.size.width, SELECTIONSCREENSIZE);
    //deckBut.alpha = 1;
    user.alpha = 1;
     fullscreenCloseBut.alpha = 0;
    [UIView commitAnimations];
    
    
}




#pragma mark -
#pragma mark DELIVERY

-(void)loadDelivery{
    //SET UP DELIVERY VIEW AND DELIVERY DECK
    deliver = [[Deliver alloc] initWithFrame:DELIVERVIEW];
    deliver.myDelegate = self;
    deliver.alpha = 1.0f;
    [self.view addSubview:deliver];
    
   
    
    deliverButton = [UIButton buttonWithType:UIButtonTypeCustom];
   // deliverButton.frame = CGRectMake(self.view.bounds.size.height*0.0145f, self.view.bounds.size.height*0.005f , self.view.bounds.size.height*0.05, self.view.bounds.size.height*0.05);
    deliverButton.frame = CGRectMake(self.view.bounds.size.width*0.85f, self.view.bounds.size.height*0.005f , TOPNAVHEIGHT*0.55, TOPNAVHEIGHT*0.55);
    deliverButton.tag = 0;
    [deliverButton setBackgroundImage:[UIImage imageNamed:@"selectButton.png"] forState:UIControlStateNormal];
    [deliverButton addTarget:self action:@selector(showDeliverScreen) forControlEvents:UIControlEventTouchUpInside];
    deliverButton.alpha = 1.0f;
    deliverButton.center = CGPointMake(deliverButton.center.x, topNavHolder.center.y);
    [topNavHolder addSubview:deliverButton];
    
    //ADD DELIVERY LABEL
    //deliverLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.height*0.08f, 0 , self.view.bounds.size.width*0.3, TOPNAVHEIGHT)];
    deliverLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*0.85f, 0 , TOPNAVHEIGHT*0.55, TOPNAVHEIGHT*0.95)];
    deliverLabel.backgroundColor = [UIColor clearColor];
    deliverLabel.alpha = 1.0f;
    deliverLabel.textAlignment =  NSTextAlignmentCenter;
    deliverLabel.textColor = [UIColor blackColor];
    deliverLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:(deliverLabel.bounds.size.height*0.25)];
    deliverLabel.userInteractionEnabled = FALSE;
    [deliverLabel setText:@""];
    [topNavHolder addSubview:deliverLabel];
    
    
    //GESTURE ON
    UITapGestureRecognizer *tapped2222= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDeliverScreen)];
    tapped2222.numberOfTapsRequired = 1;
    [deliverLabel addGestureRecognizer:tapped2222];
    
    //CREATE FAVOURITES DECK
    
    
    
    //CREATE DELIVERY DECK
    deliveryDeck = [[Deck alloc] initWithFrame:CGRectMake(0, SELECTIONSCREENSIZE, self.view.bounds.size.width, SELECTIONSCREENSIZE) setTitle:@"CHOOSE WINE FROM COLLECTIONS" setImageUrl:@"http://s7.postimg.org/o9x5hef5n/deliver_Man.png" setImageDes:@"The delivery Deck" setType:@"DELIVERY"];
    deliveryDeck.myDelegate = self;
    //deliveryDeck.backgroundColor = [UIColor redColor];
     //[deliver insertSubview:deliveryDeck atIndex:0];
    [deliveryDeck addSubviewInForm:deliver];
    [selectionScreen addSubview:deliveryDeck];
    
    
    
    
}

-(BOOL)checkForLoggedIn{
    return [user isUserLoggedIn];
}

-(NSString*)getDeliveryAddress{
    return [deliveryDeck getDelAddress];
}
-(NSString*)getDeliveryNotes{
    return [deliveryDeck getDelNotes];
}

-(void)delieveryDeckSuccess{
    NSLog(@"DELIVERY DECK SUCCESS");
    
    //CLEAR DELIVERY DECK
    [deliveryDeck clearDeckAll];
    
    //CLEAR OTHERS
    
    
    [deliveryDeck showBlackCard];
    
    //UPDATE USER INFO
    [user getUser];
}

-(void)activateDeliveryDeck{
    [deliveryDeck activateDeck];
}



-(void)setDeliveryAddress:(NSString*)myAdd{
    [deliveryDeck setDelAddress:myAdd];
}

-(id)getDeliveryData{
    return [deliveryDeck getData];
}

-(void)forwardLoc{
    [deliver forwardLocate];
}

-(void)makeDelNow{
    //CHECK IF USER HAS ENOUGH CREDITSSSSS
    
    //CALCULATE BALANCE LEFT OVER
    int remainingValue = [[[NSUserDefaults standardUserDefaults] stringForKey:@"balance"] integerValue] - [deliveryDeck getOrderPrice];
    
    
    if([user isUserLoggedIn]){
        
        
        //SHOW VINOS LEFT PRICE
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.usesGroupingSeparator = YES;
        numberFormatter.groupingSeparator = @",";
        numberFormatter.groupingSize = 3;
        [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
        NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithInteger: [deliveryDeck getOrderPrice]]];
        
        
        NSLog(@"MAKE DELIVER CREDITS REMAINING %@",numberString);
        if(remainingValue < 0){
            //CLOSE DELIVERY CARD
            [deliveryDeck activateDeck];
            
            //YOU NEED MORE VINOS
            [self openCloseUserBuy];
            
            
        }
        else{
            UIAlertView *alert;
            if([deliveryDeck getOrderQuantity]>1){
                alert = [[UIAlertView alloc] initWithTitle:@"DELIVER NOW?"
                                                   message:[NSString stringWithFormat:@"Would you like to confirm your delivery of %i bottles for %i VINOS?\n\nYour delivery will be with you shortly. (Depending on traffic conditions)", [deliveryDeck getOrderQuantity],[deliveryDeck getOrderPrice]]
                                                  delegate:self
                                         cancelButtonTitle:@"Later"
                                         otherButtonTitles:@"CONFIRM",nil];
                alert.tag = 11;

            }
            else if([deliveryDeck getOrderQuantity] == 1){
                alert = [[UIAlertView alloc] initWithTitle:@"DELIVER NOW?"
                                                   message:[NSString stringWithFormat:@"Would you like to confirm your delivery of %i bottle for %i VINOS?\n\nYour delivery will be with you shortly. (Depending on traffic conditions)", [deliveryDeck getOrderQuantity],[deliveryDeck getOrderPrice]]
                                                  delegate:self
                                         cancelButtonTitle:@"Later"
                                         otherButtonTitles:@"CONFIRM",nil];
                alert.tag = 11;

            }
            else{
                alert = [[UIAlertView alloc] initWithTitle:@"CHOOSE ITEMS"
                                                   message:@"Select your bottles for delivery from the various Wine Collections"
                                                  delegate:self
                                         cancelButtonTitle:@"Thanks"
                                         otherButtonTitles:nil];
                alert.tag = 41;
            }
            
            //CONFIRM DELIVERY
           
            [alert show];

            
           //MAKE DELIVERY
           // [deliver makeDelivery];
        }
        
        
    }
    else{
        //CLOSE DELIVERY CARD
        [deliveryDeck activateDeck];
        
        //OPEN USER FOR LOGIN OR SIGN UP
        userOpen = FALSE;
        [self openCloseUser];
    }
    
    
  
    
    
    
}


-(void)updateCardsInDecks:(id)myCard{
    
    //CHECK ALL DECKS FOR CARD AND UPDATES CHANGES FROM DELIVERY DECK
    BOOL found = FALSE;
    for(Deck *tempDeck in cardDecks){
        found = FALSE;
        //GET DATA
        for(NSDictionary *cardDict in tempDeck.data){
            NSLog(@"HELLO1");
            if ( [[((Card*)myCard).data objectForKey:@"product_id"] isEqualToString: [cardDict objectForKey:@"product_id"]  ] ) {
                
                NSLog(@"CARD UPDATED IN DECK");
                
                
                found = TRUE;
                break;
            }
        }
        if (found) {
            //ADD CARD TO DECK
            [tempDeck addCardData:((Card*)myCard).data];
        }
        
        
        
        
    }
    
    [self updateDeliveryTextAll];
    
    
    
}


-(void)addCardToDelivery:(id)myCard{
    NSLog(@"ADD CARD TO DELIVERY");
    
    
    //ADD TO DELIVERY DECK
    [deliveryDeck addCardData:((Card*)myCard).data];
    
     [self updateDeliveryTextAll];
    
    //SHOW BUTTONS
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.45f];
    deliverLabel.alpha = 1.0f;
    deliverButton.alpha = 1.0f;
    [UIView commitAnimations];
}

-(void)updateDeliveryTextAll{
    
    //UPDATE DELIVER LABEL
    deliverLabel.text = [NSString stringWithFormat:@"%i",[deliveryDeck getOrderQuantity] ] ;
    
    //UPDATE DELIVERY DECK TITLE
    [deliveryDeck updateDeliveryDeckTitle];
    
    //CHECK IF USER LOGGED IN
    if([user isUserLoggedIn]){
        //CALCULATE BALANCE LEFT OVER
        int remainingValue = [[[NSUserDefaults standardUserDefaults] stringForKey:@"balance"] integerValue] - [deliveryDeck getOrderPrice];
        
        
        //SHOW VINOS LEFT PRICE
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.usesGroupingSeparator = YES;
        numberFormatter.groupingSeparator = @",";
        numberFormatter.groupingSize = 3;
        [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
        NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithInteger: remainingValue]];
        
        
        NSLog(@"UPDATE USER MAIN STATS %@",numberString);
        if(remainingValue < 0){
            //[userVinosLabel setText:@"GET"];
            [userVinosLabel setText:numberString];
        }
        else{
            [userVinosLabel setText:numberString];
        }
        
        
    }
    
    
    
    
    //userVinosLabelTxt
    //[deliveryDeck getOrderPrice];
}

-(NSInteger)getOrderPriceDeck{
    return [deliveryDeck getOrderPrice];
}


- (void)showDeliverScreen
{
    NSLog(@"DELIVER SCREEN - SHOW");
    
    if(deliverButton.tag == 1){
        NSLog(@"DELIVER SCREEN - DEACT");
        [deliveryDeck deactivateDeck];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.15f];
        //deliver.alpha = 0;
        //selectionScreen.alpha = 1;
        [UIView commitAnimations];
        
        
        
        [self showSelectionScreen];
    }
    else{
        [deliveryDeck activateDeck];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.15f];
        //selectionScreen.alpha = 0;
        deliver.alpha = 1;
        deliverButton.alpha = 0;
        deliverLabel.alpha = 0;
        [UIView commitAnimations];
        
        deliverButton.tag = 1;
        
    }
    
}

- (void) showDeliverScreenStraight
{
    NSLog(@"DELIVER SCREEN - SHOW");
    
    
        [deliveryDeck activateDeck];
    [deliveryDeck showBlackCard];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.15f];
        //selectionScreen.alpha = 0;
        //deliver.alpha = 1;
        // deckBut.alpha = 0;
        [UIView commitAnimations];
        
        deliverButton.tag = 1;
        
    
}


#pragma mark -
#pragma mark CONNECTION PRODUCTS

-(void)loadCollectionData{
    
    //GET DATA
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MYVINOSSERVER,@"/products"]]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

    
    
    
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    // NSLog(@"data recieved");
    [collectionData appendData:data];
    //collectionData = data;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"PRODUCT DATA DONE");
    
    //GET STRING FROM DATA RETURNED
    NSString *responseString = [[NSString alloc] initWithData:collectionData encoding:NSUTF8StringEncoding];
    NSError *e = nil;
    
    //BUILD JSON DATA
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    //CREATE DICTIONARY
    jsonDataProduct = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error: &e];
    
    //NSLog(@"DATA DONE:\n %@",jsonDataProduct);
    
    //WAIT FOR APP START TO TRIGGER WHEN READY
     splashComplete = TRUE;
   
    

}


#pragma TOUCHES

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"\nTOUCHED in VIEW CONTROLLER");
    
    //RESET ALL DECKS
    
}


#pragma DEVICE CALLBACKS



- (void)didReceiveMemoryWarning {
    NSLog(@"\n---- MEMORY WARNING ----");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
     //   connectionRequired = [reachability connectionRequired];
        
     
        
        switch (netStatus)
        {
            case NotReachable:        {
                    connectionRequired = NO;
                break;
            }
                
            case ReachableViaWWAN:        {
                connectionRequired = TRUE;
                break;
            }
            case ReachableViaWiFi:        {
                connectionRequired = TRUE;
                break;
            }
        }
      
    }
    
    if (reachability == self.internetReachability)
    {
//INTERNET FOUND
       // connectionRequired = TRUE;
    }
    
    if (reachability == self.wifiReachability)
    {
//WIFI FOUND
       // connectionRequired = TRUE;
    }
    
    
}




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}


@end
