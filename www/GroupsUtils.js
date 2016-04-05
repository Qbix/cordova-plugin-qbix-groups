
var Utils = {
	hasValue: function(obj, value) {
  		for(var id in obj) {
    		if(obj[id] == value) {
      			return true;
    		}
  		}
  		return false;
	},
	isValidObjectsInArray: function(list, objClass) {
		var isValidData = true;
		for(var i=0; i < list.length; i++) {
			if(!(list[i] instanceof objClass)) {
				isValidData = false;
			}
		}
		return isValidData
	}
}

module.exports = Utils;