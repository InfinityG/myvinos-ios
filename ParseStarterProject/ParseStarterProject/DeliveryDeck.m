//
//  Deck.m
//  colorgameapp
//
//  Created by Herman Coetzee on 2012/10/07.
//  Copyright (c) 2012 Color Game App. All rights reserved.
//

#include <math.h>
#import "DeliveryDeck.h"
#import "Card.h"
#import "ParseStarterProjectViewController.h"
#import <QuartzCore/QuartzCore.h>

#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)


@interface ParseStarterProjectViewController()

@end

@implementation DeliveryDeck

@synthesize data,myDelegate,cards,boxHolder,cardsData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"HELLO DECK");
        deckOpen = FALSE;
        cards = [[NSMutableArray alloc] init];
        cardsData = [[NSMutableArray alloc] init];
        
        //DESIGN Deck
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds=FALSE;
        
        data = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                 @"products": @{
                                                                         @"color": @"RED",
                                                                         @"image_url": @"https://earthynotesdotcom.files.wordpress.com/2013/07/03-321.jpg",
                                                                         @"description": @"raw data",
                                                                         @"mood_filter": @"romance",
                                                                         @"price": @36,
                                                                         @"title": @"Franschoek Chamonix FAKE CARD 2014",
                                                                         @"farm": @"MY FARM",
                                                                         @"ID": @13390
                                                                         },
                                                                 @"id": @123456789,
                                                                 @"title": @"DELIVERY DECK"
                                                                 }];
        
        NSLog(@"%@",data);
        /*/PAN
        UIPanGestureRecognizer * recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleDeckPan:)];
        [self addGestureRecognizer:recognizer];
         */
        
        //BOX HOLDER
        boxHolder = [[UIView alloc] initWithFrame:CGRectMake(0,0 ,self.bounds.size.width, self.bounds.size.height)];
        boxHolder.backgroundColor = [UIColor clearColor];
        boxHolder.clipsToBounds = FALSE;
        //boxHolder.layer.shadowOffset = CGSizeMake(0, -4);
        //boxHolder.layer.shadowRadius = 3;
        //boxHolder.layer.shadowOpacity = 0.8;
        boxHolder.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
        
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.boxHolder.bounds.size.width, self.boxHolder.bounds.size.height) cornerRadius:0];
        
        
        
        
        //UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.size.width*0.3 ,-self.bounds.size.width*0.25 ,self.bounds.size.width*0.4, self.bounds.size.width*0.4) cornerRadius:(self.bounds.size.width*0.4)/2];
        
        UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width*0.5, 0)
                                                             radius:75
                                                         startAngle:0
                                                           endAngle:DEGREES_TO_RADIANS(180)
                                                          clockwise:YES];
        
        [path appendPath:aPath];
        [path setLineWidth:0.0f];
        [path setUsesEvenOddFillRule:YES];
        
        
        
        
        
        
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.path = path.CGPath;
        fillLayer.fillRule = kCAFillRuleEvenOdd;
        fillLayer.fillColor = [UIColor colorWithRed:192/255.0f green:41/255.0f blue:66/255.0f alpha:1.0f].CGColor;
        fillLayer.opacity = 1;
        [boxHolder.layer addSublayer:fillLayer];
        
        
        
        
        //TITLE - LOOP THROUGH WORDS
        NSArray* splitString = [@"DELIVERY" componentsSeparatedByString: @" "];
        float wordHeight = self.bounds.size.height*0.15;
        float nextT = self.bounds.size.height*0.65 - [splitString count]*wordHeight;
        //NSArray* splitString = @[[cardsData objectForKey:@"title"]];
        for(NSString *word in splitString) {
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, nextT ,self.bounds.size.width, wordHeight)];
            tf.textColor = [UIColor blackColor];
            tf.font = [UIFont systemFontOfSize:wordHeight*0.9];
            //tf.backgroundColor=[UIColor colorWithRed:163/255.0f green:118/255.0f blue:163/255.0f alpha:1.0f];
            tf.userInteractionEnabled = FALSE;
            tf.textAlignment = NSTextAlignmentCenter;
            tf.text=word;
            [boxHolder addSubview:tf];
            
            nextT = nextT + wordHeight;
            
        }
        
        
        //BACK COVER
        //  UIView *backCover = [[UIView alloc] initWithFrame:CGRectMake(0,0 ,self.bounds.size.width, self.bounds.size.height)];
        //[boxHolder addSubview:backCover];
        
        //FRONT COVER - MASK
        //UIView *frontCover = [[UIView alloc] initWithFrame:CGRectMake(0,0 ,self.bounds.size.width, self.bounds.size.height)];
        //frontCover.backgroundColor = [UIColor blackColor];
        //    [boxHolder addSubview:frontCover];
        
        
        [self addSubview:boxHolder];
    }
    return self;
}

-(void)setData:(NSMutableDictionary*)cardsData2 {
    
    
    
    
    data = cardsData2;

}

-(void)addCard:(id)myCard{
    NSLog(@"CARD ADDED TO DLEIVEY DECK - %@",[((Card*)myCard).data objectForKey:@"name"]);
    
    //ADD CARD TO products ARRAY in products
    //[[data objectForKey:@"products"] addObject:((Card*)myCard).data];
    [cardsData addObject:((Card*)myCard).data];
    
    
    //UPDATE PREVIEW DISPLAY
    
    
}

-(void)showCards{
    NSLog(@"SHOW CARDS DELIVERY DECK - %@",[data objectForKey:@"title"]);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touched in Deck DELIVERY %@",[data objectForKey:@"title"]);
    
    if(!deckOpen){
        //ACTIVATE DECK
        [self activateDeck];
        
    }
    
    
    
   
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"DELIVERY DECK TOUCHES ENDED");
    
   // [self.myDelegate panDecksEnded:0.0f];

}


-(void)activateDeck{
    NSLog(@"DECK DELVIERY - ACTIVATE");
    float delay = 0.0f;
    
    //SHOW CARDS
    //[ self.myDelegate performSelector: @selector( openDeliveryDeck )  ];
    
    if(!deckOpen){
        //CREATE ALL CARDS
            for (NSDictionary *dictionary in cardsData) {
               // NSLog(@"\n CARD FOUND - %@",[dictionary objectForKey:@"name"]);
                
                
                
                //ADD CARD TO DECK
                Card *myCard = [[Card alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
                myCard.myDelegate = self;
                //myCard.alpha = 0.5f;
                [myCard setData:dictionary];
                [cards addObject:myCard];
                [self addSubview:myCard];
                
                
                
            }
        
        delay = 0.25f;
    }
    
    //ANIMATE CARDS
    int di = 1;
    for(Card *myCard in cards) {
        [self sendSubviewToBack:myCard];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationDelay:delay];
        myCard.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*1.5 - myCard.bounds.size.height*0.08*di);
        [UIView commitAnimations];
        di++;
    }
    
    //PULL DOWN HOLDER
    [self addSubview:boxHolder];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDelay:delay];
    boxHolder.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*1.5);
    [UIView commitAnimations];
    
    deckOpen = true;
    
}

-(void)deactivateDeck{
    NSLog(@"DECK - DEACTIVATE");
    
    
    if(deckOpen){
        
       
        
        //REMOVE AND DELETE CARDS
        int di = 0;
        for(Card *card in [cards reverseObjectEnumerator]) {
            NSLog(@"CARD ani");
            [UIView beginAnimations:NULL context:(__bridge void *)(card)];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDidStopSelector:@selector(removeCardFromView:finished:context:)];
            [UIView setAnimationDuration:0.25f];
            card.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
            [UIView commitAnimations];
            di++;
            //[card removeFromSuperview];
            
        }
        
        //PULL UP HOLDER
        //[self addSubview:boxHolder];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.25f];
        boxHolder.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
        [UIView commitAnimations];
    }
    deckOpen = FALSE;
    
}


#pragma CARD HANDLER

-(void)openCard:(id)myCard{
    NSLog(@"DECK - OPEN CARD");
    
    
    //FULL SCREEN
    //[myDelegate fullScreenCard];
    
    
    //ANIMATE CARDS
    float delay = 0.0f;
    float cardDif = self.bounds.size.height*0.2 / ([cards count]+1);
    int di = 1;
    for(Card *card in [cards reverseObjectEnumerator]) {
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationDelay:delay];
        if([card isEqual:myCard]){
            //card.transform = CGAffineTransformMakeScale(1,1);
            card.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
        }
        else{
            card.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*1.5 + cardDif*di);
            di++;
        }
        [UIView commitAnimations];
        
    }
    
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35f];
    boxHolder.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*1.5 + cardDif*di);
    [UIView commitAnimations];
    
    
}

-(void)closeCard:(id)myCard{
    NSLog(@"DELIVERY DECK - CLOSE CARD");
    
    
    // CLOSE FULL SCREEN
    //[myDelegate closeFullscreenCard];
    
    //ACTIVATE DECK
    [self activateDeck];
    
    NSLog(@"CARDS DONE");

    
    /*/CLOSE CARDS
    int di = 0;
    for(Card *card in cards) {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.25f];
        if([card isEqual:myCard]){
            //card.transform = CGAffineTransformMakeScale( 0.8, 0.8);
        }
        card.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5 + card.bounds.size.height*0.08*di);
        [UIView commitAnimations];
        di++;
        
    }
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35f];
    boxHolder.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*1.25);
    [UIView commitAnimations];
     */
    
}

-(void)nextCardDeck:(id)myCard{
   
    //GET NEXT CARD
    NSInteger cardIndex = [cards indexOfObject:myCard];
    if(cardIndex<=0){
        cardIndex = [cards count]-1;
    }
    else{
        cardIndex--;
    }
    [self openCard:[cards objectAtIndex:cardIndex]];
    
    [[cards objectAtIndex:cardIndex] activateCard];
    
    
}
-(void)previousCardDeck:(id)myCard{
    //GET PREVIOUS CARD
    NSInteger cardIndex = [cards indexOfObject:myCard];
    if(cardIndex >= [cards count]-1){
        cardIndex = 0;
    }
    else{
        cardIndex++;
    }
    [self openCard:[cards objectAtIndex:cardIndex]];
    
    [[cards objectAtIndex:cardIndex] activateCard];
    
    
}

-(void)promptAddToDeliveryDeck:(id)myCard{
    NSLog(@"PROMPT DELIVERY DECK");
    
    //SHOW DELIVER BUT IF NOT ALREADY VISIBLE
    [ self.myDelegate performSelector: @selector( promptAddToDelivery: ) withObject: myCard ];

    
    
}


-(void)orderCard:(id)myCard{
    NSLog(@"ORDER CARD - deck");
    [ self.myDelegate performSelector: @selector( addCardToDelivery: ) withObject: myCard ];
    
    //REMOVE CARD FROM DECK AND PLACE IN DELIVERY DECK
}

-(void)dumpCard:(id)myCard{
    NSLog(@"DUMP CARD - deck");
    
    //REMOVE CARD FROM DECK
}




-(void)removeCardFromView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    [cards removeObject:(__bridge id)(context)];
    [(__bridge Card*)context removeFromSuperview];
    context = nil;
    NSLog(@"CARD REMOVED");
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   
    
    /*/ Drawing Rect
    [[UIColor blackColor] setFill];
    UIRectFill(CGRectMake(self.frame.size.width*0.025, self.frame.size.height*0.925, self.frame.size.width*0.95, self.frame.size.height*0.05));
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    
    //LEFT
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, self.bounds.size.width*0.05, self.bounds.size.height*0.1);
    CGContextAddLineToPoint(context, self.bounds.size.width*0.05, self.bounds.size.height);
    CGContextDrawPath(context, kCGPathStroke);
    
    
    
    //RIGHT
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, self.bounds.size.width*0.95, self.bounds.size.height*0.1);
    CGContextAddLineToPoint(context, self.bounds.size.width*0.95, self.bounds.size.height);
    CGContextDrawPath(context, kCGPathStroke);
    
     
    
    //CLIP VIEW
    // set the radius
    CGFloat radius = 30.0;
    // set the mask frame, and increase the height by the
    // corner radius to hide bottom corners
    CGRect maskFrame = self.bounds;
    maskFrame.origin.y += 5;
    maskFrame.size.height += maskFrame.size.height + radius;
    // create the mask layer
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = radius;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = maskFrame;
    
    // set the mask
    self.layer.mask = maskLayer;
     
   */
    
    
   
}

-(void)dealloc{
    NSLog(@"DEALLOC DECK");
}


@end
