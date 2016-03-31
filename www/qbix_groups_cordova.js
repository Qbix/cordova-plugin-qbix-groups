module.exports = {
    hello: function (name, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "QbixGroupsCordova", "hello", [name]);
    },
    convertGroupsBinFileToJson = function(onSuccess, onError) {
		exec(onSuccess,onError,'QGroups','convertGroupsBinFileToJson', []);
	}
};


