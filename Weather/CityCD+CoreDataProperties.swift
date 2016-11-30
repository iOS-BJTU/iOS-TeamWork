//
//  CityCD+CoreDataProperties.swift
//  
//
//  Created by ts on 2016/11/30.
//
//

import Foundation
import CoreData


extension CityCD {
    static let ApplicationSupportDirectory = FileManager().urls(for: .applicationSupportDirectory,
                                                                in: .userDomainMask).first!
    static let StoreURL = ApplicationSupportDirectory.appendingPathComponent("WeatherCity.sqlite")

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityCD> {
        return NSFetchRequest<CityCD>(entityName: "City");
    }

    @NSManaged public var city_name: String?
    @NSManaged public var temperature: String?
    @NSManaged public var image_code: String?
    @NSManaged public var is_location: Bool

}
