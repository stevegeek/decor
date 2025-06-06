These images have been further minified with `svgo` and prepared for use as inline SVGs ONLY.

```js
module.exports = {
  plugins: [
    'preset-default',
    'removeXMLNS'
  ]
};

`svgo -f ./app/assets/images/heroicons/solid/ -o ./app/assets/images/heroicons/solid/`
```
