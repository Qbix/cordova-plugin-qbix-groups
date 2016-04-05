var GroupsSections = require("./Cordova.GroupsSections"),
	GroupsError = require("./Cordova.GroupsError"),
	GroupsUtils = require("./Cordova.GroupsUtils"),
	Utils = require("./Cordova.GroupsUtils"),
	SECTION_ITEM = require("./Cordova.SectionItem"),
	ACTION_ITEM = require("./Cordova.ActionItem")


var Main = {
    convertGroupsBinFileToJson: function(onSuccess, onError) {
		exec(onSuccess,onError,'QbixGroupsCordova','convertGroupsBinFileToJson', []);
	},
	setList: function(listInfo, after, onSuccess, onError) {
		if(!Utils.hasValue(GroupsSections, after))
			return onError(GroupsError.NOT_EXIST_SECTION);

		if(listInfo == undefined || !(listInfo instanceof Array))
			return onError(GroupsError.LIST_NOT_ARRAY)

		
		if(!GroupsUtils.isValidObjectsInArray(listInfo, SECTION_ITEM))
			return onError(GroupsError.PROVIDE_DATA_ISNT_SECTION_ITEM)

		cordova.exec(onSuccess, onError, "QbixGroupsCordova", "setList", [listInfo, after]);
	},
	setActions: function(listActions, onSuccess, onError) {
		if(listActions == undefined || !(listActions instanceof Array))
			return onError(GroupsError.LIST_NOT_ARRAY)

		if(!GroupsUtils.isValidObjectsInArray(listActions, ACTION_ITEM))
			return onError(GroupsError.PROVIDE_DATA_ISNT_ACTION_ITEM)

		cordova.exec(onSuccess, onError, "QbixGroupsCordova", "setActions", [listActions]);
	}
}


module.exports = Main;

// module.exports = {
//     hello: function (name, successCallback, errorCallback) {
//         cordova.exec(successCallback, errorCallback, "QbixGroupsCordova", "hello", [name]);
//     }
// };

