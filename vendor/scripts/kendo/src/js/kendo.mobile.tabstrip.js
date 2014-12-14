/*
* Kendo UI Complete v2013.1.319 (http://kendoui.com)
* Copyright 2013 Telerik AD. All rights reserved.
*
* Kendo UI Complete commercial licenses may be obtained at
* https://www.kendoui.com/purchase/license-agreement/kendo-ui-complete-commercial.aspx
* If you do not own a commercial license, this file shall be governed by the trial license terms.
*/
kendo_module({
    id: "mobile.tabstrip",
    name: "TabStrip",
    category: "mobile",
    description: "The mobile TabStrip widget is used inside a mobile view or layout footer element to display an application-wide group of navigation buttons.",
    depends: [ "core" ]
});

(function($, undefined) {
    var kendo = window.kendo,
        ui = kendo.mobile.ui,
        Widget = ui.Widget,
        ACTIVE_STATE_CLASS = "km-state-active",
        SELECT = "select";

    var TabStrip = Widget.extend({
        init: function(element, options) {
            var that = this;

            Widget.fn.init.call(that, element, options);
            that.container().bind("show", $.proxy(this, "refresh"));

            that.element
               .addClass("km-tabstrip")
               .find("a").each(that._buildButton)
               .eq(that.options.selectedIndex).addClass(ACTIVE_STATE_CLASS);

            that.element.on("down", "a", "_release");
        },

        events: [
            SELECT
        ],

        switchTo: function(url) {
            var tabs = this.element.find('a'),
                tab,
                path,
                idx = 0,
                length = tabs.length;

            for (; idx < length; idx ++) {
                tab = tabs[idx];
                path = tab.href.replace(/(\#.+)(\?.+)$/, "$1"); // remove the fragment query string - http://www.foo.com?foo#bar**?baz=qux**

                if (path.indexOf(url, path.length - url.length) !== -1) {
                    this._setActiveItem($(tab));
                    return;
                }
            }
        },

        clear: function() {
            this.currentItem().removeClass(ACTIVE_STATE_CLASS);
        },

        currentItem: function() {
            return this.element.children("." + ACTIVE_STATE_CLASS);
        },

        _release: function(e) {
            if (e.which > 1) {
                return;
            }

            var that = this,
                item = $(e.currentTarget);

            if (item[0] === that.currentItem()[0]) {
                return;
            }

            if (that.trigger(SELECT, {item: item})) {
                e.preventDefault();
            } else {
                that._setActiveItem(item);
            }
        },

        _setActiveItem: function(item) {
            if (!item[0]) {
                return;
            }
            this.clear();
            item.addClass(ACTIVE_STATE_CLASS);
        },

        _buildButton: function() {
            var button = $(this),
                icon = kendo.attrValue(button, "icon"),
                image = button.find("img"),
                iconSpan = $('<span class="km-icon"/>');

            button
                .addClass("km-button")
                .attr(kendo.attr("role"), "tab")
                    .contents().not(image)
                    .wrapAll('<span class="km-text"/>');

            if (image[0]) {
                image.addClass("km-image");
            } else {
                button.prepend(iconSpan);
                if (icon) {
                    iconSpan.addClass("km-" + icon);
                }
            }
        },

        refresh: function(e) {
            this.switchTo(e.view.id);
        },

        destroy: function() {
            Widget.fn.destroy.call(this);
        },

        options: {
            name: "TabStrip",
            selectedIndex: 0,
            enable: true
        }
    });

    ui.plugin(TabStrip);
})(window.kendo.jQuery);
