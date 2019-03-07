//
//  OSIMarsPhoto.h
//  Objc Mars Rover
//
//  Created by Sergey Osipyan on 3/6/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OSIMarsPhoto;
@class OSIPhoto;
@class OSIPhotoCamera;
@class OSIFullName;
@class OSICameraName;
@class OSIRover;
@class OSICameraElement;
@class OSIRoverName;
@class OSIStatus;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Boxed enums

@interface OSIFullName : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (OSIFullName *)chemistryAndCameraComplex;
+ (OSIFullName *)frontHazardAvoidanceCamera;
+ (OSIFullName *)marsDescentImager;
+ (OSIFullName *)marsHandLensImager;
+ (OSIFullName *)mastCamera;
+ (OSIFullName *)navigationCamera;
+ (OSIFullName *)rearHazardAvoidanceCamera;
@end

@interface OSICameraName : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (OSICameraName *)chemcam;
+ (OSICameraName *)fhaz;
+ (OSICameraName *)mahli;
+ (OSICameraName *)mardi;
+ (OSICameraName *)mast;
+ (OSICameraName *)navcam;
+ (OSICameraName *)rhaz;
@end

@interface OSIRoverName : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (OSIRoverName *)curiosity;
@end

@interface OSIStatus : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (OSIStatus *)active;
@end

#pragma mark - Object interfaces

@interface OSIMarsPhoto : NSObject
@property (nonatomic, nullable, copy) NSArray<OSIPhoto *> *photos;
@end

@interface OSIPhoto : NSObject
@property (nonatomic, nullable, strong) NSNumber *identifier;
@property (nonatomic, nullable, strong) NSNumber *sol;
@property (nonatomic, nullable, strong) OSIPhotoCamera *camera;
@property (nonatomic, nullable, copy)   NSString *img_Src;
@property (nonatomic, nullable, copy)   NSString *earth_Date;
@property (nonatomic, nullable, strong) OSIRover *rover;
@end

@interface OSIPhotoCamera : NSObject
@property (nonatomic, nullable, strong) NSNumber *identifier;
@property (nonatomic, nullable, assign) OSICameraName *name;
@property (nonatomic, nullable, strong) NSNumber *roverID;
@property (nonatomic, nullable, assign) OSIFullName *fullName;
@end

@interface OSIRover : NSObject
@property (nonatomic, nullable, strong) NSNumber *identifier;
@property (nonatomic, nullable, assign) OSIRoverName *name;
@property (nonatomic, nullable, copy)   NSString *landingDate;
@property (nonatomic, nullable, copy)   NSString *launchDate;
@property (nonatomic, nullable, assign) OSIStatus *status;
@property (nonatomic, nullable, strong) NSNumber *maxSol;
@property (nonatomic, nullable, copy)   NSString *maxDate;
@property (nonatomic, nullable, strong) NSNumber *totalPhotos;
@property (nonatomic, nullable, copy)   NSArray<OSICameraElement *> *cameras;
@end

@interface OSICameraElement : NSObject
@property (nonatomic, nullable, assign) OSICameraName *name;
@property (nonatomic, nullable, assign) OSIFullName *fullName;
@end

NS_ASSUME_NONNULL_END
