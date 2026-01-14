var exec = require("cordova/exec");
/*
module.exports = {
  login: function (success, error) {
    exec(success, error, "Signicat", "loginAppToApp", []);
  },
};

window.handleOpenURL = function(url) {
    setTimeout(function() {
        alert(url);
        console.log(url);
    }, 0);
}
*/


module.exports = {
  login: function (
    issuer,
    clientID,
    redirectURI,
    appToAppScopes,
    brokerDigidAppAcs
  ) {
    exec(
      function (result) {
                     self.alert("Success:\r\r" + result.status);
                 },
      function (error) {
                     self.alert("Error:\r\r" + error);
                 },
      "Signicat",
      "loginAppToApp",
      [
        issuer,
        clientID,
        redirectURI,
        appToAppScopes,
        brokerDigidAppAcs
      ]
    );
  },
};