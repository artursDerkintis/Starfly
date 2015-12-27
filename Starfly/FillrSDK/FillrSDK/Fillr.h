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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
//#import <MobileCoreServices/MobileCoreServices.h>

typedef enum {
    FillrStateDownloadingApp,
    FillrStateOpenApp,
    FillrStateFormFilled
} FillrSessionState;

@protocol FillrDelegate<NSObject>
- (void)fillrStateChanged:(FillrSessionState)state currentWebView:(UIView *)currentWebView;
@end

@interface Fillr : NSObject

@property (assign, nonatomic) BOOL overlayInputAccessoryView;
@property (assign, nonatomic) id <FillrDelegate> delegate;
//@property (assign, nonatomic) UIViewController *rootViewController;

+ (Fillr *)sharedInstance;

- (void)initialiseWithDevKey:(NSString *)devKey andUrlSchema:(NSString *)urlSchema;

- (BOOL)canHandleOpenURL:(NSURL *)url;
- (void)handleOpenURL:(NSURL *)url;

- (void)installFillr;
- (void)trackWebview:(UIView *)webViewToTrack;
- (BOOL)hasWebview;

- (void)setEnabled:(BOOL)enabled;

@end
