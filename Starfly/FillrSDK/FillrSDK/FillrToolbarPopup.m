/*
 * Copyright 2015-present Pop Tech Pty Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FillrToolbarPopup.h"
#import "Fillr.h"

@implementation FillrToolbarPopup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f];
        
        UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, (self.bounds.size.height - 360.0f) / 2, self.bounds.size.width - 40.0f, 360.0f)];
        whiteBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteBgView];

        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"FillrSDKBundle" withExtension:@"bundle"]];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 20.0f, whiteBgView.frame.size.width - 30.0f, 24.0f)];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:20.0f];
        titleLabel.text = [bundle localizedStringForKey:@"Secure Autofill by Fillr" value:@"" table:nil];
        [whiteBgView addSubview:titleLabel];
        
        CGFloat accumulatedHeight = titleLabel.frame.origin.y + titleLabel.frame.size.height + 15.0f;
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, accumulatedHeight, whiteBgView.frame.size.width - 30.0f, 24.0f)];
        descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        descriptionLabel.textAlignment = NSTextAlignmentCenter;
        descriptionLabel.font = [UIFont systemFontOfSize:16.0f];
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.text = [bundle localizedStringForKey:@"Fillr is the most secure & accurate autofill in the world and it’s free. Setup takes under a minute and you’ll be returned to this page." value:@"" table:nil];
        //[bundle localizedStringForKey:@"Fillr is the most secure & accurate autofill in the world. Your profile data is PIN protected and only ever stored on your device, fully encrypted within the Fillr app. Setup takes under a minute and you'll be returned to this page." value:@"" table:nil];
        [whiteBgView addSubview:descriptionLabel];
        
        CGSize size = [descriptionLabel.text sizeWithFont:descriptionLabel.font constrainedToSize:CGSizeMake(descriptionLabel.frame.size.width, 999.0f) lineBreakMode:descriptionLabel.lineBreakMode];
        descriptionLabel.frame = CGRectMake(15.0, accumulatedHeight, whiteBgView.frame.size.width - 30.0f, size.height);
        
        accumulatedHeight = descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 20.0f;
        UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [yesButton addTarget:self action:@selector(installFillr:) forControlEvents:UIControlEventTouchUpInside];
        yesButton.frame = CGRectMake(15.0f, accumulatedHeight, whiteBgView.frame.size.width - 30.0f, 48.0f);
        yesButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [yesButton setTitle:[bundle localizedStringForKey:@"Install Fillr autofill and save me time" value:@"" table:nil] forState:UIControlStateNormal];
        [yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [yesButton setBackgroundColor:[UIColor colorWithRed:0.0f green:164.0f/255.0f blue:184.0f/255.0f alpha:1.0f]];
        yesButton.layer.cornerRadius = 3.0f;
        yesButton.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        yesButton.layer.shadowColor = [UIColor blackColor].CGColor;
        yesButton.layer.shadowRadius = 1.0f;
        yesButton.layer.shadowOpacity = 0.50f;
        yesButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        yesButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        yesButton.titleLabel.numberOfLines = 0;
        [yesButton.titleLabel sizeToFit];
        [whiteBgView addSubview:yesButton];
        
        accumulatedHeight = yesButton.frame.origin.y + yesButton.frame.size.height + 12.0f;
        UIButton *noButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [noButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        noButton.frame = CGRectMake(15.0f, accumulatedHeight, whiteBgView.frame.size.width - 30.0f, 48.0f);
        noButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [noButton setTitle:[bundle localizedStringForKey:@"Not now, I'd like to fill this form manually" value:@"" table:nil] forState:UIControlStateNormal];
        [noButton setTitleColor:[UIColor colorWithWhite:0.5f alpha:1.0f] forState:UIControlStateNormal];
        noButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        noButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        noButton.titleLabel.numberOfLines = 0;
        [noButton.titleLabel sizeToFit];
        [whiteBgView addSubview:noButton];
    }
    return self;
}

- (void)installFillr:(id)sender {
    [self removeFromSuperview];
    [[Fillr sharedInstance] installFillr];
}

- (void)dismiss:(id)sender {
    [self removeFromSuperview];
}

@end
