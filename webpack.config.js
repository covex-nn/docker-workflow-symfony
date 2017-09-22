var Encore = require('@symfony/webpack-encore');

Encore
    .setOutputPath('web/assets/')
    .setPublicPath('/assets')
    .cleanupOutputBeforeBuild()
    .addEntry('main', './assets/main.js')
    .addEntry('app', './assets/app.js')
    .addStyleEntry('global', './assets/global.scss')
    .enableSassLoader()
    .enableSourceMaps(!Encore.isProduction())
    .configureFilenames({
        js: '[name].js',
        css: '[name].css',
        images: 'images/[name].[ext]',
        fonts: 'fonts/[name].[ext]'
    })
;

module.exports = Encore.getWebpackConfig();
