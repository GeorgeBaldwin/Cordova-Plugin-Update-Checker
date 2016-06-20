/*global cordova, module*/

module.exports = {
    checkUpdate: function (name, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Hello", "Check", [name]);
    },
    successCallback : function(data){
        // Handle success here
    },
    errorCallback : function(data){
        // Handle Error Here
    }
};

window.check_for_app_update = checkUpdate;
