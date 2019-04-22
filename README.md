# Portfolio-Light

*UNDER DEVELOPMENT*: 
The idea of Portfolio Light is to have a very lightweight asset (stocks, crypto) etc. portfolio. You can add your assets, provide the time of when they were bought and everytime you open the app, you would be able to see the profit or loss of the assets. It should be seen as a fun and aesthetically pleasing gimmick to monitor your assets, no more, no less.

The app uses the Alpha Vantage API and to run the app. To actually run the project, go into the Model folder and create a file called Constants.swift. In this file add the following code:

import Foundation

struct Constants {
    
    struct AlphaVantageAPI {
        static let key = "INSERT KEY HERE"
    }
}
Where you replace the "INSERT KEY HERE" with your own API key, which can be generated through this link: https://www.alphavantage.co/support/#api-key 

The in-app charts are generated with the Charts library: https://github.com/danielgindi/Charts/
