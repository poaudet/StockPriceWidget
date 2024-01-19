import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.System;
import Toybox.Application;

class StockPriceWidgetView extends WatchUi.View {
    public var portfolio as Array = [];
    public var stock as Array = [];

    function initialize() {
        View.initialize();
    }
    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        if (Storage.getValue("portfolio") == null){
            Storage.setValue("portfolio", []);
        }
        if (Storage.getValue("stock") == null){
            Storage.setValue("stock", []);
        }
        portfolio = Storage.getValue("portfolio");
        stock = Storage.getValue("stock"); 
        if (portfolio.size() > 10){
            var message = new WatchUi.Text({
            :text=>"The list is greater\n than 10 item.\n Please remove item.",
            :color=>Graphics.COLOR_RED,
            :font=>Graphics.FONT_SMALL,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER,
            });
            message.draw(dc);
        }
        else if (stock.size() > 0){
            for( var i = 0; i < stock.size(); i++ ) {
                var textColor;
                if (stock[i]["price_change"] == null){
                    textColor = Graphics.COLOR_WHITE;
                }
                else if (stock[i]["price_change"] > 0){
                    textColor = Graphics.COLOR_GREEN;
                }
                else if (stock[i]["price_change"] < 0){
                    textColor = Graphics.COLOR_RED;
                }
                else {
                    textColor = Graphics.COLOR_WHITE;
                }
                var y = 20*i;
                var symbol = new WatchUi.Text({
                :text=>stock[i]["symbol"],
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_MEDIUM,
                :locX =>WatchUi.LAYOUT_HALIGN_LEFT,
                :locY=>y
            });
            var price = new WatchUi.Text({
                :text=>stock[i]["last_price"].format("%.2f")+"$",
                :color=>textColor,
                :font=>Graphics.FONT_MEDIUM,
                :locX =>WatchUi.LAYOUT_HALIGN_RIGHT,
                :locY=>y
            });
                symbol.draw(dc);
                price.draw(dc);
            }
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }
}
