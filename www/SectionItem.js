var GROUPS_SECTIONS = {
	STICKY:"sticky",
	GROUPS:"groups",
	SMART:"smart",
	REMINDERS:"reminders"
}


var SectionItem = function(title, icon, url) {
	this.title = title;
	this.icon = icon;
	this.url = url;
}

module.exports = SectionItem;
module.exports.GROUPS_SECTIONS = GROUPS_SECTIONS;