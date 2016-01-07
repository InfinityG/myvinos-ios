//
//  User.m
//  colorgameapp
//
//  Created by Herman Coetzee on 2012/10/07.
//  Copyright (c) 2012 Color Game App. All rights reserved.
//
#import <Parse/Parse.h>

#import "Deck.h"
#import "Deliver.h"
#import <QuartzCore/QuartzCore.h>

//#import "ParseStarterProjectViewController.h"
//#import "FormTableControllerDeliver.h"

#define CARDHEIGHT self.bounds.size.height
#define DISPLAYHEIGHT self.bounds.size.height*0.595

#define CARDRECT 0, 0 ,self.bounds.size.width*1.00, CARDHEIGHT

//#define MYVINOSSERVER @"https://myvinos-test-api.infinity-g.com"
#define MYVINOSSERVER @"https://myvinos-api.infinity-g.com"



@implementation Deliver

@synthesize myDelegate,deliveryDecks,deliverLabel,deliverButton,mapView,myAnnotation,addressLocation,locManager,timeLabel;

@synthesize topUps,connectionDeliver,dataDeliver,jsonDataDeliver,noticeView,noticeTxt,deliverButtonInside,deliveryLocation,deliverTable,deliverItemsScroll;



- (id)initWithFrame:(CGRect)frame sMyDelegate:(id)myDel
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"HELLO DELIVERY SCREEN");
        myDelegate = myDel;
        
        deliveryDecks = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
        
        deliveryLocation = [[CLLocation alloc] initWithLatitude:-33.9245683 longitude:18.419775];
        
        deliverOpen = FALSE;
        
        //ADD CARD HOLDER
        cardView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height*0.5)];
        cardView.backgroundColor = [UIColor whiteColor];
        cardView.alpha = 1.0f;
        
        
        
        //ADD FORM
        deliverTable = [[FormTableControllerDeliver alloc ]initWithStyle: UITableViewStyleGrouped];
        deliverTable.myDelegate = self;
        deliverTable.view.alpha = 1.0f;
        deliverTable.view.backgroundColor = [UIColor clearColor];
        deliverTable.view.frame = CGRectMake(self.frame.size.width*0.0,self.frame.size.height*0.5,self.frame.size.width*1,self.frame.size.height*0.475);
        //[deliverTable.tableView ]
        deliverTable.view.backgroundColor = [UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
        deliverTable.view.backgroundColor = [UIColor clearColor];
        deliverTable.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        deliverTable.tableView.scrollEnabled = FALSE;
        [self addSubview:deliverTable.view];
        
        
        //BUILD ITEMS LIST
        deliverItemsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(deliverTable.view.bounds.size.width*0.005, deliverTable.view.bounds.size.height*0.52, deliverTable.view.bounds.size.width*0.99, deliverTable.view.bounds.size.height*0.4)];
        deliverItemsScroll.backgroundColor = [UIColor clearColor];
        //[deliverTable.view addSubview:deliverItemsScroll];
        
        
        
        //ADD MAP
        [self addMapsAndStuff];
        
        //ADD DELIVER FORM
        [self addDeliverForm];
        
        //ADD NOTICE
        [self addNoticeView];
        
        //ADD CARD VIEW
        [self addSubview:cardView];
        
        /*/ADD  CONTINUE BUTTON
        UIButton *continueDeliverBut = [UIButton buttonWithType:UIButtonTypeCustom];
        continueDeliverBut.frame = CGRectMake(self.bounds.size.width*0.4,self.bounds.size.height*0.75 , self.bounds.size.width*0.225, self.bounds.size.height*0.25);
        [[continueDeliverBut imageView] setContentMode: UIViewContentModeScaleAspectFill];
        [continueDeliverBut setBackgroundImage:[UIImage imageNamed:@"selectButton.png"]  forState:UIControlStateNormal];
        continueDeliverBut.tag = 1;
        continueDeliverBut.alpha = 0.5f;
        [continueDeliverBut addTarget:self action:@selector(continueDelivery) forControlEvents:UIControlEventTouchUpInside];
        continueDeliverBut.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:continueDeliverBut];
         */
       
        //mapView.frame = CGRectMake(0, self.frame.size.height*0.15, self.frame.size.width, self.frame.size.height*0.85);
        
    }
    return self;
}

-(NSString*)getDelAddress{
    return deliverTable.address;
}

-(NSString*)getDelNotes{
    return [NSString stringWithFormat:@"%@ - %@",deliverTable.name,deliverTable.notes];
}

-(void)setDelAddress:(NSString*)myadd{
    deliverTable.address = myadd;
    [deliverTable setAddressDirect:myadd];
}


-(void)continueDelivery{
    //FLIP OVER CARD TO SHOW FINAL FORM
    
    NSLog(@"continue delivery");
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.35f];
    cardView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height*0.5);
    mapView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height*0.5);
    deliverButton.center = CGPointMake(cardView.bounds.size.width*0.5, cardView.bounds.size.height*0.5);
    [UIView commitAnimations];
    
    
    
    
    
}


-(void)updateScrollItems{
    NSLog(@"\n\nUPDATE SCROLL ITEMS - %@",@"START");
    
    
    
    //REMOVE ALL VIEWS OF SCROLL
    for (UIView *view in [deliverItemsScroll subviews])
    {
        [view removeFromSuperview];
    }
    
    
    
    //ADD TO VIEW
    int i = 0;
    CGFloat barHeight = self.frame.size.height*0.05;
    
    for (NSDictionary *dictionary in [myDelegate getData]) {
        //NSLog(@"\n\nPRODUCT FOUND - %@",dictionary);
        //BUILD HISTORY SCROLL
        
        //ADD TO SCROLL VIEW AND ADD
        CGFloat y = i * barHeight;
        
        
        
        UILabel *hist0 = [[UILabel alloc] initWithFrame:CGRectMake(0, y ,deliverItemsScroll.bounds.size.width * 0.1, barHeight)];
        hist0.textAlignment =  NSTextAlignmentCenter;
        hist0.backgroundColor = [UIColor clearColor];
        hist0.textColor = [UIColor whiteColor];
        hist0.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:(hist0.bounds.size.height*0.3)];
        hist0.userInteractionEnabled = FALSE;
        [hist0 setText:[dictionary objectForKey:@"quantity"]];
        [deliverItemsScroll addSubview:hist0];
        
        
        //ADD TO SCROLL VIEW AND ADD
        UILabel *hist1 = [[UILabel alloc] initWithFrame:CGRectMake( deliverItemsScroll.bounds.size.width*0.1 , y ,deliverItemsScroll.bounds.size.width*0.65, barHeight)];
        hist1.textAlignment =  NSTextAlignmentLeft;
        hist1.backgroundColor = [UIColor clearColor];
        hist1.textColor = [UIColor whiteColor];
        hist1.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(hist1.bounds.size.height*0.55)];
        hist1.userInteractionEnabled = FALSE;
        [hist1 setText:[dictionary objectForKey:@"name"]];
        [deliverItemsScroll addSubview:hist1];
        
        
        //ADD TO SCROLL VIEW AND ADD
        UILabel *hist2 = [[UILabel alloc] initWithFrame:CGRectMake( deliverItemsScroll.bounds.size.width*0.75, y ,deliverItemsScroll.bounds.size.width*0.25, barHeight)];
        hist2.textAlignment =  NSTextAlignmentRight;
        hist2.backgroundColor = [UIColor clearColor];
        hist2.textColor = [UIColor whiteColor];
        hist2.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:(hist2.bounds.size.height*0.25)];
        hist2.userInteractionEnabled = FALSE;
        [hist2 setText:[NSString stringWithFormat:@"%i V",[[dictionary objectForKey:@"quantity"] integerValue]*[[dictionary objectForKey:@"price"] integerValue]]];
        [deliverItemsScroll addSubview:hist2];
        
        
        
        i++;
        
    }
    CGFloat y = i * barHeight;
    
    //ADD TOTAL
    UILabel *hist1 = [[UILabel alloc] initWithFrame:CGRectMake( deliverItemsScroll.bounds.size.width*0.1 , y ,deliverItemsScroll.bounds.size.width*0.9, barHeight)];
    hist1.textAlignment =  NSTextAlignmentRight;
    hist1.backgroundColor = [UIColor clearColor];
    hist1.textColor = [UIColor whiteColor];
    hist1.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(hist1.bounds.size.height*0.75)];
    hist1.userInteractionEnabled = FALSE;
    [hist1 setText:[NSString stringWithFormat:@"TOTAL: %i VINOS",[((Deck*)myDelegate) getOrderPrice]]];
    [deliverItemsScroll addSubview:hist1];
    
    
    deliverItemsScroll.contentSize = CGSizeMake(deliverItemsScroll.frame.size.width, barHeight *(i+1));
    
    
}

#pragma mark -
#pragma mark NOTICE VIEW

-(void)addNoticeView{
    noticeView = [[UIView alloc]initWithFrame:cardView.bounds];
    noticeView.backgroundColor = [UIColor whiteColor];
    noticeView.alpha = 0.0f;
    [cardView addSubview:noticeView];
    
    //CLOSE GESTURE
    UITapGestureRecognizer *gestureTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeNotice)];
    gestureTap.numberOfTapsRequired = 1;
    [noticeView addGestureRecognizer:gestureTap];
    
    noticeTxt=[[UITextView alloc] initWithFrame:CGRectMake(noticeView.bounds.size.width*0.1, noticeView.bounds.size.height*0.1, noticeView.bounds.size.width*0.8, noticeView.bounds.size.height*0.8)];
    noticeTxt.backgroundColor = [UIColor clearColor];
    noticeTxt.textAlignment = NSTextAlignmentCenter;
    noticeTxt.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(noticeTxt.bounds.size.height*0.14)];
    noticeTxt.alpha = 1.0f;
    noticeTxt.textColor = [UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
    noticeTxt.userInteractionEnabled = FALSE;
    [noticeView addSubview:noticeTxt];
    
}

-(void)setNoticeView:(NSString*)txt{
    noticeTxt.text = txt;
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35f];
    noticeView.alpha = 0.85f;
    [UIView commitAnimations];

}

-(void)closeNotice{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.25f];
    noticeView.alpha = 0.0f;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark CARD VIEW







    
    
#pragma mark -
#pragma mark MAPS
    
    
-(void)addMapsAndStuff{
    NSLog(@"\nADD MAPS");
    
    // MAP
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,cardView.bounds.size.height*0.1,cardView.bounds.size.width,cardView.bounds.size.height*0.9)];
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeStandard;
    mapView.delegate = self;
    mapView.backgroundColor = [UIColor whiteColor];
    mapView.alpha = 1.0f;
    mapView.clipsToBounds = YES;
    mapView.layer.cornerRadius = 5.0f;
   // mapView.centerCoordinate = CLLocationCoordinate2DMake(-33.9245683,18.419775);
     [cardView addSubview:mapView];
    
   
    //START LOCATION
    
    self.locManager = [[CLLocationManager alloc] init];
    [self.locManager requestWhenInUseAuthorization];
    self.locManager.distanceFilter = kCLDistanceFilterNone;
    self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locManager.delegate = self;
    [self.locManager startUpdatingLocation];
    
    
    // CENTER ON TAJ HOTEL
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(-33.9245683,18.419775);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 500, 500)];
    [mapView setRegion:adjustedRegion animated:YES];
     
    
    //ADD PIN TO MIDDLE OF MAP
    myAnnotation = [[MKPointAnnotation alloc]init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake(-33.9245683,18.419775);
    myAnnotation.title = @"Reserve Wine Cellar";
    myAnnotation.subtitle = @"Tap for more information";
    [self.mapView addAnnotation:myAnnotation];
    
    UILabel *memberTit = [[UILabel alloc] initWithFrame:CGRectMake(0, cardView.bounds.size.height*0 ,cardView.bounds.size.width*1, cardView.bounds.size.height*0.075)];
    memberTit.textAlignment =  NSTextAlignmentCenter;
    memberTit.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
   // memberTit.font = [UIFont fontWithName:@"SFUIText-Regular" size:(memberTit.bounds.size.height*0.4)];
    memberTit.font = [UIFont systemFontOfSize:cardView.bounds.size.height*0.05];
    memberTit.userInteractionEnabled = TRUE;
    memberTit.backgroundColor = [UIColor whiteColor];
    [memberTit setText:@"DELIVER TO"];
    [cardView addSubview:memberTit];
    
    
    //ADD GESTURE
    UITapGestureRecognizer *tappedADD = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAdressField)];
    tappedADD.numberOfTapsRequired = 1;
    [memberTit addGestureRecognizer:tappedADD];
    
    
    addressLocation = [[UITextField alloc] initWithFrame:CGRectMake(0, cardView.bounds.size.height*0.075, cardView.bounds.size.width*1, cardView.bounds.size.height*0.125)] ;
    addressLocation.delegate = self;
    addressLocation.returnKeyType = UIReturnKeySearch;
    addressLocation.placeholder = @"ENTER ADDRESS" ;
    addressLocation.text = @"" ;
    addressLocation.autocorrectionType = UITextAutocorrectionTypeNo ;
    addressLocation.autocapitalizationType = UITextAutocapitalizationTypeWords;
    addressLocation.adjustsFontSizeToFitWidth = YES;
    addressLocation.textAlignment = NSTextAlignmentCenter;
    memberTit.font = [UIFont systemFontOfSize:addressLocation.bounds.size.height*0.8];
    addressLocation.backgroundColor = [UIColor whiteColor];
    addressLocation.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    [cardView addSubview:addressLocation];
    

}

-(void)selectAdressField{
    NSLog(@"SET ADDRESS FIELD");
    [addressLocation becomeFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"TEXT  SHOULD begin RETURN");
    if (addressLocation.text.length > 0) {
        addressLocation.text = @"";
    }
    
    
    return YES;
}

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"FINISH EDITING");
    
    //SET IN FORM
    [deliverTable setAddress:addressLocation.text];
    [deliverTable setAddressDirect:addressLocation.text];
    
    //LOCATE
    [self forwardLocateMap];
    
    
    
}

-(void)updateAdFromForm:(NSString *)txt{
    
    //SET IN FORM
    addressLocation.text = txt;
    
    //LOCATE
    [self forwardLocateMap];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSLog(@"TEXT FIELD SHOULD RETURN");
    
    [addressLocation resignFirstResponder];
    return NO; // We do not want UITextField to insert line-breaks.
}


#pragma mark -
#pragma mark DELIVERY

-(void)makeDelivery{
    NSLog(@"\nMAKE DELIVERY");
    
    //CHECK IF LOGGED IN
    if ([myDelegate checkForLoggedInDeck]) {
        
        //CHECK DISTANCE
        CLLocation *baseLoc = [[CLLocation alloc] initWithLatitude:-33.9245683 longitude:18.419775];
        CLLocationDistance meters = [deliveryLocation distanceFromLocation:baseLoc];
        // Go ahead with this
        if (meters < 9500) {
            //IN RANGE
            
                //CHECK IF ENOUGH CREDITS WITH DELIVERY FEE
                int remainingValue = [[[NSUserDefaults standardUserDefaults] stringForKey:@"balance"] integerValue] - [myDelegate getOrderPrice];

                if(remainingValue < 0 && [[[[NSUserDefaults standardUserDefaults] stringForKey:@"membership_type"] uppercaseString] isEqualToString:@"BASIC"]){
                    //PROMPT BUY VINOS OR GET MEMBERSHIP
                    
                    [((Deck*)myDelegate) openCloseUserBuyDeck];
                    [((Deck*)myDelegate) activateDeck];
                }
                else{
                    NSLog(@"CONFIRMED DELIVERY");
                    
                    //MIN ORDER AMOUNT
                    [self setNoticeView:@"We are processing your delivery."];
                    
                    //PLACE DELIVERY
                    [self placeDelivery];
                    
                    NSArray *productsListFake = [NSArray arrayWithArray:((NSMutableArray*)[self.myDelegate getData])];
                    
                    
                    //STORE TO PARSE DELIVERY REQUEST
                    PFObject *testObject = [PFObject objectWithClassName:@"DELIVERY_REQUESTS"];
                    testObject[@"products"] = productsListFake;
                    testObject[@"notes"] = [self getDelNotes];
                    testObject[@"address"] = [self getDelAddress];
                    testObject[@"coordinates"] = [self getDelivLocation];
                    testObject[@"price"] = [NSString stringWithFormat:@"%i",[((Deck*)myDelegate) getOrderPrice]] ;
                    testObject[@"username"] = [[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
                    
                    [testObject saveInBackground];

                }
                
            
            
            
        }
        else{
            //NOT IN RADIUS
            [self setNoticeView:@"Only available in Cape Town and nearby regions."];
            
            //HIDE BLACK CARD
           // [myDelegate activateDeliveryDeck];
        }
        
        
        
    }
    else{
        //USER NEEDS TO LOG IN
        
        //[self setNoticeView:@"Members only\n\nPlease Log In or Sign up to have your Wine Delivered to you."];
        
        //HIDE BLACK CARD
        //[((Deck*)myDelegate) activateDeck];
        
        //OPEN CLOSE USER
        [myDelegate openCloseUserDeck];
    }
    
    
    
}

-(void)activateDeckDeliver{
    //HIDE BLACK CARD
    [((Deck*)myDelegate) activateDeck];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (alertView.tag == 99) {
        if (buttonIndex == 0)
        {
            
            NSLog(@"cancel");
            //MIN ORDER AMOUNT
            [self setNoticeView:@"Our opperating hours are from 10:00 till 22:00 daily and usually deliver with in 25mins, depending on traffic."];
            
        }
        else
        {
            NSLog(@"make call");
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+27787860307"]];

            [self setNoticeView:@"Thank you for calling.\n\nWe hope you enjoy our service."];
            
        }
    }
    
    
}

-(void)placeDelivery{
    NSLog(@"PLACE DELIVERY");
    
    
    //LOADING
    [myDelegate startLoadingNowDeck:@"Placing Delivery"];
    
    
    //CALL API AND CHECK FOR USER UPDATE AFTER CONFIRM MESSAGE
    dataDeliver = [[NSMutableData alloc] init];
    //NSURL *url = [NSURL URLWithString:@"https://myvinos-api.infinity-g.com/orders"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MYVINOSSERVER,@"/orders"]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:1820.0];
    
    
    
    NSArray *productsListFake = [NSArray arrayWithArray:((NSMutableArray*)[myDelegate getData])];
    
    
    //NSArray *myTmep = [@"",nill];
    //NSArray *keys =;
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"vin_redemption", @"type",
                                 [NSDictionary dictionaryWithObjectsAndKeys:[self getDelAddress],@"address",[self getDelivLocation],@"coordinates", nil], @"location",
                                 [self getDelNotes], @"notes",
                                 productsListFake, @"products",
                                 nil];
    
    
    
    NSLog(@"\n\nSENDING ORDER REQUEST \n %@",requestData);
    
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
    
    connectionDeliver = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)closeDelivery{
    NSLog(@"\nCLOSE DELIVERY");
    
    //CHECK CREDITS
    
    //HIDE MAP
    //mapView.alpha = 0.0f;
    //deliverButton.alpha = 1.0f;
    
    
}

-(void)addDeliverForm{
    NSLog(@"\nADD DELIVERY FORM");
    
    //DELIVER TIME
    timeLabel =  [[UILabel alloc] initWithFrame:CGRectMake(cardView.bounds.size.width*0.0, cardView.bounds.size.height*0.9 , cardView.bounds.size.width*1.0,cardView.bounds.size.height*0.1 )];
    timeLabel.textAlignment =  NSTextAlignmentCenter;
    timeLabel.backgroundColor = [UIColor whiteColor];
    timeLabel.layer.cornerRadius = 5;
    timeLabel.clipsToBounds = true;
    timeLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    timeLabel.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(timeLabel.bounds.size.height*0.6)];
    timeLabel.userInteractionEnabled = FALSE;
    [timeLabel setText:@"Delivery usually takes 25 minutes"];
    [cardView addSubview:timeLabel];
    
    
    // DELIVER NOW BUTTTON
    deliverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deliverButton.frame = CGRectMake(0, 0 , cardView.bounds.size.width*0.07, cardView.bounds.size.height*0.155);
    deliverButton.center = CGPointMake(cardView.bounds.size.width*0.5, cardView.bounds.size.height*0.485);
    [[deliverButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [deliverButton setBackgroundImage:[[UIImage imageNamed:@"deliverLocation.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [deliverButton addTarget:self action:@selector(geolocateMe) forControlEvents:UIControlEventTouchUpInside];
    deliverButton.alpha = 1;
    deliverButton.userInteractionEnabled = TRUE;
    [cardView addSubview:deliverButton];
    
}


-(BOOL)hasItems{
    if ([deliveryDecks count]>0) {
        return TRUE;
    }
    else{
        return FALSE;
    }
}


#pragma mark -
#pragma mark TOUCH


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touched in DELIVERY");
   
    
}



#pragma mark -
#pragma mark MAP DELEGATES

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    NSLog(@"MAP ABOUT TO BE MOVED");
}

- (void)mapView:(MKMapView *)amapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"MAP MOVED DONE");
    //UPDATE ANNOTATION
   // myAnnotation.coordinate = mapView.camera.centerCoordinate;
    //GEO CODE POSITION
    //[addressLocation setText:@"52 Buitenkant Street, Cape Town"];
    //[mapView setCenterCoordinate:mapView.camera.centerCoordinate animated:YES];
    
    //GET STRING ADDRESS FROM MOVED MAP
    CLLocation *mapCenterLoc = [[CLLocation alloc] initWithLatitude:mapView.camera.centerCoordinate.latitude longitude:mapView.camera.centerCoordinate.longitude];
    [self reverseGeocode:mapCenterLoc];
    
   
    
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView{
    NSLog(@"\nSTART LOCATING USER");
    
    //WAIT FOR GPS TO BECOME ACCURATE AND UPDATE MAP TO CURRENT LOCATION
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView{
    NSLog(@"\nSTOP LOCATING USER");
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"\nFAIL LOCATION %@",error.localizedDescription );
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    NSLog(@"\nUPDATE USER LOCATION");
    
    /*
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    //[aMapView setRegion:region animated:YES];
     */
    
    //CENTER MAP ON CURRENT LOCATION
    // [mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"\nVIEW FOR ANNOTATION");
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
    return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            //pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            
            UIImage *orangeImage = [UIImage imageNamed:@"MyVinosMapMark.png"];
            CGRect resizeRect;
            //rescale image based on zoom level
            resizeRect.size.height = orangeImage.size.height * 0.5;
            resizeRect.size.width = orangeImage.size.width  * 0.5 ;
            NSLog(@"height =  %f, width = %f, zoomLevel = %f", resizeRect.size.height, resizeRect.size.width,11 );
            resizeRect.origin = (CGPoint){0,0};
            UIGraphicsBeginImageContext(resizeRect.size);
            [orangeImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            pinView.image = resizedImage;
            
           // pinView.image = [UIImage imageNamed:@"MyVinosMapMark.png"];
            
            pinView.calloutOffset = CGPointMake(16*0.5, 25*0.5);
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
            
            // Add an image to the left callout.
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MyVinosMapMark.png"]];
            pinView.leftCalloutAccessoryView = iconView;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        NSLog(@"Clicked Shop");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reserve Wine Cellar" message:@"Would you like to call us directly for more information?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call now", nil];
        alertView.tag = 99;
        [alertView show];
    }
    
}




#pragma mark -
#pragma mark MAP DIRECTIONS

-(void)showDirectionsOnMap{
    
    //REMOVE PREVIOUS OVERLAYS
    [mapView removeOverlays:mapView.overlays];
    
    //DELIVERY LCOATION
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:deliveryLocation.coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark] ;
    [mapItem setName:@"YOU ARE HERE"];
    
    //BASE
    CLLocation *baseLocation = [[CLLocation alloc] initWithLatitude:-33.9245683 longitude:18.419775];
    MKPlacemark *placemarkBASE = [[MKPlacemark alloc] initWithCoordinate:baseLocation.coordinate addressDictionary:nil];
    MKMapItem *mapItemBASE = [[MKMapItem alloc] initWithPlacemark:placemarkBASE] ;
    [mapItemBASE setName:@"MyVinos Wine Cellar"];
    
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:mapItem];
    [request setDestination:mapItemBASE];
    [request setTransportType:MKDirectionsTransportTypeAutomobile]; // This can be limited to automobile and walking directions.
    [request setRequestsAlternateRoutes:NO]; // Gives you several route options.
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (!error) {
            for (MKRoute *route in [response routes]) {
                [mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
                // You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
                
                //SHOW ESTIMATED TIME
                
                timeLabel.text = [NSString stringWithFormat:@"Delivered in about %i minutes",(int)([route expectedTravelTime]/60)+10];

            }
        }
        else{
            NSLog(@"WE COULD NOT DETERMINE THE BEST ROUTE FOR YOU");
        }
    }];
    
}



- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor blueColor]];
        [renderer setLineWidth:5.0];
        [renderer setAlpha:0.5];
        return renderer;
    }
    return nil;
}




#pragma mark -
#pragma mark CONNECTION DELEGATES


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    //LOADING IMAGE
   // loadingImage.alpha = 1.0f;
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = [httpResponse statusCode];
    NSLog(@"URL RESPONSE %i",responseStatusCode);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection == self.connectionDeliver) {
        [self.dataDeliver appendData:data];
    }
    // receivedData is an instance variable declared elsewhere.
   // NSLog(@"data recieved %@",data);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Did fail with error %@" , [error localizedDescription]);
    
    //LOADING IMAGE
    [myDelegate stopLoadingDeck];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    if(connection == self.connectionDeliver) {
        //GET STRING FROM DATA RETURNED
        NSString *responseString = [[NSString alloc] initWithData:dataDeliver encoding:NSUTF8StringEncoding];
        //NSLog(@"TOP UP data done %@",responseString);
        NSError *e = nil;
        
        //BUILD JSON DATA
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        //CREATE DICTIONARY
        jsonDataDeliver = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error: &e];
        NSLog(@"DELIVER DATA DONE:\n %@",jsonDataDeliver);
        //CHECK IF ERROR EXISTS AS KEY
        if ([jsonDataDeliver objectForKey:@"errors"]) {
            //NOT SUCESS
            NSLog(@"ERROR %@",[[jsonDataDeliver objectForKey:@"errors"] objectAtIndex:0]);
            
            
            [self setNoticeView:[NSString stringWithFormat:@"%@",[[jsonDataDeliver objectForKey:@"errors"] componentsJoinedByString:@"\n"]]];
            
            [myDelegate stopLoadingDeck];
            
        }
        else if ([jsonDataDeliver objectForKey:@"status"]) {
            //CHECK SUCESS
            if([[jsonDataDeliver objectForKey:@"status"] isEqualToString:@"complete"]){
                //DELIVERY DONE
                
                timeLabel.text = [NSString stringWithFormat:@"Your order will arrive in about %@ minutes",[[jsonDataDeliver objectForKey:@"delivery_details"] objectForKey:@"time_estimate"]];

               
                
                //UPDATE USER STATS
                [[NSUserDefaults standardUserDefaults] setObject:[[jsonDataDeliver objectForKey:@"balance"] objectForKey:@"balance"] forKey:@"balance"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [myDelegate updateUserMainStatsDeck];
                
                [myDelegate stopLoadingDeck];
                
                [self setNoticeView:[NSString stringWithFormat:@"DONE\n\nYour order will be with you in approximately %@ minutes.",[[jsonDataDeliver objectForKey:@"delivery_details"] objectForKey:@"time_estimate"]]];
                
                //CLEAR DECK
                [myDelegate delieveryDeckSuccessDeck];


            }
            else{
                
            }
            
        }
        else{
            //USER NEEDS TO LOG IN
            NSLog(@"DELIVERY ERROR %@",jsonDataDeliver);
            
            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MEMBERS ONLY"
                                                            message:[NSString stringWithFormat:@"Please Log In or Sign up to have your Wine Delivered",[[jsonDataDeliver objectForKey:@"delivery_details"] objectForKey:@"time_estimate"]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

             */
         
            
            [myDelegate stopLoadingDeck];
            
            [self setNoticeView:@"Something went wrong\n\nContact us on +27 (78) 786 0307 if the problem persists."];
        }
    }
    
    
    //LOADING IMAGE
    
}


#pragma mark -
#pragma mark Location Delegate

-(void)geolocateMe{
    NSLog(@"GET LOCATION");
    //CHECK PERMISIIONS ALL APPS
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"DEVICE ALLOWED LOCATION");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
           UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Enable Location"
                                               message:@"To re-enable, please go to Settings and turn on Location Service for MyVinos."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [alert show];
            
        }
        else{
            NSLog(@"APP ALLOWED LOCATION");
           // NSLog([self deviceLocation]);
            
            //ADD TO PARSE
            //ADD DEVICE STATS TO PARSE
            PFObject *testObjectGPS = [PFObject objectWithClassName:@"GPS"];
            testObjectGPS[@"LAT"] = [NSString stringWithFormat:@"%f",locManager.location.coordinate.latitude];
            testObjectGPS[@"LONG"] = [NSString stringWithFormat:@"%f",locManager.location.coordinate.longitude];
            
            //CHECK FOR USER
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if([defaults objectForKey:@"id"]){
                testObjectGPS[@"id"] = [defaults stringForKey:@"id"];
            }
            if([defaults objectForKey:@"first_name"]){
                testObjectGPS[@"first_name"] = [defaults stringForKey:@"first_name"];
            }
            if([defaults objectForKey:@"last_name"]){
                testObjectGPS[@"last_name"] = [defaults stringForKey:@"last_name"];
            }
            if([defaults objectForKey:@"email"]){
                testObjectGPS[@"email"] = [defaults stringForKey:@"email"];
            }
            if([defaults objectForKey:@"username"]){
                testObjectGPS[@"username"] = [defaults stringForKey:@"username"];
            }
            if([defaults objectForKey:@"membership_type"]){
                testObjectGPS[@"membership_type"] = [defaults stringForKey:@"membership_type"];
            }
            if([defaults objectForKey:@"balance"]){
                testObjectGPS[@"balance"] = [defaults stringForKey:@"balance"];
            }
            
            
            
            [testObjectGPS saveInBackground];
            
            [self reverseGeocode:locManager.location];
            
            //SET MAP
            [mapView setCenterCoordinate:locManager.location.coordinate];
        }
    }
    else{
        //DEVICE DENIED
        NSLog(@"DEVICE DENIED LOCATION");
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Enable Location"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for MyVinos."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    

    
   
}

-(void)forwardLocate{
    NSLog(@"FORMWARD LOCATION");
    
    //SET MAP
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:[NSString stringWithFormat:@"%@ Cape Town, WC, South Africa",[self getDelAddress]]
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     // Check for returned placemarks
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         
                         //GET CO-ORDINATES
                         
                         //SET MAP
                         [mapView setCenterCoordinate:topResult.location.coordinate animated:YES];
                         
                         //SET DELIVERY LOCATION
                         deliveryLocation = topResult.location;
                         
                         
                         // Create a MLPlacemark and add it to the map view
                         //MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         //[self.mapView addAnnotation:placemark];
                         //[placemark release];
                     }
                     //[geocoder release];
                 }];
}

-(void)forwardLocateMap{
    NSLog(@"FORMWARD LOCATION MAP");
    
    //SET MAP
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:addressLocation.text
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     // Check for returned placemarks
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         
                         //GET CO-ORDINATES
                         
                         //SET MAP
                         [mapView setCenterCoordinate:topResult.location.coordinate animated:YES];
                         
                         //SET DELIVERY LOCATION
                         deliveryLocation = topResult.location;
                         
                         //SHOW ROUTE
                         //[self showDirectionsOnMap];
                         
                         // Create a MLPlacemark and add it to the map view
                         //MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         //[self.mapView addAnnotation:placemark];
                         //[placemark release];
                     }
                     else{
                         //PLACE NOT FOUND
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Correct Address?"
                                                                         message:@"Please check the address you entered or use the map to scroll to your delivery location."
                                                                        delegate:self
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
                         [alert show];
                     }
                 }];
}

-(void)updateCurrentLocation{
    
    //UPDATE MAP
    
    //check if location is available first
    if([CLLocationManager locationServicesEnabled]){
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
           //NOT AVAILABLE
            
        }
        else{
            [self geolocateMe];
        }
        
        

        
    }
    else{
        //NOT AVAILABLE
    }
    
   

    
    
    
}

- (NSString *)deviceLocation
{
    NSString *theLocation = [NSString stringWithFormat:@"%f, %f", self.locManager.location.coordinate.latitude, self.locManager.location.coordinate.longitude];
    return theLocation;
}

- (NSString *)getDelivLocation
{
    NSString *theLocation = [NSString stringWithFormat:@"%f, %f", deliveryLocation.coordinate.latitude, self.deliveryLocation.coordinate.longitude];
    return theLocation;
}

- (void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (!error) {
            CLPlacemark *placemark = [placemarks lastObject];
            NSLog(@"Country: %@", placemark.country);
            
            NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
            NSString *addressString = [lines componentsJoinedByString:@","];
            NSLog(@"Address: %@", addressString);
            
            //SET FORM
            [self setDelAddress:addressString];
            
            //SET DELIVERY LOCATION
            deliveryLocation = location;
            addressLocation.text = addressString;
            
            //SHOW ROUTE
            [self showDirectionsOnMap];
            
            
        } else
            NSLog(@"Error %@", error.description);
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"LOCATION in fail with error");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"LOCATION in update to location");
    
    
    
    //LOCATION FOUND AND UPDATED
    
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   
    
    
}


@end
