#AOTutorial - Out of the box tutorial application

AOTutorial is under MIT Licence so if you find it helpful just use it !

###**AOTutorialDemo**

This project help create clean application home view controller with block based animation for background images. You can also choose between NSBundle images or distant images with placeholder while image being downloaded.

The AOMedallionView inherit from AGMedallionView library to add user interaction and delegate method.

https://github.com/arturgrigor/AGMedallionView

Distant background images is using the EGOImageLoader library.

https://github.com/enormego/EGOImageLoading

###**Screenshot:**
AOTutorialDemo in the iphone simulator

![ScreenShot](http://public.appsido.com/iPhone/public/AOTutorial/AOTutorialScreen_1.0.png)

###**Video:**
http://public.appsido.com/iPhone/public/AOTutorial/AOTutorial.mp4

##How To Use It

Sample project show a simple usage.

###Documentation

```objc

/**
 * Custom init method to create a new AOTutorialController object
 *
 * @param NSArray collection of background images (ie. @[@"bg_1.jpg", @"bg_2.jpg", @"bg_3.jpg"])
 * @param NSArray collection of labels (ie. @[@{@"Header": @"Header 1", @"Label": @"label 1"}, @{@"Header": @"Header 2", @"Label": @"label 2"}, @{@"Header": @"Header 3", @"Label": @"label 3"}])
 *
 * @return AOTutorialController
 */

- (instancetype)initWithBackgroundImages:(NSArray *)images andInformations:(NSArray *)informations;

```

###Code snippet

```objc
// First create a new view controller class that inherit from AOTutorialViewController class. Do not forget to import the AOTutorialViewController interface

#import "AOTutorialViewController.h"

@interface AOTutorialController : AOTutorialViewController

@end

// Then in the .m file add the buttons action methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

#pragma mark - User interface methods

- (IBAction)signup:(id)sender
{
    NSLog(@"signup button touch up completed");
}

- (IBAction)login:(id)sender
{
    NSLog(@"login button touch up completed");
}

- (IBAction)dismiss:(id)sender
{
    NSLog(@"dismiss button touch up completed");
}

// Finally load your Tutorial view controller
AOTutorialController *vc = [[AOTutorialController alloc] initWithBackgroundImages:@[@"bg_1.jpg", @"bg_2.jpg", @"bg_3.jpg", @"bg_4.jpg", @"bg_5.jpg"]
                                                                      andInformations:@[@{@"Header": @"Header 1", @"Label": @"label 1"}, @{@"Header": @"Header 2", @"Label": @"label 2"}, @{@"Header": @"Header 3", @"Label": @"label 3"}, @{@"Header": @"Header 4", @"Label": @"label 4"}, @{@"Header": @"Header 5", @"Label": @"label 5"}]];

// Define which button you want. By default only dismiss button is shown
[vc setButtons:AOTutorialButtonSignup | AOTutorialButtonLogin];

// Define a company header image. By default no image is shown
[vc setHeaderImage:[UIImage imageNamed:@"myCompanyLogo.png"]];
```

Any comments are welcomed

@Appsido
contact@appsido.com
