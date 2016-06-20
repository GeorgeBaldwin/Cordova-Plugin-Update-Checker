/*global cordova, module*/

module.exports = {
    checkUpdate: function (name, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Hello", "Check", [name]);
    },
    successCallback : function(data){


    },
    errorCallback : function(data){


    }
};
