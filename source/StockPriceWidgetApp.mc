import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class StockPriceWidgetApp extends Application.AppBase {
    public var stock as Lang.Array = [];
    
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        getPrices(Properties.getValue("portfolio"));
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
            for( var i = 0; i < data.size(); i++ ) {
            var newStock = {};
            newStock.put("symbol", data[i]["symbol"]);
            newStock.put("bid", data[i]["last_price"]);
            stock.add(newStock);
            Storage.setValue("stock",stock);
            WatchUi.requestUpdate();
            }
        } else {
            // Handle error here
            System.println("Error in API call. Response code: " + responseCode + " Data: " + data);
        }
   }

   function getPrices(portfolio) {
       var url = "https://stockprice.fly.dev/get_last_prices";                         // set the url
        
       var params = {                                              // set the parameters
              "symbols" => portfolio
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
}

function getApp() as StockPriceWidgetApp {
    return Application.getApp() as StockPriceWidgetApp;
}