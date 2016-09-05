//
//  LocationService.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import MapKit;
#import "LocationService.h"
#import "Shop.h"

#pragma mark - Class Extension -

@interface LocationService() <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) int arrayLength;
@property (nonatomic) int counter;
@property (nonatomic) CLLocation *userLocation;

@end

#pragma mark - Implementation -

@implementation LocationService

#pragma mark - Public methods

- (void)getUserLocation {
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}

- (void)calculateDistanceFromUserToShops:(NSArray *)shops {
    _arrayLength = (int)shops.count;
    _counter = 0;
    
    for (Shop *shop in shops) {
        [self getDistanceFromLocation:self.userLocation toLocation:CLLocationCoordinate2DMake(shop.latitude, shop.longitude) withShop:shop];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error getting location");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = [locations lastObject];
    if(newLocation.coordinate.latitude != 0) {
        self.userLocation = newLocation;
        [_locationManager stopUpdatingLocation];
        id<LocationServiceDelegate> delegate = self.delegate;
        if ([delegate respondsToSelector:@selector(didFinishGettingUsersLocation)]) {
            [delegate didFinishGettingUsersLocation];
        }
    }
}

#pragma mark - Private methods

/**
 @description : This function calculates the distance between users location and a point(coordinates).
 @param : Parameters are the start and end points.
 @return : Returns a string , which holds the distance calculated in KM , if no internet it returns "--".
 */
- (void)getDistanceFromLocation:(CLLocation *)startLocation toLocation:(CLLocationCoordinate2D)endLocation withShop:(Shop *)shop {
    
    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(startLocation.coordinate.latitude, startLocation.coordinate.longitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@""];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:endLocation addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    
    source = nil;
    srcMapItem = nil;
    destination = nil;
    distMapItem = nil;
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    request = nil;
    
    __weak typeof(self) weakSelf = self;
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            MKRoute *route = obj;
            shop.distanceFromUser = route.distance;
            strongSelf.counter++;
            if (strongSelf.counter == strongSelf.arrayLength) {
                id<LocationServiceDelegate> delegate = strongSelf.delegate;
                if ([delegate respondsToSelector:@selector(didFinishRouteDistanceCalculation)]) {
                    [delegate didFinishRouteDistanceCalculation];
                }
            }
        }];
    }];
}

@end
