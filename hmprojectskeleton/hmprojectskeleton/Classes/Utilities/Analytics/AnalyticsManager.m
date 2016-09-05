//
//  FlurryManager.m
//  TruValue
//
//  Created by Tamas Levente on 5/28/14.
//  Copyright (c) 2014 Halcyon Mobile. All rights reserved.
//

#import "AnalyticsManager.h"
#import "Flurry.h"

// TODO: Configure proper app Key for flurry
static NSString * const kFlurryAppKey               = @"";
static NSString * const kKeyParameterDictionary     = @"parameter";

static BOOL _enabled = NO;

@implementation AnalyticsManager

+ (void)startSessionAndLogging:(BOOL)enabled {
    _enabled = enabled;

    if (_enabled) {
        [Flurry setAppVersion:kAppVersionNumber];
        [Flurry startSession:kFlurryAppKey];
        [Flurry setLogLevel:FlurryLogLevelNone];
    }
}

+ (void)updateUserHash:(NSString *)userHash {
    if (_enabled && userHash) {
        [Flurry setUserID:userHash];
    }
}

#pragma mark - Events

#pragma mark :: log simple events

+ (void)logEvent:(NSString *)eventName {
    [self logEvent:eventName timed:NO];
}

+ (void)logEvent:(NSString *)eventName parameter:(NSString *)parameter {
    [self logEvent:eventName timed:NO parameter:parameter];
}

+ (void)logEvent:(NSString *)eventName parameterKeys:(NSArray *)keys values:(id)firstValue,... {
    va_list values;
    va_start(values,firstValue);
    NSDictionary *parameters = [self parameterDictionaryWithKeys:keys firstValue:firstValue values:values];
    va_end(values);
    
    [self logEvent:eventName timed:NO parameterDictionary:parameters];
}

#pragma mark :: log timed events

+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed {
    [self logEvent:eventName timed:timed parameter:nil];
}

+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed parameter:(NSString *)parameter {
    NSDictionary *parameterDictionary = parameter.length > 0 ? @{kKeyParameterDictionary : parameter} : nil;
    [self logEvent:eventName timed:timed parameterDictionary:parameterDictionary];
}

+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed parameterKeys:(NSArray *)keys values:(id)firstValue, ... {
    va_list values;
    va_start(values,firstValue);
    NSDictionary *parameters = [self parameterDictionaryWithKeys:keys firstValue:firstValue values:values];
    va_end(values);
    
    [self logEvent:eventName timed:timed parameterDictionary:parameters];
}

#pragma mark :: end timed event

+ (void)endTimedEvent:(NSString *)eventName {
    [self endTimedEvent:eventName parameter:nil];
}

+ (void)endTimedEvent:(NSString *)eventName parameter:(NSString *)parameter {
    if (_enabled) {
        if (parameter) {
            [Flurry endTimedEvent:eventName withParameters:@{kKeyParameterDictionary : parameter}];
        } else {
            [Flurry endTimedEvent:eventName withParameters:parameter ? @{kKeyParameterDictionary : parameter} : nil];
        }
    }
}

#pragma mark :: private

+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed parameterDictionary:(NSDictionary *)parameterDict {
    if (_enabled) {
        if (parameterDict) {
            [Flurry logEvent:eventName withParameters:parameterDict timed:timed];
        } else {
            [Flurry logEvent:eventName timed:timed];
        }
    }
}

+ (NSDictionary *)parameterDictionaryWithKeys:(NSArray *)keys firstValue:(id)firstValue values:(va_list)values {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSInteger parameterCount = keys.count;
    
    if (parameterCount > 0) {
        NSString *key = [keys validObjectAtIndex:0];
        [parameters setValidObject:firstValue forKey:key];
        
        id value;
        for (NSInteger i = 1; i < parameterCount; i++) {
            key = [keys validObjectAtIndex:i];
            value = va_arg(values, id);
            [parameters setValidObject:value forKey:key];
        }
    }
    
    return parameters;
}

#pragma mark - Error methods

+ (void)logError:(NSString *)errorName message:(NSString *)errorMessage {
    if (_enabled) {
        [Flurry logError:errorName message:errorMessage error:nil];
    }
}

@end
