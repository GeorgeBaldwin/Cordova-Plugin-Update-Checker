/*global cordova, module*/

module.exports = {
    UpdateCheck: function (name, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "UpdateCheck", "check", [name]);
    },
    successCallback : function(data){
        // Handle success here
    },
    errorCallback : function(data){
        // Handle Error Here
    }
};

window.updateCheck = module.exports.UpdateCheck;
