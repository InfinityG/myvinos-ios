//
//  Card.m
//  colorgameapp
//
//  Created by Herman Coetzee on 2012/10/07.
//  Copyright (c) 2012 Color Game App. All rights reserved.
//

#import "Card.h"
#import "Deck.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation Card

@synthesize data,myDelegate,description,title,bottleIcons,price, panRecognizer,bottleCounter,cardHolder;

@synthesize maxPriceTxt;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       // NSLog(@"HELLO WINE CARD");
        cardOpen = FALSE;
        //DESIGN CARD
        self.backgroundColor = [UIColor clearColor];
        numberOfItems = 0;
        
        bottleIcons = [[NSMutableArray alloc] init];
        self.clipsToBounds = FALSE;
        
    }
    return self;
}


- (void)drawDashedBorderAroundView:(UIView *)v
{
    //border definitions
    CGFloat cornerRadius = 5;
    CGFloat borderWidth = 0.4f;
    UIColor *lineColor = [UIColor lightGrayColor];
    
    //drawing
    CGRect frame = v.bounds;
    
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = frame;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    _shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
    _shapeLayer.strokeColor = [lineColor CGColor];
    _shapeLayer.lineWidth = borderWidth;
    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view, the border is visible
    [v.layer addSublayer:_shapeLayer];
    v.layer.cornerRadius = cornerRadius;
}



#pragma mark -
#pragma mark DATA

-(void)setData:(NSDictionary*)myColor {
    //NSLog(@"SET CARD DATA %@",myColor);

    //DATA ADD NEW FIELDS
    data = [[NSMutableDictionary alloc] initWithDictionary:myColor copyItems:NO];
    
    //CREATE CARD HOLDER
    cardHolder = [[UIView alloc] initWithFrame:self.bounds];
    //cardHolder.backgroundColor = [UIColor whiteColor];
    [self drawDashedBorderAroundView:cardHolder];
    /*
    cardHolder.layer.cornerRadius = 10;
    cardHolder.layer.shadowColor = [UIColor blackColor].CGColor;
   cardHolder.layer.shadowOffset = CGSizeMake(0, 0);
   cardHolder.layer.shadowOpacity = 0.75f;
    cardHolder.layer.shadowRadius = 1.0;
     */
    [self addSubview:cardHolder];
    
    
    //ADD BOTTLE COUNTER
    bottleCounter = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.000, self.bounds.size.height*0 ,self.bounds.size.width*0.1, self.bounds.size.height*0.1)];
    bottleCounter.textAlignment =  NSTextAlignmentCenter;
    bottleCounter.backgroundColor = [UIColor clearColor];
    bottleCounter.userInteractionEnabled = TRUE;
    bottleCounter.textColor = [UIColor whiteColor];
    bottleCounter.font = [UIFont fontWithName:@"SFUIText-Bold" size:(bottleCounter.bounds.size.height*0.24)];
    bottleCounter.userInteractionEnabled = TRUE;
    if([[data objectForKey:@"quantity"] integerValue] > 0) {
        [bottleCounter setText:[NSString stringWithFormat:@"%i",[[data objectForKey:@"quantity"] integerValue]]] ;
    }
    //BOTTLE TAP
    
   
    
    
    //ADD TITLE
    title = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.095, self.bounds.size.height*0 ,self.bounds.size.width*0.9, self.bounds.size.height*0.1)];
    title.textAlignment =  NSTextAlignmentLeft;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    title.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(title.bounds.size.height*0.275)];
    title.userInteractionEnabled = FALSE;
    [title setText:[myColor objectForKey:@"name"]];
    [self addSubview:title];
    
    //ADD UNIT PRICE
    UILabel *titlePrice = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.1, self.bounds.size.height*0 ,self.bounds.size.width*0.325, self.bounds.size.height*0.04)];
    titlePrice.textAlignment =  NSTextAlignmentLeft;
    titlePrice.backgroundColor = [UIColor clearColor];
    titlePrice.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    titlePrice.font = [UIFont fontWithName:@"SFUIText-Regular" size:(titlePrice.bounds.size.height*0.5)];
    titlePrice.userInteractionEnabled = FALSE;
    [titlePrice setText:[NSString stringWithFormat:@"%@ VINOS",[myColor objectForKey:@"price"]]];
    [self addSubview:titlePrice];
    
    //ADD WINE COLOR
    UIImageView *color = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@0.png",[[data objectForKey:@"color"] uppercaseString]] ]];
    //color.frame = CGRectMake(self.bounds.size.width*0.925, title.bounds.origin.y+title.bounds.size.height*0.3, self.bounds.size.width*0.05, title.bounds.size.height*0.4);
    color.frame = CGRectMake(self.bounds.size.width*0.005, title.bounds.origin.y+title.bounds.size.height*0.1, self.bounds.size.width*0.09, title.bounds.size.height*0.7);
    color.backgroundColor = [UIColor clearColor];
    color.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:color];
    
    //ADD HEART
    UIImageView *favIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"heart%@.png", [data objectForKey:@"favourite"]]]];
    favIcon.frame = CGRectMake(self.bounds.size.width*0.015, 0, self.bounds.size.width*0.05, title.bounds.size.height*1.0);
    favIcon.backgroundColor = [UIColor clearColor];
    favIcon.contentMode = UIViewContentModeScaleAspectFit;
    favIcon.tag = 0;
    favIcon.userInteractionEnabled = TRUE;
    favIcon.backgroundColor = [UIColor clearColor];
    //[self addSubview:favIcon];
    
    [self addSubview:bottleCounter];
    
    /*/HEART TAP
    UITapGestureRecognizer *tappedFav= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeOrRemoveFav:)];
    tappedFav.numberOfTapsRequired = 1;
    [favIcon addGestureRecognizer:tappedFav];
    */
    //ADD PRICE
    
    maxPriceTxt = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.075, self.bounds.size.height*0.925 ,self.bounds.size.width*0.85, self.bounds.size.height*0.05)];
    maxPriceTxt.textAlignment =  NSTextAlignmentCenter;
    maxPriceTxt.backgroundColor = [UIColor whiteColor];
    maxPriceTxt.alpha = 0.0f;
    maxPriceTxt.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    maxPriceTxt.font = [UIFont systemFontOfSize:(price.bounds.size.height*0.5)];
    maxPriceTxt.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(maxPriceTxt.bounds.size.height*0.35)];
    maxPriceTxt.userInteractionEnabled = FALSE;
    [maxPriceTxt setText:@"THATS ALL YOU HAVE IN THE CELLAR"];
    [cardHolder addSubview:maxPriceTxt];

}




#pragma mark -
#pragma mark CARD ACTIVATE AND DEACTIVATE

-(void)activateCard{
    NSLog(@"ACTIVATE CARD");
    
    
    
    //title.userInteractionEnabled = TRUE;
    
    //ADD PAN
    panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panRecognizer];
    lastLocation = self.center;
    
    
    //BUILD UP ALL SCREENS
    NSLog(@"ACTIVATE CARD");

    
   
    
    
    
    
    
    
    
    NSLog(@"IMAGE LOADED");
    
    
    //NSString* myString = [[NSString alloc] initWithString:[NSURL URLWithString:[data objectForKey:@"image_url"] encoding: NSISOLatin1StringEncoding];
    
                         /*
                          char converted[([[data objectForKey:@"image_url"] length] + 1)];
                          [[data objectForKey:@"image_url"] getCString:converted maxLength:([[data objectForKey:@"image_url"] length] + 1) encoding: NSUTF8StringEncoding];
                          
                          NSLog(@"CONVERTE STRING %s", converted);
    */
    
    UIImageView *imageView = [[UIImageView alloc] init];
    // Here we use the new provided sd_setImageWithURL: method to load the web image
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[data objectForKey:@"image_url"]]]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    imageView.frame = CGRectMake (self.bounds.size.width*0.025,title.bounds.size.height*0.95,self.bounds.size.width*0.95,self.bounds.size.height*0.425);
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cardHolder addSubview:imageView];

    
    
    
    
    
    
    
    
    [self addSubview:bottleCounter];

    
    
    
    
    
    
    
    
    
    
    NSLog(@"ACTIVATE CARD2");

    //ADD FARM
    UILabel *farm = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.025, self.bounds.size.height*0.525 ,title.bounds.size.width, title.bounds.size.height*0.5)];
    farm.textAlignment =  NSTextAlignmentLeft;
    farm.backgroundColor = [UIColor clearColor];
    farm.textColor = [UIColor blackColor];
    farm.font = [UIFont fontWithName:@"SFUIDisplay-UltraLight" size:(farm.bounds.size.height*0.5)];
    farm.userInteractionEnabled = FALSE;
    NSMutableString *str = [[[[data objectForKey:@"tags"] objectForKey:@"region"] uppercaseString] mutableCopy];
    
    if (![str isEqualToString:@""]) {
        //ADD /
        [str appendString:@" / "];
    }
    [str appendString:[[[data objectForKey:@"tags"] objectForKey:@"producer"] uppercaseString]];
    
    if (![str isEqualToString:@""]) {
        //ADD /
        [str appendString:@" / "];
    }
    [str appendString:[[[data objectForKey:@"tags"] objectForKey:@"grapes"] uppercaseString]];

    [farm setText:str];
    
    [cardHolder addSubview:farm];
    //NSLog(@"hello3");
    NSLog(@"ACTIVATE CARD3");

    //ADD FARM2
    UILabel *farm2 = [[UILabel alloc] initWithFrame:CGRectMake(-self.bounds.size.width*0.025, self.bounds.size.height*0.525 ,self.bounds.size.width, title.bounds.size.height*0.5)];
    farm2.textAlignment =  NSTextAlignmentRight;
    farm2.backgroundColor = [UIColor clearColor];
    farm2.textColor = [UIColor blackColor];
    farm2.font = [UIFont fontWithName:@"SFUIDisplay-UltraLight" size:(farm2.bounds.size.height*0.5)];
    farm2.userInteractionEnabled = FALSE;
    
    [farm2 setText:[[data objectForKey:@"tags"] objectForKey:@"vintage"]];
    [cardHolder addSubview:farm2];
    
    
    //NSLog(@"hello4");
   // NSLog(@"ACTIVATE CARD4 %@",data);
 /*/NSLog(@"ACTIVATE CARD4 %@",[data objectForKey:@"description"]);
    NSString *descreiptionFormatedText = [[[NSAttributedString alloc] initWithData:[[data objectForKey:@"description"] dataUsingEncoding:NSASCIIStringEncoding ] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSASCIIStringEncoding]} documentAttributes:nil error:nil] string];
    @try {
        //ADD TEXT BOX
  
    }
    @catch (NSException *exception) {
        NSLog(@"THIS IS THE ISSUE %@", exception.reason);
    }
    @finally {
        NSLog(@"DESCRIPTION HAS A FORMAT ERROR %@", [data objectForKey:@"description"]);
    }
   */
    
    NSString *descreiptionFormatedText = [[[NSAttributedString alloc] initWithData:[[data objectForKey:@"description"] dataUsingEncoding:NSUTF8StringEncoding ] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil] string];
   
    
    //NSLog(@"ACTIVATE CARD4.1 %@",data);
   // NSLog(@"ACTIVATE CARD4.1 %@",[data objectForKey:@"description"]);
    
    description = [[UITextView alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.025, self.bounds.size.height*0.575 ,self.bounds.size.width*0.95, self.bounds.size.height*0.325)];
    description.userInteractionEnabled = FALSE;
    description.textAlignment =  NSTextAlignmentNatural;
    [description setBackgroundColor:[UIColor clearColor]];
    description.font = [UIFont fontWithName:@"SFUIText-Light" size:(title.bounds.size.height*0.25)];
    [description setText:descreiptionFormatedText ];
    description.scrollEnabled = TRUE;
    description.userInteractionEnabled = TRUE;
    description.editable = FALSE;
    [cardHolder addSubview:description];
    
    //NSLog(@"hello5");
    
    NSLog(@"ACTIVATE CARD5");

    //ADD PRICE
    price = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.2, self.bounds.size.height*0.925 ,self.bounds.size.width*0.6, self.bounds.size.height*0.05)];
    price.textAlignment =  NSTextAlignmentCenter;
    price.backgroundColor = [UIColor clearColor];
    price.textColor = [UIColor colorWithRed:97.0f/255.0f green:24.0f/255.0f blue: 53.0f/255.0f alpha:1.0f];
    price.font = [UIFont systemFontOfSize:(price.bounds.size.height*0.5)];
    price.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(title.bounds.size.height*0.35)];
    price.userInteractionEnabled = TRUE;
    [price setText:[NSString stringWithFormat:@"GET 1 for %@ VINOS",[data objectForKey:@"price"] ]];
    [cardHolder addSubview:price];
    
    
    //BOTTLE TAP
    bottleTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deliverNowScreenPre)];
    bottleTap.numberOfTapsRequired = 1;
    [price addGestureRecognizer:bottleTap];
    
    
    
    
    
    //PLACE MAX REACHED ON TOP
    [cardHolder addSubview:maxPriceTxt];
    
    NSLog(@"ACTIVATE CARD6");

    
    //ADD QUANTITY BUTTONS
    UIButton *lessBut = [UIButton buttonWithType:UIButtonTypeCustom];
    lessBut.frame = CGRectMake(self.bounds.size.width*0.05, self.bounds.size.height*0.925, self.bounds.size.width*0.1, self.bounds.size.width*0.1);
    [lessBut setBackgroundImage:[[UIImage imageNamed:@"vinosButLess.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    lessBut.contentMode = UIViewContentModeScaleAspectFit;
    [lessBut addTarget:self action:@selector(removeItem) forControlEvents:UIControlEventTouchUpInside];
    [cardHolder addSubview:lessBut];
    
    UIButton *moreBut = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBut.frame = CGRectMake(self.bounds.size.width - self.bounds.size.width*0.1 - self.bounds.size.width*0.05, self.bounds.size.height*0.925, self.bounds.size.width*0.1, self.bounds.size.width*0.1);
    [moreBut setBackgroundImage:[[UIImage imageNamed:@"vinosButMore.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    moreBut.contentMode = UIViewContentModeScaleAspectFit;
    [moreBut addTarget:self action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];
    [cardHolder addSubview:moreBut];
    
    NSLog(@"ACTIVATE CARD7");

    
        
        [bottleIcons removeAllObjects];
        numberOfItems = 0;
        
        //ADD ITEMS
        for (int i = 0 ; i<[[data objectForKey:@"quantity"] integerValue]; i++) {
            [self addItem];
        }
        
        NSLog(@"CARD QUANTITY IS %i",numberOfItems);
        [self showHideDescription];
        
        //[self animateIconsToGrid];
    
    
    
    
    NSLog(@"ACTIVATE CARD8");

    
    cardOpen = TRUE;
    
}

-(void)deliverNowScreenPre{
    
    
    //CHECK IF IT HAS ITEMS
    if(numberOfItems > 0 && ![[myDelegate getDeckType] isEqualToString:@"DELIVERY"]){
        //DEACTIVATE CARD
        //[self deactivateCard];
        
        [self closeMyCard];
        
        //SET DATA QUNATITY
        [data setObject:[NSString stringWithFormat:@"%i",numberOfItems] forKey:@"quantity"];
        
        
        [ self.myDelegate performSelector: @selector( orderCard: ) withObject: self ];
        
        
        
        //SHOW SCREEN
        [myDelegate deliverNowScreen];

    }
    
    
    
}

-(NSString *) stringByStrippingHTML:(NSString*)s {
    NSRange r;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

-(void)deactivateCard{
    NSLog(@"deactivateCard");
    
    
    //REMOVE ALL SCREENS INSIDE SCREEN HOLDER
    for (UIView *myView in [cardHolder subviews]) {
        [myView removeFromSuperview];
    }
    
    
    [bottleIcons removeAllObjects];
    
    //REMOVE PAN
    [self removeGestureRecognizer:panRecognizer];
     [bottleCounter removeGestureRecognizer:bottleTap];
    
    //numberOfItems = 0;
    
    //REMOVE CARDS
    cardOpen = !cardOpen;
    title.userInteractionEnabled = FALSE;
}





#pragma mark -
#pragma mark FAVOURITE

-(void)makeOrRemoveFav:(UITapGestureRecognizer*)sender{
    NSLog(@"makeOrRemoveFav");
    UIImageView *view = (UIImageView*)sender.view;
    
    if ([[data objectForKey:@"favourite"] isEqualToString:@"0"]) {
        [data setObject:@"1" forKey:@"favourite"];
        
        
    }
    else{
        [data setObject:@"0" forKey:@"favourite"];
        
    }
    NSLog(@"HEART %@",[NSString stringWithFormat:@"heart%@.png", [data objectForKey:@"favourite"]]);
    view.image = [UIImage imageNamed:[NSString stringWithFormat:@"heart%@.png", [data objectForKey:@"favourite"]]];
    
    //SAVE IN DEFAULTS
    //[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"pId%@fav",[dictionary objectForKey:@"product_id"]]]
    
    [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"favourite"] forKey:[NSString stringWithFormat:@"pId%@fav",[data objectForKey:@"product_id"]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}




#pragma mark -
#pragma mark BOTTLES AND DESCRIPTION

-(void)addItem{
    NSLog(@"ADD ITEM TO CARD");
    
    //CHECK FOR MAX
    if (numberOfItems <= [[data objectForKey:@"stock_quantity"] integerValue]) {
        
        if(numberOfItems < 6){
            //ADD BOTTLE
            UIImageView *myBottleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wineBottle.png"]];
            myBottleIcon.frame = CGRectMake( (numberOfItems-1)*(self.bounds.size.width*0.1)+self.bounds.size.width*0.1, self.bounds.size.height*0.65, self.bounds.size.width*0.15, self.bounds.size.height*0.25);
            myBottleIcon.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*1.2);
            myBottleIcon.transform = CGAffineTransformMakeScale(0.3, 0.3);
            myBottleIcon.contentMode = UIViewContentModeScaleAspectFit;
            [cardHolder addSubview:myBottleIcon];
            [bottleIcons addObject:myBottleIcon];
            
        }
        numberOfItems++;
        
        //ANIMATE TO GRID
        [self animateIconsToGrid];
        
    }
    else{
        NSLog(@"MAX ORDER REACHED");
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState:TRUE];
        [UIView setAnimationDidStopSelector:@selector(hideMaxPriceAni)];
        maxPriceTxt.alpha = 1.0f;
        [UIView commitAnimations];
    }
    
    //UPDATE VISUAL
    [self showHideDescription];
    
    
    
}


-(void)hideMaxPriceAni{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDelay:0.95f];
    maxPriceTxt.alpha = 0.0f;
    [UIView commitAnimations];
}



-(void)removeItem{
    NSLog(@"REMOVE ITEM TO CARD");
    if (numberOfItems>0) {
        if(numberOfItems < 7){
            //REMOVE BOTTLE
            [[bottleIcons objectAtIndex:numberOfItems-1] removeFromSuperview];
            [bottleIcons removeObject:[bottleIcons objectAtIndex:numberOfItems-1]];
            
        }
        numberOfItems--;
        //ANIMATE TO GRID
        [self animateIconsToGrid];
        
    }
    else{
        NSLog(@"MIN ORDER REACHED");
    }
    
    //UPDATE VISUAL
    [self showHideDescription];
}

-(void)animateIconsToGrid{
    
    //SET UP GRID ACCORDING TO NUMBER OF BOTTLES
    int colum=0;
    int row=0;
    int columM=6;
    int numberOfItemsF = numberOfItems;
    if (numberOfItems > 6) {
        numberOfItemsF = 6;
    }
    float wid=self.bounds.size.width*0.95/numberOfItemsF;
    int hei=(self.bounds.size.height*0.3);
    
    
    for(UIImageView *aniBot in bottleIcons)
    {
        if(colum>=columM){ colum = 0; row++;}
        
        
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.75f];
        //deck.frame = CGRectMake(colum*wid, row*hei, wid, hei);
        //aniBot.transform = CGAffineTransformMakeScale(0.8, 0.8);
        aniBot.transform = CGAffineTransformMakeScale(1, 1);
        aniBot.center = CGPointMake(colum*wid + wid*0.5 + self.bounds.size.width*0.025, row*hei + hei*0.5 + self.bounds.size.height*0.6);
        colum++;
        
        [UIView commitAnimations];
        
        
    }
    
    
    
    
}

-(void)showHideDescription{
    
    //SHOW HIDE DESCRIPTION
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.25f];
    if (numberOfItems > 0) {
        description.alpha = 0.0f;
        //UPDATE PRICE
        [price setText:[NSString stringWithFormat:@"GET %i for %i VINOS",numberOfItems,[[data objectForKey:@"price"] integerValue]*numberOfItems ]];
    }
    else{
        description.alpha = 1.0f;
        [price setText:[NSString stringWithFormat:@"GET 1 for %@ VINOS",[data objectForKey:@"price"]]];
    }
    [UIView commitAnimations];
    
    if (numberOfItems > 0) {
        [bottleCounter setText:[NSString stringWithFormat:@"%i",numberOfItems]];
    }
    else{
        [bottleCounter setText:@""];
    }
    
    
    
    
}





#pragma mark -
#pragma mark TOUCHES

//-(void)openCloseCard{
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"\nTOUCHED CARD %@",[data objectForKey:@"name"]);
    
    
    
    //CHECK IF DECK IS OPEN
    if(!cardOpen && [((Deck*)myDelegate) isScrollingNow]){
        NSLog(@"t1");
        //SHOW CARDS
        [ self.myDelegate performSelector: @selector( openCard: ) withObject: self ];
        NSLog(@"t2");
        [self activateCard];
        NSLog(@"t3");
        
    }
    else{
        // Remember original location
        lastLocation = self.center;
    }
    
}





#pragma mark -
#pragma mark PANNING

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint currentlocation = [recognizer locationInView:self.superview];
    
    //MOVE CARD - ACCORDING TO SELF
    CGPoint translation = [recognizer translationInView:self.superview];
    self.center = CGPointMake(lastLocation.x + translation.x,lastLocation.y + translation.y);
    
    
    //ANIMATE CARD
    CGPoint vel = [recognizer velocityInView:self];
    
    
    //GET PERCENTAGE
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"PAN STARTED");
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            NSLog(@"PAN ENDED");
            
            //GET NUMBER OF ITEMS
           // NSLog(@"\nNUMBER OF ITEMS %i",numberOfItems);
            //GET CARD PERCENTAGE
            //NSLog(@"PAN PERx %f",currentlocation.x/self.bounds.size.width);
            //NSLog(@"PAN PERy %f",currentlocation.y/self.bounds.size.height);
            //CHECK MOVEMENT
            if (vel.y > 900 || currentlocation.y/self.bounds.size.height > 1.0f)
            {
                NSLog(@"CLOSE - swipe down detected %f",vel.y);
                //HACK
                [self closeMyCard];
                
            }
            else if (vel.y < -900 || currentlocation.y/self.bounds.size.height < 0.3f)
            {
                NSLog(@"FLIP CARD - swipe up detected %f",vel.y);
                
                //REMOVE CARD FROM DECK
                //[ self.myDelegate performSelector: @selector( flipCard: ) withObject: self ];
                
                
                NSLog(@"RETURN TO CENTER");
                [UIView beginAnimations:NULL context:NULL];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [UIView setAnimationDuration:0.25f];
                self.center = lastLocation;
                self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                [UIView commitAnimations];
                
                //[self closeMyCard];
                
            }
            else if (vel.x > 500 /*|| currentlocation.x/self.bounds.size.width < 0.2f*/)
            {
                NSLog(@"MOVE CARDS LEFT - %f",vel.x);
                
                //SHOW NEXT CARD
                [self nextCard];
            }
            else if (vel.x < -500 /*|| currentlocation.x/self.bounds.size.width > 0.8f*/)
            {
                NSLog(@"MOVE CARDS RIGHT - %f",vel.x);
                
                [self previousCard];
            }
            else //RETURN TO CENTER
            {
                NSLog(@"RETURN TO CENTER");
                [UIView beginAnimations:NULL context:NULL];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [UIView setAnimationDuration:0.25f];
                self.center = lastLocation;
                self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                [UIView commitAnimations];
                
                //SHOW INFO TO USER
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"USE GESTURES"
                                                                message:@"Swipe DOWN to return.\nLEFT or RIGHT to browse cards."
                                                               delegate:self
                                                      cancelButtonTitle:@"Thanks"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
            
            
            //SET DATA QUNATITY
            [data setObject:[NSString stringWithFormat:@"%i",numberOfItems] forKey:@"quantity"];
            
            
            [ self.myDelegate performSelector: @selector( orderCard: ) withObject: self ];
            
            
        }
            
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            //NSLog(@"PAN CHANGED");
            
            CGPoint translation = [recognizer translationInView:self.superview];
            
            //recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
            
            //NSLog(@"RECC VIEW %f %f",translation.x,translation.y);
            
            if(translation.y < 0){
                //SCALE CARD DOWN
                float traS = (100 + translation.y)*0.01;
                //self.transform = CGAffineTransformMakeScale(traS, traS);
            }
            
            //PROMPT
            if (vel.y > 0)
            {
               // NSLog(@"DOWN %f",vel.y);
                
                //GOING TO ADD CARD TO DELIVERY
            }
            else
            {
              //  NSLog(@"UP");
            }
            
            break;
        }
            
        default:
            break;
    }
    
    
    
}

-(int)getNumberOfItems{
    return numberOfItems;
}


-(void)closeMyCard{
    NSLog(@"CLOSE MY CARD");
    
    [self deactivateCard];
    
    [ self.myDelegate performSelector: @selector( closeCard: ) withObject: self ];
    
    
    
    //DO COOL ANIMATIONS
}

-(void)closeMyCardForce{
    NSLog(@"CLOSE MY CARD");
    
    [self deactivateCard];
    
    [ self.myDelegate performSelector: @selector( closeCard: ) withObject: self ];
    
    //SET DATA QUNATITY
    [data setObject:[NSString stringWithFormat:@"%i",numberOfItems] forKey:@"quantity"];
    
    
    [ self.myDelegate performSelector: @selector( orderCard: ) withObject: self ];
}




-(void)nextCard{
    NSLog(@"NEXT CARD");
    
   [self deactivateCard];
    
    [ self.myDelegate performSelector: @selector( nextCardDeck: ) withObject: self ];

    

    
}

-(void)previousCard{
    NSLog(@"PREVIOUS CARD");
   
    [self deactivateCard];
    
    [ self.myDelegate performSelector: @selector( previousCardDeck: ) withObject: self ];
    
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    /*/ Drawing code
    CGRect rectangle = CGRectMake(self.bounds.size.width*0.025, self.bounds.size.height*0.925, self.bounds.size.width*0.95, self.bounds.size.height*0.05);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextFillRect(context, rectangle);
    //CGContextRef context = UIGraphicsGetCurrentContext();
    
    //LEFT
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, self.bounds.size.width*0.05, self.bounds.size.height*0.05);
    CGContextAddLineToPoint(context, self.bounds.size.width*0.05, self.bounds.size.height*0.35);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, self.bounds.size.width*0.05, self.bounds.size.height*0.6);
    CGContextAddLineToPoint(context, self.bounds.size.width*0.05, self.bounds.size.height*0.95);
    CGContextDrawPath(context, kCGPathStroke);
    
    
    //RIGHT
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, self.bounds.size.width*0.95, self.bounds.size.height*0.05);
    CGContextAddLineToPoint(context, self.bounds.size.width*0.95, self.bounds.size.height*0.35);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, self.bounds.size.width*0.95, self.bounds.size.height*0.6);
    CGContextAddLineToPoint(context, self.bounds.size.width*0.95, self.bounds.size.height*0.95);
    CGContextDrawPath(context, kCGPathStroke);
    */
    
    /*/CLIP VIEW
    // set the radius
    CGFloat radius = 10.0;
    // set the mask frame, and increase the height by the
    // corner radius to hide bottom corners
    CGRect maskFrame = self.bounds;
    maskFrame.size.height += radius-10;
    // create the mask layer
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = radius;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = maskFrame;
    maskLayer.shadowColor = [UIColor blackColor].CGColor;
    maskLayer.shadowOffset = CGSizeMake(0, 0);
    maskLayer.shadowOpacity = 0.75f;
    maskLayer.shadowRadius = 10.0;
    
    // set the mask
    self.layer.mask = maskLayer;
    */
    
}


-(void)dealloc{
   // NSLog(@"dealloc CARD");
    
}


@end
