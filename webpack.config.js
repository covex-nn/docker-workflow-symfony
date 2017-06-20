var Encore = require('@symfony/webpack-encore');

Encore
    .setOutputPath('web/assets/')
    .setPublicPath('/assets')
    .setManifestKeyPrefix('/assets')

    .cleanupOutputBeforeBuild()
    .addEntry('main', './assets/main.js')
    .addEntry('app', './assets/app.js')
    .addStyleEntry('global', './assets/global.scss')
    .enableSassLoader({
        resolve_url_loader: false
    })
    .enableSourceMaps(!Encore.isProduction())
    // .enableVersioning()
;

module.exports = Encore.getWebpackConfig();
