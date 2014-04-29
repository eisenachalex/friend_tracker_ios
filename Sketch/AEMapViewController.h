//
//  AEMapViewController.h
//  Sketch
//
//  Created by Alex Eisenach on 4/27/14.
//  Copyright (c) 2014 Free Swim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEFriendsViewController.h"

@interface AEMapViewController : UIViewController<NSURLConnectionDelegate,AEFriendsViewControllerDelegate> {
    NSMutableData *_responseData;
    NSString *activeFriend;

}

@property NSTimer *myTime;
@end

