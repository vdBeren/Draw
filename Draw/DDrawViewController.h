//
//  DDrawViewController.h
//  Draw
//
//  Created by Victor D. Savariego on 25/3/15.
//  Copyright (c) 2015 Victor D. Savariego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDrawViewController : UIViewController{
    
    CGPoint lastPoint;
    CGPoint moveBackTo;
    CGPoint currentPoint;
    CGPoint location;
    BOOL mouseSwiped;
    UIImageView *drawImage;
    UIImageView *frontImage;
    
    CABasicAnimation *theAnimation;
    
    float r, g, b;
    
    
    
}

-(void) colorSelected;

@end
