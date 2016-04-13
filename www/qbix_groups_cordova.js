var GroupsError = require("./Cordova.GroupsError"),
	GroupsUtils = require("./Cordova.GroupsUtils"),
	Utils = require("./Cordova.GroupsUtils"),
	SECTION_ITEM = require("./Cordova.SectionItem"),
	ACTION_ITEM = require("./Cordova.ActionItem")


var BRIDGE_NAME = "QbixGroupsCordova";

var Main = {
 //    convertGroupsBinFileToJson: function(onSuccess, onError) {
	// 	exec(onSuccess,onError,'QbixGroupsCordova','convertGroupsBinFileToJson', []);
	// },
	setList: function(title, listInfo, after, onSuccess, onError) {
		if(!Utils.hasValue(SECTION_ITEM.GROUPS_SECTIONS, after))
			return onError(GroupsError.NOT_EXIST_SECTION);

		if(listInfo == undefined || !(listInfo instanceof Array))
			return onError(GroupsError.LIST_NOT_ARRAY)

		
		if(!GroupsUtils.isValidObjectsInArray(listInfo, SECTION_ITEM))
			return onError(GroupsError.PROVIDE_DATA_ISNT_SECTION_ITEM)

		cordova.exec(onSuccess, onError, BRIDGE_NAME, "setList", [listInfo, after, title]);
	},
	setActions: function(listActions, onSuccess, onError) {
		if(listActions == undefined || !(listActions instanceof Array))
			return onError(GroupsError.LIST_NOT_ARRAY)

		if(!GroupsUtils.isValidObjectsInArray(listActions, ACTION_ITEM))
			return onError(GroupsError.PROVIDE_DATA_ISNT_ACTION_ITEM)

		cordova.exec(onSuccess, onError, BRIDGE_NAME, "setActions", [listActions]);
	},
	cordovaShowFullscreen: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "cordovaShowFullscreen", []);
    },
    cordovaHideFullscreen: function (height, onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "cordovaHideFullscreen", [height]);
    },
    cordovaShowOptions: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "cordovaShowOptions", []);
    },
    cordovaShowEnhance: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "cordovaShowEnhance", []);
    },
    cordovaShowSupport: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "cordovaShowSupport", []);
    },
    cordovaShowEdit: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "cordovaShowEdit", []);
    },
    cordovaDeleteStickyAds: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "cordovaDeleteStickyAds", []);
    },
    // cordovaRevertWebMode: function () {
    //     cordova.exec(function(msg){}, function(err){}, "QGroupsCordova", "cordovaRevertWebMode", []);
    // },
    cordovaCloseModalWebView: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "cordovaСloseModalWebView", []);
    }
}


module.exports = Main;

// module.exports = {
//     hello: function (name, successCallback, errorCallback) {
//         cordova.exec(successCallback, errorCallback, "QbixGroupsCordova", "hello", [name]);
//     }
// };

