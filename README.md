# ExpressCjs [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> coffee-react / jade / stylus middleware for Single Page Application on Express4

## API

### `expressCjs(options)` -> middleware

* If GET `/` to parse `/index.jade`
* If GET `/index.js` to parse `/index.coffee` with [ng-annotate][1]
* If GET `/index.css` to parse `/index.styl` with [kouto-swiss][2]

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
// Default options
var options= {
  // specify the parse location
  cwd: process.cwd(),

  // if true, compress & cache result
  debug: process.env.NODE_ENV==='production',

  // if true, include node_modules
  bundleExternal: true,

  // if true, use `coffee-reactify` (do not use `coffeeify`)
  useReactify: true,

  // if true, use `browserify-ngannotate` at /index.coffee
  useNgannotate: true,

  // if true, use `plain-jadeify` at /index.coffee
  usePlainJadeify: true,

  // if true, use `brfs` at /index.coffee
  useBrfs: true,

  // if true, always parse `/index.jade` at 'GET *' (for no matches)
  html5Mode: false,
};

// Setup & Boot
var app= express();
app.use(cjs(options));
app.listen(process.env.PORT,function(){
  console.log('http://localhost:%s <- %s',process.env.PORT,options.root);
});
```

# Related projects
* __express-cjs__
* [express-onefile](https://github.com/59naga/express-onefile#readme)
* [difficult-http-server](https://github.com/59naga/difficult-http-server#readme)

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
