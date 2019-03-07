//
//  OSIMarsRoverClient.m
//  Objc Mars Rover
//
//  Created by Sergey Osipyan on 3/4/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

#import "OSIMarsRoverClient.h"


// apiKey: A5GInzhik79kruLeQ4FYlN02lBcTmwnTnV5pHIKi
//  baseURL = URL(string: "https://api.nasa.gov/mars-photos/api/v1")!

@implementation OSIMarsRoverClient {
    NSMutableArray *_savedPhotos;
}

static NSString * const baseURL = @"https://api.nasa.gov/mars-photos/api/v1";
static NSString * const apiKey = @"A5GInzhik79kruLeQ4FYlN02lBcTmwnTnV5pHIKi";

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _savedPhotos = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)savedPhotos {
    return [_savedPhotos copy];
}



- (void)searchForRover:(NSString *)roverName completion:(void (^)(OSIMarsRover *rover, NSError * _Nullable))completion {
    
    
    NSURL *url = [NSURL URLWithString:baseURL];
    
    url = [url URLByAppendingPathComponent:@"manifests"];
    url = [url URLByAppendingPathComponent:roverName];
    
    
    NSURLComponents * urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];;
    
    NSURLQueryItem *queryItemApiKey = [NSURLQueryItem queryItemWithName:@"api_key" value:apiKey];
    [urlComponents setQueryItems:@[queryItemApiKey]];
    
    NSURL *requestURL = [urlComponents URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          
          if (error) {
              NSLog(@"Error fetching data: %@", error);
              completion(nil, error);
              return;
          }
          if (!data) {
              NSLog(@"Data is missing");
              completion(nil, [[NSError alloc] init]);
              return;
          }
          
          NSDictionary *marsRoverJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
          if (![marsRoverJSON isKindOfClass:[NSDictionary class]]) {
              NSLog(@"JSON error, not dictinary");
              completion(nil, error);
              
              return;
          }
          NSArray *results = [marsRoverJSON objectForKey:@"photo_manifest"];
          
          OSIMarsRover *marsRover = [[OSIMarsRover alloc] init];
          
          marsRover.name = [results valueForKey:@"name"];
          marsRover.status = [results valueForKey:@"status"];
          marsRover.launchDate = [results valueForKey:@"launch_date"];
          marsRover.landingDate = [results valueForKey:@"landing_date"];
          marsRover.maxSol = [results valueForKey:@"max-sol"];
          marsRover.maxDate = [results valueForKey:@"max-date"];
          // marsRover.photos = [results valueForKey:@"photos"];
          marsRover.totalPhotos = [results valueForKey:@"total_photos"];
          
          NSArray *photoDict = [results valueForKey:@"photos"];
          
          NSMutableArray *photos = [NSMutableArray array];
          
          for (NSDictionary *phot in photoDict) {
              OSIPhoto *photo = [[OSIPhoto alloc] init];
              
              photo.sol = [phot valueForKey:@"sol"];
              photo.totalPhotos = [phot valueForKey:@"total_photos"];
              photo.earthDate = [phot valueForKey:@"earth_date"];
              photo.cameras = [phot valueForKey:@"cameras"];
              
              [photos addObject:photo];
          }
          marsRover.photos = photos;
          
          completion(marsRover, nil);
          
      }]resume];
}


- (void)fetchPhotosFrome:(OSIMarsRover *)rover onSol:(int )sol completion:(void (^)(MarsPhotoReference *dict, NSError * _Nullable))completion {
    
    NSURL *url = [NSURL URLWithString:baseURL];
    
    url = [url URLByAppendingPathComponent:@"rovers"];
    url = [url URLByAppendingPathComponent:rover.name];
    url = [url URLByAppendingPathComponent:@"photos"];
    
    NSURLComponents * urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    NSNumber *solNumber = [NSNumber numberWithInt:sol];
    NSString *solString = [NSNumberFormatter localizedStringFromNumber:solNumber numberStyle:NSNumberFormatterDecimalStyle];
    NSURLQueryItem *queryItemSol = [NSURLQueryItem queryItemWithName:@"sol" value:solString];
    NSURLQueryItem *queryItemApiKey = [NSURLQueryItem queryItemWithName:@"api_key" value:apiKey];
    [urlComponents setQueryItems:@[queryItemApiKey, queryItemSol]];
    
    NSURL *requestURL = [urlComponents URL];
 //   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    
  //  NSData *data = [NSData dataWithContentsOfURL:requestURL];
    [[[NSURLSession sharedSession] dataTaskWithURL:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
//    [[[NSURLSession sharedSession] dataTaskWithRequest:requestURL completionHandler:
//      ^(NSData * _Nullable data,
//        NSURLResponse * _Nullable response,
//        NSError * _Nullable error) {
        
          if (error) {
              NSLog(@"Error fetching data: %@", error);
              completion(nil, error);
              return;
          }
          if (!data) {
              NSLog(@"Data is missing");
              completion(nil, [[NSError alloc] init]);
              return;
          }
        NSError *decodingError = nil;
        NSDictionary *decodedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&decodingError];
        
        if (decodingError != nil) {
            NSLog(@"Error decoding JSON: %@", decodingError);
            completion(nil, decodingError);
            return;
        }
        
        if ([decodedObject isKindOfClass:[NSDictionary class]] == NO) {
            NSLog(@"JSON result is not a dictionary");
            completion(nil, nil);
            return;
        }
        
        NSArray *results = [decodedObject objectForKey:@"photos"];
        if ([results isKindOfClass:[NSArray class]] == NO) {
            NSLog(@"JSON does not have results array");
            completion(nil, nil);
            return;
        }
        
        MarsPhotoReference *firstResult = [results firstObject];
        if ([firstResult isKindOfClass:[NSDictionary class]] == NO) {
            NSLog(@"First JSON result is not a dictionary");
            completion(nil, nil);
            return;
        }
        
        completion(firstResult, nil);
       
          
      }]resume];
      }
      
      @end
      
