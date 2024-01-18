import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class StockPriceWidgetApp extends Application.AppBase {
    public var portfolio;
    public var stock as Lang.Array = [];
    
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        portfolio = toArray(Properties.getValue("portfolio"),";");
        updatePortfolio(portfolio);
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new StockPriceWidgetView() ] as Array<Views or InputDelegates>;
    }

        // set up the response callback function
   function onReceive(responseCode as Lang.Number, data as Lang.Dictionary) as Void {
        if (responseCode == 200) {
            var newStock = {};
            newStock.put("symbol", data["symbol"]);
            newStock.put("bid", data["bid"]);
            stock.add(newStock);
            Storage.setValue("portfolio", portfolio);
            Storage.setValue("stock",stock);
            WatchUi.requestUpdate();
        } else {
            // Handle error here
            System.println("Error in API call. Response code: " + responseCode + " Data: " + data);
        }
   }

   function getPrice(symbol) {
       var url = "https://api.finage.co.uk/last/stock/" + symbol;                         // set the url
        
       var params = {                                              // set the parameters
              "apikey" => "API_KEY7364NKWZGBWTK32K3EK13ITKQOYTUF8Q"
       };

       var options = {                                             // set the options
           :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
           :headers => {                                           // set headers
                   "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
                                                                   // set response type
           :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
       };

       var responseCallback = method(:onReceive);                  // set responseCallback to
                                                                   // onReceive() method
       // Make the Communications.makeWebRequest() call
       Communications.makeJsonRequest(url, params, options, responseCallback);
  }

   function updatePortfolio(portfolio) {
    for (var i = 0; i < portfolio.size(); i++) {
            var symbol = portfolio[i];
            getPrice(symbol);
        }
   }

   function toArray(string, splitter) {
    if (string == null){
        string = "AAPL;GOOG";
    }
    var array = [];  // Starting with an array of size 4
    var index = 0;
    var location;
    
    do {
        location = string.find(splitter);
        if (location != null) {            
            array.add(string.substring(0, location));
            string = string.substring(location + 1, string.length());
            index = index + 1;
        }
    } while (location != null);
    
    array.add(string);

    return array;
}


}

function getApp() as StockPriceWidgetApp {
    return Application.getApp() as StockPriceWidgetApp;
}