//
//  AEHomeViewController.h
//  Sketch
//
//  Created by Alex Eisenach on 4/27/14.
//  Copyright (c) 2014 Free Swim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AECLController.h"

@interface AEHomeViewController : UIViewController<AECLControllerDelegate,NSURLConnectionDelegate>
{
    AECLController *locationController;
    NSMutableData *_responseData;

}

@property IBOutlet UISwitch *switcher;

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
-(IBAction)tracking_button:(id)sender;

@end
