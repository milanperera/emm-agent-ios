//
//  ConnectionUtils.m
//  iOSMDMAgent
//
//

#import "ConnectionUtils.h"
#import "URLUtils.h"
#import "MDMUtils.h"
#import "KeychainItemWrapper.h"

//Remove this code chunk in production
@interface NSURLRequest(Private)

+(void)setAllowsAnyHTTPSCertificate:(BOOL)inAllow forHost:(NSString *)inHost;

@end

@implementation ConnectionUtils

- (void)sendPushTokenToServer:(NSString *)udid pushToken:(NSString *)token {
    
    NSString *endpoint = [NSString stringWithFormat:[URLUtils getTokenPublishURL], udid];

    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:token forKey:TOKEN];

    [request setHTTPMethod:PUT];
    [request setHTTPBody:[[self dictionaryToJSON:paramDictionary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self setContentType:request];
    [self addAccessToken:request];
    
    [self setAllowsAnyHTTPSCertificate:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        long code = [(NSHTTPURLResponse *)response statusCode];
        NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (returnedData != nil) {
            NSLog(@"sendPushTokenToServer:Data recieved: %@", returnedData);
        }

        NSLog(@"sendPushTokenToServer:Response recieved: %ld", code);
        if (code == OAUTH_FAIL_CODE || code == 0) {
            NSLog(@"Authentication failed. Obtaining a new access token");
            if([self getNewAccessToken]){
                [self sendPushTokenToServer:udid pushToken:token];
            }
            NSLog(@"Error occurred %ld", code);
        }

    }];
}

- (void)sendLocationToServer:(NSString *)udid latitiude:(float)lat longitude:(float)longi {
    NSString *endpoint = [NSString stringWithFormat:[URLUtils getLocationPublishURL], udid];

    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setObject:[NSNumber numberWithFloat:lat] forKey:LATITIUDE];
    [paramDictionary setObject:[NSNumber numberWithFloat:longi] forKey:LONGITUDE];
    [paramDictionary setObject:[MDMUtils getLocationOperationId] forKey:OPERATION_ID];

    [request setHTTPMethod:PUT];
    [request setHTTPBody:[[self dictionaryToJSON:paramDictionary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self setContentType:request];
    
    [self addAccessToken:request];
    [self setAllowsAnyHTTPSCertificate:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        long code = [(NSHTTPURLResponse *)response statusCode];
        
        NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (returnedData != nil) {
            NSLog(@"sendLocationUpdateToServer:Data recieved: %@", returnedData);
            [MDMUtils setLocationUpdatedTime];
        }

        NSLog(@"sendLocationToServer:Response recieved: %ld", code);
        if (code == OAUTH_FAIL_CODE || code == 0) {
            NSLog(@"Authentication failed. Obtaining a new access token");
            if([self getNewAccessToken]){
                [self sendLocationToServer:udid latitiude:lat longitude:longi];
            }
            NSLog(@"Error occurred %ld", code);
        }
    }];
}


- (void)sendOperationUpdateToServer:(NSString *)deviceId operationId:(NSString *)opId status:(NSString *)state {
    NSString *endpoint = [NSString stringWithFormat:[URLUtils getOperationURL], deviceId];

    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:opId forKey:OPERATION_ID];
    [paramDictionary setValue:state forKey:STATUS];

    [request setHTTPMethod:PUT];
    [request setHTTPBody:[[self dictionaryToJSON:paramDictionary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self setContentType:request];
    
    [self addAccessToken:request];
    [self setAllowsAnyHTTPSCertificate:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        long code = [(NSHTTPURLResponse *)response statusCode];
        
        NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (returnedData != nil) {
            NSLog(@"sendOperationUpdateToServer:Data recieved: %@", returnedData);
        }
        NSLog(@"sendOperationUpdateToServer:Response recieved: %ld", code);
        if (code == OAUTH_FAIL_CODE || code == 0) {
            NSLog(@"Authentication failed. Obtaining a new access token");
            if([self getNewAccessToken]){
                [self sendOperationUpdateToServer:deviceId operationId:opId status:state];
            }
            NSLog(@"Error occurred %ld", code);
        }
    }];
}

- (void)sendUnenrollToServer {
    [self getNewAccessToken];
    NSURL *url = [NSURL URLWithString:[URLUtils getUnenrollURL]];

    NSString *deviceId = [MDMUtils getDeviceUDID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    NSArray *deviceList = @[deviceId];
    
    [request setHTTPMethod:POST];
    [self addAccessToken:request];
    [request setHTTPBody:[[self arrayToJSON:deviceList] dataUsingEncoding:NSUTF8StringEncoding]];
    [self setContentType:request];
    
    [self setAllowsAnyHTTPSCertificate:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        long code = [(NSHTTPURLResponse *)response statusCode];
        NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (returnedData != nil) {
            NSLog(@"sendUnenrollToServer:Data recieved: %@", returnedData);
        }
        NSLog(@"sendUnenrollToServer:Response recieved: %ld", code);
        if (code == OAUTH_FAIL_CODE) {
            NSLog(@"Authentication failed. Obtaining a new access token");
            if([self getNewAccessToken]){
                [self sendUnenrollToServer];
            }
            [MDMUtils setEnrollStatus:UNENROLLED];
    
        } else if (code == HTTP_CREATED) {
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful)]){
                [_delegate unregisterSuccessful];
            }
            
        } else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
            
        }
    }];
}

- (void)addAccessToken:(NSMutableURLRequest *)request {
//    KeychainItemWrapper* wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:TOKEN_KEYCHAIN accessGroup:nil];
//    NSString *storedAccessToken = [wrapper objectForKey:(__bridge id)(kSecAttrAccount)];

    NSString *storedAccessToken = [MDMUtils getAccessToken];
    
    if(storedAccessToken != nil){
        NSString *headerValue = [AUTHORIZATION_BEARER stringByAppendingString:storedAccessToken];
        [request setValue:headerValue forHTTPHeaderField:AUTHORIZATION];
    }
}

- (BOOL)getAccessToken:(NSString *)username password:(NSString *)pwd {
    
    NSLog(@"getAccessToken: Obtaining a access token");
    
    NSString *endpoint = [URLUtils getRefreshTokenURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    //    KeychainItemWrapper* wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:TOKEN_KEYCHAIN accessGroup:nil];
    //    NSString *storedRefreshToken = [wrapper objectForKey:(__bridge id)(kSecValueData)];
    
    NSString *scopes = @"perm:ios:enroll perm:ios:view-device perm:ios:applications perm:ios:enterprise-wipe";
    NSString *payload=[NSString stringWithFormat:@"grant_type=password&username=%@&password=%@&scope=%@", username, pwd, scopes];
    NSLog(@"Request payload: %@", payload);
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    [self setContentTypeFormEncoded:request];
    [self addClientDeatils:request];
    [self setAllowsAnyHTTPSCertificate:url];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        long code = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"getAccessToken:Response recieved: %li", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            NSString *accessToken =(NSString*)[json objectForKey:@"access_token"];
            NSString *refreshToken =(NSString*)[json objectForKey:@"refresh_token"];
            [MDMUtils setAccessToken:accessToken];
            [MDMUtils setRefreshToken:refreshToken];
            return true;
        }
    }
    NSLog(@"Error while getting access token.");
    return false;
}


- (BOOL)getNewAccessToken {
    
    NSLog(@"getNewAccessToken: Obtaining a new access token through refresh token");
    
    NSString *endpoint = [URLUtils getRefreshTokenURL];

    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    
//    KeychainItemWrapper* wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:TOKEN_KEYCHAIN accessGroup:nil];
//    NSString *storedRefreshToken = [wrapper objectForKey:(__bridge id)(kSecValueData)];
    
    NSString *storedRefreshToken = [MDMUtils getRefreshToken];
    
    NSString *payload=[@"grant_type=refresh_token&refresh_token=" stringByAppendingString:storedRefreshToken];
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    [self setContentTypeFormEncoded:request];
    [self addClientDeatils:request];
    [self setAllowsAnyHTTPSCertificate:url];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        long code = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"getNewAccessToken:Response recieved: %li", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            NSString *accessToken =(NSString*)[json objectForKey:@"access_token"];
            NSString *refreshToken =(NSString*)[json objectForKey:@"refresh_token"];
            [MDMUtils setAccessToken:accessToken];
            [MDMUtils setRefreshToken:refreshToken];
            
            
            return true;
        }
    }
    NSLog(@"Error while getting refresh token.");
    return false;
}


- (BOOL)setClientCredentials:(NSString *)username password:(NSString*)pwd {
    
    NSLog(@"Calling dynamic client endpoint: Obtaining client credentials");    
    NSString *endpoint = [URLUtils getDynamicClientURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:[NSString stringWithFormat:@"%@%@", APPLICATION_NAME_PREFIX, [MDMUtils getDeviceUDID]] forKey:APPLICATION_NAME];
    [paramDictionary setValue:false forKey:IS_ALLOWED_TO_TENANT_DOMAINS];
    [paramDictionary setValue:false forKey:IS_MAPPING_EXISTING_APP];
    [paramDictionary setObject:[NSArray arrayWithObjects:@"ios", nil] forKey:TAGS];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[[self dictionaryToJSON:paramDictionary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self setContentType:request];
    [self addEncodedUserName:request username:username password:pwd];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        long code = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"getClientCredentials:Response recieved: %li", code);
        
        NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (returnedData != nil) {
            NSLog(@"getClientCredentials:Data recieved: %@", returnedData);
        }
        
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            NSString *clientId =(NSString*)[json objectForKey:CLIENT_ID];
            NSString *clientSecret =(NSString*)[json objectForKey:CLIENT_SECRET];
            
            NSString *clientCredentials = [MDMUtils encodeToBase64:clientId val:clientSecret];
            NSLog(@"Encoded client credentials: %@", clientCredentials);
            
            [MDMUtils setClientCredentials:clientCredentials];
            return true;
        }
    }
    return false;

}


- (NSMutableURLRequest *)getOrganizationRequest:(NSString *)username password:(NSString *)pwd {
    
    NSLog(@"Calling get organizations");
    NSString *endpoint = [URLUtils getOrganizationURL];
    
    NSLog(@"get organization endpoint: %@", endpoint);
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    [request setHTTPMethod:GET];
    [self setContentType:request];
    [self addEncodedUserName:request username:username password:pwd];
    [self setAllowsAnyHTTPSCertificate:url];
    
    return request;
    
//    NSURLResponse * response = nil;
//    NSError * error = nil;
//    NSData * data = [NSURLConnection sendSynchronousRequest:request
//                                          returningResponse:&response
//                                                      error:&error];
//    
//    if (error == nil) {
//        long code = [(NSHTTPURLResponse *)response statusCode];
//        NSLog(@"getOrganizations:Response recieved: %li", code);
//        
//        NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        if (returnedData != nil) {
//            NSLog(@"getOrganizations:Data recieved: %@", returnedData);
//        }
//        
//        if (code == HTTP_OK) {
//            NSError *jsonError;
//            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                 options:NSJSONReadingMutableContainers
//                                                                   error:&jsonError];
//            
//            NSDictionary *tenantObjects = [json objectForKey:@"getTenantDisplayNamesResponse"];
//            NSArray *tenants = [tenantObjects objectForKey:@"return"];
//            return tenants;
//        }
//    }
//    return nil;
    
//    __block NSArray *tenants;
//    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        
//        long code = [(NSHTTPURLResponse *)response statusCode];
//        NSLog(@"getOrganizations:Response recieved: %li", code);
//        
//        NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        if (returnedData != nil) {
//            NSLog(@"getOrganizations:Data recieved: %@", returnedData);
//        }
//        
//        if (code == HTTP_OK) {
//            NSError *jsonError;
//            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                 options:NSJSONReadingMutableContainers
//                                                                   error:&jsonError];
//        
//            NSDictionary *tenantObjects = [json objectForKey:@"getTenantDisplayNamesResponse"];
//            tenants = [tenantObjects objectForKey:@"return"];
//        }
//        
//    }];
//    return tenants;
    
}


- (BOOL)authenticateUser:(NSString *)username password:(NSString *)pwd tenantDomain:(NSString *)tDomain {
    NSLog(@"Authenticating user");
    NSString *fullyQualifiedName = [NSString stringWithFormat:@"%@@%@", username, tDomain];
    NSLog(@"Fully qualified user: %@", fullyQualifiedName);
    BOOL result = false;
    result = [self setClientCredentials:fullyQualifiedName password:pwd];
    if (result) {
        result = [self getAccessToken:fullyQualifiedName password:pwd];
    }
    return result;
}


- (void)addEncodedUserName:(NSMutableURLRequest *)request username:(NSString *)uname password:(NSString *)pwd {
    
    NSString *base64EncodedUserName = [MDMUtils encodeToBase64:uname val:pwd];
    NSLog(@"Encoded username and password: %@", base64EncodedUserName);
    
    NSString *headerValue = [AUTHORIZATION_BASIC stringByAppendingString:base64EncodedUserName];
    [request setValue:headerValue forHTTPHeaderField:AUTHORIZATION];
    
}

- (void)addClientDeatils:(NSMutableURLRequest *)request {
    
    NSString *storedClientDetails = [MDMUtils getClientCredentials];
    
    if(storedClientDetails != nil){
        NSString *headerValue = [AUTHORIZATION_BASIC stringByAppendingString:storedClientDetails];
        [request setValue:headerValue forHTTPHeaderField:AUTHORIZATION];
    }
}



- (void)setContentType:(NSMutableURLRequest *)request {
    [request setValue:APPLICATION_JSON forHTTPHeaderField:CONTENT_TYPE];
    [request setValue:APPLICATION_JSON forHTTPHeaderField:ACCEPT];
}

- (void)setContentTypeFormEncoded:(NSMutableURLRequest *)request {
    [request setValue:FORM_ENCODED forHTTPHeaderField:CONTENT_TYPE];
}


- (void)setAllowsAnyHTTPSCertificate:(NSURL *)url {
    //remove this code chunk in production
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
}

-(NSString *)dictionaryToJSON:(NSDictionary *)dictionary {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
}

-(NSString *)arrayToJSON:(NSArray *)array {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
}

@end
