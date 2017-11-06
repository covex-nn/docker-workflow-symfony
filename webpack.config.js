var Encore = require('@symfony/webpack-encore');

Encore
    // the project directory where compiled assets will be stored
    .setOutputPath('public/assets/')
    // the public path used by the web server to access the previous directory
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
