//
//  User.h
//  colorgameapp
//
//  Created by Herman Coetzee on 2012/10/07.
//  Copyright (c) 2012 Color Game App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface TutorialDel : UIView <UIAlertViewDelegate,UIScrollViewDelegate>{
    
  
   
    NSMutableArray *iconsList;
    
    
}

@property (strong, nonatomic) NSMutableArray *iconsList;



@end
