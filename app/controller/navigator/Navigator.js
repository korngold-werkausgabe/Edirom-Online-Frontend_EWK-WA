/**
 *  Edirom Online
 *  Copyright (C) 2014 The Edirom Project
 *  http://www.edirom.de
 *
 *  Edirom Online is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Edirom Online is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Edirom Online.  If not, see <http://www.gnu.org/licenses/>.
 */
Ext.define('EdiromOnline.controller.navigator.Navigator', {

    extend: 'Ext.app.Controller',

    views: [
        'navigator.Navigator'
    ],

    init: function() {

        this.application.addListener('workSelected', this.onWorkSelected, this);

        // this.navigators = new Array();
        // this.navigatorContents = new Ext.util.MixedCollection();

        this.control({
            'navigator': {
                afterrender: this.onNavigatorRendered
            }
        });
    },

    updateNavigatorContent: function (workId) {
        me = this;

        var editionId = this.application.activeEdition;
        var lang = window.getLanguage('application_language');

        this.fetchNavigatorContent(workId, editionId, lang, function (navigatorContent) {
            me.ediromNavigator.setAttribute('navigator-data', JSON.stringify(navigatorContent));
        });


    },

    fetchNavigatorContent: function (workId, editionId, lang, onSuccess) {
        window.doAJAXRequest('data/xql/getNavigatorConfig.xql',
            'GET',
            {
                editionId: editionId,
                workId: workId,
                lang: lang
            },
            Ext.bind(function (response) {
                var data = response && response.responseText ? Ext.decode(response.responseText) : null;
                if (Ext.isFunction(onSuccess)) onSuccess(data);
            }, this)
        );
    },


    onNavigatorRendered: function (navigator) {
        var me = this;

        me.ediromNavigator = document.querySelector(`#${navigator.id}-navigator`);

        this.updateNavigatorContent(this.application.activeWork);

        me.ediromNavigator.addEventListener('load-link-request', function (e) {
            var target = e.detail.target;
            var options = e.detail.options;
            loadLink(target, options);
        });

    },

    onWorkSelected: function(workId) {

        this.updateNavigatorContent(workId);

    }
});

