//
//  FlurryManager.h
//  TruValue
//
//  Created by Tamas Levente on 5/28/14.
//  Copyright (c) 2014 Halcyon Mobile. All rights reserved.
//

@interface AnalyticsManager : NSObject

+ (void)startSessionAndLogging:(BOOL)enabled;
+ (void)updateUserHash:(NSString *)userHash;

+ (void)logEvent:(NSString *)eventName;
+ (void)logEvent:(NSString *)eventName parameter:(NSString *)parameter;
+ (void)logEvent:(NSString *)eventName parameterKeys:(NSArray *)keys values:(id)firstValue,...;

+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed;
+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed parameter:(NSString *)parameter;
+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed parameterKeys:(NSArray *)keys values:(id)firstValue,...;

+ (void)endTimedEvent:(NSString *)eventName;
+ (void)endTimedEvent:(NSString *)eventName parameter:(NSString *)parameter;

+ (void)logError:(NSString *)errorName message:(NSString *)errorMessage;

@end

#pragma mark - Keys

#pragma mark :: events

// Commented code is left jsut for inspiration. Remove or use it
// extern NSString * const kAnalyticsEventViewLoginWithFacebook;
// extern NSString * const kAnalyticsEventViewLoginWithLinkedin;

