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
Ext.define('EdiromOnline.view.window.AnnotationsView', {
    extend: 'EdiromOnline.view.window.View',

    cls: 'annotsView',

    requires: [
        'Ext.grid.Panel',
        /*'Ext.grid.PagingScroller',*/
        'Ext.ux.grid.FiltersFeature',
        'EdiromOnline.model.Annotation',
        'EdiromOnline.model.AnnotationParticipant',
        'EdiromOnline.view.utils.Lightbox',
        'EdiromOnline.view.window.annotationLayouts.AnnotationLayout1',
        'EdiromOnline.view.window.annotationLayouts.AnnotationLayout2',
        'EdiromOnline.view.window.annotationLayouts.AnnotationLayout3',
        'EdiromOnline.view.window.annotationLayouts.AnnotationLayout4'
    ],

    alias: 'widget.annotationsView',

    layout: 'card',

    cls: 'annotationsView',

    image_server: null,

    initComponent: function () {

        console.log("Ich bin die Annot Web Component View!")

        var me = this;

        let annotationsViewJsElement = document.createElement("script");
        annotationsViewJsElement.setAttribute("defer", "defer");
        annotationsViewJsElement.setAttribute("src", "resources/web-components/edirom-annotations-view/edirom-annotations-view.js")
        document.querySelector("head").appendChild(annotationsViewJsElement);

        me.html = `<edirom-annotations-view id="${me.id}-annotations-view" state="pause"></edirom-annotations-view>`;

        me.callParent();
    }
});
