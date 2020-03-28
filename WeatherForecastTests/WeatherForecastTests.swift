//
//  WeatherForecastTests.swift
//  WeatherForecastTests
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import XCTest
@testable import WeatherForecast

private var currentCurrentLocatioVC: CurrentLocationViewController!
private let  weatherViewModel = WeatherViewModel()
//let app = XCUIApplication()
let networkCall = NetworkCalls()
let currentLocationViewModel = CurrentLocationViewModel()
var detailTableViewCell: DetailTableViewCell!
var cityNameTableViewCell: CityNameTableViewCell!
var weatherTableViewCell: WeatherTableViewCell!
var detailCellViewModel: DetailCellViewModel!
var weatherCellViewModel: WeatherCellViewModel!
var cityNameCellViewModel: CityNameCellViewModel!
var cityNameViewModel: CityNameViewModel!



class WeatherForecastTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = true
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        currentCurrentLocatioVC = storyBoard.instantiateViewController(identifier: "CurrentLocationViewController")
        
        cityNameTableViewCell = Bundle.main.loadNibNamed("CityNameTableViewCell", owner: nil, options: nil)?.first as? CityNameTableViewCell
        detailTableViewCell = Bundle.main.loadNibNamed("DetailTableViewCell", owner: nil, options: nil)?.first as? DetailTableViewCell
        weatherTableViewCell = Bundle.main.loadNibNamed("WeatherTableViewCell", owner: nil, options: nil)?.first as? WeatherTableViewCell
    }

    func test_Invalid_CityNames_As_Input() {
        weatherViewModel.dataSource.removeAll()
        weatherViewModel.searchBarSearchButtonClicked(with: ["CityName1","CityName2","CityName3"])
        let expectation3 = XCTestExpectation(description: "Empty DataSource Of WeatherViewModel")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            XCTAssertTrue(weatherViewModel.dataSource.count == 0)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 10.0)
        
    }
    func test_Correct_CityNames_As_Input() {
        let expectation = XCTestExpectation(description: "Citiinfo received")

        DataContainerSingleTon.shared.loadLocalCityNames(completion: {(status) in
            print("Citiinfo received -> \(status)")
            XCTAssertTrue(DataContainerSingleTon.shared.cityNames.count > 0)
            XCTAssertEqual(DataContainerSingleTon.shared.cityNames.count, 209577)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 20.0)

        DataContainerSingleTon.shared.useStubData = true
        weatherViewModel.dataSource.removeAll()

        weatherViewModel.searchBarSearchButtonClicked(with: ["dubai","sharjah","chennai"])
        let expectation1 = XCTestExpectation(description: "Fill DataSource Of WeatherViewModel")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            XCTAssertTrue(weatherViewModel.dataSource.count > 0)
                expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 10.0)
    }
    
    func test_Correct_Lat_Long_As_Input() {
        currentLocationViewModel.userLocationRecieved("37.785834", longitude: "-122.406417")
        let expectation2 = XCTestExpectation(description: "Check DataSource Of currentLocationViewModel has value")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            XCTAssertTrue(currentLocationViewModel.dataSource.count > 0)
                expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 10.0)
    }
    func test_Utility_Methods() {
        
        var weatherJSONForMulitCities = Utility.getLocalData(of: "WEATHER_FOR_MULTIPLE_CITIES", type: "json")
        XCTAssertNotNil(weatherJSONForMulitCities.data)
        XCTAssertNotNil(weatherJSONForMulitCities.dictionary)

        weatherJSONForMulitCities = Utility.getLocalData(of: "THERE_IS_NO_SUCH_FILE", type: "json")
        XCTAssertNil(weatherJSONForMulitCities.data)
        XCTAssertNil(weatherJSONForMulitCities.dictionary)

        weatherJSONForMulitCities = Utility.getLocalData(of: "WEATHER_FOR_MULTIPLE_CITIES", type: "UNKNOWN_FILE_NAME")
        XCTAssertNil(weatherJSONForMulitCities.data)
        XCTAssertNil(weatherJSONForMulitCities.dictionary)

        weatherJSONForMulitCities = Utility.getLocalData(of: "THERE_IS_NO_SUCH_FILE", type: "UNKNOWN_FILE_NAME")
        XCTAssertNil(weatherJSONForMulitCities.data)
        XCTAssertNil(weatherJSONForMulitCities.dictionary)
        
//        Utility.showAlert("Sorry", message: "errorMessage", sender: currentCityVC)
        XCTAssertTrue((UIApplication.topViewController()?.isKind(of: WeatherForecastByCityNameViewController.self))!)
        Utility.showAlert("Sorry", message: "errorMessage", sender: currentCurrentLocatioVC)
        XCTAssertTrue((UIApplication.topViewController()?.isKind(of: WeatherForecastByCityNameViewController.self))!)

        var unixDate = 1585429200
        var utcTimeZone = TimeZone(secondsFromGMT: 0)
        var time = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .h_mm_a, timeZone: utcTimeZone)
        var day = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .ee, timeZone: utcTimeZone).uppercased()
        var date = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .dd, timeZone: utcTimeZone)
        XCTAssertNotNil(time)
        XCTAssertNotNil(day)
        XCTAssertNotNil(date)

        unixDate = 0
        time = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .h_mm_a, timeZone: utcTimeZone)
        day = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .ee, timeZone: utcTimeZone).uppercased()
        date = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .dd, timeZone: utcTimeZone)
        XCTAssertEqual(time, "12:00 AM")
        XCTAssertEqual(day, "THU")
        XCTAssertEqual(date, "01")


        unixDate = -1
        time = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .h_mm_a, timeZone: utcTimeZone)
        day = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .ee, timeZone: utcTimeZone).uppercased()
        date = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .dd, timeZone: utcTimeZone)
        XCTAssertEqual(time, "11:59 PM")
        XCTAssertEqual(day, "WED")
        XCTAssertEqual(date, "31")

        unixDate = 0
        utcTimeZone = nil
        time = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .h_mm_a, timeZone: utcTimeZone)
        day = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .ee, timeZone: utcTimeZone).uppercased()
        date = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .dd, timeZone: utcTimeZone)
        XCTAssertEqual(time, "4:00 AM")
        XCTAssertEqual(day, "THU")
        XCTAssertEqual(date, "01")
    }
    func test_NetworkParser() {
        var weatherJSONForMulitCities = Utility.getLocalData(of: "THERE_IS_NO_SUCH_FILE", type: "json")
        var parsingStauts = NetworkParser.parse(weatherJSONForMulitCities.dictionary ?? [String: Any]())
        XCTAssertFalse(isReponseReceived(parsingStauts))
        
        weatherJSONForMulitCities = Utility.getLocalData(of: "WEATHER_FOR_MULTIPLE_CITIES", type: "json")
        parsingStauts = NetworkParser.parse(weatherJSONForMulitCities.dictionary ?? [String: Any]())
        XCTAssertTrue(isReponseReceived(parsingStauts))
    }
        
    func isReponseReceived(_ responseState: ResponseState) -> Bool {
        switch responseState {
        case .success:
            return  true
        case .failure:
            return  false
        }
    }
    
    func test_CommonLoader() {
        CommonLoader.showSpinner()
        XCTAssertTrue(CommonLoader.alertController.view.subviews.count == 2)
        CommonLoader.hideSpinner()
        XCTAssertTrue(CommonLoader.alertController.view.subviews.count == 2)
    }
    func test_DetailTableViewCell_Not_Nil() {
        XCTAssertNotNil(detailTableViewCell)
        let title = "Test"
        detailTableViewCell.updateUI(DetailCellViewModel.init(DetailsListModel.init(title: title, image: nil)))
        XCTAssertEqual(detailTableViewCell.descriptionLabel.text, title)
        XCTAssertEqual(detailTableViewCell.weatherImage.isHidden, true)
        
        
        detailTableViewCell.updateUI(DetailCellViewModel.init(DetailsListModel.init(title: title, image: "someURL")))
        XCTAssertEqual(detailTableViewCell.descriptionLabel.text, title)
        XCTAssertEqual(detailTableViewCell.weatherImage.isHidden, false)

    }
    
    func test_CityNameTableViewCell_Not_Nil() {
        XCTAssertNotNil(cityNameTableViewCell)
        var weatherData = [Weather]()
        let weather = Weather.init(description: "overcast clouds", icon: "04n")
        weatherData.append(weather)
        let tempMin = 9.3499999999999996
        let tempMax = 9.3800000000000008
        let temp = 9.3499999999999996
        let name = "San Francisco"
        let speed = 0.81000000000000005

        let main = Main.init(tempMin: tempMin, tempMax: tempMax, temp: temp)
        let wind = Wind.init(speed: speed)

        cityNameTableViewCell.updateUI(CityNameCellViewModel.init(WeatherModel.init(weather: weatherData, main: main, wind: wind, name: name, unixDate: 1585396800)))
        XCTAssertEqual(cityNameTableViewCell.cityName.text, name)
    }
    
    func test_WeatherTableViewCell_Not_Nil() {
        XCTAssertNotNil(weatherTableViewCell)
    }
    
    func test_DetailCellViewModel_Not_Nil() {
        var title = "Test"
        detailCellViewModel = DetailCellViewModel.init(DetailsListModel.init(title: title, image: "ImageURL"))
        XCTAssertNotNil(detailCellViewModel)
        XCTAssertFalse(detailCellViewModel.showImage())
        XCTAssertNotNil(detailCellViewModel.description())
        XCTAssertTrue(detailCellViewModel.description().count > 0)
        XCTAssertNotNil(detailCellViewModel.getURL())

        detailCellViewModel = DetailCellViewModel.init(DetailsListModel.init(title: title, image: ""))
        XCTAssertNotNil(detailCellViewModel)
        XCTAssertFalse(detailCellViewModel.showImage())
        XCTAssertNotNil(detailCellViewModel.description())
        XCTAssertTrue(detailCellViewModel.description().count > 0)
        XCTAssertNotNil(detailCellViewModel.getURL())

        detailCellViewModel = DetailCellViewModel.init(DetailsListModel.init(title: title, image: nil))
        XCTAssertNotNil(detailCellViewModel)
        XCTAssertTrue(detailCellViewModel.showImage())
        XCTAssertNotNil(detailCellViewModel.description())
        XCTAssertTrue(detailCellViewModel.description().count > 0)
        XCTAssertNil(detailCellViewModel.getURL())

        title = ""
        detailCellViewModel = DetailCellViewModel.init(DetailsListModel.init(title: title, image: nil))
        XCTAssertNotNil(detailCellViewModel)
        XCTAssertTrue(detailCellViewModel.showImage())
        XCTAssertTrue(detailCellViewModel.description().count == 0)
        XCTAssertNil(detailCellViewModel.getURL())

    }
    
    func test_WeatherCellViewModel_Not_Nil() {
        var weatherData = [Weather]()
        let weather = Weather.init(description: "overcast clouds", icon: "04n")
        weatherData.append(weather)
        let tempMin = 9.3499999999999996
        let tempMax = 9.3800000000000008
        let temp = 9.3499999999999996
        let name = "San Francisco"
        let speed = 0.81000000000000005

        let main = Main.init(tempMin: tempMin, tempMax: tempMax, temp: temp)
        let wind = Wind.init(speed: speed)

        weatherCellViewModel = WeatherCellViewModel.init(WeatherModel.init(weather: weatherData, main: main, wind: wind, name: name, unixDate: 1585396800))
        
        XCTAssertNotNil(weatherCellViewModel.viewModel(for: IndexPath(row: 0, section: 0)))
        XCTAssertNotNil(weatherCellViewModel.weatherModel)
        XCTAssertNotNil(weatherCellViewModel.internalDataSoruce)
        XCTAssertTrue(weatherCellViewModel.internalDataSoruce.count > 0)
        XCTAssertTrue(weatherCellViewModel.internalDataSoruce.count == 2)
        
        XCTAssertEqual(weatherCellViewModel.tempMin(), "Temp Min: \(tempMin)")
        XCTAssertEqual(weatherCellViewModel.tempMax(), "Temp Max: \(tempMax)")
        XCTAssertEqual(weatherCellViewModel.temp(), "\(temp)°C")
        XCTAssertEqual(weatherCellViewModel.name(), name)
        XCTAssertNotNil(weatherCellViewModel.description())
        
        XCTAssertEqual(weatherCellViewModel.miniMaxTemp(), "Min: \(tempMin)° Max: \(tempMax)°")

        XCTAssertEqual(weatherCellViewModel.wind(), "Wind \(speed) m/s")
        XCTAssertNotNil(weatherCellViewModel.getURL())
        
        let (time, date, day) = weatherCellViewModel.getTimeDateDay()!
        XCTAssertEqual(time, "12:00 PM")
        XCTAssertEqual(date, "28")
        XCTAssertEqual(day, "SAT")
    }
    func test_CityNameCellViewModel_Not_Nil() {
        
        var weatherData = [Weather]()
        let weather = Weather.init(description: "overcast clouds", icon: "04n")
        weatherData.append(weather)
        let tempMin = 9.3499999999999996
        let tempMax = 9.3800000000000008
        let temp = 9.3499999999999996
        let name = "San Francisco"
        let speed = 0.81000000000000005

        let main = Main.init(tempMin: tempMin, tempMax: tempMax, temp: temp)
        let wind = Wind.init(speed: speed)

        cityNameCellViewModel = CityNameCellViewModel.init(WeatherModel.init(weather: weatherData, main: main, wind: wind, name: name, unixDate: 1585396800))

        XCTAssertNotNil(cityNameCellViewModel.weatherModel)
        XCTAssertEqual(cityNameCellViewModel.name(), name)


    }
        func test_CityNameViewModel_Not_Nil() {
            
            let name = "Dibba Al-Hisn"
            let country = "AE"
            let coord = Coord.init(lon: 56.272911, lat: 25.619551)

            var cityData = [CityName]()
            let cityName = CityName.init(id: 292239, name: "Dibba Al-Hisn", country: "AE", coord: coord)
            cityData.append(cityName)
        
            cityNameViewModel = CityNameViewModel.init(cityData, "Dibba Al-Hisn")
            XCTAssertEqual(cityNameViewModel.cityName(for: IndexPath(row: 0, section: 0)),
                           "\(name) \nCountry: \(country) \nGeo coords [\(coord.lon), \(coord.lat)]")

        }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        detailTableViewCell = nil
        cityNameTableViewCell = nil
        weatherTableViewCell = nil
        detailCellViewModel = nil
        weatherCellViewModel = nil
        cityNameCellViewModel = nil
        cityNameViewModel = nil
    }

    

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
