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
	sendSms: function(recipients, text, imageUrl, onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "sendSms", [recipients, text, imageUrl]);
    },
    sendEmail: function(recipients, subject, text, onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "sendEmail", [recipients, subject, text]);
    },

    getEmailInfo: function(cuid, onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "getEmailInfo", [cuid]);
    },
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
    getNativeTemplates: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "getNativeTemplates", []);
    },
    getSupportLanguages: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "getSupportLanguages", []);
    },
    getCurrentLanguage: function (onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "getCurrentLanguage", []);
    },
    chooseTemplate: function (data, onSuccess, onError) {
        var parameters = [];
        if(data.sms != null) {
            var text = data.sms.text;
            var image = data.sms.image
            var templateName = data.sms.templateName;
            parameters = ["sms", text, image, templateName];
        } else if(data.email != null) {
            var subject = data.email.subject;
            var body = data.email.body
            var templateName = data.email.templateName;
            parameters = ["email", subject, body, templateName];
        }
        
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "chooseTemplate", parameters);
    },
    send: function(src, state, onSuccess, onError) {
        cordova.exec(onSuccess, onError, BRIDGE_NAME, "send", [src, state]);
    }

}


module.exports = Main;

// module.exports = {
//     hello: function (name, successCallback, errorCallback) {
//         cordova.exec(successCallback, errorCallback, "QbixGroupsCordova", "hello", [name]);
//     }
// };
