//
//  LocationService.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@protocol LocationServiceDelegate <NSObject>

/**
 *  Gets called when all the distances for each shop are calculated.
 */
- (void)didFinishRouteDistanceCalculation;
/**
 *  Notifies the viewcontroller that implements the delegate that the users location has been retrieved.
 */
- (void)didFinishGettingUsersLocation;

@end

@interface LocationService : NSObject

@property (nonatomic, weak) id<LocationServiceDelegate> delegate;

/**
 *  Starts CLLocationManager to get users location.
 */
- (void)getUserLocation;

/**
 *  Calculates the distance for each shop between the users location and the shops location.
 
 *  NOTE:Just triggers the calculation method.
 *
 *  @param shops    Array containing all shops.
 *  @param location Users location
 */
- (void)calculateDistanceFromUserToShops:(NSArray *)shops;

@end
