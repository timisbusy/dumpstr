'use strict';

var path = require('path');

global.chai = require('chai');
global.expect = global.chai.expect;

global.LIB_ROOT = path.resolve(__dirname, '../lib');
