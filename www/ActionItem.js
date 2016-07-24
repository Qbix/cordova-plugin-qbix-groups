var GROUPS_ACTIONS = {
	SEND_SMS:0,
	SEND_EMAIL:1,
	SHARE_LOCATION:2,
	COPY_CONTACTS:3,
	REMIND_ME_LATER:4,
	DELETE_CONTACTS:5,
	EMAIL_CONTACTS_IMPORT:6,
    CUSTOM_ACTION: 7,
    DUPLICATE_CONTACTS: 8,
    GROUPS_CONTACTS: 9,
    DELETE_CONTACTS_FROM_GROUP: 10
}

var ActionItem = function(title, icon, action, isNew, url) {
	this.title = title;
	this.icon = icon;
	this.action = action;
	this.isNew = isNew;
	this.url = url;
}

module.exports = ActionItem;
module.exports.CONST_ACTIONS = GROUPS_ACTIONS;