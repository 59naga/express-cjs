# ExpressCjs [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> coffee-script / jade / stylus middleware for Single Page Application on Express4

## CLI - Quick usage

```bash
npm install express-cjs --global

mkdir my-project
cd my-project

echo "head" > index.jade
echo "  script(src='index.js')" >> index.jade
echo "  link(href='index.css' rel='stylesheet')" >> index.jade
echo "body" >> index.jade
echo "  h1 world" >> index.jade

more index.jade
# head
#   script(src='index.js')
#   link(href='index.css' rel='stylesheet')
# body
#   h1 world

mkdir articles

echo "require('./articles')" > index.coffee
echo "console.log 'hello?'" > articles/index.coffee

echo "console.log require('./articles/index.jade')" >> index.coffee
echo "string of jade" > articles/index.jade

echo "meyer-reset()" > index.styl
echo "@import './articles/**'" >> index.styl
echo "body{font-size:10vw}" > articles/index.styl

tree .
# my-project
# ├── index.coffee
# ├── index.jade
# ├── index.styl
# └── articles
#     ├── index.coffee
#     ├── index.jade
#     └── index.styl

cjs .
# http://localhost:59798 <- /Users/59naga/Downloads/my-project
```

## API

### `expressCjs(options)` -> middleware

* If GET `/` to parse `/index.jade`
* If GET `/index.js` to parse `/index.coffee` with [ng-annotate][1]
* If GET `/index.css` to parse `/index.styl` with [kouto-swiss][2]
* Otherwise as static serve

[1]: https://github.com/olov/ng-annotate#readme
[2]: http://kouto-swiss.io/

```js
// Dependencies
var express= require('express');
var cjs= require('express-cjs');

// Environment
if(process.env.PORT===undefined){
  process.env.PORT= 59798;
}
var options= {
  root: process.cwd(),
  // specify the parse location

  debug: process.env.NODE_ENV==='production',
  // if true, compress & cache result

  staticServe: true,
  // if true, enable static serve

  bundleExternal: false,
  // if true, include node_modules
};

// Setup & Boot
var app= express();
app.use(cjs(options));
app.listen(process.env.PORT,function(){
  console.log('http://localhost:%s <- %s',process.env.PORT,options.root);
});
```

## CLI - Extra usage

if `--onefile`, use [express-onefile](https://github.com/59naga/express-onefile) middleware

```bash
bower init
# yes, yes yes...
bower install angular-ui-router --save
# ...

cjs . --onefile
# http://localhost:59798 <- /Users/59naga/Downloads/my-project
```

Can access `http://localhost:59798/pkgs.min.js` contains `angular.js` and `angular-ui-router.js`

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/

[sauce-image]: http://soysauce.berabou.me/u/59798/express-cjs.svg
[sauce]: https://saucelabs.com/u/59798
[npm-image]:https://img.shields.io/npm/v/express-cjs.svg?style=flat-square
[npm]: https://npmjs.org/package/express-cjs
[travis-image]: http://img.shields.io/travis/59naga/express-cjs.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/express-cjs
[coveralls-image]: http://img.shields.io/coveralls/59naga/express-cjs.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/express-cjs?branch=master
