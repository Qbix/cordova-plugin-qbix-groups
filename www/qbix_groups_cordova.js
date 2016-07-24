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
	setList: function(sectionsList, onSuccess, onError) {
	   var finishedList = [];
       if(sectionsList != undefined && sectionsList instanceof Array) {
           for(var i=0; i < sectionsList.length; i++) {
               var title = sectionsList[i].title;
               var items = sectionsList[i].items;
               var after = sectionsList[i].after;
       
               if(!Utils.hasValue(SECTION_ITEM.GROUPS_SECTIONS, after))
               return onError(GroupsError.NOT_EXIST_SECTION);
               
               if(items == undefined || !(items instanceof Array))
               return onError(GroupsError.LIST_NOT_ARRAY)
               
               
               if(!GroupsUtils.isValidObjectsInArray(items, SECTION_ITEM))
               return onError(GroupsError.PROVIDE_DATA_ISNT_SECTION_ITEM)
       
               finishedList.push(sectionsList[i]);
           }
       
       }
    
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "setList", [finishedList]);
	},
	setActions: function(listActions, onSuccess, onError) {
		if(listActions == undefined || !(listActions instanceof Array))
			return onError(GroupsError.LIST_NOT_ARRAY)

		if(!GroupsUtils.isValidObjectsInArray(listActions, ACTION_ITEM))
			return onError(GroupsError.PROVIDE_DATA_ISNT_ACTION_ITEM)

		cordova.exec(onSuccess, onError, BRIDGE_NAME, "setActions", [listActions]);
	},
	showFullscreen: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "showFullscreen", []);
    },
    hideFullscreen: function (height, onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "hideFullscreen", [height]);
    },
    showOptions: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "showOptions", []);
    },
    showEnhance: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "showEnhance", []);
    },
    showSupport: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "showSupport", []);
    },
    showEdit: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "showEdit", []);
    },
    deleteStickyAds: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "deleteStickyAds", []);
    },
    // cordovaRevertWebMode: function () {
    //     cordova.exec(function(msg){}, function(err){}, "QGroupsCordova", "cordovaRevertWebMode", []);
    // },
    closeModalWebView: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "closeModalWebView", []);
    },
    
}


module.exports = Main;

// module.exports = {
//     hello: function (name, successCallback, errorCallback) {
//         cordova.exec(successCallback, errorCallback, "QbixGroupsCordova", "hello", [name]);
//     }
// };

