const elastic = require('elasticsearch');
const client = new elastic.Client();
const templates = require('../config/templates.json');
const kibana_conf = require('../config/kibana-config.json');
const pipelines = require('../config/pipelines.json');
const _ = require('lodash');
const elk_utils = require('./elk-utils');

function createTemplates(callback) {
    "use strict";
    const keys = Object.keys(templates);
    for (let i = 0; i < keys.length; i++) {
        client.indices.putTemplate({
            create: false,
            body: templates[keys[i]],
            name: keys[i]
        }, (err, res) => {
            console.log(res);
        });
    }

    callback();
}


function createPipelines(callback) {
    "use strict";
    const keys = Object.keys(pipelines);
    for(let i = 0; i < keys.length; i++ ) {
        client.ingest.putPipeline({id: keys[i], body: pipelines[keys[i]]}, function(err, res){
            if(err) {
                console.error(err);
            } else {
                console.log(res);
            }
        });
    }

    callback();
}


function makeKibanBetter() {
    "use strict";
     const errors = [];
     let finished = 0;

     for(let i = 0; i < kibana_conf.templates.length; i++) {
        let el = kibana_conf.templates[i];
        console.log('Going create ' + el._id);
        client.index({
            index: el._index,
            type: el._type,
            id: el._id,
            body: el._source
        }, (err, res) => {
            if (err) {
                console.error(err);
                errors.push(err);
            } else {
                console.log(res);
            }
            finished += 1;
        });
     }

     const interval = setInterval(() => {
         if (finished >= kibana_conf.templates.length) {
             if (errors.length === 0) {
                 process.exit(0);
             } else {
                 process.exit(1);
             }
         }
     }, 100)
}

elk_utils.waitToElastic(client, function() {
    createTemplates(() => {
        "use strict";
        makeKibanBetter();
    });

    createPipelines(function(err, res) {
        "use strict";
        console.log("Pipelines created")
    })
});




