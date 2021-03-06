//
//  NSDictionaryAdditions.m
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "NSDictionaryAdditions.h"


@implementation NSDictionary (Additions)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    return [self objectForKey:key] == [NSNull null] || [[self objectForKey:key] isKindOfClass:[NSNull class]] ? defaultValue 
						: [[self objectForKey:key] boolValue];
}

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue {
	return ([self objectForKey:key] == [NSNull null]  || [[self objectForKey:key] isKindOfClass:[NSNull class]] || [self objectForKey:key] == nil)? defaultValue : [[self objectForKey:key] intValue];
}

- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue {
	NSString *stringTime   = [self objectForKey:key];
    if (![stringTime isKindOfClass:[NSString class]] && ![stringTime isKindOfClass:[NSNull class]]) {
        stringTime = [NSString stringWithFormat:@"%@",[(NSNumber*)stringTime stringValue]];
    }
    if ((id)stringTime == [NSNull null] || [stringTime isKindOfClass:[NSNull class]]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}

- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
	return [self objectForKey:key] == [NSNull null]  || [[self objectForKey:key] isKindOfClass:[NSNull class]]
		? defaultValue : [[self objectForKey:key] longLongValue];
}

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
//	return [self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null] 
//				? defaultValue : [self objectForKey:key];
	
	id value = [self objectForKey:key];
	if (value == nil)
		return defaultValue;
	else if ([value isKindOfClass:[NSNull class]])
		return defaultValue;
	else if ([value isKindOfClass:[NSString class]])
		return value;
	
	return nil;
}

- (CGFloat) getFloatValueForKey:(NSString*)key defaultValue:(CGFloat)defaultValue {
	return [self objectForKey:key] == [NSNull null] || [[self objectForKey:key] isKindOfClass:[NSNull class]]
	? defaultValue : [[self objectForKey:key] floatValue];
}


@end
