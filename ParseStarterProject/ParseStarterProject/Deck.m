//
//  Deck.m
//  colorgameapp
//
//  Created by Herman Coetzee on 2012/10/07.
//  Copyright (c) 2012 Color Game App. All rights reserved.
//

#include <math.h>
#import "UIImageView+WebCache.h"

#import "Deliver.h"
#import "Deck.h"
#import "Card.h"
#import "ParseStarterProjectViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>


#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)
#define STARTPOINT self.bounds.size.height*0.1
#define PREVIEWHEIGHT  self.bounds.size.height*0.08
#define FILTERTEXTHEIGHT self.bounds.size.height*0.1

@interface ParseStarterProjectViewController()

@end

@implementation Deck

@synthesize data,myDelegate,cards,boxHolder,colorFilter,moodFilter,title,type,blackCard,scrollView,imageUrl,description,backCard;

@synthesize filterTxt,deckBut,filterBut,currentOpenCard,fakeBoxHolder;

- (id)initWithFrame:(CGRect)frame setTitle:(NSString*)myTitle setImageUrl:(NSString*)imageUrlT setImageDes:(NSString*)imageDesT setType:(NSString*)myType
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"HELLO DECK %@",myTitle);
        
        self.backgroundColor = [UIColor clearColor];
        self.exclusiveTouch = YES;
        /*
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.startPoint = CGPointMake(0.5, 0);
        gradient.endPoint = CGPointMake(0.5,1);
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor purpleColor] CGColor], (id)[[UIColor colorWithRed:75.0f/255.0f green:12.0f/255.0f blue: 39.0f/255.0f alpha:1.0f] CGColor], nil];
        [self.layer insertSublayer:gradient atIndex:0];
*/

        deckOpen = FALSE;
        title = myTitle;
        data = [[NSMutableArray alloc] init];
        cards = [[NSMutableArray alloc] init];
        colorFilter = [[NSMutableArray alloc] init];
        moodFilter = [[NSMutableArray alloc] init];
        colorF = [[NSMutableString alloc] initWithString:@""];
        moodF = [[NSMutableString alloc] initWithString:@""];
        colorButs = [[NSMutableArray alloc] init];
        colorButsLabels = [[NSMutableArray alloc] init];
        moodButs = [[NSMutableArray alloc] init];
        type = myType;
        imageUrl = imageUrlT;
        description = imageDesT;
        
        
        //BLACK CARD
        [self buildBlackCard];
        
        //BACK CARD
        [self buildBackCard];

        //BOX HOLDER
        [self buildBoxHolder];
        
        //SCROLL VIEW
        [self buildScrollView];
        



        


    }
    return self;
}



#pragma mark -
#pragma mark BLACK CARD

-(void)buildBlackCard{
    //BUILD BLACK CARD
    blackCard = [[UIView alloc] initWithFrame:CGRectMake(0,0 ,self.bounds.size.width, self.bounds.size.height)];
    if ([type isEqualToString:@"DELIVERY"]) {
        blackCard.frame = CGRectMake(0, self.bounds.size.height*0.0, self.bounds.size.width, self.bounds.size.height);
    }
    blackCard.backgroundColor = [UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
    blackCard.clipsToBounds = FALSE;
    blackCard.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.4);
    blackCard.layer.cornerRadius = 10;
    blackCard.layer.shadowColor = [UIColor blackColor].CGColor;
    blackCard.layer.shadowOffset = CGSizeMake(0, 0);
    blackCard.layer.shadowOpacity = 0.75f;
    blackCard.layer.shadowRadius = 10.0;
    //UILabel* filterTxtLabel;
    //DELIVERY INSTRUCTION
    if([type isEqualToString:@"DELIVERY"]){
       // blackCard.backgroundColor = [UIColor whiteColor];
        
        /*
        filterTxtLabel = [[UILabel alloc] initWithFrame:CGRectMake(blackCard.bounds.size.width*0.05, blackCard.bounds.size.height*0 ,blackCard.bounds.size.width*0.9, self.bounds.size.height*0.06)];
        filterTxtLabel.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(filterTxtLabel.bounds.size.height*0.7)];
        filterTxtLabel.textAlignment =  NSTextAlignmentCenter;
        filterTxtLabel.backgroundColor = [UIColor clearColor];
        filterTxtLabel.textColor = [UIColor blackColor];
        filterTxtLabel.userInteractionEnabled = TRUE;
        filterTxtLabel.alpha = 1;
        [filterTxtLabel setText:@"DELIVER NOW"];
        [blackCard addSubview:filterTxtLabel];
        */
    }
    
    /*/ADD TOUCH TO OPEN
    UITapGestureRecognizer *tapped223 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBlackCard)];
    tapped223.numberOfTapsRequired = 1;
    [filterTxtLabel addGestureRecognizer:tapped223];
    */
    
    filterTxt = [[UILabel alloc] initWithFrame:CGRectMake(blackCard.bounds.size.width*0.025, blackCard.bounds.size.height*0 ,blackCard.bounds.size.width*0.95, FILTERTEXTHEIGHT)];
    filterTxt.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(filterTxt.bounds.size.height*0.35)];
    filterTxt.textColor = [UIColor whiteColor];
    if([type isEqualToString:@"DELIVERY"]){
       // filterTxt.textColor = [UIColor blackColor];
        //filterTxt.frame = CGRectMake(blackCard.bounds.size.width*0.025, blackCard.bounds.size.height*0.06 ,blackCard.bounds.size.width*0.9, self.bounds.size.height*0.04);
        //filterTxt.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(filterTxt.bounds.size.height*0.4)];
        //filterTxt.textColor = [UIColor blackColor];

    }
    filterTxt.textAlignment =  NSTextAlignmentCenter;
    filterTxt.backgroundColor = [UIColor clearColor];
    filterTxt.userInteractionEnabled = TRUE;
    filterTxt.alpha = 1;
    [filterTxt setText:title];
    [blackCard addSubview:filterTxt];
    
    
    //ADD TOUCH TO OPEN
    UITapGestureRecognizer *tapped22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBlackCard)];
    tapped22.numberOfTapsRequired = 1;
    [filterTxt addGestureRecognizer:tapped22];
    
    /*/PROMPT TEXT
   UILabel* promptText = [[UILabel alloc] initWithFrame:CGRectMake(blackCard.bounds.size.width*0.025, blackCard.bounds.size.height*0 ,blackCard.bounds.size.width*0.95, FILTERTEXTHEIGHT*0.35)];
    promptText.font = [UIFont fontWithName:@"SFUIText-Bold" size:(promptText.bounds.size.height*0.35)];
    promptText.textAlignment =  NSTextAlignmentRight;
    promptText.backgroundColor = [UIColor clearColor];
    promptText.textColor = [UIColor whiteColor];
    promptText.userInteractionEnabled = FALSE;
    promptText.alpha = 0.5f;
    [promptText setText:@"TAP TO OPEN"];
    [blackCard addSubview:promptText];
    */
    
    /*/PROMPT BUTTON
    //ADD WINE COLOR
    UIImageView *promptBut = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vinosButMore.png" ]];
    promptBut.frame = CGRectMake(self.bounds.size.width*0.9, filterTxt.bounds.origin.y, self.bounds.size.width*0.075, filterTxt.bounds.size.height);
    promptBut.backgroundColor = [UIColor clearColor];
    promptBut.contentMode = UIViewContentModeScaleAspectFit;
    promptBut.userInteractionEnabled = FALSE;
    [blackCard addSubview:promptBut];
    */
    
    if(![type isEqualToString:@"DELIVERY"]){
        
        // IMAGE
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                NSLog(@"IMAGE LOADED");
                UIImage *image = [UIImage imageWithData:imageData];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                imageView.frame = CGRectMake (blackCard.bounds.size.width*0.025,blackCard.bounds.size.height*0.1,blackCard.bounds.size.width*0.95,blackCard.bounds.size.height*0.375);
                imageView.backgroundColor = [UIColor clearColor];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [blackCard addSubview:imageView];
                
            });
        });
        
        //ADD TEXT BOX
        //NSString *descreiptionFormatedText = [[[NSAttributedString alloc] initWithData:[[data objectForKey:@"description"] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil] string];
        
        UITextView *descriptionBlackCard = [[UITextView alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.025, self.bounds.size.height*0.515 ,self.bounds.size.width*0.95, self.bounds.size.height*0.325)];
        descriptionBlackCard.userInteractionEnabled = FALSE;
        descriptionBlackCard.textAlignment =  NSTextAlignmentNatural;
        descriptionBlackCard.textColor = [UIColor whiteColor];
        [descriptionBlackCard setBackgroundColor:[UIColor clearColor]];
        descriptionBlackCard.font = [UIFont fontWithName:@"SFUIText-Regular" size:(filterTxt.bounds.size.height*0.25)];
        [descriptionBlackCard setText:description ];
        descriptionBlackCard.scrollEnabled = TRUE;
        descriptionBlackCard.userInteractionEnabled = TRUE;
        descriptionBlackCard.editable = FALSE;
        [blackCard addSubview:descriptionBlackCard];
        
        //ADD FILTER BUT TO FLIP OVER CARD AND SHOW BACK
        /*/SIGN UP BUTTON
        UIButton *butShowBack = [UIButton buttonWithType:UIButtonTypeCustom];
        butShowBack.frame = CGRectMake(blackCard.bounds.size.width*0.05,blackCard.bounds.size.height*0.9,blackCard.bounds.size.width*0.9,blackCard.bounds.size.height*0.1);
        butShowBack.backgroundColor = [UIColor clearColor];
        [butShowBack setTitle:@"SHUFFLE" forState:UIControlStateNormal];
        [butShowBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        butShowBack.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(butShowBack.bounds.size.height*0.4)];
        [butShowBack addTarget:myDelegate action:@selector(showBackCard) forControlEvents:UIControlEventTouchUpInside];
        butShowBack.alpha = 1;
        [blackCard addSubview:butShowBack];
         */
        
        
    }
    else{
        //IS DELIVERY
        
        //SET UP DELIVERY VIEW AND DELIVERY DECK
        deliver = [[Deliver alloc] initWithFrame:CGRectMake(blackCard.bounds.size.width*0.05, blackCard.bounds.size.height*0.1 ,blackCard.bounds.size.width*0.9, blackCard.bounds.size.height*0.9) sMyDelegate:self];
        deliver.alpha = 1.0f;
        deliver.myDelegate = self;
        [blackCard addSubview:deliver];
    
       
        
        //ONLY WHERE MAP VIEW GOES
    }
    
    [self addSubview:blackCard];
    
}


-(void)openCloseUserBuyDeck{
    [myDelegate openCloseUserBuy];
}

-(void)delieveryDeckSuccessDeck{
    [myDelegate delieveryDeckSuccess];

}

-(BOOL)checkForLoggedInDeck{
    return [myDelegate checkForLoggedIn];
}

-(void)startLoadingNowDeck:(NSString*)txt{
    [myDelegate startLoadingNow:txt];
}

-(void)showBackCard{
    NSLog(@"SHOW BACK CARD");
    [blackCard addSubview:backCard];
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3f];
    backCard.alpha = 1;
    [UIView commitAnimations];
    
    
}



-(void)deliverNow{
    
    
    //CONFIRM DELIVERY
    
    
     [myDelegate makeDelNow];
}

-(void)deliverNowScreen{
    NSLog(@"MAKE DELIVER NOW FROM DECK");
    
    //CLOSE DECK AND UPDATE CARDS
    [self deactivateDeck];
    
    [myDelegate showSelectionScreen];

    //OPEN DELIVERY SCREEN
    [myDelegate showDeliverScreen];
    
    


}


#pragma mark -
#pragma mark BACK CARD

-(void)buildBackCard{
    backCard = [[UIView alloc] initWithFrame:CGRectMake(0,0 ,self.bounds.size.width, self.bounds.size.height)];
    backCard.backgroundColor = [UIColor blackColor];
    backCard.clipsToBounds = FALSE;
    backCard.alpha = 0;
    backCard.backgroundColor = [UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
    blackCard.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.4);
    //backCard.layer.cornerRadius = 10;
   // backCard.layer.shadowColor = [UIColor blackColor].CGColor;
   // backCard.layer.shadowOffset = CGSizeMake(0, 0);
    //blackCard.layer.shadowOpacity = 0.75f;
   // backCard.layer.shadowRadius = 10.0;
    
    
    if ([type isEqualToString:@"DELIVERY"]) {

        //IS DELIVERY
       // backCard.backgroundColor = [UIColor whiteColor];

      
        

        
    }
    else{
        //NOT DELIVERY
        UILabel *backCardHeading = [[UILabel alloc] initWithFrame:CGRectMake(backCard.bounds.size.width*0.05, backCard.bounds.size.height*0 ,backCard.bounds.size.width*0.8, FILTERTEXTHEIGHT)];
        backCardHeading.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(backCardHeading.bounds.size.height*0.35)];
        backCardHeading.textAlignment =  NSTextAlignmentLeft;
        backCardHeading.backgroundColor = [UIColor clearColor];
        backCardHeading.textColor = [UIColor whiteColor];
        backCardHeading.userInteractionEnabled = TRUE;
        backCardHeading.alpha = 1;
        [backCardHeading setText:@"I'm in the MOOD for..."];
        [backCard addSubview:backCardHeading];
        
        [blackCard addSubview:backCard];

    }
    
    
    
}




#pragma mark -
#pragma mark BOX HOLDER

-(void)buildBoxHolder{

    //BOX HOLDER
    boxHolder = [[UIView alloc] initWithFrame:CGRectMake(0,0 ,self.bounds.size.width, self.bounds.size.height*1.0)];
    boxHolder.backgroundColor = [UIColor clearColor];
    boxHolder.clipsToBounds = FALSE;
    boxHolder.userInteractionEnabled = TRUE;
    boxHolder.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
    //boxHolder.layer.cornerRadius = cornerRadius;
    //boxHolder.layer.shadowColor = [UIColor blackColor].CGColor;
    //boxHolder.layer.shadowOffset = CGSizeMake(0, 0);
    //boxHolder.layer.shadowOpacity = 0.75f;
    //boxHolder.layer.shadowRadius = 10.0;
    [self addSubview:boxHolder];
    
    // OPEN CLOSE GESTURE
    UITapGestureRecognizer *tappe2d = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCloseDeck)];
    tappe2d.numberOfTapsRequired = 1;
    [boxHolder addGestureRecognizer:tappe2d];
    
   
    
    
    //CLIP WITH CUT BOX LAYER
    //border definitions
    CGFloat cornerRadius = 10;
    CGFloat borderWidth = 1;
    UIColor *lineColor = [UIColor whiteColor];
    //drawing
    CGRect frame = boxHolder.bounds;
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddArc(path, NULL, frame.size.width*0.5, 0, frame.size.width*0.1, DEGREES_TO_RADIANS(180), 0, YES);//THE CUT
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    //path is set as the _shapeLayer object's path
    
    /*/CHECK IF DELIVERY
    if([type isEqualToString:@"DELIVERY"]){
        CGAffineTransform translation = CGAffineTransformMakeTranslation(0,self.bounds.size.height*0.1);
        _shapeLayer.path = CGPathCreateCopyByTransformingPath(path, &translation);
    }
    else{
        _shapeLayer.path = path;
    }
    */
    
    _shapeLayer.path = path;
    
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = frame;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    if([type isEqualToString:@"DELIVERY"]){
    _shapeLayer.fillColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
    }
    else{
    _shapeLayer.fillColor = [UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f].CGColor;
    }
    _shapeLayer.strokeColor = [lineColor CGColor];
    _shapeLayer.lineWidth = borderWidth;
    //_shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:dashPattern1], [NSNumber numberWithInt:dashPattern2], nil];
    _shapeLayer.lineCap = kCALineCapRound;
    //_shapeLayer is added as a sublayer of the view, the border is visible
    [boxHolder.layer addSublayer:_shapeLayer];
    
    
    
    //SHADOW
    //boxHolder.layer.cornerRadius = cornerRadius;
    boxHolder.layer.shadowColor = [UIColor blackColor].CGColor;
    boxHolder.layer.shadowOffset = CGSizeMake(0, 0);
    boxHolder.layer.shadowOpacity = 0.75f;
    boxHolder.layer.shadowRadius = 5.0f;
    
    /*/MASK RECT
     // Create a mask layer and the frame to determine what will be visible in the view.
     CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
     CGRect maskRect = CGRectMake(0, 0, 50, 100);
     // Create a path with the rectangle in it.
     CGPathRef pathMask = CGPathCreateWithRect(maskRect, NULL);
     // Set the path to the mask layer.
     maskLayer.path = pathMask;
     // Release the path since it's not covered by ARC.
     CGPathRelease(pathMask);
     // Set the mask of the view.
     boxHolder.layer.mask = maskLayer;
     */

    /*/MASK IMG
     CALayer* maskLayerIMG = [CALayer layer];
     maskLayerIMG.frame = boxHolder.bounds;
     maskLayerIMG.contents = (__bridge id)[[UIImage imageNamed:@"logoMask.png"] CGImage];
     
     // Apply the mask to your uiview layer
     boxHolder.layer.mask = maskLayerIMG;
     
     */
    
    //TITLE
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, self.bounds.size.height*0.1 ,self.bounds.size.width, self.bounds.size.height*0.1)];
    tf.textColor = [UIColor whiteColor];
    tf.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(tf.bounds.size.height*0.8)];
    tf.backgroundColor=[UIColor clearColor];
    tf.userInteractionEnabled = FALSE;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.text=title;
   // [boxHolder addSubview:tf];
    
    
    
    
    
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    // Here we use the new provided sd_setImageWithURL: method to load the web image
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        imageView.frame = CGRectMake (self.bounds.size.width*0.025,self.bounds.size.height*0.25,self.bounds.size.width*0.95,self.bounds.size.height*0.55);
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [boxHolder addSubview:imageView];

    
    
    
    
    
    
    
    /*/ IMAGE
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            NSLog(@"IMAGE LOADED");
            UIImage *image = [UIImage imageWithData:imageData];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake (self.bounds.size.width*0.025,self.bounds.size.height*0.25,self.bounds.size.width*0.95,self.bounds.size.height*0.55);
            imageView.backgroundColor = [UIColor clearColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [boxHolder addSubview:imageView];
            
        });
    });
    */
    
    
    
    
    
    
    //ADD FAKE BUT FOR DELIVERY
    if([type isEqualToString:@"DELIVERY"]){
        //BOX HOLDER
        fakeBoxHolder = [[UIView alloc] initWithFrame:CGRectMake(0,self.bounds.size.height*0.0125 ,self.bounds.size.width, self.bounds.size.height*0.15)];
        //fakeBoxHolder.backgroundColor = [UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
        fakeBoxHolder.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        fakeBoxHolder.clipsToBounds = FALSE;
        fakeBoxHolder.alpha = 0;
        fakeBoxHolder.userInteractionEnabled = FALSE;
        fakeBoxHolder.layer.cornerRadius = cornerRadius;
        fakeBoxHolder.layer.shadowColor = [UIColor blackColor].CGColor;
        fakeBoxHolder.layer.shadowOffset = CGSizeMake(0, 0);
        fakeBoxHolder.layer.shadowOpacity = 0.5f;
        fakeBoxHolder.layer.shadowRadius = 5.0;
        //[boxHolder addSubview:fakeBoxHolder];
        
      
       
    }

    
    
    
    
    
    
    //DECK BUTS
    deckBut = [UIButton buttonWithType:UIButtonTypeCustom];
    deckBut.frame = CGRectMake(self.bounds.size.width*0.025, self.bounds.size.height*0.032  ,self.bounds.size.width*0.154, self.bounds.size.height*0.056);
    [deckBut setBackgroundImage:[[UIImage imageNamed:@"filterBut.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [deckBut addTarget:myDelegate action:@selector(showSelectionScreen) forControlEvents:UIControlEventTouchUpInside];
    deckBut.alpha = 0;
    [boxHolder addSubview:deckBut];
    
    //FILTER BUT
    filterBut = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBut.frame = CGRectMake(self.bounds.size.width*0.85, self.bounds.size.height*0.01  ,self.bounds.size.width*0.115, self.bounds.size.height*0.08);
    if(![type isEqualToString:@"DELIVERY"]){
        [filterBut setBackgroundImage:[[UIImage imageNamed:@"deckBut.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [filterBut addTarget:self action:@selector(showFilterScreen) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [filterBut setBackgroundImage:[[UIImage imageNamed:@"deliverMan.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
        filterBut.frame = CGRectMake(self.bounds.size.width*0.85, self.bounds.size.height*0.01  ,self.bounds.size.width*0.15, self.bounds.size.height*0.095);
        [filterBut addTarget:self action:@selector(showBlackCard) forControlEvents:UIControlEventTouchUpInside];
        filterBut.contentMode = UIViewContentModeScaleAspectFit;
    }
    

    filterBut.alpha = 0;
    [boxHolder addSubview:filterBut];
    //WINE COLOR SELECTION BUTS
}


-(void)openCloseUserDeck{
    [myDelegate openCloseUser];
}



#pragma mark -
#pragma mark FILTER



-(void)hideAllCards{
    NSLog(@"HIDE ALL CARDS");
    
    //CARDS
    float delay = 0.0f;
    float cardDif = self.bounds.size.height*0.1 / ([cards count]+1);
    int di = 1;
    for(Card *card in cards) {
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationDelay:delay];
        card.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*1.5 + cardDif*di);
        di++;
        [UIView commitAnimations];
    }
    if (fakeBoxHolder!=NULL) {
        fakeBoxHolder.alpha=0.0f;
    }
    filterBut.alpha = 0;
    deckBut.alpha = 0;
    
    //BOX HOLDER
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35f];
    boxHolder.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*1.5 + cardDif*di);
    scrollView.frame = CGRectMake(0, 0, scrollView.bounds.size.width, self.bounds.size.height);

    [UIView commitAnimations];
    
    
}

-(NSString*)getDeckType{
    return type;
}


-(void)showBlackCard{
    
    NSLog(@"showFilterScreen REMOVE REMOVE REMOVE REMOVE");
    
    //ADD PAN
    panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [blackCard addGestureRecognizer:panRecognizer];
    lastLocation = self.center;
    
    
    //GET SCROLL CONTENT OFFSET
    contentOffPrev = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top) animated:NO];
   

    
    
    //HIDE OTHER CARDS
    [self hideAllCards];
    
    //SHOW BLACK CARD - HIDE BOX HOLDER
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDidStopSelector:@selector(blackCardOnTop)];
    blackCard.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
    [UIView commitAnimations];
    
    //FULLSCREEN VIEW
    [myDelegate fullScreenCard];
    
}


#pragma mark -
#pragma mark PANNING

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint currentlocation = [recognizer locationInView:self.superview];
    
    //MOVE CARD - ACCORDING TO SELF
    CGPoint translation = [recognizer translationInView:self.superview];
    blackCard.center = CGPointMake(lastLocation.x + translation.x,lastLocation.y + translation.y);
    
    
    //ANIMATE CARD
    CGPoint vel = [recognizer velocityInView:self];
    
    
    //GET PERCENTAGE
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"PAN STARTED");
            [self sendSubviewToBack:blackCard];
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
                [self activateDeck];
                
            }
            else if (vel.y < -900 || currentlocation.y/self.bounds.size.height < 0.3f)
            {
                NSLog(@"FLIP CARD - swipe up detected %f",vel.y);
                
                //REMOVE CARD FROM DECK
                //[ self.myDelegate performSelector: @selector( flipCard: ) withObject: self ];
                
                [self activateDeck];
                
                
            }
            else if (vel.x > 500 /*|| currentlocation.x/self.bounds.size.width < 0.2f*/)
            {
                NSLog(@"MOVE CARDS LEFT - %f",vel.x);
                
                //SHOW NEXT CARD
                //[self previousCard];
                [self activateDeck];
            }
            else if (vel.x < -500 /*|| currentlocation.x/self.bounds.size.width > 0.8f*/)
            {
                NSLog(@"MOVE CARDS RIGHT - %f",vel.x);
               // [self nextCard];
                [self activateDeck];
            }
            else //RETURN TO CENTER
            {
                NSLog(@"RETURN TO CENTER");
                [self activateDeck];
                /*
                [UIView beginAnimations:NULL context:NULL];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [UIView setAnimationDuration:0.25f];
                [UIView setAnimationDidStopSelector:@selector(blackCardOnTop)];
                blackCard.center = lastLocation;
                blackCard.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                [UIView commitAnimations];
                 */
            }
            
            
            
            
            
        }
            
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            
            break;
        }
            
        default:
            break;
    }
    
    
    
}


- (void)showFilterScreen{
    
    NSLog(@"showFilterScreen REMOVE REMOVE REMOVE REMOVE");
    
    [self showBlackCard];
    
    //FLIP OVER CARD
    
    //[self showBackCard];
    
    
}

-(void)clearDeckAll{
    //remove all data
    filterTxt.text = @"ADD ITEMS FOR DELIVERY";
    
    [data removeAllObjects];
    [self createCards];
    
    [self activateDeck];
    
    //activate
    
}

-(void)blackCardOnTop{
    [self bringSubviewToFront:blackCard];
    
    NSLog(@"BLACK CARD ANI");
    
    /*
    float aniDela = 1.5f;
    //PROMPT DOWN
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    [UIView setAnimationDelay:aniDela];
    blackCard.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height*0.1);
    [UIView commitAnimations];
    
    aniDela += 0.15f;
    
    //CENTER off
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    [UIView setAnimationDelay:aniDela];
    blackCard.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height*0.05);
    [UIView commitAnimations];
    
    aniDela += 0.15f;
    
    //DOWN
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    [UIView setAnimationDelay:aniDela];
    blackCard.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height*0.1);
    [UIView commitAnimations];
    
    aniDela += 0.15f;
    
    //CENTER
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationDelay:aniDela];
    blackCard.center = self.center;
    [UIView commitAnimations];
    */
    
}

-(void)loadFilterSettings{
    NSLog(@"LOAD FILTER %i",[self.colorFilter count]);
    
    colorF = @"";
   moodF = @"";
    
    //REMOVE ALL VIEWS FROM ARRAYS
    for(UIImageView *but in colorButs ) {
        [but removeFromSuperview];
        
    }
    [colorButs removeAllObjects];
    for(UIImageView *but in colorButsLabels ) {
        [but removeFromSuperview];
        
    }
    [colorButsLabels removeAllObjects];
    for(UIButton *mbut in moodButs) {
        [mbut removeFromSuperview];
    }
    [moodButs removeAllObjects];
    
    //COLOR FILTER
    float dW = self.bounds.size.width;
    float colorW = dW/([colorFilter count]+1);
    for (int i =0; i<[colorFilter count]; i++) {
        //ADD WINE COLOR
        UIImageView *color = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@1.png",[[colorFilter objectAtIndex:i] uppercaseString]] ]];
        color.frame = CGRectMake((i)*colorW, self.bounds.size.height*0.875, colorW, self.bounds.size.height*0.07);
        color.backgroundColor = [UIColor clearColor];
        color.contentMode = UIViewContentModeScaleAspectFit;
        color.tag = i;
        //color.alpha = 0.75f;
        color.userInteractionEnabled = TRUE;
        [blackCard addSubview:color];
        [colorButs addObject:color];
        
        //ADD WINE LABEL
        UILabel* promptText = [[UILabel alloc] initWithFrame:CGRectMake((i)*colorW, self.bounds.size.height*0.94, colorW, self.bounds.size.height*0.04)];
        promptText.font = [UIFont fontWithName:@"SFUIText-Regular" size:(promptText.bounds.size.height*0.45)];
        promptText.textAlignment =  NSTextAlignmentCenter;
        promptText.backgroundColor = [UIColor clearColor];
        promptText.textColor = [UIColor whiteColor];
        promptText.userInteractionEnabled = FALSE;
        promptText.alpha = 0.5f;
        promptText.tag = 999;
        [promptText setText:[NSString stringWithFormat:@"%@",[[colorFilter objectAtIndex:i] uppercaseString]]];
    
        [blackCard addSubview:promptText];
        [colorButsLabels addObject:promptText];
        
        
        //ADD LOGO TAP
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterColorView:)];
        tapped.numberOfTapsRequired = 1;
        [tapped setDelegate:self];
        [color addGestureRecognizer:tapped];
        
    }
    
    //MOOD FILTER
    //ANIMATE DECKS IN
    UILabel *filterPlabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.2, self.bounds.size.height*0.8  ,self.bounds.size.width*0.6, self.bounds.size.height*0.05)];

    filterPlabel.backgroundColor = [UIColor clearColor];
    filterPlabel.alpha = 0.5f;
    filterPlabel.textAlignment =  NSTextAlignmentCenter;
    filterPlabel.textColor = [UIColor whiteColor];
    filterPlabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:(filterPlabel.bounds.size.height*0.55)];
    filterPlabel.userInteractionEnabled = FALSE;
    [filterPlabel setText:@"FILTER BY"];
    [blackCard addSubview:filterPlabel];
    
    //FILTER BUT
    //ADD WINE COLOR
    UIImageView *shuffleBut = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"deckBut.png"]];
    shuffleBut.frame = CGRectMake([colorFilter count]*colorW, self.bounds.size.height*0.875, colorW, self.bounds.size.height*0.07);
    shuffleBut.backgroundColor = [UIColor clearColor];
    shuffleBut.contentMode = UIViewContentModeScaleAspectFit;
    //color.alpha = 0.75f;
    shuffleBut.userInteractionEnabled = TRUE;
    [blackCard addSubview:shuffleBut];
    
    //ADD SHUFFEL TAP
    UITapGestureRecognizer *tapped234 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBackCard)];
    tapped234.numberOfTapsRequired = 1;
    [tapped234 setDelegate:self];
    [shuffleBut addGestureRecognizer:tapped234];
    
    //MOOD PROMPT
    UILabel* filterPrompt = [[UILabel alloc] initWithFrame:CGRectMake([colorFilter count]*colorW, self.bounds.size.height*0.94, colorW, self.bounds.size.height*0.04)];
    filterPrompt.backgroundColor = [UIColor clearColor];
    filterPrompt.alpha = 0.5f;
    filterPrompt.textAlignment =  NSTextAlignmentCenter;
    filterPrompt.textColor = [UIColor whiteColor];
    filterPrompt.font = [UIFont fontWithName:@"SFUIText-Regular" size:(filterPrompt.bounds.size.height*0.4)];
    filterPrompt.userInteractionEnabled = FALSE;
    [filterPrompt setText:@"MOOD"];
    [blackCard addSubview:filterPrompt];
    

    
    
    
    
    float wid=backCard.bounds.size.width*0.9/3;
    int hei=backCard.bounds.size.height*0.9/3;
    int colum=0;
    int row=0;
    int columM=3;
    for (int i =0; i<[moodFilter count]; i++) {
        if(colum>=columM){ colum = 0; row++;}
        //ADD WINE COLOR
        UIImageView *mood = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[[[moodFilter objectAtIndex:i] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""]] ]];
        mood.frame = CGRectMake(0, 0, wid, hei);
        mood.backgroundColor = [UIColor clearColor];
        mood.contentMode = UIViewContentModeScaleAspectFit;
        mood.tag = i;
        mood.alpha = 0.5f;
        mood.userInteractionEnabled = TRUE;
        [backCard addSubview:mood];
        [moodButs addObject:mood];
        
        
        
        //ADD LOGO TAP
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterMoodView:)];
        tapped.numberOfTapsRequired = 1;
        [tapped setDelegate:self];
        [mood addGestureRecognizer:tapped];
        
        mood.center = CGPointMake(colum*wid + wid*0.5 + backCard.bounds.size.width*0.05, row*hei + hei*0.5 + backCard.bounds.size.height*0.05);
        colum++;
        
        UILabel *moodLabel = [[UILabel alloc] initWithFrame:CGRectMake(mood.bounds.origin.x, mood.bounds.origin.y+mood.bounds.size.height , mood.bounds.size.width, mood.bounds.size.height*0.1)];
        moodLabel.backgroundColor = [UIColor clearColor];
        moodLabel.center = CGPointMake(mood.center.x, mood.center.y+hei*0.5);
        moodLabel.alpha = 0.5f;
        moodLabel.textAlignment =  NSTextAlignmentCenter;
        moodLabel.textColor = [UIColor whiteColor];
        moodLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:(moodLabel.bounds.size.height*0.85)];
        moodLabel.userInteractionEnabled = FALSE;
        [moodLabel setText:[moodFilter objectAtIndex:i]];
        [backCard addSubview:moodLabel];
        
        
        /*
        UIButton *moodBut = [UIButton buttonWithType:UIButtonTypeCustom];
        moodBut.frame = CGRectMake(0, nextT ,self.bounds.size.width, self.bounds.size.height*0.1);
        moodBut.backgroundColor = [UIColor redColor];
        [moodBut setTitle:[moodFilter objectAtIndex:i] forState:UIControlStateNormal];
        [moodBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        moodBut.font = [UIFont boldSystemFontOfSize:(moodBut.bounds.size.height*0.8)];
        moodBut.tag = i;
        [moodBut addTarget:self action:@selector(filterMoodView:) forControlEvents:UIControlEventTouchUpInside];
        moodBut.alpha = 0.75f;
        [blackCard addSubview:moodBut];
        [moodButs addObject:moodBut];
        
        nextT = nextT + self.bounds.size.height*0.1;
         */
        
        
    }
    
    
    NSLog(@"FILTER ADJUSTED AND DONE");
    
}

-(void)filterColorView:(UITapGestureRecognizer*)myId{
    int i = 0;
    //UNDO ALL PREVIOUS
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    for(UIImageView *but in colorButs ) {
        if(but.tag == myId.view.tag) {
            but.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1.png",[[colorFilter objectAtIndex:i] uppercaseString]]] ;
        }
        else{
            but.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@0.png",[[colorFilter objectAtIndex:i] uppercaseString]]] ;
        }
        i++;
    }
    [UIView commitAnimations];
    

    if(![colorF isEqualToString:[colorFilter objectAtIndex:[myId.view tag]]])
    {
        NSLog(@"FILTER COLOR BY %@",[colorFilter objectAtIndex:[myId.view tag]]);
        colorF = [colorFilter objectAtIndex:[myId.view tag]];
        //moodF = @"";
        
        //CREATE CARDS
        [self createCards];
        //
        
        //APPLY FILTER
        [self applyFilterToDeck];
        
        [self activateDeck];
        
        
        
        filterTxt.text =  [self getFilterTxt];
    }
    else{
        NSLog(@"COLOR FILTER ALREADY SELECTED");
    }
    
    

    
}

-(void)filterMoodView:(UITapGestureRecognizer*)myId{
    int i = 0;
    //UNDO ALL PREVIOUS
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    for(UIImageView *but in moodButs ) {
        if(but.tag == myId.view.tag) {
            but.alpha = 1.0f;
            //but.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1.png",[[moodFilter objectAtIndex:i] uppercaseString]]] ;
        }
        else{
            but.alpha = 0.5f;
            //but.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@0.png",[[moodFilter objectAtIndex:i] uppercaseString]]] ;
        }
        i++;
    }
    [UIView commitAnimations];
    
    
    if(![moodF isEqualToString:[moodFilter objectAtIndex:[myId.view tag]]])
    {
        NSLog(@"FILTER MOOD BY %@",[moodFilter objectAtIndex:[myId.view tag]]);
        moodF = [moodFilter objectAtIndex:[myId.view tag]];
        
        colorF = @"";
        
        //CREATE CARDS
        [self createCards];
        //
        
        //APPLY FILTER
        [self applyFilterToDeck];
        
        [self activateDeck];
        
        
        
        filterTxt.text =  [self getFilterTxt];
    }
    else{
        NSLog(@"MOOD FILTER ALREADY SELECTED");
    }
    
    
    
}


/*
-(void)filterMoodView:(UIButton*)myId{
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    for(UIButton *but in moodButs ) {
        if(but.tag == myId.tag) but.alpha = 1.0f;
        else but.alpha = 0.55f;
    }
    [UIView commitAnimations];
    
    //UPDATE TEXT
    //Deck *lastOpenDeckTemp = lastOpenDeck;
    
    [filterTxt setText:[ self filterMood: myId ]];
    
    
    
}
*/


-(NSString*)filterMood:(id)myMf{
    UIButton *myBut = (UIButton *)myMf;
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    myBut.alpha = 1.0f;
    [UIView commitAnimations];
    
    NSLog(@"FILTER MOOD BY %@",[moodFilter objectAtIndex:[myBut tag]]);
    moodF = [moodFilter objectAtIndex:[myBut tag]];
    
    //APPLY FILTER
    [self applyFilterToDeck];
    
    //RE-ACTIVATE DECK
    [self activateDeck];
    
    return [self getFilterTxt];
}

-(void)applyFilterToDeck{
    NSLog(@"APPLY FILTERS- %i %i %@ %@" , [data count], [cards count],colorF , moodF);
    //REMOVE FILTERS
    NSMutableArray *toDelete = [NSMutableArray array];
    for(Card *myCard in cards) {
        //CHECK FOR APPLIED FILTER
        
        //CHECK IF COLOR APPLIED
        if (![colorF isEqualToString:@""]) {
            if(![colorF isEqualToString:[myCard.data  objectForKey:@"color"]])
            {
                NSLog(@"REMOVED DUE TO FILTER %@ %@",[myCard.data  objectForKey:@"color"],[myCard.data  objectForKey:@"moods"]);
                [toDelete addObject:myCard];
                [myCard removeFromSuperview];
                //myCard = NULL;
            }
        }
        
        //CHECK IF MOOD APPLIED
        if (![moodF isEqualToString:@""]){
        
            if( ![moodF isEqualToString:[myCard.data  objectForKey:@"moods"]])
            {
                NSLog(@"REMOVED DUE TO FILTER %@ %@",[myCard.data  objectForKey:@"color"],[myCard.data  objectForKey:@"moods"]);
                [toDelete addObject:myCard];
                [myCard removeFromSuperview];
                //myCard = NULL;
            }
        }
        
        
        
        /*
        if(![colorF isEqualToString:[myCard.data  objectForKey:@"color"]] && ![moodF isEqualToString:[myCard.data  objectForKey:@"moods"]])
        {
            NSLog(@"REMOVED DUE TO FILTER %@ %@",[myCard.data  objectForKey:@"color"],[myCard.data  objectForKey:@"moods"]);
            [toDelete addObject:myCard];
            [myCard removeFromSuperview];
            //myCard = NULL;
        }

        */
    }
    NSLog(@"APPLY FILTERS 1 %i %i %@ %@" , [data count], [cards count],colorF , moodF);
    // Remove them
    [cards removeObjectsInArray:toDelete];
    
    
}

-(NSString*)getFilterTxt{
    if (![colorF  isEqual: @""] && ![moodF  isEqual: @""]) {
        return [NSString stringWithFormat:@"%@ %@ for %@",colorF,title,moodF];
    }
    else if (![colorF  isEqual: @""]){
        return [NSString stringWithFormat:@"%@ %@",colorF,title];
    }
    else if (![moodF  isEqual: @""]){
        return [NSString stringWithFormat:@"%@ for %@",title,moodF];
    }
    else{
        return @"love";
    }
    
}



#pragma mark -
#pragma mark SCROLL VIEW

-(void)buildScrollView{
    // ADD SCROLL VIEW
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height*0.0, self.bounds.size.width,self.bounds.size.height*1.0)];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.clipsToBounds = FALSE;
    scrollView.userInteractionEnabled = TRUE;
    scrollView.scrollEnabled = TRUE;
    scrollView.alpha = 1.0f;
    [self insertSubview:scrollView atIndex:0];
}

BOOL notScrolling = TRUE;

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        //STILL SCROLLING
        notScrolling = false;

    }
    else{
        notScrolling = TRUE;
    }
    NSLog(@"SCROLL STARTED");
    
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"SCROLL STOPPED");
    
    notScrolling = TRUE;
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
   // NSLog(@"SCROLL STOPPED");
    //notScrolling = TRUE;
}

-(BOOL)isScrollingNow{
    return notScrolling;
}




#pragma mark -
#pragma mark DATA

-(void)addCardData:(NSDictionary*)cardData{
    
    //CHECK IF DATA EXISTS
    BOOL foundCard = FALSE;
    for(NSMutableDictionary *myDict in data){
        if([myDict objectForKey:@"product_id"] == [cardData objectForKey:@"product_id"] ){
            NSLog(@"CARD ALREADY IN DECK");
            
            //UPDATE QUANTITY OF ITEMS
            [myDict setObject:[cardData objectForKey:@"quantity"] forKey:@"quantity"];
            //UPDATE QUANTITY OF ITEMS
            [myDict setObject:[cardData objectForKey:@"favourite"] forKey:@"favourite"];
            
            NSLog(@"CARD ALREADY IN DECK1");
            
            foundCard = TRUE;
        }
    }
    if (!foundCard) {
       // NSLog(@"CARD ADD TO DECK");
        if ([type isEqualToString:@"DELIVERY"]) {
            //CHECK FOR QUANTITY
            if ([[cardData objectForKey:@"quantity"] integerValue] > 0) {
                [data addObject:cardData];
                
            }
            else{
                NSLog(@"NO QUANTITY FOUND NOT ADDED TO DELIVERY");
            }
            
        }
        else{
            [data addObject:cardData];
        }
    }
    
    // NSLog(@"ADD CARD DATA %@",cardData);
    //[data addObject:cardData];
}

-(void)addCard:(id)myCard{
    NSLog(@"ADD CARD");
    [cards addObject:((Card*)myCard)];
    // NSLog(@"CARD DATA DONE 2");
    [self insertSubview:((Card*)myCard) atIndex:0];
}

-(NSString*)getTitle{
    return title;
}

-(id)getData{
    NSMutableArray *myMinArr = [[NSMutableArray alloc] init];
    
    for(NSMutableDictionary *myDict in data){
        [myMinArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[myDict objectForKey:@"product_id"],@"product_id",[myDict objectForKey:@"quantity"],@"quantity", nil]];
    }
    
    return myMinArr;
}

-(NSInteger)getOrderQuantity{
    NSLog(@"ORDER QUANTITY");
    NSInteger totalBottles = 0;
    for(NSMutableDictionary *myDict in data){
        totalBottles += [[myDict objectForKey:@"quantity"] integerValue];
    }
    
    
    return totalBottles;
}

-(NSInteger)getOrderPrice{
    NSLog(@"ORDER PRICE");
    NSInteger totalPrice = 0;
    for(NSMutableDictionary *myDict in data){
        int totalBottles = [[myDict objectForKey:@"quantity"] integerValue];
        totalPrice += totalBottles * [[myDict objectForKey:@"price"] integerValue];
    }
    
    
    return totalPrice;
}

-(void)updateUserMainStatsDeck{
    [myDelegate updateUserMainStats];
}


-(void)stopLoadingDeck{
    [myDelegate stopLoading ];
}


#pragma mark -
#pragma mark RANDOM

-(void)openCloseDeck{
    NSLog(@"OPEN CLOSE DECK %@",title);
    
    if(!deckOpen){
        if(![type isEqualToString:@"DELIVERY"]){
            //ACTIVATE DECK
            [self activateDeck];
            
            //LOAD FILTER
            [ self loadFilterSettings];
            
            //[self showBlackCard ];
        }
        else{
            //CHECK IF HAS QUANTITY
            if([self getOrderQuantity]>0){
                [self activateDeck];
                //[self showBlackCard ];
            }
            else{
               // [myDelegate promptSelection];
            }
            
        }
    }
    else{
        //DEACTIVATE DECK
        [myDelegate showSelectionScreen];
    }

}





#pragma mark -
#pragma mark TOUCHES

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touched in Deck %@",title);
    
   
   
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"DECK TOUCHES ENDED");
    
    [myDelegate showSelectionScreen];
}











#pragma mark -
#pragma mark ACTIVATE

-(void)createCards{
    
    if([cards count]>0){
        //REMOVE CARDS NOW
        NSLog(@"HAS CARDS ALREADYYYYYY");
    }
    
    
    for(Card *myC in cards){
        [myC removeFromSuperview];
        //myC = nil;
    }
    [cards removeAllObjects];
    
    //SET TITLE
    if(![type isEqualToString:@"DELIVERY"])filterTxt.text = title;
    
    
    //colorF = @"";
    //moodF = @"";
    
    int i =0;
    float delay;
    //CREATE ALL CARDS
    //NSLog(@"create data 0");
    for (NSDictionary *dictionary in data) {

        Card *myCard = [[Card alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        myCard.myDelegate = self;
        [myCard setData:dictionary];
        [cards addObject:myCard];
        
        
        //GET ALL FILTERS
        if (![colorFilter containsObject:[dictionary objectForKey:@"color"]]) {
            [colorFilter addObject:[dictionary objectForKey:@"color"]];
        }
        
        
        if([dictionary objectForKey:@"moods"] != nil){
            if (![moodFilter containsObject:[dictionary objectForKey:@"moods"]]) {
                [moodFilter addObject:[dictionary objectForKey:@"moods"] ];
            }
        }
        

        
        i++;
    }
    delay = 0.25f;
    
    
    
}

-(void)forceCloseCardAndActiveDeck{
    NSLog(@"forceCloseCardAndActiveDeck");
    //CHECK FOR CURRENT OPEN CARD
    if(currentOpenCard !=nil){
        [(Card*)currentOpenCard closeMyCardForce];
        //close black card
        
    }
    else{
        [self activateDeck];
    }
    
    
}

-(void)activateDeck{
    NSLog(@"DECK - ACTIVATE");
    
    currentOpenCard = nil;
    scrollView.scrollEnabled = TRUE;
    
    //REMOVE PAN
    if(panRecognizer !=nil) [blackCard removeGestureRecognizer:panRecognizer];
    
    //HIDE BLACK CARD
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.15f];
    backCard.alpha = 0;
    [UIView commitAnimations];
    
    scrollView.frame = CGRectMake(0, self.bounds.size.height*0.0, self.bounds.size.width,self.bounds.size.height*0.9);
    [self.superview bringSubviewToFront:self];
    
    NSLog(@"DECK 1");
    
    
    float delay = 0;
    int i = 0;
    if(!deckOpen){
        NSLog(@"DECK 11");
        //if (![type isEqualToString:@"DELIVERY"])delay = 1.0f;
        

        [self createCards];
        NSLog(@"DECK 12");
        //SHOW CARDS
        [ self.myDelegate performSelector: @selector( openDeck: ) withObject: self ];
        NSLog(@"DECK 13");
        
        [self showBlackCard];
        
        
        //SET MAP CENTER
        [deliver updateCurrentLocation];
       
        
        deckOpen = true;

    }
    else{
        
        //ALREADY OPEN
        int di = 1;
        for(Card *myCard in cards ) {
            [scrollView addSubview:myCard];
            //[scrollView insertSubview:myCard atIndex:0];
            
            [UIView beginAnimations:NULL context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration:0.35f];
            [UIView setAnimationDelay:delay];
            myCard.center = CGPointMake(self.bounds.size.width*0.5,  PREVIEWHEIGHT*di + myCard.bounds.size.height*0.5);
            [UIView commitAnimations];
            
            di++;
        }
        
        //PULL DOWN HOLDER
        [scrollView insertSubview:blackCard atIndex:0];
        //[self insertSubview:blackCard atIndex:0];
        [self addSubview:boxHolder];
        
        //if(![type isEqualToString:@"DELIVERY"]){
        // [self addSubview:filterBut];
        // [self addSubview:deckBut];
        // }
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationDelay:delay];
        deckBut.alpha = 1;
        filterBut.alpha = 1;
        if (fakeBoxHolder!=NULL) {
            fakeBoxHolder.alpha=1.0f;
        }
        
        boxHolder.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*1.5- STARTPOINT);
        
        //ALL DECKS
        if (PREVIEWHEIGHT * ([cards count]+1) < self.bounds.size.height*0.9) {
            //MOVE DOWN BY DIFFERENCE
            scrollView.frame = CGRectMake(0, self.bounds.size.height*0.9 - PREVIEWHEIGHT * ([cards count]+1), scrollView.bounds.size.width, self.bounds.size.height*0.9);
            //BLACK CARD
            blackCard.frame = CGRectMake(0, self.bounds.size.height*0.9 - PREVIEWHEIGHT * ([cards count]+1), blackCard.bounds.size.width, blackCard.bounds.size.height);
            blackCard.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
            
        }
        else{
            blackCard.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
        }
        
        
        ////GOES TO TOP
        /*
         blackCard.frame = CGRectMake(0, 0, blackCard.bounds.size.width, blackCard.bounds.size.height);
         
         if (PREVIEWHEIGHT * ([cards count]+1) < self.bounds.size.height*0.9) {
         //WILL NOT SCROLL
         
         //scrollView.frame = CGRectMake(0, self.bounds.size.height*0.9 - PREVIEWHEIGHT * ([cards count]), scrollView.bounds.size.width, self.bounds.size.height*0.9);
         //BLACK CARD
         //blackCard.frame = CGRectMake(0, self.bounds.size.height*0.9 - PREVIEWHEIGHT * ([cards count]+1), blackCard.bounds.size.width, blackCard.bounds.size.height);
         boxHolder.center = CGPointMake(self.bounds.size.width*0.5,  PREVIEWHEIGHT*di + boxHolder.bounds.size.height*0.5);
         
         }
         else{
         
         //WILL SCROLLLL
         boxHolder.center = CGPointMake(self.bounds.size.width*0.5,  PREVIEWHEIGHT*di + boxHolder.bounds.size.height*0.5);
         //boxHolder.frame = CGRectMake(0, self.bounds.size.height*0.9, boxHolder.frame.size.width, boxHolder.frame.size.height);
         //blackCard.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
         }
         */
        
        
        
        [UIView commitAnimations];
        
        [myDelegate closeFullscreenCard];


        
    }
    
    //SET SCROLL VIEW CONTENT SIZE
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, PREVIEWHEIGHT * ([cards count]+1));
    
    NSLog(@"DECK 3");

    
    
    //BOTTOM
    /*
    if ([type isEqualToString:@"DELIVERY"]) {
        if (PREVIEWHEIGHT * ([cards count]+1) < self.bounds.size.height*0.5) {
            //MOVE DOWN BY DIFFERENCE
            scrollView.frame = CGRectMake(0, self.bounds.size.height - PREVIEWHEIGHT * ([cards count]+1), scrollView.bounds.size.width, self.bounds.size.height*0.5);
            //BLACK CARD
            blackCard.frame = CGRectMake(0, self.bounds.size.height*0.9 - PREVIEWHEIGHT * ([cards count]+1), blackCard.bounds.size.width, blackCard.bounds.size.height);
        }
        else{
            //MORE
            scrollView.frame = CGRectMake(0, self.bounds.size.height*0.5, scrollView.bounds.size.width, self.bounds.size.height*0.5);
            blackCard.frame = CGRectMake(0, self.bounds.size.height*0.4, blackCard.bounds.size.width, blackCard.bounds.size.height);
        }
    }
    else{
        NSLog(@"NOT DELIVERY DECK");
        if (PREVIEWHEIGHT * ([cards count]+1) < self.bounds.size.height*0.9) {
            //MOVE DOWN BY DIFFERENCE
            scrollView.frame = CGRectMake(0, self.bounds.size.height*0.9 - PREVIEWHEIGHT * ([cards count]), scrollView.bounds.size.width, self.bounds.size.height*0.9);
            //BLACK CARD
            blackCard.frame = CGRectMake(0, self.bounds.size.height*0.9 - PREVIEWHEIGHT * ([cards count]+1), blackCard.bounds.size.width, blackCard.bounds.size.height);
        }
        else{
            blackCard.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
        }
    }
     */
    
    
    
    
    
    //CLOSE FULLSCREEN ALWAYS
    //
    
    NSLog(@"DECK 4");

}


#pragma mark -
#pragma mark DEACTIVATE

int cardPrev = 0;

-(void)deactivateDeck{
    NSLog(@"DECK - DEACTIVATE");
    
    if(deckOpen){
        //CLEAR FILTER TXT
        if(![type isEqualToString:@"DELIVERY"])filterTxt.text = title;
        
        colorF = [NSMutableString stringWithFormat:@""];
        moodF = [NSMutableString stringWithFormat:@""];
        
        //CHECK IF SCROLL LIST IS BIGGER
        //scrollView.backgroundColor = [UIColor redColor];
        scrollView.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.45);
        //[scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0) animated:NO];
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top) animated:NO];

        //REMOVE AND DELETE CARDS
        int delay = 0;
        for(Card *card in cards ) {
            //NSLog(@"CARD ani");
            [UIView beginAnimations:NULL context:(__bridge void *)(card)];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDidStopSelector:@selector(removeCardFromView:finished:context:)];
            [UIView setAnimationDuration:0.15f];
            [UIView setAnimationDelay:delay];
            card.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
            [UIView commitAnimations];
            //delay += 0.1f;
        }
        
       // [self showFakeCards];
        
        //PULL UP HOLDER
        //[self addSubview:blackCard];
        [self addSubview:boxHolder];
        
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.15f];
        [UIView setAnimationDelay:delay];
        deckBut.alpha = 0.0f;
        filterBut.alpha = 0.0f;
        if (fakeBoxHolder!=NULL) {
            fakeBoxHolder.alpha=0.0f;
        }
        boxHolder.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
        blackCard.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.4);
        [UIView commitAnimations];
        
        

        
        deckOpen = FALSE;
    }
    
    
}



#pragma mark -
#pragma mark CARD OPEN CLOSE

-(void)openCard:(id)myCard{
    NSLog(@"DECK - OPEN CARD");
    
    //SET CURRENT CAR
    currentOpenCard = myCard;
    
    //GET SCROLL CONTENT OFFSET
    contentOffPrev = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);

    if (![type isEqualToString:@"DELIVERY"]) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top) animated:NO];
    }
    else{
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0) animated:NO];
    }
    scrollView.scrollEnabled = FALSE;
    
    //FULL SCREEN
    [myDelegate fullScreenCard];
    
    
    //HIDE ALL CARD EXCEPT SELECTED
    float delay = 0.0f;
    float cardDif = self.bounds.size.height*0.1 / ([cards count]+1);
    int di = 1;
    for(Card *card in cards) {
        
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
    
    deckBut.alpha = 0.0f;
    filterBut.alpha = 0.0f;
    if (fakeBoxHolder!=NULL) {
        fakeBoxHolder.alpha=0.0f;
    }
    
    //OTHER
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35f];
    scrollView.frame = CGRectMake(0, 0, scrollView.bounds.size.width, self.bounds.size.height);
    boxHolder.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*1.5 + cardDif*di);
    blackCard.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*1.5 + cardDif*di);
    [UIView commitAnimations];

}

-(void)closeCard:(id)myCard{
    NSLog(@"DECK - CLOSE CARD");
    
    // CLOSE FULL SCREEN
    [myDelegate closeFullscreenCard];
    

    
    if (![type isEqualToString:@"DELIVERY"]) {
        [scrollView setContentOffset:contentOffPrev animated:YES];
        
    }
    else{
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0) animated:YES];
    }
    
    
    
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





#pragma mark -
#pragma mark CARD NEXT AND PREVIOUS

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



#pragma mark -
#pragma mark ORDER CARD

-(void)orderCard:(id)myCard{
    NSLog(@"ORDER CARD - deck");
    
    //UPDATE CARD DATA IN DECK FOR NEXT TIME
    [self addCardData:((Card*)myCard).data];
    
    NSLog(@"ORDER CARD - deck2");
    
    //CHECK IF DELIVERY DECK
    if([type isEqualToString:@"DELIVERY"]){
        //UPDATE ALL CARDS IN COLLECTIONS
        NSLog(@"ORDER CARD - deck22");
        [ self.myDelegate performSelector: @selector( updateCardsInDecks: ) withObject: myCard ];
        NSLog(@"ORDER CARD - deck3");
        
        //PROMPT TO REMOVE CARD
        if( [((Card*)myCard) getNumberOfItems] <= 0  ){
            
            //REMOVE FROM DELIVERY AND ACTIVATE DECK...
            [UIView beginAnimations:NULL context:(__bridge void *)(myCard)];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDidStopSelector:@selector(removeCardFromViewAndData:finished:context:)];
            [UIView setAnimationDuration:0.15f];
            ((Card*)myCard).center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*1.5);
            [UIView commitAnimations];
            NSLog(@"ORDER CARD - deck5");
            /*/PROMPT
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",((Card*)myCard).title.text ]
                                                            message:[NSString stringWithFormat:@"%@ has been removed from your Delivery Pack",((Card*)myCard).title.text ]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
             */
            NSLog(@"ORDER CARD - deck6");
           
        }
        
        
    }
    else{
        //ADD TO DELIVERY DECK
        [ self.myDelegate performSelector: @selector( addCardToDelivery: ) withObject: myCard ];
    }
    
    
    //REMOVE CARD FROM DECK AND PLACE IN DELIVERY DECK
}


-(void)updateDeliveryDeckTitle{
    NSLog(@"UPDATE DELIVERY DECK TITLE");
    
    //GO THROUGH DATA AND COUNT BOTTLES
    [deliver updateScrollItems];
    
    //SET TITLE BASED ON BOTTLES AND TOTAL PRICE
    if ([self getOrderQuantity]<1) {
        filterTxt.text = @"CHOOSE WINE FROM COLLECTIONS";
    }
    else if([self getOrderQuantity]>1) {
        filterTxt.text = [NSString stringWithFormat:@"%i BOTTLES FOR %i VINOS",[self getOrderQuantity],[self getOrderPrice]]; ;
    }
    else {
        filterTxt.text = [NSString stringWithFormat:@"%i BOTTLE FOR %i VINOS",[self getOrderQuantity],[self getOrderPrice]]; ;
    }
}



#pragma mark -
#pragma mark FLIP CARD

-(void)flipCard:(id)myCard{
    NSLog(@"FLIP CARD OVER - deck");
    
    //REMOVE CARD FROM DECK
}





#pragma mark -
#pragma mark REMOVING CARDS

-(void)removeCardFromView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    if (!cards || !cards.count !=NULL) {
        if([cards containsObject: (__bridge id)(context)]){
            
            [(__bridge Card*)context removeFromSuperview];
            [cards removeObject:(__bridge id)(context)];
            context = nil;
            
            // NSLog(@"OOOIIII  CARD REMOVED");
        }
    }
    
    
  
    
}

-(void)removeCardFromViewAndData:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    //REMOVE FROM DATA
    //CHECK IF DATA EXISTS
    BOOL foundCard = FALSE;
    NSMutableDictionary *objectToRemove;
    for(NSMutableDictionary *myDict in data){
        if([myDict objectForKey:@"product_id"] == [((__bridge Card*)context).data objectForKey:@"product_id"] ){
           // NSLog(@"DELETE THIS DATA");
            objectToRemove = [[NSMutableDictionary alloc] initWithDictionary:myDict];
            
            
            foundCard = TRUE;
            break;
        }
    }
    if (foundCard) {
        
        //DELETE DATA
        [data removeObject:objectToRemove];
        
        [cards removeObject:(__bridge id)(context)];
        [(__bridge Card*)context removeFromSuperview];
        context = nil;
       // NSLog(@"CARD REMOVED");
        
         [self activateDeck];
    }

    
    
    
    
}

/*
-(void)showFakeCards{
    NSLog(@"SHOW FAKE CARDS");
    cardPrev = 0;
    float cardH = (self.bounds.size.height*0.1) / ([data count]+1);

    for (int i = 0; i<[data count]; i++) {
        //FAKE CARDS
        UIView *tempCard = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
        tempCard.backgroundColor = [UIColor whiteColor];
        tempCard.layer.shadowColor = [UIColor grayColor].CGColor;
        tempCard.layer.shadowOffset = CGSizeMake(-5, -5);
        tempCard.layer.shadowOpacity = 0.7f;
        tempCard.layer.shadowRadius = 1.0;
        [self insertSubview:tempCard atIndex:0];
        [fakeCard addObject:tempCard];
        
        
        //ANIMATE
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.25f];
        //[UIView setAnimationDelay:0.25f];
        tempCard.frame = CGRectMake(0, (0-cardH) * cardPrev, self.bounds.size.width, self.bounds.size.height);
        [UIView commitAnimations];
        cardPrev = cardPrev +1;
    }
    
}
 */

/*
-(void)hideFakeCards{
    NSLog(@"HIDE FAKE CARDS");
    
   
    for(UIView *fCard in fakeCard){
        [UIView beginAnimations:NULL context:(__bridge void *)(fCard)];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(removeFakeCardFromView:finished:context:)];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.15f];
        fCard.frame = CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height);
        fCard.alpha = 0.0f;
        [UIView commitAnimations];
    }
    
}
 */

/*
-(void)removeFakeCardFromView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    [(__bridge UIView*)context removeFromSuperview];
    [fakeCard removeObject:(__bridge id)(context)];
    context = nil;
    NSLog(@"FAKE CARD REMOVED");
    
}
*/

// Only override drawRect: if you perform custom drawing.
/*/ An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   
    
    // Drawing Rect
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
     
  
    
    
   
}
 */
-(void)dealloc{
    NSLog(@"DEALLOC DECK");
}


@end
