//
//  API.swift
//  Virtual Tourist
//
//  Created by Deema  on 14/07/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct API {
    
    static func getPhotosUrls(with coordinate: CLLocationCoordinate2D, pageNumber: Int, completion: @escaping ([URL]?, Error?, String?) -> ()) {
        let methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.BoundingBox: bboxString(for: coordinate),
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback,
            Constants.FlickrParameterKeys.Page: pageNumber,
            Constants.FlickrParameterKeys.PerPage: Constants.FlickrParameterValues.PerPage,
            ] as [String:Any]
        
        
        let request = URLRequest(url: getURL(from: methodParameters))
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else {
                completion(nil, error, nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil, nil, "Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                completion(nil, nil, "No data was returned by the request!")
                return
            }
            
            //            print(String(data: data, encoding: .utf8)!)
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                completion(nil, nil, "Could not parse the data as JSON.")
                return
            }
            
            guard let stat = result!["stat"] as? String, stat == "ok" else {
                completion(nil, nil, "Flickr API returned an error. See error code and message in \(result)")
                return
            }
            
            guard let photosDictionary = result!["photos"] as? [String:Any] else {
                completion(nil, nil, "Cannot find key 'photos' in \(result)")
                return
            }
            
            guard let photosArray = photosDictionary["photo"] as? [[String:Any]] else {
                completion(nil, nil, "Cannot find key 'photo' in \(photosDictionary)")
                return
            }
            
            let photosURLs = photosArray.compactMap { photoDictionary -> URL? in
                guard let url = photoDictionary["url_m"] as? String else { return nil}
                return URL(string: url)
            }

            completion(photosURLs, nil, nil)
        }
        
        task.resume()
    }
    
    static func bboxString(for coordinate: CLLocationCoordinate2D) -> String {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        let minimumLon = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, -180)
        let minimumLat = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, -90)
        let maximumLon = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, 180)
        let maximumLat = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, 90)
        
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    }
    
    
    
    static func getURL(from parameters: [String:Any]) -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest"
        components.queryItems = [URLQueryItem]()
        
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}
