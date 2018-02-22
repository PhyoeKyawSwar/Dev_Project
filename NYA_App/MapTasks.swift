//
//  MapTasks.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 8/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import Foundation
import CoreLocation

let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"

var selectedRoute: Dictionary<NSObject, AnyObject>!

var overviewPolyline: Dictionary<NSObject, AnyObject>!

var originCoordinate: CLLocationCoordinate2D!

var destinationCoordinate: CLLocationCoordinate2D!

var originAddress: String!

var destinationAddress: String!


