module.exports = {
    hello: function (name, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "QbixGroupsCordova", "hello", [name]);
    }
};


