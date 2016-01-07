//
//  User.m
//  colorgameapp
//
//  Created by Herman Coetzee on 2012/10/07.
//  Copyright (c) 2012 Color Game App. All rights reserved.
//
#import <Parse/Parse.h>

#import "Tutorial.h"
#import <QuartzCore/QuartzCore.h>
//#import "ParseStarterProjectViewController.h"
//#import "FormTableControllerDeliver.h"


//#define MYVINOSSERVER @"https://myvinos-test-api.infinity-g.com"
#define MYVINOSSERVER @"https://myvinos-api.infinity-g.com"



@implementation Tutorial

@synthesize iconsList;


int pageIndex = 0;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"HELLO TUTORIAL SCREEN");
        pageIndex = 0;
        
        self.backgroundColor = [UIColor clearColor];
        
        
        NSArray *images = [[NSArray alloc] initWithObjects:@"selectButton.png",@"vinosButtut.png",@"deliverMan.png",@"memButGOLDtut.png", nil];
        NSArray *titles = [[NSArray alloc] initWithObjects:@"Select",@"Purchase",@"Deliver",@"Members", nil];
        NSArray *descriptions = [[NSArray alloc] initWithObjects:@"Choose from incredible\ncollections guided by tasting\nnotes and recommendations\nfrom professional\nsommeliers.",@"Purchase VINOS during\nliquor trading hours and\nhave your wine delivered\non demand.",@"Delivered on-demand in\n30-45 minutes, directly from\nthe cellar to your door, ready\nto enjoy at the perfect\ntemperature.",@"Own your share of\nthe private cellar. Get your wine\non-demand for no extra charge,\nincluding after-hours.", nil];
        NSArray *subDescriptions = [[NSArray alloc] initWithObjects:@"Collections are regularly updated.",@"(R10 = 1 VINOS)",@"12:00 - 22:00 daily",@"VINOS will be automatically topped up.", nil];
        
        
        
        
        //BACK GROUND
        UIView *b2k = [[UIView alloc] initWithFrame:self.frame];
        b2k.backgroundColor = [UIColor whiteColor];
        b2k.alpha = 0.85f;
        
        [self addSubview:b2k];

        
        
        
        
        iconsList = [[NSMutableArray alloc] init];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        scrollView.pagingEnabled = YES;
        scrollView.clipsToBounds = YES;
        [scrollView setContentSize:CGSizeMake(self.frame.size.width*([titles count]+1), self.frame.size.height)];
        scrollView.delegate = self;
        
         [self addSubview:scrollView];
        
        for (int i =0; i<[titles count]; i++) {
            
            NSLog(@"HELLO");
            //BACK GROUND
            UIView *bk = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width*0.06 + self.frame.size.width*i, self.frame.size.height*0.11, self.frame.size.width*0.9, self.frame.size.height*0.75)];
            bk.clipsToBounds = YES;
            [self drawDashedBorderAroundView:bk ];
            //bk.backgroundColor = [UIColor clearColor];
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.bounds;
            gradient.startPoint = CGPointMake(0.5, 0);
            gradient.endPoint = CGPointMake(0.5,1);
            gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:192.0f/255.0f green:41.0f/255.0f blue:66.0f/255.0f alpha:1.0f] CGColor], nil];
            bk.layer.shadowColor = [UIColor blackColor].CGColor;
            bk.layer.shadowOffset = CGSizeMake(0, 0);
            bk.layer.shadowOpacity = 0.75f;
            bk.layer.shadowRadius = 5.0f;

            [bk.layer insertSublayer:gradient atIndex:0];
            
            
            
            //bk.alpha = 0.65f;
            
            [scrollView addSubview:bk];
            
            
            //CREDIT TITLE
            UITextView *title =[[UITextView alloc] initWithFrame:CGRectMake(bk.bounds.size.width*0.1, bk.bounds.size.height*0.025, bk.bounds.size.width*0.8, bk.bounds.size.height*0.125)];
            title.backgroundColor = [UIColor clearColor];
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = [UIColor whiteColor];
            title.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(title.bounds.size.height*0.725)];
            title.alpha = 1.0f;
            title.userInteractionEnabled = FALSE;
            title.text = [titles objectAtIndex:i];
            [bk addSubview:title];
            
            
            
            
            //IMAGE
            UIImageView *tutImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[images objectAtIndex:i] ]];
            tutImg.frame = CGRectMake(bk.bounds.size.width*0.0, bk.bounds.size.height*0.155, bk.bounds.size.width*1, bk.bounds.size.height*0.325);
            tutImg.backgroundColor = [UIColor clearColor];
            tutImg.contentMode = UIViewContentModeScaleAspectFit;
            tutImg.userInteractionEnabled = FALSE;
            [bk addSubview:tutImg];
            
            
            
            //CREDIT DESCRIPTION
            UITextView *description =[[UITextView alloc] initWithFrame:CGRectMake(bk.bounds.size.width*0.05, bk.bounds.size.height*0.5, bk.bounds.size.width*0.9, bk.bounds.size.height*0.25)];
            description.backgroundColor = [UIColor clearColor];
            description.textAlignment = NSTextAlignmentCenter;
            description.font = [UIFont fontWithName:@"SFUIText-Regular" size:(title.bounds.size.height*0.3)];
            description.alpha = 1.0f;
            description.textColor = [UIColor whiteColor];
            
            description.userInteractionEnabled = FALSE;
            description.text = [descriptions objectAtIndex:i];
            [bk addSubview:description];
            
            
            // DESCRIPTION 2
            UITextView *description2 =[[UITextView alloc] initWithFrame:CGRectMake(bk.bounds.size.width*0.05, bk.bounds.size.height*0.75, bk.bounds.size.width*0.9, bk.bounds.size.height*0.2)];
            description2.backgroundColor = [UIColor clearColor];
            description2.textAlignment = NSTextAlignmentCenter;
            description2.font = [UIFont fontWithName:@"SFUIText-Italic" size:(title.bounds.size.height*0.3)];
            description2.alpha = 1.0f;
            description2.textColor = [UIColor whiteColor];
            
            description2.userInteractionEnabled = FALSE;
            description2.text = [subDescriptions objectAtIndex:i];
            [bk addSubview:description2];

        }
        
        
        
        //COLOR FILTER
        float dW = self.frame.size.width*0.4;
        float colorW = dW/([titles count]);
        for (int i =0; i<[titles count]; i++) {
            //ADD WINE COLOR
            UIImageView *color = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RED1.png" ]];
            color.frame = CGRectMake((i)*colorW+self.frame.size.width*0.3, self.bounds.size.height*0.88, colorW, self.bounds.size.height*0.04);
            color.backgroundColor = [UIColor clearColor];
            color.contentMode = UIViewContentModeScaleAspectFit;
            color.tag = i;
            color.alpha = 0.5f;
            [self addSubview:color];
            [iconsList addObject:color];
            
          
            
        }
        
        
        //SET FIRST ONE
        [[iconsList objectAtIndex:0] setAlpha:1.0f];
        
        
        //SKIP BUT
        UIButton *skipBut = [UIButton buttonWithType:UIButtonTypeCustom];
        skipBut.frame = CGRectMake(self.bounds.size.width*0.05, self.bounds.size.height*0.9, self.bounds.size.width*0.9, self.bounds.size.height*0.1);
        skipBut.backgroundColor = [UIColor clearColor];
        [skipBut setTitle:@"Skip" forState:UIControlStateNormal];
        [skipBut setTitleColor:[UIColor colorWithRed:110.0f/255.0f green:0.0f/255.0f blue: 30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        skipBut.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:(skipBut.bounds.size.height*0.4)];
        [skipBut addTarget:self action:@selector(skipTut) forControlEvents:UIControlEventTouchUpInside];
        skipBut.alpha = 1;
        [self addSubview:skipBut];
        
      
    }
    return self;
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
[[iconsList objectAtIndex:pageIndex] setAlpha:0.5f];
    int pageWidth = self.frame.size.width;
    int pageX = pageIndex*pageWidth-scrollView.contentInset.left;
    if (targetContentOffset->x<pageX) {
        if (pageIndex>0) {
            pageIndex--;
        }
    }
    else if(targetContentOffset->x>pageX){
        if (pageIndex<4) {
            pageIndex++;
        }
    }
   // targetContentOffset->x = pageIndex*pageWidth-scrollView.contentInset.left;
    
    if(pageIndex==[iconsList count]){
        NSLog(@"END TUTORIAL");
        [self removeFromSuperview];
    }
    else{
        [[iconsList objectAtIndex:pageIndex] setAlpha:1.0f];
        NSLog(@"%d %d", pageIndex, (int)targetContentOffset->x);
    }
    
}

-(void)skipTut{
    NSLog(@"END TUTORIAL");
    
    
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDidStopSelector:@selector(skipTutEnd)];
    self.alpha = 0.0f;
    [UIView commitAnimations];
    
}


-(void)skipTutEnd{
    [self removeFromSuperview];
}

- (void)drawDashedBorderAroundView:(UIView *)v
{
    //border definitions
    CGFloat cornerRadius = 20;
    CGFloat borderWidth = 2;
    UIColor *lineColor = [UIColor whiteColor];
    
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
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeColor = [lineColor CGColor];
    _shapeLayer.lineWidth = borderWidth;
    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view, the border is visible
    [v.layer addSublayer:_shapeLayer];
    v.layer.cornerRadius = cornerRadius;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Touched on Tutorial");
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"Touch ENDED on Tutorial");
    

    
}



@end
