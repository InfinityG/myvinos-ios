//
//  User.m
//  colorgameapp
//
//  Created by Herman Coetzee on 2012/10/07.
//  Copyright (c) 2012 Color Game App. All rights reserved.
//
#import <Parse/Parse.h>

#import "Deliver.h"
#import "ParseStarterProjectViewController.h"
#import "FormTableControllerDeliver.h"

#define CARDHEIGHT self.bounds.size.height
#define DISPLAYHEIGHT self.bounds.size.height*0.595

#define CARDRECT 0, 0 ,self.bounds.size.width*1.00, CARDHEIGHT

//#define MYVINOSSERVER @"https://myvinos-test-api.infinity-g.com"
#define MYVINOSSERVER @"https://myvinos-api.infinity-g.com"



@implementation Deliver

@synthesize myDelegate,deliveryDecks,deliverLabel,deliverButton,mapView,myAnnotation,addressLocation,locManager,timeLabel;

@synthesize topUps,connectionDeliver,dataDeliver,jsonDataDeliver,noticeView,noticeTxt,deliverButtonInside,deliveryLocation;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"HELLO DELIVERY SCREEN");
        
        deliveryDecks = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
        
        deliveryLocation = [[CLLocation alloc] initWithLatitude:-33.9245683 longitude:18.419775];
        
        deliverOpen = FALSE;
        
        //ADD CARD HOLDER
        cardView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        cardView.backgroundColor = [UIColor whiteColor];
        cardView.alpha = 1.0f;
        
        
        //ADD MAP
        [self addMapsAndStuff];
        
        //ADD DELIVER FORM
        [self addDeliverForm];
        
        //ADD NOTICE
        [self addNoticeView];
        
        //ADD CARD VIEW
        [self addSubview:cardView];
       
        mapView.frame = CGRectMake(0, self.frame.size.height*0.15, self.frame.size.width, self.frame.size.height*0.85);
        
    }
    return self;
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
    
    noticeTxt=[[UITextView alloc] initWithFrame:CGRectMake(noticeView.bounds.size.width*0.1, noticeView.bounds.size.height*0.2, noticeView.bounds.size.width*0.8, noticeView.bounds.size.height*0.6)];
    noticeTxt.backgroundColor = [UIColor clearColor];
    noticeTxt.textAlignment = NSTextAlignmentCenter;
    noticeTxt.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:(noticeTxt.bounds.size.height*0.11)];
    noticeTxt.alpha = 1.0f;
    noticeTxt.userInteractionEnabled = FALSE;
    [noticeView addSubview:noticeTxt];
    
}

-(void)setNoticeView:(NSString*)txt{
    noticeTxt.text = txt;
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    noticeView.alpha = 1.0f;
    [UIView commitAnimations];

}

-(void)closeNotice{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    noticeView.alpha = 0.0f;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark CARD VIEW


-(void)hideCardView{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    
    cardView.frame = CGRectMake(self.bounds.size.width*0.00, -CARDHEIGHT ,self.bounds.size.width*1.00, CARDHEIGHT);
   
    [UIView commitAnimations];
}


-(void)showCardView{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    
    cardView.frame = CGRectMake(CARDRECT);
    
    [UIView commitAnimations];
}

    
    
    
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
   // mapView.centerCoordinate = CLLocationCoordinate2DMake(-33.9245683,18.419775);
     [cardView addSubview:mapView];
    
    /*/LOCATION BUT
    UIButton *geolocateBut = [UIButton buttonWithType:UIButtonTypeCustom];
    geolocateBut.frame = CGRectMake(cardView.bounds.size.width*0.88, cardView.bounds.size.height*0.825 , cardView.bounds.size.width*0.1, cardView.bounds.size.width*0.1);
    [geolocateBut setBackgroundImage:[[UIImage imageNamed:@"geolocateBut.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [geolocateBut addTarget:self action:@selector(geolocateMe) forControlEvents:UIControlEventTouchUpInside];
    geolocateBut.alpha = 1;
    geolocateBut.backgroundColor = [UIColor clearColor];
    [cardView addSubview:geolocateBut];
    */
    
    //START LOCATION
    
    self.locManager = [[CLLocationManager alloc] init];
    [self.locManager requestWhenInUseAuthorization];
    self.locManager.distanceFilter = kCLDistanceFilterNone;
    self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locManager.delegate = self;
    [self.locManager startUpdatingLocation];
    
    
    // CENTER ON TAJ HOTEL
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(-33.9245683,18.419775);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 200, 200)];
    [mapView setRegion:adjustedRegion animated:YES];
     
    
    //ADD PIN TO MIDDLE OF MAP
    myAnnotation = [[MKPointAnnotation alloc]init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake(-33.9245683,18.419775);
    myAnnotation.title = @"Reserve Wine Cellar";
    myAnnotation.subtitle = @"Tap for more information";
    [self.mapView addAnnotation:myAnnotation];
    
    UILabel *memberTit = [[UILabel alloc] initWithFrame:CGRectMake(mapView.bounds.size.width*0.0, mapView.bounds.size.height*0.0 ,mapView.bounds.size.width*1, mapView.bounds.size.height*0.08)];
    memberTit.textAlignment =  NSTextAlignmentCenter;
    memberTit.backgroundColor = [UIColor clearColor];
    memberTit.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    memberTit.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(memberTit.bounds.size.height*0.8)];
    memberTit.userInteractionEnabled = FALSE;
    memberTit.backgroundColor = [UIColor whiteColor];

    [memberTit setText:@"GOING TO"];
    [cardView addSubview:memberTit];
    
    addressLocation = [[UITextField alloc] initWithFrame:CGRectMake(mapView.bounds.size.width*0.0, mapView.bounds.size.height*0.08, mapView.bounds.size.width*1, mapView.bounds.size.height*0.09)] ;
    addressLocation.delegate = self;
    addressLocation.returnKeyType = UIReturnKeySearch;
    addressLocation.placeholder = @"ENTER ADDRESS" ;
    addressLocation.text = @"" ;
    addressLocation.autocorrectionType = UITextAutocorrectionTypeNo ;
    addressLocation.autocapitalizationType = UITextAutocapitalizationTypeWords;
    addressLocation.adjustsFontSizeToFitWidth = YES;
    addressLocation.textAlignment = NSTextAlignmentCenter;
    memberTit.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(addressLocation.bounds.size.height*0.8)];
    addressLocation.backgroundColor = [UIColor whiteColor];
    addressLocation.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
[cardView addSubview:addressLocation];
    
   

}

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"FINISH EDITING");
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
    if ([myDelegate checkForLoggedIn]) {
        
        //CHECK DISTANCE
        CLLocation *baseLoc = [[CLLocation alloc] initWithLatitude:-33.9245683 longitude:18.419775];
        CLLocationDistance meters = [deliveryLocation distanceFromLocation:baseLoc];
        // Go ahead with this
        if (meters < 9500) {
            //IN RANGE
            
                //CHECK IF ENOUGH CREDITS WITH DELIVERY FEE
                int remainingValue = [[[NSUserDefaults standardUserDefaults] stringForKey:@"balance"] integerValue] - [myDelegate getOrderPriceDeck];

                if(remainingValue < 0){
                    //PROMPT BUY
                    
                    [myDelegate openCloseUserBuy];
                     [myDelegate activateDeliveryDeck];
                }
                else{
                    NSLog(@"CONFIRMED DELIVERY");
                    
                    //MIN ORDER AMOUNT
                    [self setNoticeView:@"PLEASE WAIT\n\nWe are processing your delivery."];
                    
                    //PLACE DELIVERY
                    [self placeDelivery];
                    
                    NSArray *productsListFake = [NSArray arrayWithArray:((NSMutableArray*)[((ParseStarterProjectViewController*)self.myDelegate) getDeliveryData])];
                    
                    
                    //STORE TO PARSE DELIVERY REQUEST
                    PFObject *testObject = [PFObject objectWithClassName:@"DELIVERY_REQUESTS"];
                    testObject[@"products"] = productsListFake;
                    testObject[@"notes"] = [myDelegate getDeliveryNotes];
                    testObject[@"address"] = [myDelegate getDeliveryAddress];
                    testObject[@"coordinates"] = [self getDelivLocation];
                    testObject[@"price"] = [NSString stringWithFormat:@"%i",[myDelegate getOrderPriceDeck]] ;
                    testObject[@"username"] = [[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
                    [testObject saveInBackground];

                }
                
            
            
            
        }
        else{
            //NOT IN RADIUS
            [self setNoticeView:@"OUTSIDE DELIVERY ZONE\n\nOnly available in CBD and nearby regions."];
            
            //HIDE BLACK CARD
           // [myDelegate activateDeliveryDeck];
        }
        
        
        
    }
    else{
        //USER NEEDS TO LOG IN
        
        [self setNoticeView:@"Members only\n\nPlease Log In or Sign up to have your Wine Delivered to you."];
        
        //HIDE BLACK CARD
        [myDelegate activateDeliveryDeck];
    }
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (alertView.tag == 99) {
        if (buttonIndex == 0)
        {
            
            NSLog(@"cancel");
            //MIN ORDER AMOUNT
            [self setNoticeView:@"We are here to help.\n\nOur opperating hours are from 10:00 till 22:00 daily and usually deliver with in 25mins, depending on traffic."];
            
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
    [myDelegate startLoadingNow:@"Placing Delivery"];
    
    
    //CALL API AND CHECK FOR USER UPDATE AFTER CONFIRM MESSAGE
    dataDeliver = [[NSMutableData alloc] init];
    //NSURL *url = [NSURL URLWithString:@"https://myvinos-api.infinity-g.com/orders"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MYVINOSSERVER,@"/orders"]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:1820.0];
    
    //CREATE PRODUCTS ARRAY
    //NSArray *productsListFake = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"72316",@"product_id",@"5",@"quantity", nil],nil];
    // NSDictionary *productsListFake = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"72316",@"product_id",@"5",@"quantity", nil],nil];
    // NSDictionary *productsListFake = [NSArray arrayWithArray:((NSMutableArray*)[((ParseStarterProjectViewController*)self.myDelegate) getDeliveryData])];
    
    NSArray *productsListFake = [NSArray arrayWithArray:((NSMutableArray*)[((ParseStarterProjectViewController*)self.myDelegate) getDeliveryData])];
    
    
    //NSArray *myTmep = [@"",nill];
    //NSArray *keys =;
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"vin_redemption", @"type",
                                 [NSDictionary dictionaryWithObjectsAndKeys:[myDelegate getDeliveryAddress],@"address",[self getDelivLocation],@"coordinates", nil], @"location",
                                 [myDelegate getDeliveryNotes], @"notes",
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
    timeLabel =  [[UILabel alloc] initWithFrame:CGRectMake(cardView.bounds.size.width*0.0, cardView.bounds.size.height*0.4 , cardView.bounds.size.width*0.2,cardView.bounds.size.width*0.2 )];
    timeLabel.center = CGPointMake(cardView.bounds.size.width*0.1, cardView.bounds.size.height*0.5);
    timeLabel.textAlignment =  NSTextAlignmentCenter;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.layer.cornerRadius = 5;
    timeLabel.clipsToBounds = true;
    timeLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    timeLabel.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:(timeLabel.bounds.size.height*0.4)];
    timeLabel.userInteractionEnabled = FALSE;
    [timeLabel setText:@"NOW"];
    //[cardView addSubview:timeLabel];
    
    
    // DELIVER NOW BUTTTON
    deliverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deliverButton.frame = CGRectMake(0, 0 , cardView.bounds.size.width*0.07, cardView.bounds.size.height*0.155);
    deliverButton.center = CGPointMake(cardView.bounds.size.width*0.5, cardView.bounds.size.height*0.5);
    [deliverButton setBackgroundImage:[[UIImage imageNamed:@"deliverLocation.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [deliverButton addTarget:myDelegate action:@selector(geolocateMe) forControlEvents:UIControlEventTouchUpInside];
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
    [myDelegate stopLoading];
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
        NSLog(@"TOP UP DATA DONE:\n %@",jsonDataDeliver);
        //CHECK IF ERROR EXISTS AS KEY
        if ([jsonDataDeliver objectForKey:@"errors"]) {
            //NOT SUCESS
            NSLog(@"ERROR %@",[[jsonDataDeliver objectForKey:@"errors"] objectAtIndex:0]);
            
            
            [self setNoticeView:[NSString stringWithFormat:@"OOPS\n\n%@",[[jsonDataDeliver objectForKey:@"errors"] componentsJoinedByString:@"\n"]]];
            
            [myDelegate stopLoading];
            
        }
        else if ([jsonDataDeliver objectForKey:@"status"]) {
            //CHECK SUCESS
            if([[jsonDataDeliver objectForKey:@"status"] isEqualToString:@"complete"]){
                //DELIVERY DONE
                
                timeLabel.text = [[jsonDataDeliver objectForKey:@"delivery_details"] objectForKey:@"time_estimate"];
                
               
                
                //UPDATE USER STATS
                [[NSUserDefaults standardUserDefaults] setObject:[[jsonDataDeliver objectForKey:@"balance"] objectForKey:@"balance"] forKey:@"balance"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [myDelegate updateUserMainStats];
                
                [myDelegate stopLoading];
                
                [self setNoticeView:[NSString stringWithFormat:@"SUCCESS\n\nYour order will be with you in approximately %@ minutes. (Depending on traffic conditions)\n\nIN VINOS VERITAS!",[[jsonDataDeliver objectForKey:@"delivery_details"] objectForKey:@"time_estimate"]]];
                
                //CLEAR DECK
                [myDelegate delieveryDeckSuccess];


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
         
            
            [myDelegate stopLoading];
            
            [self setNoticeView:@"We apologise\n\nSomething went wrong, please contact us on +27 (78) 786 0307 if the problem persists. Will can process your order telephonically for you."];
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
            NSLog([self deviceLocation]);
            
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
    [geocoder geocodeAddressString:[NSString stringWithFormat:@"%@ Cape Town South Africa",[myDelegate getDeliveryAddress]]
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
                     //[geocoder release];
                 }];
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
            [myDelegate setDeliveryAddress:addressString];
            
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
