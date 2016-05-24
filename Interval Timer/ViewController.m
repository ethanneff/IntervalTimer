//
//  ViewController.m
//  Interval Timer
//
//  Created by Ethan Neff on 9/4/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import "ViewController.h"
#import "Util.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

// frame
@property (nonatomic) UIInterfaceOrientation orientation;

// colors
@property (nonatomic) UIColor *colorBackground;
@property (nonatomic) UIColor *colorPrimary;
@property (nonatomic) UIColor *colorSecondary;
@property (nonatomic) UIColor *colorTertiary;
@property (nonatomic) UIColor *colorRed;
@property (nonatomic) UIColor *colorYellow;
@property (nonatomic) UIColor *colorGreen;

// toggles
@property (nonatomic) bool toggleNotifications;
@property (nonatomic) bool toggleVibrations;
@property (nonatomic) bool toggleSound;
@property (nonatomic) float toggleVolume;


// header and action bar
@property (nonatomic) UIView *headerView;
@property (nonatomic) UIButton *actionButton;
@property (nonatomic) float actionButtonHeight;



// content main
@property (nonatomic) UIView *contentViewMain;

@property (nonatomic) float barHeight;
@property (nonatomic) float barSeparatorHeight;
@property (nonatomic) float barSeparatorBuffer;

// picker bar
@property (nonatomic) UIPickerView *pickerView;
@property (nonatomic) int intervalHours;
@property (nonatomic) int intervalMinutes;
@property (nonatomic) int intervalSeconds;

// button bar
@property (nonatomic) UIButton *buttonStart;
@property (nonatomic) UIButton *buttonPause;

// counter bar
@property (nonatomic) UIView *counterBar;
@property (nonatomic) UILabel *timeToIntervalCounter;

// stats bar
@property (nonatomic) UIView *statsBar;
@property (nonatomic) UILabel *clockCounter;
@property (nonatomic) UILabel *intervalCounter;
@property (nonatomic) UILabel *lastIntervalTime;
@property (nonatomic) UITextField *intervalSpeedTimer;



// content settings
@property (nonatomic) UIView *contentViewSettings;
@property (nonatomic) UITextField *textFieldVolume;



// timer
@property (nonatomic) NSTimer *timer;
@property (nonatomic) double timerInterval;
@property (nonatomic) double timerElapsed;
@property (nonatomic) NSDate *timerStarted;
@property (nonatomic) int totalSeconds;
@property (nonatomic) int totalIntervals;



// audio
@property (nonatomic) NSMutableArray *audioPlayers;
@property (nonatomic) AVAudioPlayer *audio;
@property (nonatomic) UIScrollView *containerView;
@property (nonatomic) UITextField *activeField;
@property (nonatomic) UILocalNotification *badgeNotification;


@end

@implementation ViewController

- (void)initalizeVariables {
    // frame
    self.orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0 invocation:nil repeats:NO];
    self.totalSeconds = 0;
    self.totalIntervals = 0;
    self.timerInterval = 1;
    self.timerElapsed = 0;
    self.intervalHours = 0;
    self.intervalMinutes = 1;
    self.intervalSeconds = 45;
    
    // toggles
    self.toggleNotifications = true;
    self.toggleVibrations = false;
    self.toggleSound = true;
    self.toggleVolume = 20.0;
    
    // notifications
    self.badgeNotification = [[UILocalNotification alloc] init];
    
    // scene
    self.actionButtonHeight = 40.0f;
    self.barHeight = 50.0f;
    self.barSeparatorHeight = 2.0f;
    self.barSeparatorBuffer = 10.0f;
    
    // colors
    self.colorBackground = [UIColor whiteColor];
    self.colorPrimary = [UIColor colorWithRed:0/255.0f green:120/255.0f blue:188/255.0f alpha:1.0f];
    self.colorSecondary = [UIColor blackColor];
    self.colorTertiary = [UIColor lightGrayColor];
    self.colorRed = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f];
    self.colorYellow = [UIColor colorWithRed:241/255.0f green:196/255.0f blue:15/255.0f alpha:1.0f];
    self.colorGreen = [UIColor colorWithRed:46/255.0f green:204/255.0f blue:113/255.0f alpha:1.0f];
    
    // sounds
    self.audio = [[AVAudioPlayer alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // set up audio sounds
        self.audioPlayers = [[NSMutableArray alloc] init];
        NSArray *soundNames = @[@"count0", @"count1", @"count2", @"count3", @"count4", @"count5", @"hour0min05", @"hour0min10", @"hour0min15", @"hour0min20", @"hour0min25", @"hour0min30", @"hour0min35", @"hour0min40", @"hour0min45", @"hour0min50", @"hour0min55", @"hour1min00", @"hour1min05", @"hour1min10", @"hour1min15", @"hour1min20", @"hour1min25", @"hour1min30", @"hour1min35", @"hour1min40", @"hour1min45", @"hour1min50", @"hour1min55", @"hour2min00", @"hour2min05", @"hour2min10", @"hour2min15", @"hour2min20", @"hour2min25", @"hour2min30", @"hour2min35", @"hour2min40", @"hour2min45", @"hour2min50", @"hour2min55", @"hour3min00", @"hour3min05", @"hour3min10", @"hour3min15", @"hour3min20", @"hour3min25", @"hour3min30", @"hour3min35", @"hour3min40", @"hour3min45", @"hour3min50", @"hour3min55", @"hour4min00", @"hour4min05", @"hour4min10", @"hour4min15", @"hour4min20", @"hour4min25", @"hour4min30", @"hour4min35", @"hour4min40", @"hour4min45", @"hour4min50", @"hour4min55", @"hour5min00", @"hour5min05", @"hour5min10", @"hour5min15", @"hour5min20", @"hour5min25", @"hour5min30", @"hour5min35", @"hour5min40", @"hour5min45", @"hour5min50", @"hour5min55", @"hour6min00",
                                @"started", @"stopped", @"paused", @"resumed"];
        for (NSString *soundName in soundNames) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:soundName withExtension:@".mp3"];
            AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [audioPlayer prepareToPlay];
            [self.audioPlayers addObject:audioPlayer];
        }
        
        // setup background audio sound
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *error = nil;
        if (![audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error]) {
            NSLog(@"Unable to set audio session category: %@", error); // util show error
        }
        BOOL result = [audioSession setActive:YES error:&error];
        if (!result) {
            NSLog(@"Error activating audio session: %@", error);
        }
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    });
}

- (void)viewDidLoad {
    NSLog(@"view did load");
    [super viewDidLoad];
    
    // initalize view
    [self.view setBackgroundColor:self.colorBackground];
    
    // status bar color
    [self setNeedsStatusBarAppearanceUpdate];
    
    // initalize properties
    [self initalizeVariables];
    
    // allow notifications
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
    // allow timer in background
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // allow keyboard
    [self setupKeyboardHandling];
    
    // create view
    [self createViews];
}

- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription *desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    // status bar color
    return UIStatusBarStyleLightContent;
}

#pragma mark - portrait to landscape orientation
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
    
    // create everything basesd on orientation change
    if ([UIApplication sharedApplication].statusBarOrientation != self.orientation) {
        [self createViews];
    }
    self.orientation = [UIApplication sharedApplication].statusBarOrientation;
    
}

-(CGRect)currentScreenBoundsDependOnOrientation {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat width = CGRectGetWidth(screenBounds);
    CGFloat height = CGRectGetHeight(screenBounds);
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        screenBounds.size = CGSizeMake(width, height);
    }else if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        screenBounds.size = CGSizeMake(width, height);
    }
    return screenBounds;
}



#pragma mark - create views
-(void)createViews {
    NSLog(@"create view");
    
    // remove previous views
    [[self.view viewWithTag:10] removeFromSuperview];
    
    // main container scrollview (for keyboard scrolling)
    self.containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [self currentScreenBoundsDependOnOrientation].size.width, [self currentScreenBoundsDependOnOrientation].size.height)];
    self.containerView.tag = 10;
    
    [self createHeader];
    [self createActionButton];
    [self createContentMain];
    [self createContentSettings];
    
    [self.containerView addSubview:self.headerView];
    [self.containerView addSubview:self.contentViewMain];
    [self.containerView addSubview:self.contentViewSettings];
    [self.containerView addSubview:self.actionButton]; // goes last to be above everything else
    
    self.containerView.contentSize = CGSizeMake([self currentScreenBoundsDependOnOrientation].size.width,self.statsBar.frame.origin.y + self.statsBar.frame.size.height);
    
    [self.view addSubview:self.containerView];
}

-(void)createDropShadowWithView:(UIView *)view zPosition:(int)zPosition {
    view.layer.zPosition = zPosition;
    view.layer.shadowOffset = CGSizeMake(0, zPosition/2.5f);
    view.layer.shadowColor = [self.colorSecondary CGColor];
    view.layer.shadowRadius = zPosition/1.5f;
    view.layer.shadowOpacity = 0.5f;
    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.layer.bounds] CGPath];
}

-(void)createHeader {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self currentScreenBoundsDependOnOrientation].size.width, 70)];
    self.headerView.backgroundColor = self.colorPrimary;
    [self createDropShadowWithView:self.headerView zPosition:4];
    
    UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self currentScreenBoundsDependOnOrientation].size.width, 20)];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, statusBar.frame.origin.y + statusBar.frame.size.height , [self currentScreenBoundsDependOnOrientation].size.width, self.barHeight)];
    [labelTitle setText:@"Workout Interval Timer"];
    [labelTitle setTextColor:self.colorBackground];
    [labelTitle setFont:[UIFont boldSystemFontOfSize:20.0]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    labelTitle.layer.zPosition = self.headerView.layer.zPosition;
    
    [self.headerView addSubview:labelTitle];
}

-(void)createActionButton {
    // settings button
    self.actionButton = [[UIButton alloc]  initWithFrame:CGRectMake([self currentScreenBoundsDependOnOrientation].size.width-self.barHeight, self.headerView.frame.origin.y+self.headerView.frame.size.height-self.actionButtonHeight/2, self.actionButtonHeight, self.actionButtonHeight)];
    [self.actionButton setTag:23];
    [self.actionButton setBackgroundColor:self.colorBackground];
    self.actionButton.layer.cornerRadius = self.actionButtonHeight/2;
    self.actionButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.actionButton setImage:[UIImage imageNamed:@"settingsBlue"] forState:UIControlStateNormal];
    [self.actionButton setImage:[UIImage imageNamed:@"settingsBlack"] forState:UIControlStateHighlighted];
    [self.actionButton setImage:[UIImage imageNamed:@"settingsBlack"] forState:UIControlStateSelected];
    [self.actionButton addTarget:self action:@selector(buttonTap:) forControlEvents: UIControlEventTouchUpInside];
    [self.actionButton addTarget:self action:@selector(buttonHold:) forControlEvents: UIControlEventTouchDown];
    [self createDropShadowWithView:self.actionButton zPosition:10];
    self.actionButton.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.actionButton.bounds cornerRadius:self.actionButtonHeight/2].CGPath;
}

-(void)createContentMain {
    self.contentViewMain = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self currentScreenBoundsDependOnOrientation].size.width, [self currentScreenBoundsDependOnOrientation].size.height)];
    self.contentViewMain.backgroundColor = self.colorBackground;
    [self createDropShadowWithView:self.buttonStart zPosition:2];
    
    [self createContentMainPickerBar];
    [self createContentMainStartButton];
    [self createContentMainPauseButton];
    [self createContentMainCounterBar];
    [self createContentMainStatsBar];
    
    [self.contentViewMain addSubview:self.pickerView];
    [self.contentViewMain addSubview:self.buttonStart];
    [self.contentViewMain addSubview:self.buttonPause];
    [self.contentViewMain addSubview:self.counterBar];
    [self.contentViewMain addSubview:self.statsBar];
}

-(void)createContentMainPickerBar {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height + self.headerView.frame.origin.y, [self currentScreenBoundsDependOnOrientation].size.width, 200)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.pickerView selectRow:self.intervalHours inComponent:0 animated:NO];
    [self.pickerView selectRow:self.intervalMinutes inComponent:1 animated:NO];
    [self.pickerView selectRow:self.intervalSeconds inComponent:2 animated:NO];
    
    UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, self.pickerView.frame.size.height / 2 - 15, 75, 30)];
    hourLabel.text = @"hour";
    
    UILabel *minsLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 + (self.pickerView.frame.size.width / 3), self.pickerView.frame.size.height / 2 - 15, 75, 30)];
    minsLabel.text = @"min";
    
    UILabel *secsLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 + ((self.pickerView.frame.size.width / 3) * 2), self.pickerView.frame.size.height / 2 - 15, 75, 30)];
    secsLabel.text = @"sec";
    
    [self.pickerView addSubview:hourLabel];
    [self.pickerView addSubview:minsLabel];
    [self.pickerView addSubview:secsLabel];
}

-(void)createContentMainStartButton {
    self.buttonStart = [[UIButton alloc] initWithFrame:CGRectMake(10, self.pickerView.frame.origin.y + self.pickerView.frame.size.height, [self currentScreenBoundsDependOnOrientation].size.width/2 - 15 , self.barHeight)];
    self.buttonStart.tag = 21;
    [self.buttonStart setBackgroundColor:self.colorPrimary];
    self.buttonStart.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self.buttonStart setTitle:@"Start" forState:UIControlStateNormal];
    [self.buttonStart setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.buttonStart setTitle:@"Stop" forState:UIControlStateSelected];
    [self.buttonStart setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.buttonStart addTarget:self action:@selector(buttonTap:) forControlEvents: UIControlEventTouchUpInside];
    [self.buttonStart addTarget:self action:@selector(buttonHold:) forControlEvents: UIControlEventTouchDown];
    [self createDropShadowWithView:self.buttonStart zPosition:4];
}

-(void)createContentMainPauseButton {
    self.buttonPause = [[UIButton alloc] initWithFrame:CGRectMake([self currentScreenBoundsDependOnOrientation].size.width/2 + 5, self.pickerView.frame.origin.y + self.pickerView.frame.size.height, [self currentScreenBoundsDependOnOrientation].size.width/2 - 15, self.barHeight)];
    self.buttonPause.tag = 22;
    [self.buttonPause setEnabled:false];
    [self.buttonPause setBackgroundColor:self.colorPrimary];
    self.buttonPause.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self.buttonPause setTitle:@"Pause" forState:UIControlStateNormal];
    [self.buttonPause setTitleColor:self.colorTertiary forState:UIControlStateNormal];
    [self.buttonPause setTitle:@"Resume" forState:UIControlStateSelected];
    [self.buttonPause addTarget:self action:@selector(buttonTap:) forControlEvents: UIControlEventTouchUpInside];
    [self.buttonPause addTarget:self action:@selector(buttonHold:) forControlEvents: UIControlEventTouchDown];
    [self createDropShadowWithView:self.buttonPause zPosition:4];
}

-(void)createContentMainCounterBar {
    self.counterBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.buttonStart.frame.origin.y + self.buttonStart.frame.size.height, [self currentScreenBoundsDependOnOrientation].size.width, self.barHeight)];
    
    UILabel *labelTimeLeftTimer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self currentScreenBoundsDependOnOrientation].size.width, self.counterBar.frame.size.height)];
    [labelTimeLeftTimer setText:@""];
    [labelTimeLeftTimer setTextColor:self.colorTertiary];
    [labelTimeLeftTimer setFont:[UIFont boldSystemFontOfSize:32.0]];
    [labelTimeLeftTimer setTextAlignment:NSTextAlignmentCenter];
    self.timeToIntervalCounter = labelTimeLeftTimer;
    
    [self.counterBar addSubview:labelTimeLeftTimer];
}

-(void)createContentMainStatsBar {
    // stats bar
    self.statsBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.counterBar.frame.origin.y + self.counterBar.frame.size.height, [self currentScreenBoundsDependOnOrientation].size.width, self.barHeight*2 + self.barSeparatorHeight)];
    self.statsBar.backgroundColor = self.colorPrimary;;
    [self createDropShadowWithView:self.statsBar zPosition:4];
    
    //total time
    UILabel *labelTimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ([self currentScreenBoundsDependOnOrientation].size.width-self.barSeparatorHeight)/2, self.barHeight/2)];
    [labelTimeTitle setText:@"Total Time"];
    //    labelTimeTitle.attributedText = [[NSAttributedString alloc] initWithString:@"Total Time" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    [labelTimeTitle setTextColor:self.colorBackground];
    [labelTimeTitle setFont:[UIFont boldSystemFontOfSize:18.0]];
    [labelTimeTitle setTextAlignment:NSTextAlignmentCenter];
    labelTimeTitle.layer.zPosition = self.statsBar.layer.zPosition;
    
    self.clockCounter = [[UILabel alloc] initWithFrame:CGRectMake(0, self.barHeight/2, ([self currentScreenBoundsDependOnOrientation].size.width-self.barSeparatorHeight)/2, self.barHeight/2)];
    [self.clockCounter setText:@"00:00:00"];
    [self.clockCounter setTextColor:self.colorBackground];
    [self.clockCounter setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.clockCounter setTextAlignment:NSTextAlignmentCenter];
    self.clockCounter.layer.zPosition = self.statsBar.layer.zPosition;
    
    // top line
    UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(labelTimeTitle.frame.origin.x + labelTimeTitle.frame.size.width, self.barSeparatorBuffer, self.barSeparatorHeight, self.barHeight-self.self.barSeparatorBuffer*2)];
    [topSeparator setBackgroundColor:[self.colorBackground colorWithAlphaComponent:0.5]];
    topSeparator.layer.zPosition = self.statsBar.layer.zPosition;
    
    // total intervals
    UILabel *labelIntervalTitle = [[UILabel alloc] initWithFrame:CGRectMake(topSeparator.frame.origin.x + topSeparator.frame.size.width, 0, ([self currentScreenBoundsDependOnOrientation].size.width-self.barSeparatorHeight)/2, self.barHeight/2)];
    //    labelIntervalTitle.attributedText = [[NSAttributedString alloc] initWithString:@"Total Intervals" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    [labelIntervalTitle setText:@"Total Intervals"];
    [labelIntervalTitle setTextColor:self.colorBackground];
    [labelIntervalTitle setFont:[UIFont boldSystemFontOfSize:18.0]];
    [labelIntervalTitle setTextAlignment:NSTextAlignmentCenter];
    labelIntervalTitle.layer.zPosition = self.statsBar.layer.zPosition;
    
    self.intervalCounter = [[UILabel alloc] initWithFrame:CGRectMake(topSeparator.frame.origin.x + topSeparator.frame.size.width, self.barHeight/2, ([self currentScreenBoundsDependOnOrientation].size.width-self.barSeparatorHeight)/2, self.barHeight/2)];
    [self.intervalCounter setText:@"0"];
    [self.intervalCounter setTextColor:self.colorBackground];
    [self.intervalCounter setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.intervalCounter setTextAlignment:NSTextAlignmentCenter];
    self.intervalCounter.layer.zPosition = self.statsBar.layer.zPosition;
    
    // left line
    UIView *leftSeparator = [[UIView alloc] initWithFrame:CGRectMake(self.barSeparatorBuffer, self.barHeight, ([self currentScreenBoundsDependOnOrientation].size.width-self.barSeparatorHeight)/2-(self.barSeparatorBuffer*2), self.barSeparatorHeight)];
    [leftSeparator setBackgroundColor:[self.colorBackground colorWithAlphaComponent:0.5]];
    leftSeparator.layer.zPosition = self.statsBar.layer.zPosition;
    
    // right line
    UIView *rightSeparator = [[UIView alloc] initWithFrame:CGRectMake(topSeparator.frame.origin.x + topSeparator.frame.size.width+self.barSeparatorBuffer, self.barHeight, ([self currentScreenBoundsDependOnOrientation].size.width-self.barSeparatorHeight)/2-(self.barSeparatorBuffer*2), self.barSeparatorHeight)];
    [rightSeparator setBackgroundColor:[self.colorBackground colorWithAlphaComponent:0.5]];
    rightSeparator.layer.zPosition = self.statsBar.layer.zPosition;
    
    // last interval time
    UILabel *labelLastInterval = [[UILabel alloc] initWithFrame:CGRectMake(0, leftSeparator.frame.size.height + leftSeparator.frame.origin.y, ([self currentScreenBoundsDependOnOrientation].size.width-self.barSeparatorHeight)/2, self.barHeight/2)];
    //    labelLastInterval.attributedText = [[NSAttributedString alloc] initWithString:@"Last Interval Time" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    [labelLastInterval setText:@"Last Interval Time"];
    [labelLastInterval setTextColor:self.colorBackground];
    [labelLastInterval setFont:[UIFont boldSystemFontOfSize:18.0]];
    [labelLastInterval setTextAlignment:NSTextAlignmentCenter];
    labelLastInterval.layer.zPosition = self.statsBar.layer.zPosition;
    
    self.lastIntervalTime = [[UILabel alloc] initWithFrame:CGRectMake(0, leftSeparator.frame.size.height + leftSeparator.frame.origin.y + self.barHeight/2, ([self currentScreenBoundsDependOnOrientation].size.width-self.barSeparatorHeight)/2, self.barHeight/2)];
    [self.lastIntervalTime setText:@"00:00:00"];
    [self.lastIntervalTime setTextColor:self.colorBackground];
    [self.lastIntervalTime setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.lastIntervalTime setTextAlignment:NSTextAlignmentCenter];
    self.lastIntervalTime.layer.zPosition = self.statsBar.layer.zPosition;
    
    // bottom line
    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(labelTimeTitle.frame.origin.x + labelTimeTitle.frame.size.width, leftSeparator.frame.size.height + leftSeparator.frame.origin.y + self.barSeparatorBuffer, self.barSeparatorHeight, self.barHeight-self.barSeparatorBuffer*2)];
    [bottomSeparator setBackgroundColor:[self.colorBackground colorWithAlphaComponent:0.5]];
    bottomSeparator.layer.zPosition = self.statsBar.layer.zPosition;
    
    // interval speed
    UILabel *labelIntervalSpeed = [[UILabel alloc] initWithFrame:CGRectMake(bottomSeparator.frame.origin.x + bottomSeparator.frame.size.width, rightSeparator.frame.size.height + rightSeparator.frame.origin.y, ([self currentScreenBoundsDependOnOrientation].size.width-self.barSeparatorHeight)/2, self.barHeight/2)];
    //    labelIntervalSpeed.attributedText = [[NSAttributedString alloc] initWithString:@"Interval Speed" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    [labelIntervalSpeed setText:@"Interval Speed"];
    [labelIntervalSpeed setTextColor:self.colorBackground];
    [labelIntervalSpeed setFont:[UIFont boldSystemFontOfSize:18.0]];
    [labelIntervalSpeed setTextAlignment:NSTextAlignmentCenter];
    labelIntervalSpeed.layer.zPosition = self.statsBar.layer.zPosition;
    
    self.intervalSpeedTimer = [[UITextField alloc] initWithFrame:CGRectMake(topSeparator.frame.origin.x + topSeparator.frame.size.width, rightSeparator.frame.size.height + rightSeparator.frame.origin.y + self.barHeight/2, ([self currentScreenBoundsDependOnOrientation].size.width-self.barSeparatorHeight)/2, self.barHeight/2)];
    [self.intervalSpeedTimer setTag:25];
    [self.intervalSpeedTimer setText:[NSString stringWithFormat:@"%.02f",self.timerInterval]];
    [self.intervalSpeedTimer setTextColor:self.colorSecondary];
    [self.intervalSpeedTimer setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.intervalSpeedTimer setTextAlignment:NSTextAlignmentCenter];
    self.intervalSpeedTimer.keyboardType = UIKeyboardTypeDecimalPad;
    self.intervalSpeedTimer.delegate = self; // call to textFieldDidBeginEditing when activated
    self.intervalSpeedTimer.layer.zPosition = self.statsBar.layer.zPosition;
    
    [self.statsBar addSubview:labelTimeTitle];
    [self.statsBar addSubview:self.clockCounter];
    [self.statsBar addSubview:topSeparator];
    [self.statsBar addSubview:labelIntervalTitle];
    [self.statsBar addSubview:self.intervalCounter];
    
    [self.statsBar addSubview:leftSeparator];
    [self.statsBar addSubview:rightSeparator];
    
    [self.statsBar addSubview:labelLastInterval];
    [self.statsBar addSubview:self.lastIntervalTime];
    [self.statsBar addSubview:bottomSeparator];
    [self.statsBar addSubview:labelIntervalSpeed];
    [self.statsBar addSubview:self.intervalSpeedTimer];
}

-(void)createContentSettings {
    self.contentViewSettings = [[UIView alloc] initWithFrame:CGRectMake(0, [self currentScreenBoundsDependOnOrientation].size.height, [self currentScreenBoundsDependOnOrientation].size.width, [self currentScreenBoundsDependOnOrientation].size.height-70)];
    self.contentViewSettings.backgroundColor = self.colorBackground;
    [self createDropShadowWithView:self.contentViewSettings zPosition:2];
    
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(settingsSwipeDown)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    UIView *settingsGroup = [[UIView alloc] initWithFrame:CGRectMake(0, self.barHeight*2, [self currentScreenBoundsDependOnOrientation].size.width, (self.barHeight+self.barSeparatorHeight)*4 - self.barSeparatorHeight)];
    settingsGroup.backgroundColor = self.colorPrimary;
    [self createDropShadowWithView:settingsGroup zPosition:4];
    
    
    NSMutableAttributedString *stringOnNotifications = [[NSMutableAttributedString alloc] initWithString:@"Notifications On"];
    [stringOnNotifications addAttribute:NSFontAttributeName
                                  value:[UIFont boldSystemFontOfSize:18.0]
                                  range:NSMakeRange(0, stringOnNotifications.length)];
    [stringOnNotifications addAttribute:NSForegroundColorAttributeName
                                  value:self.colorBackground
                                  range:NSMakeRange(0, stringOnNotifications.length)];
    [stringOnNotifications addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor greenColor]
                                  range:NSMakeRange(stringOnNotifications.length-2,2)];
    
    
    NSMutableAttributedString *stringOffNotifications = [[NSMutableAttributedString alloc] initWithString:@"Notifications Off"];
    [stringOffNotifications addAttribute:NSFontAttributeName
                                   value:[UIFont boldSystemFontOfSize:18.0]
                                   range:NSMakeRange(0, stringOffNotifications.length)];
    [stringOffNotifications addAttribute:NSForegroundColorAttributeName
                                   value:self.colorBackground
                                   range:NSMakeRange(0, stringOffNotifications.length)];
    [stringOffNotifications addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor redColor]
                                   range:NSMakeRange(stringOffNotifications.length-3,3)];
    
    UIButton *buttonNotifications = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [self currentScreenBoundsDependOnOrientation].size.width, self.barHeight)];
    [buttonNotifications setTag:11];
    [buttonNotifications setAttributedTitle:stringOnNotifications forState:UIControlStateNormal];
    [buttonNotifications setAttributedTitle:stringOffNotifications forState:UIControlStateSelected];
    [buttonNotifications addTarget:self action:@selector(buttonTap:) forControlEvents: UIControlEventTouchUpInside];
    [buttonNotifications addTarget:self action:@selector(buttonHold:) forControlEvents: UIControlEventTouchDown];
    buttonNotifications.layer.zPosition = settingsGroup.layer.zPosition;
    (!self.toggleNotifications) ? [buttonNotifications setSelected:true] : [buttonNotifications setSelected:false];
    
    UIView *lineNotifications = [[UIView alloc] initWithFrame:CGRectMake(self.barSeparatorBuffer, buttonNotifications.frame.origin.y + buttonNotifications.frame.size.height, [self currentScreenBoundsDependOnOrientation].size.width-self.barSeparatorBuffer*2, self.barSeparatorHeight)];
    [lineNotifications setBackgroundColor:[self.colorBackground colorWithAlphaComponent:0.5]];
    lineNotifications.layer.zPosition = settingsGroup.layer.zPosition;
    
    NSMutableAttributedString *stringOnVibrations = [[NSMutableAttributedString alloc] initWithString:@"Vibrations On"];
    [stringOnVibrations addAttribute:NSFontAttributeName
                               value:[UIFont boldSystemFontOfSize:18.0]
                               range:NSMakeRange(0, stringOnVibrations.length)];
    [stringOnVibrations addAttribute:NSForegroundColorAttributeName
                               value:self.colorBackground
                               range:NSMakeRange(0, stringOnVibrations.length)];
    [stringOnVibrations addAttribute:NSForegroundColorAttributeName
                               value:[UIColor greenColor]
                               range:NSMakeRange(stringOnVibrations.length-2,2)];
    
    
    NSMutableAttributedString *stringOffVibrations = [[NSMutableAttributedString alloc] initWithString:@"Vibrations Off"];
    [stringOffVibrations addAttribute:NSFontAttributeName
                                value:[UIFont boldSystemFontOfSize:18.0]
                                range:NSMakeRange(0, stringOffVibrations.length)];
    [stringOffVibrations addAttribute:NSForegroundColorAttributeName
                                value:self.colorBackground
                                range:NSMakeRange(0, stringOffVibrations.length)];
    [stringOffVibrations addAttribute:NSForegroundColorAttributeName
                                value:[UIColor redColor]
                                range:NSMakeRange(stringOffVibrations.length-3,3)];
    
    
    UIButton *buttonVibrations = [[UIButton alloc] initWithFrame:CGRectMake(0, lineNotifications.frame.origin.y + lineNotifications.frame.size.height, [self currentScreenBoundsDependOnOrientation].size.width, self.barHeight)];
    [buttonVibrations setTag:12];
    [buttonVibrations setAttributedTitle:stringOnVibrations forState:UIControlStateNormal];
    [buttonVibrations setAttributedTitle:stringOffVibrations forState:UIControlStateSelected];
    [buttonVibrations addTarget:self action:@selector(buttonTap:) forControlEvents: UIControlEventTouchUpInside];
    [buttonVibrations addTarget:self action:@selector(buttonHold:) forControlEvents: UIControlEventTouchDown];
    buttonVibrations.layer.zPosition = settingsGroup.layer.zPosition;
    (!self.toggleVibrations) ? [buttonVibrations setSelected:true] : [buttonVibrations setSelected:false];
    
    UIView *lineVibrations = [[UIView alloc] initWithFrame:CGRectMake(self.barSeparatorBuffer, buttonVibrations.frame.origin.y + buttonVibrations.frame.size.height, [self currentScreenBoundsDependOnOrientation].size.width-self.barSeparatorBuffer*2, self.barSeparatorHeight)];
    [lineVibrations setBackgroundColor:[self.colorBackground colorWithAlphaComponent:0.5]];
    lineVibrations.layer.zPosition = settingsGroup.layer.zPosition;
    
    NSMutableAttributedString *stringOnSounds = [[NSMutableAttributedString alloc] initWithString:@"Sounds On"];
    [stringOnSounds addAttribute:NSFontAttributeName
                           value:[UIFont boldSystemFontOfSize:18.0]
                           range:NSMakeRange(0, stringOnSounds.length)];
    [stringOnSounds addAttribute:NSForegroundColorAttributeName
                           value:self.colorBackground
                           range:NSMakeRange(0, stringOnSounds.length)];
    [stringOnSounds addAttribute:NSForegroundColorAttributeName
                           value:[UIColor greenColor]
                           range:NSMakeRange(stringOnSounds.length-2,2)];
    
    
    NSMutableAttributedString *stringOffSounds = [[NSMutableAttributedString alloc] initWithString:@"Sounds Off"];
    [stringOffSounds addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:18.0]
                            range:NSMakeRange(0, stringOffSounds.length)];
    [stringOffSounds addAttribute:NSForegroundColorAttributeName
                            value:self.colorBackground
                            range:NSMakeRange(0, stringOffSounds.length)];
    [stringOffSounds addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor]
                            range:NSMakeRange(stringOffSounds.length-3,3)];
    
    
    UIButton *buttonSound = [[UIButton alloc] initWithFrame:CGRectMake(0, lineVibrations.frame.origin.y + lineVibrations.frame.size.height, [self currentScreenBoundsDependOnOrientation].size.width, self.barHeight)];
    [buttonSound setTag:13];
    [buttonSound setAttributedTitle:stringOnSounds forState:UIControlStateNormal];
    [buttonSound setAttributedTitle:stringOffSounds forState:UIControlStateSelected];
    [buttonSound addTarget:self action:@selector(buttonTap:) forControlEvents: UIControlEventTouchUpInside];
    [buttonSound addTarget:self action:@selector(buttonHold:) forControlEvents: UIControlEventTouchDown];
    buttonSound.layer.zPosition = settingsGroup.layer.zPosition;
    (!self.toggleSound) ? [buttonSound setSelected:true] : [buttonSound setSelected:false];
    
    UIView *lineSound = [[UIView alloc] initWithFrame:CGRectMake(self.barSeparatorBuffer, buttonSound.frame.origin.y + buttonSound.frame.size.height, [self currentScreenBoundsDependOnOrientation].size.width-self.barSeparatorBuffer*2, self.barSeparatorHeight)];
    [lineSound setBackgroundColor:[self.colorBackground colorWithAlphaComponent:0.5]];
    lineSound.layer.zPosition = settingsGroup.layer.zPosition;
    
    
    NSMutableAttributedString *stringVolume = [[NSMutableAttributedString alloc] initWithString:@"Volume 00"];
    [stringVolume addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:18.0]
                            range:NSMakeRange(0, stringVolume.length)];
    [stringVolume addAttribute:NSForegroundColorAttributeName
                         value:self.colorBackground
                         range:NSMakeRange(0, stringVolume.length)];
    [stringVolume addAttribute:NSForegroundColorAttributeName
                            value:self.colorPrimary
                            range:NSMakeRange(stringVolume.length-3, 3)];
    
    UILabel *labelVolume = [[UILabel alloc] initWithFrame:CGRectMake(0, lineSound.frame.origin.y + lineSound.frame.size.height, [self currentScreenBoundsDependOnOrientation].size.width, self.barHeight)];
    [labelVolume setAttributedText:stringVolume];
    [labelVolume setTextAlignment:NSTextAlignmentCenter];
    labelVolume.layer.zPosition = settingsGroup.layer.zPosition;
    
    self.textFieldVolume = [[UITextField alloc] initWithFrame:CGRectMake([self currentScreenBoundsDependOnOrientation].size.width*1.14/2,lineSound.frame.origin.y + lineSound.frame.size.height, self.barHeight, self.barHeight)];
    [self.textFieldVolume setTag:14];
    [self.textFieldVolume setText:[NSString stringWithFormat:@"%00.f",self.toggleVolume]];
    [self.textFieldVolume setTextColor:self.colorSecondary];
    [self.textFieldVolume setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.textFieldVolume setTextAlignment:NSTextAlignmentLeft];
    self.textFieldVolume.keyboardType = UIKeyboardTypeDecimalPad;
    self.textFieldVolume.delegate = self; // call to textFieldDidBeginEditing when activated
    self.textFieldVolume.layer.zPosition = settingsGroup.layer.zPosition;
    [self.textFieldVolume setEnabled: (!self.toggleSound) ? false : true];
    [self.textFieldVolume setTextColor: (!self.toggleSound) ? self.colorTertiary : self.colorSecondary];

    [settingsGroup addSubview:buttonNotifications];
    [settingsGroup addSubview:lineNotifications];
    [settingsGroup addSubview:buttonVibrations];
    [settingsGroup addSubview:lineVibrations];
    [settingsGroup addSubview:buttonSound];
    [settingsGroup addSubview:lineSound];
    [settingsGroup addSubview:labelVolume];
    [settingsGroup addSubview:self.textFieldVolume];
    
    [self.contentViewSettings addGestureRecognizer:swipeDownGestureRecognizer];
    [self.contentViewSettings addSubview:settingsGroup];
    
}

-(void)settingsSwipeDown {
    [self buttonHold:self.actionButton];
    [self buttonTap:self.actionButton];
}


#pragma mark - Button Handling
-(void)buttonHold:(UIButton *)button { // called before buttonTap
    // set button selection
    button.selected = !button.selected;
    
    // set z position
    [self ascendAndDescendButton:button];
}

-(void)ascendAndDescendButton:(UIButton *)button {
    // level 1 buttons
    if (button.tag == 21 || button.tag == 22) {
        button.layer.zPosition = (button.selected) ? 10 : 4;
        [self createDropShadowWithView:button zPosition:button.layer.zPosition];
    }
    // level 2 buttons (settings)
    else if (button.tag == 23) {
        button.layer.zPosition = (button.selected) ? 16 : 10;
        [self createDropShadowWithView:button zPosition:button.layer.zPosition];
        button.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds cornerRadius:self.actionButtonHeight/2].CGPath;
    }
}

-(void)buttonTap:(UIButton *)button{
    // if toggle
    if (button.tag == 11) {
        self.toggleNotifications = (button.selected) ? false : true;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        return;
    }
    
    if (button.tag == 12) {
        self.toggleVibrations = (button.selected) ? false : true;
        return;
    }

    if (button.tag == 13) {
        self.toggleSound = (button.selected) ? false : true;
        [self.textFieldVolume setEnabled: (button.selected) ? false : true];
        [self.textFieldVolume setTextColor: (button.selected) ? self.colorTertiary : self.colorSecondary];
        return;
    }
    
    // if settings, show
    if (button.tag == 23) {
        [UIView beginAnimations:@"moveSettingsView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        if (button.isSelected) {
            self.contentViewSettings.frame = CGRectMake(0, self.headerView.frame.size.height, self.contentViewSettings.frame.size.width, self.contentViewSettings.frame.size.height);
        } else {
            self.contentViewSettings.frame = CGRectMake(0, [self currentScreenBoundsDependOnOrientation].size.height, self.contentViewSettings.frame.size.width, self.contentViewSettings.frame.size.height);
        }
        [UIView commitAnimations];
        return;
    }
    
    // timer reactions to button
    if ([button.titleLabel.text isEqual:@"Start"] && button.isSelected == YES) {
        // start
        UIButton *pausedButton = (UIButton *)[[[self.view viewWithTag:10] viewWithTag:20] viewWithTag:22];
        [pausedButton setSelected:NO];
        for (int j = 0; j < self.audioPlayers.count; j++) {
            self.audio = [self.audioPlayers objectAtIndex:j];
            [self.audio setVolume:self.toggleVolume];
            if ([self.audio.url.filePathURL.lastPathComponent.stringByDeletingPathExtension isEqualToString:@"started"]) {
                if (self.toggleSound)
                    [self.audio play];
                break;
            }
        }
        [self.buttonPause setEnabled:true];
        [self.buttonPause setTitleColor:self.colorSecondary forState:UIControlStateNormal];
        [self runTimer];
        // stop
    } else if ([button.titleLabel.text isEqual:@"Start"] && button.isSelected == NO) {
        for (int j = 0; j < self.audioPlayers.count; j++) {
            self.audio = [self.audioPlayers objectAtIndex:j];
            [self.audio setVolume:self.toggleVolume];
            if ([self.audio.url.filePathURL.lastPathComponent.stringByDeletingPathExtension isEqualToString:@"stopped"]) {
                if (self.toggleSound)
                    [self.audio play];
                break;
            }
        }
        [self.buttonPause setEnabled:false];
        [self.buttonPause setSelected:false];
        [self.buttonPause setTitleColor:self.colorTertiary forState:UIControlStateNormal];
        
        [self stopTimer];
        // pause
    } else if ([button.titleLabel.text isEqual:@"Pause"] && button.isSelected == YES) {
        [self.timeToIntervalCounter setTextColor:self.colorYellow];
        [self.buttonPause setTitleColor:self.colorSecondary forState:UIControlStateNormal];
        for (int j = 0; j < self.audioPlayers.count; j++) {
            self.audio = [self.audioPlayers objectAtIndex:j];
            [self.audio setVolume:self.toggleVolume];
            if ([self.audio.url.filePathURL.lastPathComponent.stringByDeletingPathExtension isEqualToString:@"paused"]) {
                if (self.toggleSound)
                    [self.audio play];
                break;
            }
        }
        [self pauseTimer];
        // stop
    } else if ([button.titleLabel.text isEqual:@"Pause"] && button.isSelected == NO) {
        [self.buttonPause setTitleColor:self.colorSecondary forState:UIControlStateNormal];
        for (int j = 0; j < self.audioPlayers.count; j++) {
            self.audio = [self.audioPlayers objectAtIndex:j];
            [self.audio setVolume:self.toggleVolume];
            if ([self.audio.url.filePathURL.lastPathComponent.stringByDeletingPathExtension isEqualToString:@"resumed"]) {
                if (self.toggleSound)
                    [self.audio play];
                break;
            }
        }
        [self runTimer];
    }
}




#pragma mark - Vibrate
- (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}





#pragma mark - Timer
-(void)startTimer {
    // run timer in background of iphone for 1 interval length (needed to allow for pausing)
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(self.timerInterval - self.timerElapsed) target:self selector:@selector(runTimer) userInfo:nil repeats:NO];
    self.timerStarted = [NSDate date];
}

-(void)pauseTimer {
    [self.timer invalidate];
    self.timer = nil;
    self.timerElapsed = [[NSDate date] timeIntervalSinceDate:self.timerStarted];
}

-(void)stopTimer {
    // set labels
    [self.lastIntervalTime setText:[Util getTimeStr:self.totalSeconds]];
    
    // reset timer
    [self.timer invalidate];
    self.timer = nil;
    self.timerElapsed = 0;
    
    // reset output
    self.totalSeconds = 0;
    self.totalIntervals = 0;
    [self.clockCounter setText:@"00:00:00"];
    [self.intervalCounter setText:@"0"];
    [self.timeToIntervalCounter setText:@""];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

-(void)runTimer {
    // reset
    [self.timer invalidate];
    self.timer = nil;
    self.timerElapsed = 0.0;
    
    // run timer for 1 interval length
    [self startTimer];
    
    // calculate
    self.totalSeconds++;
    self.intervalHours = (int)[self.pickerView selectedRowInComponent:0];
    self.intervalMinutes = (int)[self.pickerView selectedRowInComponent:1];
    self.intervalSeconds = (int)[self.pickerView selectedRowInComponent:2];
    int intervalTotalSeconds = self.intervalHours * 3600 + self.intervalMinutes * 60 + self.intervalSeconds;
    int timeToInterval = (intervalTotalSeconds == 0) ? 0 : intervalTotalSeconds - self.totalSeconds % intervalTotalSeconds;
    float intervalPercent = timeToInterval/(intervalTotalSeconds*1.0f);
    //    NSLog(@"pecent: %f red %f green %f blue %f" ,intervalPercent, ((1-intervalPercent)*255+intervalPercent*170), (intervalPercent*170), (intervalPercent*170));
    
    // output
    [self.clockCounter setText:[Util getTimeStr:self.totalSeconds]];
    [self.timeToIntervalCounter setText:[NSString stringWithFormat:@"%i",timeToInterval]];
    [self.timeToIntervalCounter setTextColor:[UIColor colorWithRed:((1-intervalPercent)*255+intervalPercent*46)/255.0f green:(intervalPercent*204)/255.0f blue:(intervalPercent*113)/255.0f alpha:1.0]];
    
    // when total seconds is divisible by the timer's interval
    if (intervalTotalSeconds > 0 && self.totalSeconds % intervalTotalSeconds == 0) {
        self.totalIntervals++;
        [self.intervalCounter setText:[NSString stringWithFormat:@"%d",self.totalIntervals]];
    }
    
    // badge notification countdown
    self.badgeNotification.applicationIconBadgeNumber = timeToInterval;
    if (self.toggleNotifications)
        [[UIApplication sharedApplication] scheduleLocalNotification:self.badgeNotification];
    
    // countdown voice (5, 4, 3, 2, 1)
    for (int i = 1; i <= 5; i++) {
        if (intervalTotalSeconds > 0 && self.totalSeconds % intervalTotalSeconds == intervalTotalSeconds-i) {
            for (int j = 0; j < self.audioPlayers.count; j++) {
                self.audio = [self.audioPlayers objectAtIndex:j];
                [self.audio setVolume:self.toggleVolume];
                if ([self.audio.url.filePathURL.lastPathComponent.stringByDeletingPathExtension isEqualToString:[NSString stringWithFormat:@"count%d",i]]) {
                    // play background sound
                    if (self.toggleSound)
                        [self.audio play];
                    break;
                }
                
                if (self.toggleVibrations)
                    [self vibrate];
            }
        }
    }
    
    // minute voice
    if (self.totalSeconds > 0 && self.totalSeconds % 300 == 0) { // 300 = divisible by 5 minutes
        for (int j = 0; j < self.audioPlayers.count; j++) {
            self.audio = [self.audioPlayers objectAtIndex:j];
            [self.audio setVolume:self.toggleVolume];
            NSString *fileName = self.audio.url.filePathURL.lastPathComponent.stringByDeletingPathExtension;
            if (fileName.length >= 9) {
                int fileNameSeconds = ([[fileName substringWithRange:NSMakeRange(4, 1)] intValue] * 60 + [[fileName substringWithRange:NSMakeRange(8, 2)] intValue]) * 60;
                if (self.totalSeconds == fileNameSeconds) {
                    // play background sound
                    if (self.toggleSound)
                        [self.audio play];
                    break;
                }
            }
        }
    }
    
    // stop the timer completely after 6 hours and 1 minute
    if (self.totalSeconds > 21601) {
        [self stopTimer];
    }
    
    // notifcation that interval is still running after 7 hours
    if (self.totalSeconds > 25200) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = [NSString stringWithFormat:@"Your interval timer is still running."];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification: localNotification];
    }
}





#pragma mark - Clock Picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return 24;  // hour
    return 60;      // minutes and seconds
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *columnView = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, [self currentScreenBoundsDependOnOrientation].size.width/3 - 35, 30)];
    [columnView setText:[NSString stringWithFormat:@"%lu", (long)row]];
    
    return columnView;
}





#pragma mark - keyboard handling
-(void)setupKeyboardHandling {
    // handle keyboard appear and disappear notifcations
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // handle touch anywhere to hide keyboard
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    // scroll the view to make textfield visible
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.containerView.contentInset = contentInsets;
    self.containerView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint origin = self.activeField.frame.origin;
    origin.y -= self.containerView.contentOffset.y;
    if (!CGRectContainsPoint(aRect, origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-(aRect.size.height));
        [self.containerView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    // reset the scroll whenever the keyboard disappears
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.containerView.contentInset = contentInsets;
    self.containerView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - textfield handling
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 14) {
        if ([textField.text doubleValue] > 50) {
            textField.text = @"50";
        }
        if ([textField.text doubleValue] < 1) {
            textField.text = @"1";
        }
        self.toggleVolume = [textField.text doubleValue];
    } else if (textField.tag == 25) {
        self.timerInterval = [textField.text doubleValue];
    }
    
    self.activeField = nil;
    [self dismissKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self textFieldDidEndEditing:(UITextField *)textField];
    return NO;
}

-(void)textFieldDidChange:(UITextField *)textField {
    NSLog(@"bob");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // only allow decimal
    static NSString *numbers = @"0123456789";
    static NSString *numbersPeriod = @"01234567890.";
    static NSString *numbersComma = @"0123456789,";
    
    if (range.length > 0 && [string length] == 0) {
        // enable delete
        return YES;
    }
    NSString *symbol = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    if (range.location == 0 && [string isEqualToString:symbol]) {
        // decimalseparator should not be first
        //        return NO;
    }
    NSCharacterSet *characterSet;
    NSRange separatorRange = [textField.text rangeOfString:symbol];
    if (separatorRange.location == NSNotFound) {
        if ([symbol isEqualToString:@"."]) {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersPeriod] invertedSet];
        }
        else {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersComma] invertedSet];
        }
    }
    else {
        // allow 2 characters after the decimal separator
        if (range.location > (separatorRange.location + 2)) {
            return NO;
        }
        characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
    }
    return ([[string stringByTrimmingCharactersInSet:characterSet] length] > 0);
}

@end
