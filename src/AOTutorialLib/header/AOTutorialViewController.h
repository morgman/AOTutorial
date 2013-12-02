//
//  AOTutorialViewController.h
//  BabyPlanner
//
//  Created by Loïc GRIFFIE on 11/10/2013.
//  Copyright (c) 2013 Appsido. All rights reserved.
//

#import <UIKit/UIKit.h>

enum  {
    AOTutorialButtonNone,
    AOTutorialButtonSignup,
    AOTutorialButtonLogin
};
typedef NSUInteger AOTutorialButton;

@interface AOTutorialViewController : UIViewController

@property (assign, nonatomic) AOTutorialButton buttons;
@property (retain, nonatomic) UIImage *header;
/**
 * Custom init method to create a new AOTutorialController object
 *
 * @param NSArray collection of background images (ie. @[@"bg_1.jpg", @"bg_2.jpg", @"bg_3.jpg"])
 * @param NSArray collection of labels (ie. @[@{@"Header": @"Header 1", @"Label": @"label 1"}, @{@"Header": @"Header 2", @"Label": @"label 2"}, @{@"Header": @"Header 3", @"Label": @"label 3"}])
 *
 * @return AOTutorialController
 */

- (instancetype)initWithBackgroundImages:(NSArray *)images andInformations:(NSArray *)informations;

/**
 * Define a header image
 *
 * @param UIImage image used for header
 */

- (void)setHeaderImage:(UIImage *)logo;

/**
 * Callback for Signup button being touched up
 */

- (IBAction)signup:(id)sender;

/**
 * Callback for Login button being touched up
 */


- (IBAction)login:(id)sender;

/**
 * Callback for Dismiss button being touched up
 */


- (IBAction)dismiss:(id)sender;

@end