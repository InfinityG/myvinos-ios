//
//  User.h
//  colorgameapp
//
//  Created by Herman Coetzee on 2012/10/07.
//  Copyright (c) 2012 Color Game App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>



@interface Deliver : UIView <MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>{
    
    NSMutableArray *topUps;

    NSURLConnection *connectionDeliver;

    NSMutableData *dataDeliver;

    NSMutableDictionary *jsonDataDeliver;

    
    BOOL deliverOpen;
    MKMapView *mapView;
    
    NSMutableArray *deliveryDecks;
    MKPointAnnotation *myAnnotation;
    
    UIButton *deliverButton;
    UIButton *deliverLabel;
    
    UITextField *addressLocation;
    
    id myDelegate;
    
    CLLocationManager *locManager;
    
    UIView *cardView;

    
    
    UILabel *timeLabel;
    
    UIView *noticeView;
    UITextView *noticeTxt;
    
    UIButton *deliverButtonInside;
    
    CLLocation *deliveryLocation;
}

@property (retain, nonatomic)NSMutableArray *topUps;
@property (retain, nonatomic)NSURLConnection *connectionDeliver;
@property (retain, nonatomic)NSMutableData *dataDeliver;
@property (retain, nonatomic)NSMutableDictionary *jsonDataDeliver;

@property (strong, nonatomic) NSMutableArray *deliveryDecks;
@property (strong, nonatomic) MKPointAnnotation *myAnnotation;
@property (strong, nonatomic) MKMapView *mapView;

@property (strong, nonatomic) UIButton *deliverButton;
@property (strong, nonatomic) UIButton *deliverLabel;

@property (strong, nonatomic) UITextField *addressLocation;

@property (strong, nonatomic) id myDelegate;

@property (nonatomic, retain) CLLocationManager *locManager;

@property (strong, nonatomic) UIView *cardView;



@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIView *noticeView;
@property (strong, nonatomic) UITextView *noticeTxt;

@property (strong, nonatomic) UIButton *deliverButtonInside;

@property (nonatomic, retain) CLLocation *deliveryLocation;



-(void)makeDelivery;
-(BOOL)hasItems;
-(void)closeDelivery;

-(void)hideCardView;
-(void)showCardView;

-(void)forwardLocate;

@end
