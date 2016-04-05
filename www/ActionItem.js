var GROUPS_ACTIONS = {
	SEND_SMS:0,
	SEND_EMAIL:1,
	SHARE_LOCATION:2,
	COPY_CONTACTS:3,
	REMIND_ME_LATER:4,
	DELETE_CONTACTS:5,
	EMAIL_CONTACTS_IMPORT:6
}

var ActionItem = function(title, icon, action) {
	this.title = title;
	this.icon = icon;
	this.action = action;
}

module.exports = ActionItem;
module.exports.CONST_ACTIONS = GROUPS_ACTIONS;