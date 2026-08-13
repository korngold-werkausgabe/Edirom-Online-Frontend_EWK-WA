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
Ext.define('EdiromOnline.view.webComponents.EdiromWebSocketConnector', {

    extend: 'Ext.container.Container',

    alias: 'widget.ediromWebSocketConnector',

    requires: [
    ],

    items: [],

    initComponent: function () {
        var me = this;

        // Read the WebSocket server URL from the runtime configuration (config.json).
        // When it is empty, the WebSocket features are disabled.
        var wsUrl = EdiromOnline.getApplication().getController('ConfigController').getConfig('wsURL');

        if (!wsUrl) {
            me.hidden = true;
        }

        let webSocketJsElement = document.createElement("script");
        webSocketJsElement.setAttribute("defer", "defer");
        console.log("Setting web socket connector script src");

        webSocketJsElement.setAttribute("src", "resources/web-components/edirom-web-socket-connector/edirom-web-socket-connector.js")
        document.querySelector("head").appendChild(webSocketJsElement);




        var wsUrlAttribute = wsUrl ? ` ws-url="${wsUrl}"` : '';

        me.html = `<edirom-web-socket id="web-socket"${wsUrlAttribute}></edirom-web-socket>`;

        me.callParent();

    },

    close: function () {
        this.hide();
    }
});