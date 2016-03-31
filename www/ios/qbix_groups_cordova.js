var exec = require('cordova/exec');
var qbix_groups_cordova = require('../qbix_groups_cordova.js');

qbix_groups_cordova.convertGroupsBinFileToJson = function(onSuccess, onError) {
	exec(onSuccess,onError,'QGroups','convertGroupsBinFileToJson', []);
}

module.exports = qbix_groups_cordova;