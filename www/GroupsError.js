var GROUPS_ERROR = {
	NOT_EXIST_SECTION: {
		code: 1,
		msg: "after section not exist"
	},
	LIST_NOT_ARRAY: {
		code: 2,
		msg: "list param must be array"
	},
	PROVIDE_DATA_ISNT_SECTION_ITEM: {
		code: 3,
		msg: "provide data must be array instaces of SectionItem class"
	},
	PROVIDE_DATA_ISNT_ACTION_ITEM: {
		code: 4,
		msg: "provide data must be array instaces of ActionItem class"
	}
}

module.exports = GROUPS_ERROR;