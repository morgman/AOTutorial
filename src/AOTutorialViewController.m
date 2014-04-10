//
//  AOTutorialViewController.m
//  BabyPlanner
//
//  Created by Loïc GRIFFIE on 11/10/2013.
//  Copyright (c) 2013 Appsido. All rights reserved.
//

#import "AOTutorialViewController.h"
#import "UIColor+Additions.h"

#define headerLeftMargin    20.0f
#define headerFontSize      15.0f
#define headerFontType      @"Helvetica"
#define headerColor         [UIColor whiteColor]

#define labelLeftMargin     40.0f
#define labelFontSize       12.0f
#define labelFontType       @"Helvetica-Light"
#define labelColor          [UIColor whiteColor]

#define buttonColorTop      @"#FFFFFF"
#define buttonColorBottom   @"#D5D5D5"

#define loginLabelColor     @"#000000"
#define signupLabelColor    @"#B80000"
#define dismissLabelColor   @"#000000"


@interface UIColor (AOAdditions)

/**
 * Generate UIColor with given Hexadecimal color such as 0x123456
 *
 * @param UInt32 The hexadecimal color
 * @return UIColor translation
 */

+ (UIColor *)colorWithHex:(UInt32)col;

/**
 * Generate UIColor with given Hexadecimal color string representationsuch as #123456
 *
 * @param NSString The hexadecimal color
 * @return UIColor translation
 */

+ (UIColor *)colorWithHexString:(NSString *)str;

@end

@implementation UIColor (AOAdditions)

+ (UIColor *)colorWithHexString:(NSString *)str {
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:(int)x];
}

+ (UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

@end

@interface AOTutorialViewController ()
{
    NSUInteger _index;
}

@property (strong, nonatomic) NSMutableArray *backgroundImages;
@property (strong, nonatomic) NSMutableArray *informationLabels;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundBottomImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundTopImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation AOTutorialViewController

#pragma mark - Helper function

CGSize ACMStringSize(NSString *string, CGSize size, NSDictionary *attributes)
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:string];
    [textStorage setAttributes:attributes range:NSMakeRange(0, [textStorage length])];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:size];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    return [layoutManager usedRectForTextContainer:textContainer].size;
}

#pragma mark - Life cycle methods

- (instancetype)initWithBackgroundImages:(NSArray *)images andInformations:(NSArray *)informations
{
    self = [self initWithNibName:@"AOTutorialViewController" bundle:nil];
    if (self)
    {
        self.backgroundImages = [NSMutableArray array];
        for (NSString *imageName in images) {
            UIImage *anImage = [UIImage imageNamed:imageName];
            [self.backgroundImages addObject:anImage];
        }
        self.informationLabels = [NSMutableArray arrayWithArray:informations];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _index = 0;
        _buttons = AOTutorialButtonNone;
        
        self.backgroundImages = [NSMutableArray array];
        self.informationLabels = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.header)
    {
        [self.logo setHidden:NO];
        [self.logo setImage:self.header];
    }
    
    [self.pageController setNumberOfPages:[self.backgroundImages count]];
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width * [self.backgroundImages count], self.scrollview.frame.size.height)];
    
    [self.backDismissButton setTitle:[[self.dismissButton titleLabel] text] forState:UIControlStateNormal];

    [self layoutViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addButton
{
    [self.loginButton setTitleColor:[UIColor colorWithHexString:loginLabelColor] forState:UIControlStateNormal];
    [self.signupButton setTitleColor:[UIColor colorWithHexString:signupLabelColor] forState:UIControlStateNormal];
    [self.dismissButton setTitleColor:[UIColor colorWithHexString:dismissLabelColor] forState:UIControlStateNormal];
    
    [self.dismissButton setHidden:YES];
    [self.backDismissButton setHidden:YES];
    [self.backDismissButton setAlpha:0.0];
    
    switch (self.buttons) {
        case AOTutorialButtonSignup:
            [self.signupButton setHidden:NO];
            break;
        case AOTutorialButtonLogin:
            [self.loginButton setHidden:NO];
            break;
        case AOTutorialButtonSignup | AOTutorialButtonLogin:
            [self.signupButton setHidden:NO];
            [self.loginButton setHidden:NO];
            break;
        default:
            [self.signupButton setHidden:YES];
            [self.loginButton setHidden:YES];
            [self.dismissButton setHidden:NO];
            [self.backDismissButton setHidden:NO];
    }
}

- (void)layoutViews
{
    [self addButton];
    [self addInformationsLabels];
    [self resetBackgroundImageState];
    
    [self.backgroundBottomImage setImage:[self.backgroundImages objectAtIndex:_index+1]];
}

- (void)addInformationsLabels
{
    NSUInteger index = 0;
    for (NSDictionary *labels in self.informationLabels)
    {
        CGSize hSize = ACMStringSize([labels valueForKey:@"Header"], CGSizeMake(([[UIScreen mainScreen] bounds].size.width - (headerLeftMargin * 2)), 60.0f), [self headerTextStyleAttributesGivenSize:[[labels valueForKey:@"HeaderSize"] intValue]]);
        CGSize lSize = ACMStringSize([labels valueForKey:@"Label"], CGSizeMake(([[UIScreen mainScreen] bounds].size.width - (labelLeftMargin * 2)), 60.0f), [self labelTextStyleAttributesGivenSize:[[labels valueForKey:@"HeaderSize"] intValue]]);
        
        NSLog(@"Frame > %@", NSStringFromCGRect(self.scrollview.frame));
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0.0f + ([[UIScreen mainScreen] bounds].size.width * index) + headerLeftMargin, [[UIScreen mainScreen] bounds].size.height - 120.0f - lSize.height, ([[UIScreen mainScreen] bounds].size.width - (headerLeftMargin * 2)), hSize.height + 5.0f)];
        [header setNumberOfLines:1];
        [header setLineBreakMode:NSLineBreakByTruncatingTail];
        [header setText:[labels valueForKey:@"Header"]];
        [header setTextAlignment:NSTextAlignmentCenter];
        [header setBackgroundColor:[UIColor clearColor]];
        [header setTextColor:[UIColor colorWithHexString:[labels valueForKey:@"HeaderColor"]]];
        [header setFont:[UIFont fontWithName:headerFontType size:[[labels valueForKey:@"HeaderSize"] intValue]]];
        [self.scrollview addSubview:header];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f + ([[UIScreen mainScreen] bounds].size.width * index) + labelLeftMargin, header.frame.origin.y + hSize.height + 5.0f, ([[UIScreen mainScreen] bounds].size.width - (labelLeftMargin * 2)), lSize.height)];
        [label setNumberOfLines:0];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label setText:[labels valueForKey:@"Label"]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithHexString:[labels valueForKey:@"LabelColor"]]];
        [label setFont:[UIFont fontWithName:labelFontType size:[[labels valueForKey:@"LabelSize"] intValue]]];
        [self.scrollview addSubview:label];
        
        index++;
    }
}

- (void)resetBackgroundImageState
{
    [self.backgroundTopImage setImage:[self.backgroundImages objectAtIndex:_index]];
    [self.backgroundTopImage setAlpha:1.0];
    [self.backgroundBottomImage setAlpha:0.0];
    
    [self.backDismissButton setAlpha:0.0];
    [self.dismissButton setAlpha:1.0];
}

- (void)setHeaderImage:(UIImage *)logo
{
    [self setHeader:logo];
}

- (void)setHeaderVisible:(bool)isVisible {
    
    float targetAlpha = 1.0;
    if (isVisible) {
        targetAlpha = 0.0;
        [self.logo setHidden:NO];
    } else {
        [self.logo setHidden:YES];
    }
    [UIView animateWithDuration:0.2
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.logo.alpha = targetAlpha;
                     }
                     completion:^(BOOL finished){
                         [self.logo setHidden:isVisible];
                     }];
    
}

#pragma mark - Labels methods

- (NSDictionary *)headerTextStyleAttributesGivenSize:(int)fontSize
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineSpacing:5.0f];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowBlurRadius = 0.0;
    shadow.shadowOffset = CGSizeMake(1.0, 1.0);
    
    return @{NSFontAttributeName:[UIFont fontWithName:headerFontType size:fontSize], NSForegroundColorAttributeName:headerColor, NSParagraphStyleAttributeName:style, NSShadowAttributeName:shadow};
}

- (NSDictionary *)labelTextStyleAttributesGivenSize:(int)fontSize
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineSpacing:5.0f];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowBlurRadius = 0.0;
    shadow.shadowOffset = CGSizeMake(1.0, 1.0);
    
    return @{NSFontAttributeName:[UIFont fontWithName:labelFontType size:fontSize], NSForegroundColorAttributeName:labelColor, NSParagraphStyleAttributeName:style, NSShadowAttributeName:shadow};
}

#pragma mark - User interface methods

- (IBAction)signup:(id)sender
{
    
}

- (IBAction)login:(id)sender
{
    
}

- (IBAction)dismiss:(id)sender
{
    
}

#pragma mark - Scrollview delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat alpha = [scrollView contentOffset].x / [[UIScreen mainScreen] bounds].size.width - _index;
    
    NSInteger newIndex = (alpha < 0 ? _index-1 : _index+1);
    NSMutableArray *infoTopImage = [self.informationLabels objectAtIndex:_index];
    NSMutableArray *infoBottomImage = nil;
    if (newIndex < [self.informationLabels count]) {
        infoBottomImage = [self.informationLabels objectAtIndex:newIndex];
    } else {
        infoBottomImage = infoTopImage;
    }

    [self.backDismissButton setTitleColor:[UIColor colorWithHexString:[infoBottomImage valueForKey:@"DismissColor"]] forState:UIControlStateNormal];
    
    
    UIImage *nextImage = [self.backgroundImages objectAtIndex:(newIndex < 0 ? 0 : (newIndex >= [self.backgroundImages count] ? [self.backgroundImages count]-1 : newIndex))];
    
    if (![[self.backgroundBottomImage image] isEqual:nextImage]) {
        [self.backgroundBottomImage setImage:nextImage];
    }
     
    [self.backgroundTopImage setAlpha:1-fabs(alpha)];
    [self.backgroundBottomImage setAlpha:fabs(alpha)];
        
    bool topShowLogo = [[infoTopImage valueForKey:@"ShowLogo"] boolValue];
    bool bottomShowLogo = [[infoBottomImage valueForKey:@"ShowLogo"] boolValue];
    if (topShowLogo) {
        if (!bottomShowLogo) {
            if ([self.logo alpha] != 0.0) {
                [self.logo setAlpha:1-fabs(alpha)];
            }
        }
    } else {
        if (bottomShowLogo) {
            if ([self.logo alpha] != 1.0) {
                [self.logo setAlpha:fabs(alpha)];
            }
        }
    }
    
    
    NSString *topDismissColorString = [infoTopImage valueForKey:@"DismissColor"];
    NSString *bottomDismissColorString = [infoBottomImage valueForKey:@"DismissColor"];
    
    if ([topDismissColorString compare:bottomDismissColorString] != NSOrderedSame) {
        [self.dismissButton setAlpha:1-fabs(alpha)];
        [self.backDismissButton setAlpha:fabs(alpha)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollview.frame.size.width;
    _index = floor((self.scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self.pageController setCurrentPage:_index];
    [self resetBackgroundImageState];
    
    NSMutableArray *infoTopImage = [self.informationLabels objectAtIndex:_index];
    if ([[infoTopImage valueForKeyPath:@"ShowLogo"] boolValue]) {
        [self.logo setAlpha:1.0];
    } else {
        [self.logo setAlpha:0.0];
    }    
    [self.dismissButton setTitleColor:[UIColor colorWithHexString:[infoTopImage valueForKey:@"DismissColor"]] forState:UIControlStateNormal];
    [self.dismissButton setAlpha:1.0];
    [self.backDismissButton setAlpha:0.0]; // Ready for next transition    
}

@end
