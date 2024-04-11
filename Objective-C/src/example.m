#import <Foundation/Foundation.h>

@interface Example : NSObject
@end

@implementation Example
+ (NSString *)p_e_escapeString:(NSString *)s {
    NSString *(^p_e_escapeChar)(unichar) = ^NSString *(unichar c) {
        if (c == '\\') return @"\\\\";
        if (c == '\"') return @"\\\"";
        if (c == '\n') return @"\\n";
        if (c == '\t') return @"\\t";
        return [NSString stringWithFormat:@"%c", c];
    };
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < s.length; i++) {
        unichar c = [s characterAtIndex:i];
        [result appendString:p_e_escapeChar(c)];
    }
    return result;
}

+ (NSString *(^)(NSNumber *))p_e_bool {
    return ^NSString *(NSNumber *b) {
        return b.boolValue ? @"true" : @"false";
    };
}

+ (NSString *(^)(NSNumber *))p_e_int {
    return ^NSString *(NSNumber *i) {
        return i.stringValue;
    };
}

+ (NSString *(^)(NSNumber *))p_e_double {
    return ^NSString *(NSNumber *d) {
        NSString *s0 = [NSString stringWithFormat:@"%.7f", d.doubleValue];
        NSString *s1 = [s0 substringToIndex:s0.length - 1];
        return [s1 isEqualToString:@"-0.000000"] ? @"0.000000" : s1;
    };
}

+ (NSString *(^)(NSString *))p_e_string {
    return ^NSString *(NSString *s) {
        return [NSString stringWithFormat:@"\"%@\"" , [self p_e_escapeString:s]];
    };
}

+ (NSString *(^)(NSArray<id> *))p_e_list:(NSString *(^)(id))f0 {
    return ^NSString *(NSArray<id> *lst) {
        NSMutableArray<NSString *> *vs = [NSMutableArray array];
        [lst enumerateObjectsUsingBlock:^(id v, NSUInteger i, BOOL *stop) {
            [vs addObject:f0(v)];
        }];
        return [NSString stringWithFormat:@"[%@]", [vs componentsJoinedByString:@", "]];
    };
}

+ (NSString *(^)(NSArray<id> *))p_e_ulist:(NSString *(^)(id))f0 {
    return ^NSString *(NSArray<id> *lst) {
        NSMutableArray<NSString *> *vs = [NSMutableArray array];
        [lst enumerateObjectsUsingBlock:^(id v, NSUInteger i, BOOL *stop) {
            [vs addObject:f0(v)];
        }];
        [vs sortUsingSelector:@selector(compare:)];
        return [NSString stringWithFormat:@"[%@]", [vs componentsJoinedByString:@", "]];
    };
}

+ (NSString *(^)(NSDictionary<NSNumber *, id> *))p_e_idict:(NSString *(^)(id))f0 {
    NSString *(^f1)(NSNumber *, id) = ^(NSNumber *k, id v) {
        return [NSString stringWithFormat:@"%@=>%@", [self p_e_int](k), f0(v)];
    };
    return ^NSString *(NSDictionary<NSNumber *, id> *dct) {
        NSMutableArray<NSString *> *vs = [NSMutableArray array];
        [dct enumerateKeysAndObjectsUsingBlock:^(NSNumber *k, id v, BOOL *stop) {
            [vs addObject:f1(k, v)];
        }];
        [vs sortUsingSelector:@selector(compare:)];
        return [NSString stringWithFormat:@"{%@}", [vs componentsJoinedByString:@", "]];
    };
}

+ (NSString *(^)(NSDictionary<NSString *, id> *))p_e_sdict:(NSString *(^)(id))f0 {
    NSString* (^f1)(NSString *, id) = ^(NSString *k, id v) {
        return [NSString stringWithFormat:@"%@=>%@", [self p_e_string](k), f0(v)];
    };
    return ^NSString *(NSDictionary<NSString *, id> *dct) {
        NSMutableArray<NSString *> *result = [NSMutableArray array];
        [dct enumerateKeysAndObjectsUsingBlock:^(NSString *k, id v, BOOL *stop) {
            [result addObject:f1(k, v)];
        }];
        [result sortUsingSelector:@selector(compare:)];
        return [NSString stringWithFormat:@"{%@}", [result componentsJoinedByString:@", "]];
    };
}

+ (NSString *(^)(id))p_e_option:(NSString *(^)(id))f0 {
    return ^NSString *(id opt) {
        return ([opt class] == [NSNull class] || opt == nil) ? @"null" : f0(opt);
    };
}

$$code$$

@end

int main() {
    @autoreleasepool {
        NSString *p_e_out = [Example p_e_entry];
        [p_e_out writeToFile:@"result.out" atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }
    return 0;
}




