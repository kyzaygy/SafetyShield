#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (nonatomic, strong) UIButton *telegramButton;
@property (nonatomic, strong) CAGradientLayer *bgGradient;
@property (nonatomic, strong) CAGradientLayer *buttonGradient;
@property (nonatomic, strong) UIView *shieldContainer;
@end

@implementation ViewController

#pragma mark - Colors

+ (UIColor *)accentCyan   { return [UIColor colorWithRed:0.00 green:0.93 blue:0.95 alpha:1.0]; }
+ (UIColor *)accentGreen  { return [UIColor colorWithRed:0.30 green:1.00 blue:0.55 alpha:1.0]; }
+ (UIColor *)bgTop        { return [UIColor colorWithRed:0.04 green:0.05 blue:0.09 alpha:1.0]; }
+ (UIColor *)bgBottom     { return [UIColor colorWithRed:0.00 green:0.01 blue:0.03 alpha:1.0]; }
+ (UIColor *)panelColor   { return [UIColor colorWithRed:0.07 green:0.09 blue:0.13 alpha:1.0]; }

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    [self setupBackground];
    [self setupGridOverlay];
    [self setupShield];
    [self setupTitles];
    [self setupFeatureChips];
    [self setupTelegramButton];
    [self setupFooter];
}

- (BOOL)prefersStatusBarHidden { return NO; }
- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }

#pragma mark - Background

- (void)setupBackground {
    self.bgGradient = [CAGradientLayer layer];
    self.bgGradient.frame = self.view.bounds;
    self.bgGradient.colors = @[
        (id)[ViewController bgTop].CGColor,
        (id)[ViewController bgBottom].CGColor
    ];
    self.bgGradient.startPoint = CGPointMake(0.0, 0.0);
    self.bgGradient.endPoint   = CGPointMake(1.0, 1.0);
    [self.view.layer insertSublayer:self.bgGradient atIndex:0];
}

- (void)setupGridOverlay {
    CAShapeLayer *grid = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat step = 28.0;
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    for (CGFloat x = 0; x < w; x += step) {
        [path moveToPoint:CGPointMake(x, 0)];
        [path addLineToPoint:CGPointMake(x, h)];
    }
    for (CGFloat y = 0; y < h; y += step) {
        [path moveToPoint:CGPointMake(0, y)];
        [path addLineToPoint:CGPointMake(w, y)];
    }
    grid.path = path.CGPath;
    grid.strokeColor = [[ViewController accentCyan] colorWithAlphaComponent:0.05].CGColor;
    grid.lineWidth = 0.5;
    grid.frame = self.view.bounds;
    [self.view.layer addSublayer:grid];
}

#pragma mark - Shield

- (void)setupShield {
    CGFloat size = 140.0;
    CGFloat topInset = 80.0;

    self.shieldContainer = [[UIView alloc] initWithFrame:
        CGRectMake((self.view.bounds.size.width - size) / 2.0, topInset, size, size)];
    self.shieldContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.shieldContainer];

    CAShapeLayer *glow = [CAShapeLayer layer];
    glow.path = [self shieldPathInRect:self.shieldContainer.bounds].CGPath;
    glow.fillColor = [[ViewController accentCyan] colorWithAlphaComponent:0.12].CGColor;
    glow.shadowColor = [ViewController accentCyan].CGColor;
    glow.shadowOpacity = 0.9;
    glow.shadowRadius = 26.0;
    glow.shadowOffset = CGSizeZero;
    [self.shieldContainer.layer addSublayer:glow];

    CAShapeLayer *outline = [CAShapeLayer layer];
    outline.path = [self shieldPathInRect:self.shieldContainer.bounds].CGPath;
    outline.fillColor = [UIColor clearColor].CGColor;
    outline.strokeColor = [ViewController accentCyan].CGColor;
    outline.lineWidth = 3.0;
    outline.lineJoin = kCALineJoinRound;
    [self.shieldContainer.layer addSublayer:outline];

    UILabel *check = [[UILabel alloc] initWithFrame:self.shieldContainer.bounds];
    check.text = @"\u2713";
    check.textAlignment = NSTextAlignmentCenter;
    check.font = [UIFont systemFontOfSize:70.0 weight:UIFontWeightBold];
    check.textColor = [ViewController accentGreen];
    check.layer.shadowColor = [ViewController accentGreen].CGColor;
    check.layer.shadowOpacity = 0.8;
    check.layer.shadowRadius = 10.0;
    check.layer.shadowOffset = CGSizeZero;
    [self.shieldContainer addSubview:check];

    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    pulse.fromValue = @18.0;
    pulse.toValue = @34.0;
    pulse.duration = 1.8;
    pulse.autoreverses = YES;
    pulse.repeatCount = HUGE_VALF;
    [glow addAnimation:pulse forKey:@"pulse"];
}

- (UIBezierPath *)shieldPathInRect:(CGRect)r {
    CGFloat w = r.size.width;
    CGFloat h = r.size.height;
    UIBezierPath *p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(w * 0.5, 0)];
    [p addLineToPoint:CGPointMake(w, h * 0.2)];
    [p addLineToPoint:CGPointMake(w, h * 0.55)];
    [p addCurveToPoint:CGPointMake(w * 0.5, h)
         controlPoint1:CGPointMake(w, h * 0.85)
         controlPoint2:CGPointMake(w * 0.75, h)];
    [p addCurveToPoint:CGPointMake(0, h * 0.55)
         controlPoint1:CGPointMake(w * 0.25, h)
         controlPoint2:CGPointMake(0, h * 0.85)];
    [p addLineToPoint:CGPointMake(0, h * 0.2)];
    [p closePath];
    return p;
}

#pragma mark - Titles

- (void)setupTitles {
    CGFloat w = self.view.bounds.size.width;
    CGFloat titleY = CGRectGetMaxY(self.shieldContainer.frame) + 18.0;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, titleY, w, 38)];
    title.text = @"SafetyShield";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:32.0 weight:UIFontWeightHeavy];
    title.textColor = [UIColor whiteColor];
    title.layer.shadowColor = [ViewController accentCyan].CGColor;
    title.layer.shadowOpacity = 0.7;
    title.layer.shadowRadius = 8.0;
    title.layer.shadowOffset = CGSizeZero;
    [self.view addSubview:title];

    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(16, titleY + 40, w - 32, 22)];
    subtitle.text = @"\u2022 \u0426\u0418\u0424\u0420\u041E\u0412\u0410\u042F  \u0411\u0415\u0417\u041E\u041F\u0410\u0421\u041D\u041E\u0421\u0422\u042C \u2022";
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightSemibold];
    subtitle.textColor = [[ViewController accentCyan] colorWithAlphaComponent:0.85];
    [self.view addSubview:subtitle];

    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(28, titleY + 72, w - 56, 64)];
    desc.text = @"\u0417\u0430\u0449\u0438\u0442\u0430 \u0434\u0430\u043D\u043D\u044B\u0445, \u043F\u0440\u0438\u0432\u0430\u0442\u043D\u043E\u0441\u0442\u044C \u0438 \u043A\u0438\u0431\u0435\u0440\u0433\u0438\u0433\u0438\u0435\u043D\u0430.\n\u0412\u0441\u0451 \u0441\u0430\u043C\u043E\u0435 \u0432\u0430\u0436\u043D\u043E\u0435 \u2014 \u0432 \u043D\u0430\u0448\u0435\u043C Telegram-\u043A\u0430\u043D\u0430\u043B\u0435.";
    desc.textAlignment = NSTextAlignmentCenter;
    desc.numberOfLines = 2;
    desc.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
    desc.textColor = [UIColor colorWithWhite:0.75 alpha:1.0];
    [self.view addSubview:desc];
}

#pragma mark - Feature chips

- (void)setupFeatureChips {
    NSArray *titles = @[
        @"\uD83D\uDD10 \u0428\u0438\u0444\u0440\u043E\u0432\u0430\u043D\u0438\u0435",
        @"\uD83D\uDC41 OSINT",
        @"\u26A1 0-day"
    ];

    CGFloat w = self.view.bounds.size.width;
    CGFloat y = self.view.bounds.size.height * 0.58;
    CGFloat totalW = w - 32;
    CGFloat chipW = (totalW - 20) / 3.0;

    for (NSUInteger i = 0; i < titles.count; i++) {
        UIView *chip = [[UIView alloc] initWithFrame:
            CGRectMake(16 + i * (chipW + 10), y, chipW, 36)];
        chip.backgroundColor = [ViewController panelColor];
        chip.layer.cornerRadius = 10.0;
        chip.layer.borderWidth = 1.0;
        chip.layer.borderColor = [[ViewController accentCyan] colorWithAlphaComponent:0.35].CGColor;

        UILabel *l = [[UILabel alloc] initWithFrame:chip.bounds];
        l.text = titles[i];
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
        l.textColor = [UIColor whiteColor];
        [chip addSubview:l];

        [self.view addSubview:chip];
    }
}

#pragma mark - Button

- (void)setupTelegramButton {
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;

    CGFloat btnW = w - 48;
    CGFloat btnH = 60;
    CGFloat btnY = h - btnH - 80;

    self.telegramButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.telegramButton.frame = CGRectMake(24, btnY, btnW, btnH);
    self.telegramButton.layer.cornerRadius = 16.0;
    self.telegramButton.clipsToBounds = NO;

    self.buttonGradient = [CAGradientLayer layer];
    self.buttonGradient.frame = self.telegramButton.bounds;
    self.buttonGradient.colors = @[
        (id)[ViewController accentCyan].CGColor,
        (id)[ViewController accentGreen].CGColor
    ];
    self.buttonGradient.startPoint = CGPointMake(0, 0.5);
    self.buttonGradient.endPoint   = CGPointMake(1, 0.5);
    self.buttonGradient.cornerRadius = 16.0;
    [self.telegramButton.layer insertSublayer:self.buttonGradient atIndex:0];

    self.telegramButton.layer.shadowColor = [ViewController accentCyan].CGColor;
    self.telegramButton.layer.shadowOpacity = 0.7;
    self.telegramButton.layer.shadowRadius = 18.0;
    self.telegramButton.layer.shadowOffset = CGSizeMake(0, 6);

    [self.telegramButton setTitle:@"\u2708  \u041F\u0435\u0440\u0435\u0439\u0442\u0438 \u0432 Telegram"
                         forState:UIControlStateNormal];
    [self.telegramButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.telegramButton.titleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightBold];

    [self.telegramButton addTarget:self
                            action:@selector(openTelegram)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.telegramButton addTarget:self
                            action:@selector(buttonDown)
                  forControlEvents:UIControlEventTouchDown];
    [self.telegramButton addTarget:self
                            action:@selector(buttonUp)
                  forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];

    [self.view addSubview:self.telegramButton];
}

- (void)setupFooter {
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;

    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, h - 40, w, 20)];
    footer.text = @"@safetyshield  \u00B7  stay secure";
    footer.textAlignment = NSTextAlignmentCenter;
    footer.font = [UIFont systemFontOfSize:11.0 weight:UIFontWeightMedium];
    footer.textColor = [UIColor colorWithWhite:0.45 alpha:1.0];
    [self.view addSubview:footer];
}

#pragma mark - Actions

- (void)buttonDown {
    [UIView animateWithDuration:0.12 animations:^{
        self.telegramButton.transform = CGAffineTransformMakeScale(0.96, 0.96);
    }];
}

- (void)buttonUp {
    [UIView animateWithDuration:0.12 animations:^{
        self.telegramButton.transform = CGAffineTransformIdentity;
    }];
}

- (void)openTelegram {
    [self buttonUp];

    NSURL *tg  = [NSURL URLWithString:@"tg://resolve?domain=safetyshield"];
    NSURL *web = [NSURL URLWithString:@"https://t.me/safetyshield"];

    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:tg]) {
        if (@available(iOS 10.0, *)) {
            [app openURL:tg options:@{} completionHandler:nil];
        } else {
            [app openURL:tg];
        }
    } else {
        if (@available(iOS 10.0, *)) {
            [app openURL:web options:@{} completionHandler:nil];
        } else {
            [app openURL:web];
        }
    }
}

@end
