
const waitToElastic = function(client, callback) {
    client.ping(function(err, res) {
        if(err || !res) {
            setTimeout(() => {
                console.log("[i] continue wait to elastic");
                waitToElastic(client, callback);
            }, 1000);
        } else {
            callback();
        }
    });
};
module.exports.waitToElastic = waitToElastic;