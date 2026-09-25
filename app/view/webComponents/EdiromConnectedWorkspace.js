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
Ext.define('EdiromOnline.view.webComponents.EdiromConnectedWorkspace', {

    extend: 'Ext.container.Container',

    alias: 'widget.ediromConnectedWorkspace',

    requires: [
    ],

    items: [],

    initComponent: function () {
        var me = this;

        me.width = 24;
        me.height = 24;

        // This view is only instantiated by TopBar.js when a wsURL is
        // configured (see TopBar.js), so no config check is needed here.
        var wsUrl = EdiromOnline.getApplication().getController('ConfigController').getConfig('wsURL');

        let webSocketJsElement = document.createElement("script");
        webSocketJsElement.setAttribute("defer", "defer");
        console.log("Setting connected workspace script src");

        webSocketJsElement.setAttribute("src", "resources/js/edirom-connected-workspace/edirom-connected-workspace.js")
        webSocketJsElement.setAttribute("type", "module");
        document.querySelector("head").appendChild(webSocketJsElement);

        // The current page URL (including its query parameters, e.g. work/edition/lang) is used as the base for session invite links. The web component appends or overwrites its own "session" parameter on top of this.
        var inviteUrl = window.location.href.replace(/&/g, '&amp;').replace(/"/g, '&quot;');

        // A "session" URL parameter (as produced by the invite-url above) auto-joins that session on startup.
        var sessionParam = EdiromOnline.getApplication().getURLParameter('session');
        var sessionAttr = sessionParam !== null ? ` session="${sessionParam.replace(/"/g, '&quot;')}"` : '';

        me.html = `<edirom-connected-workspace id="connected-workspace" ws-url="${wsUrl}" invite-url="${inviteUrl}"${sessionAttr}></edirom-connected-workspace>`;
        me.style = {
            "--primary-color": "#000000",
            "--secondary-color": "#cacaca",
            "--tertiary-color": "#faf6f0",
            "--quaternary-color": "#333333"
        };



        me.callParent();

    },

    close: function () {
        this.hide();
    }
});