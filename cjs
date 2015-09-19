#!/usr/bin/env node

require('coffee-script/register');

// Dependencies
var commander= require('commander');
var touch= require('touch');
var express= require('express');
var cjs= require('./');
var onefile= require('express-onefile');
var path= require('path');

commander
  .version(require('./package'))
  .usage('<rootDir>')
  .option('-p --port <number>','listening port <number>',59798)
  .option('-o --onefile','enable express-onefile at ./pkgs.js using ./bower.json')

commander
  .command('touch [index]')
  .description('touch the [index](.coffee .jade .styl)')
  .action(function(name){
    if(name==null){
      name= 'index';
    }

    touch.sync(name+'.coffee');
    touch.sync(name+'.jade');
    touch.sync(name+'.styl');
    process.exit(0);
  })
  .parse(process.argv)

commander
  .command('*')
  .description('boot express-cjs server')
  .action(function(dirname){
    // Environment
    var options= {}
    options.root= path.resolve(process.cwd(),dirname);

    var app= express();
    app.use(cjs(options));
    if(commander.onefile){
      app.use(onefile({cwd:options.root}));
    }
    app.listen(commander.port,function(){
      console.log('http://localhost:%s <- %s',commander.port,options.root);
    });
  })

commander.parse(process.argv)
if(process.argv.slice(2).length===0){
  commander.outputHelp()
}
