# Weather Forecast App

An application to fetch the weather forecast of multiple cities. The user can get the user's current city weather forecast details and user can search by using citynames. If the user is searching by city name, th user should enter minimum 3 cities and he can enter maximum 7 cities. The multiple city names will be comma seperated.

## Getting Started
We are using [OpenWeather](http://openweathermap.org) API to get the weather forecast details.
### How to run the project?

1. Clone this repo.
1. Open `WeatherForecast.xcworkspace` and run the project on selected device or simulator.

### Dependencies

Thrid party framewoks and Library are managed using Cocoapods.

### Pods used 
	- pod 'Alamofire'
	- pod 'AlamofireImage'
  
### Folder structure and architecture

Here, we are using MVVM architectural pattern.
- Model folder contains all the models.
- View folder contains all the ViewControllers and views.
- ViewModel folder contains all the business logics.
- Helper folder contains Network Engine, Constants and some utility files.
- NetworkCalls contains all the web service calls.
- Supporting file contains AppDeletegate, Storyboards and images.
- Extensions contains the added extension files.

### Screenwise details

There are total 4 screens for this application
1. Splash screen.
1. Home screen
    - The name of the ViewController is `WeatherForecastByCityNameViewController`
    - This ViewController is managing all the tasks related to getting weather forecast reports by entering city names.
1. City name selection screen
    - If the user typed cityname is not unique, then we will show a list of available city names and ask the user to select their desired city name.
    - This is managed by `CityNameSelectionViewController`
1. Current location screen
    - Here we will show the 5 days weather forecast deatils of the user's current location.
    - We will get the current location by using GPS.
    - This is managed by `CurrentLocationViewController`

## Running the tests

### Prerequisites

We are using [Slather](https://github.com/SlatherOrg/slather) to get code coverage report.

To install the gem, open terminal and copy paste the below command

```
sudo gem install slather
```

### Running the test cases

  1. Open `WeatherForecast.xcworkspace`
  1. Click `command + U` or go to `Product` -> `Test`
  1. Now the xcode will start build and run the test cases.
  1. Click the Test Navigator icon to view the status and results of the tests.

### Generate coverage report

  1. Make sure that the slather is installed.
  1. Run the test cases on Xcode.
  1. Open `Terminal`
  1. Then run (Replace the path/to/ with the exact path of the file)
  1. After finishing, a new window will be open in your browser with the code coverage report.
  
  ```
  slather coverage --show --html --scheme WeatherForecast --workspace path/to/WeatherForecast.xcworkspace path/to/WeatherForecast.xcodeproj
  ```

#### Please note

If you are installing to a device having iOS 13.3.1, please add a Provisioning Profile with a valid developer account. 
Many developers reported a crash due to this reason.
