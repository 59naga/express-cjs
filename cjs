#!/usr/bin/env node

// Dependencies
var express= require('express');
var cjs= require('./');
var minimist= require('minimist');
var path= require('path');

// Environment
var args= minimist(process.argv.slice(2))._;// eg: `$ cjs . foo` -> args[0] === 'foo'

var options= {}
options.root= process.cwd();
if(args[0]){
  options.root= path.resolve(process.cwd(),args[0]);
}
if(process.env.PORT===undefined){
  process.env.PORT= 59798;
}

// Setup & Boot
var app= express();
app.use(cjs(options));
app.listen(process.env.PORT,function(){
  console.log('http://localhost:%s <- %s',process.env.PORT,options.root);
});
