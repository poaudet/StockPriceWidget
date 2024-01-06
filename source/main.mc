var UI = require("ui");
var HttpClient = require("common/http").HttpClient;

var main = new UI.Menu({
    sections: [{
        items: [{
            title: "Fetch Data",
            subtitle: "Retrieve data from API"
        }]
    }]
});

main.show();

main.on('select', function (e) {
    if (e.item.title === "Fetch Data") {
        fetchDataFromApi();
    }
});

function fetchDataFromApi() {
    var url = "YOUR_API_ENDPOINT_URL_HERE";
    var request = new HttpClient();

    request.open("GET", url);
    request.onreadystatechange = function () {
        if (request.readyState === 4) {
            if (request.status === 200) {
                var data = JSON.parse(request.responseText);
                displayDataOnWidget(data);
            } else {
                console.error("Failed to fetch data from API. Status: " + request.status);
            }
        }
    };

    request.send();
}

function displayDataOnWidget(data) {
    var items = [];
    for (var i = 0; i < data.length; i++) {
        var item = {
            title: data[i].symbol,
            subtitle: "Price: " + data[i].price.toFixed(2) // Assuming price is a floating-point number
        };
        items.push(item);
    }

    var symbolList = new UI.Menu({
        sections: [{
            items: items
        }]
    });

    symbolList.show();
}