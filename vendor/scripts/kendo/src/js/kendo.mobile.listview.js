/*
* Kendo UI Complete v2013.1.319 (http://kendoui.com)
* Copyright 2013 Telerik AD. All rights reserved.
*
* Kendo UI Complete commercial licenses may be obtained at
* https://www.kendoui.com/purchase/license-agreement/kendo-ui-complete-commercial.aspx
* If you do not own a commercial license, this file shall be governed by the trial license terms.
*/
kendo_module({
    id: "mobile.listview",
    name: "ListView",
    category: "mobile",
    description: "The Kendo Mobile ListView widget is used to display flat or grouped list of items.",
    depends: [ "mobile.application" ]
});

(function($, undefined) {
    var kendo = window.kendo,
        Node = window.Node,
        mobile = kendo.mobile,
        ui = mobile.ui,
        DataSource = kendo.data.DataSource,
        Widget = ui.Widget,
        ITEM_SELECTOR = ".km-list > li, > li:not(.km-group-container)",
        HIGHLIGHT_SELECTOR = ".km-listview-link, .km-listview-label",
        proxy = $.proxy,
        attrValue = kendo.attrValue,
        GROUP_CLASS = "km-group-title",
        ACTIVE_CLASS = "km-state-active",
        GROUP_WRAPPER = '<div class="' + GROUP_CLASS + '"><div class="km-text"></div></div>',
        GROUP_TEMPLATE = kendo.template('<li><div class="' + GROUP_CLASS + '"><div class="km-text">#= this.headerTemplate(data) #</div></div><ul>#= kendo.render(this.template, data.items)#</ul></li>'),
        WRAPPER = '<div class="km-listview-wrapper" />',
        SEARCH_TEMPLATE = kendo.template('<form class="km-filter-form"><div class="km-filter-wrap"><input type="search" placeholder="#=placeholder#"/><a href="\\#" class="km-filter-reset" title="Clear"><span class="km-icon km-clear"></span><span class="km-text">Clear</span></a></div></form>'),
        NS = ".kendoMobileListView",
        LAST_PAGE_REACHED = "lastPageReached",
        CLICK = "click",
        CHANGE = "change",
        PROGRESS = "progress",
        FUNCTION = "function",

        whitespaceRegExp = /^\s+$/,
        buttonRegExp = /button/;

    function whitespace() {
        return this.nodeType === Node.TEXT_NODE && this.nodeValue.match(whitespaceRegExp);
    }

    function addIcon(item, icon) {
        if (icon) {
            item.prepend('<span class="km-icon km-' + icon + '"/>');
        }
    }

    function enhanceItem(item) {
        addIcon(item, attrValue(item, "icon"));
    }

    function enhanceLinkItem(item) {
        var parent = item.parent(),
            itemAndDetailButtons = item.add(parent.children(kendo.roleSelector("detailbutton"))),
            otherNodes = parent.contents().not(itemAndDetailButtons).not(whitespace);

        if (otherNodes.length) {
            return;
        }

        item.addClass("km-listview-link")
            .attr(kendo.attr("role"), "listview-link");

        addIcon(item, attrValue(parent, "icon"));
    }

    function enhanceCheckBoxItem(label) {
        if (!label.children("input[type=checkbox],input[type=radio]").length) {
            return;
        }

        var item = label.parent();

        if (item.contents().not(label).not(function() { return this.nodeType == 3; })[0]) {
            return;
        }

        label.addClass("km-listview-label");
    }

    var ListView = Widget.extend({
        init: function(element, options) {
            var that = this;

            Widget.fn.init.call(that, element, options);

            element = that.element;

            options = that.options;

            if (options.scrollTreshold) {
                options.scrollThreshold = options.scrollTreshold;
            }

            that._dragged = false;

            element
                .on("down", HIGHLIGHT_SELECTOR, "_highlight")
                .on("move up cancel", HIGHLIGHT_SELECTOR, "_dim")
                .on("down", ITEM_SELECTOR, function() { that._dragged = false; })
                .on("move", ITEM_SELECTOR, function() { that._dragged = true; })
                .on("up", ITEM_SELECTOR, "_click");

            element.wrap(WRAPPER);
            that.wrapper = that.element.parent();

            that._footer();

            that._dataSource();

            that._bindScroller();

            that._fixHeaders();

            that._filterable();

            if (options.dataSource && that.options.autoBind) {
                that.dataSource.fetch();
            } else {
                that._style();
            }

            kendo.notify(that, ui);
        },

        events: [
            CLICK,
            "dataBound",
            LAST_PAGE_REACHED
        ],

        options: {
            name: "ListView",
            style: "",
            type: "flat",
            autoBind: true,
            fixedHeaders: false,
            template: "#:data#",
            headerTemplate: '<span class="km-text">#:value#</span>',
            appendOnRefresh: false,
            loadMore: false,
            loadMoreText: "Press to load more",
            endlessScroll: false,
            scrollThreshold: 30,
            pullToRefresh: false,
            pullTemplate: "Pull to refresh",
            releaseTemplate: "Release to refresh",
            refreshTemplate: "Refreshing",
            pullOffset: 140,
            filterable: false
        },

        setOptions: function(options) {
            Widget.fn.setOptions.call(this, options);
        },

        setDataSource: function(dataSource) {
            this.options.dataSource = dataSource;
            this._dataSource();
            if (this.options.autoBind) {
                dataSource.fetch();
            }
        },

        destroy: function() {
            var that = this;

            Widget.fn.destroy.call(that);

            that._unbindDataSource();
            that.stopEndlessScrolling();
            that.stopLoadMore();

            kendo.destroy(that.element);
        },

        refresh: function(e) {
            e = e || {};

            var that = this,
                element = that.element,
                options = that.options,
                dataSource = that.dataSource,
                view = dataSource.view(),
                loading = that.loading,
                appendMethod = "html",
                action = e.action,
                items = e.items,
                idx = 0,
                contents,
                groups,
                length,
                data,
                item;

            if (action === "itemchange") {
                data = items[0];
                item = $(that.template(data));

                element.find("[data-" + kendo.ns + "uid=" + data.uid + "]").replaceWith(item);

                that.trigger("itemChange", {
                    item: item,
                    data: data,
                    ns: ui
                });

                that._style();
                return;
            } else if (action === "add") {
                length = items.length;

                for (; idx < length; idx++) {
                    element.append(that.template(items[idx]));
                }

                that._style();
                return;
            } else if (action === "remove") {
                length = items.length;

                for (; idx < length; idx++) {
                    element.find("[data-" + kendo.ns + "uid=" + items[idx].uid + "]").remove();
                }

                return;
            }

            if (!that.template) {
                that._templates();
            }

            that._cacheDataItems(view);

            that.trigger("dataBinding");

            groups = dataSource.group();

            if (groups && groups[0]) {
                options.type = "group";
                contents = kendo.render(that.groupTemplate, view);
            } else {
                contents = kendo.render(that.template, view);
            }

            if (loading) {
                appendMethod = "append";
            } else if (options.appendOnRefresh && !that._filter) {
                appendMethod = "prepend";
            }

            that._filter = false;

            contents = $(contents);
            element[appendMethod](contents);
            mobile.init(contents);

            if (loading) {
                that.loading = false;
                that._calcThreshold();
                that._toggleLoader(false);
            }

            if (options.pullToRefresh) {
                that._scroller().pullHandled();
            }

            that._hideLoading();

            that._shouldFixHeaders();
            that._style();

            that._invalidateLoadMore();

            that.trigger("dataBound", { ns: ui });
        },

        _invalidateLoadMore: function() {
            var that = this,
                options = that.options,
                dataSource = that.dataSource,
                shouldInit = that._stopLoadMore && (!dataSource.total() || dataSource.page() < dataSource.totalPages());

            if (shouldInit) {
                if (options.endlessScroll) {
                    that.initEndlessScrolling();
                }

                if (options.loadMore) {
                    that.initLoadMore();
                }
            }
        },

        _cacheDataItems: function(view) {
            var that = this, item;

            if (!that.element[0].firstChild) {
                that._firstOrigin = that._first = view[0];
                that._last = view[view.length - 1];
            }

            if (that._pulled) {
                item = view[0];
                that._pulled = false;

                if (item) {
                    that._first = item;
                }
            }

            if (that.loading) {
                item = view[view.length - 1];

                if (item) {
                    that._last = item;
                }
            }
        },

        items: function() {
            if (this.options.type === "group") {
                return this.element.find(".km-list").children();
            } else {
                return this.element.children();
            }
        },

        initEndlessScrolling: function() {
            this._stopLoadMore = false;
            this._scroller().setOptions({
                resize: this._scrollerResize,
                scroll: this._scrollerScroll
            });
        },

        stopEndlessScrolling: function() {
            var that = this,
                scroller = that._scroller();

           if (scroller && that._loadIcon) {
               that.loading = false;
               that._stopLoadMore = true;
               that._loadIcon.parent().hide();

               scroller.unbind("resize", that._scrollerResize)
                       .unbind("scroll", that._scrollerScroll);

               that.trigger(LAST_PAGE_REACHED);
           }
        },

        initLoadMore: function() {
            var that = this;

            that._stopLoadMore = false;
            that._loadButton.autoApplyNS().on("up", proxy(that._nextPage, that));
        },

        stopLoadMore: function() {
           var that = this;

           if (that._loadButton) {
               that._stopLoadMore = true;
               that.loading = false;
               that._loadButton
                   .kendoDestroy()
                   .parent().hide();

               that.trigger(LAST_PAGE_REACHED);
           }
        },

        _dim: function(e) {
            this._toggle(e, false);
        },

        _highlight: function(e) {
            this._toggle(e, true);
        },

        _toggle: function(e, highlight) {
            if (e.which > 1) {
                return;
            }

            var clicked = $(e.currentTarget),
                item = clicked.parent(),
                role = attrValue(clicked, "role") || "",
                plainItem = (!role.match(buttonRegExp)),
                prevented = e.isDefaultPrevented();

            if (plainItem) {
                item.toggleClass(ACTIVE_CLASS, highlight && !prevented);
            }
        },

        _unbindDataSource: function() {
            var that = this;

            that.dataSource.unbind(CHANGE, that._refreshHandler)
                           .unbind(PROGRESS, that._progressHandler);
        },

        _dataSource: function() {
            var that = this,
                options = that.options;

            if (that.dataSource && that._refreshHandler) {
                that._unbindDataSource();
            } else {
                that._refreshHandler = proxy(that.refresh, that);
                that._progressHandler = proxy(that._showLoading, that);
            }

            that.dataSource = DataSource.create(options.dataSource)
                                        .bind(CHANGE, that._refreshHandler);

            if (!options.pullToRefresh && !options.loadMore && !options.endlessScroll) {
                that.dataSource.bind(PROGRESS, that._progressHandler);
            }
        },

        _fixHeader: function(e) {
            if (this.fixedHeaders) {
                var i = 0,
                    that = this,
                    scroller = that._scroller(),
                    scrollTop = e.scrollTop,
                    headers = that.headers,
                    headerPair,
                    offset,
                    header;

                do {
                    headerPair = headers[i++];
                    if (!headerPair) {
                        header = $("<div />");
                        break;
                    }
                    offset = headerPair.offset;
                    header = headerPair.header;
                } while (offset > scrollTop);

                if (that.currentHeader != i) {
                    scroller.fixedContainer.html(header.clone());
                    that.currentHeader = i;
                }
            }
        },

        _shouldFixHeaders: function() {
            this.fixedHeaders = this.options.type === "group" && this.options.fixedHeaders;
        },

        _cacheHeaders: function() {
            var that = this,
                headers = [];

            if (that.fixedHeaders) {
                that.element.find("." + GROUP_CLASS).each(function(_, header) {
                    header = $(header);
                    headers.unshift({
                        offset: header.position().top,
                        header: header
                    });
                });

                that.headers = headers;
                that._fixHeader({scrollTop: 0});
            }
        },

        _fixHeaders: function() {
            var that = this,
                scroller = that._scroller();

            that._shouldFixHeaders();

            if (scroller) {
                kendo.onResize(function(){
                    that._cacheHeaders();
                });

                scroller.bind("scroll", function(e) {
                    that._fixHeader(e);
                });
            }
        },

        _bindScroller: function() {
            var that = this,
                options = that.options,
                scroller = that._scroller();

            if (!scroller) {
                return;
            }

            if (options.pullToRefresh) {
                scroller.setOptions({
                    pullToRefresh: true,
                    pull: function() {
                        var callback = options.pullParameters,
                            params = { page: 1 };

                        if (callback) {
                            params = callback.call(that, that._first);
                        }

                        that._pulled = true;
                        that.dataSource.read(params);
                    },
                    pullTemplate: options.pullTemplate,
                    releaseTemplate: options.releaseTemplate,
                    refreshTemplate: options.refreshTemplate
                });
            }

            if (options.endlessScroll) {
                that._scrollHeight = scroller.element.height();
                that._scrollerResize = function() {
                    that._scrollHeight = scroller.element.height();
                    that._calcThreshold();
                },
                that._scrollerScroll = function(e) {
                    if (!that.loading && e.scrollTop + that._scrollHeight > that._threshold) {
                        that._nextPage();
                    }
                };

                that.initEndlessScrolling();
            }
        },

        _calcThreshold: function() {
            var that = this,
                scroller = that._scroller();

            if (scroller) {
                that._threshold = scroller.scrollHeight() - that.options.scrollThreshold;
            }
        },

        _nextPage: function() {
            var that = this,
                options = that.options,
                callback = options.endlessScrollParameters || options.loadMoreParameters,
                params;

            that.loading = true;
            that._toggleLoader(true);

            if (callback) {
                params = callback.call(that, that._firstOrigin, that._last);
            }

            if (!that.dataSource.next(params)) {
                that.stopLoadMore();
                that.stopEndlessScrolling();
            }
        },

        _templates: function() {
            var that = this,
                template = that.options.template,
                headerTemplate = that.options.headerTemplate,
                dataIDAttribute =  ' data-uid="#=data.uid || ""#"',
                templateProxy = {},
                groupTemplateProxy = {};

            if (typeof template === FUNCTION) {
                templateProxy.template = template;
                template = "#=this.template(data)#";
            }

            groupTemplateProxy.template = that.template = proxy(kendo.template("<li" + dataIDAttribute + ">" + template + "</li>"), templateProxy);

            if (typeof headerTemplate === FUNCTION) {
                groupTemplateProxy._headerTemplate = headerTemplate;
                headerTemplate = "#=this._headerTemplate(data)#";
            }

            groupTemplateProxy.headerTemplate = kendo.template(headerTemplate);

            that.groupTemplate = proxy(GROUP_TEMPLATE, groupTemplateProxy);
        },

        _click: function(e) {
            if (e.which > 1 || e.isDefaultPrevented()) {
                return;
            }

            if (this._dragged) {
                e.preventDefault();
                return;
            }

            var that = this,
                dataItem,
                item = $(e.currentTarget),
                target = $(e.target),
                buttonElement = target.closest(kendo.roleSelector("button", "detailbutton", "backbutton")),
                button = kendo.widgetInstance(buttonElement, ui),
                id = item.attr(kendo.attr("uid"));

            if (id) {
                dataItem = that.dataSource.getByUid(id);
            }

            if (that.trigger(CLICK, {target: target, item: item, dataItem: dataItem, button: button})) {
                e.preventDefault();
            }
        },

        _style: function() {
            var that = this,
                options = that.options,
                grouped = options.type === "group",
                element = that.element,
                inset = options.style === "inset";

            element.addClass("km-listview")
                .toggleClass("km-list", !grouped)
                .toggleClass("km-listinset", !grouped && inset)
                .toggleClass("km-listgroup", grouped && !inset)
                .toggleClass("km-listgroupinset", grouped && inset);

            if (grouped) {
                element
                    .children()
                    .children("ul")
                    .addClass("km-list");

                element.children("li").each(function() {
                    var li = $(this),
                        groupHeader = li.contents().first();
                    li.addClass("km-group-container");
                    if (!groupHeader.is("ul") && !groupHeader.is("div." + GROUP_CLASS)) {
                        groupHeader.wrap(GROUP_WRAPPER);
                    }
                });
            }

            that._enhanceItems();

            if (!element.parents(".km-listview")[0]) {
                element.closest(".km-content").toggleClass("km-insetcontent", inset); // iOS has white background when the list is not inset.
            }

            that._cacheHeaders();
        },

        _enhanceItems: function() {
            this.items().each(function() {
                var item = $(this),
                    child,
                    enhanced = false;

                item.children().each(function() {
                    child = $(this);
                    if (child.is("a")) {
                        enhanceLinkItem(child);
                        enhanced = true;
                    } else if (child.is("label")) {
                       enhanceCheckBoxItem(child);
                       enhanced = true;
                    }
                });

                if (!enhanced) {
                    enhanceItem(item);
                }
            });
        },

        _footer: function() {
            var that = this,
                options = that.options,
                loadMore = options.loadMore,
                loadWrapper;

            if (loadMore || options.endlessScroll) {
                that._loadIcon = $('<span style="display:none" class="km-icon"></span>');
                loadWrapper = $('<span class="km-load-more"></span>').append(that._loadIcon);

                if (loadMore) {
                    that._loadButton = $('<button class="km-load km-button">' + options.loadMoreText + '</button>');

                    that.initLoadMore();

                    loadWrapper.append(that._loadButton);
                }

                that.wrapper.append(loadWrapper);
            }
        },

        _toggleLoader: function(toggle) {
            var that = this,
                icon = that._loadIcon,
                button = that._loadButton;

            if (button) {
                button.toggle(!toggle);
            }

            if (toggle) {
                icon.parent().addClass("km-scroller-refresh");
                icon.css("display", "block");
            } else {
                icon.hide();
                icon.parent().removeClass("km-scroller-refresh");
            }
        },

        _scroller: function() {
            var that = this, view;

            if (!that._scrollerInstance) {
                view = that.view();
                that._scrollerInstance = view && view.scroller;
            }

            return that._scrollerInstance;
        },

        _showLoading: function() {
            var view = this.view();
            if (view && view.loader) {
                view.loader.show();
            }
        },

        _hideLoading: function() {
            var view = this.view();
            if (view && view.loader) {
                view.loader.hide();
            }
        },

        _filterable: function() {
            var that = this,
                filterable = that.options.filterable,
                events = "change paste";

            if (filterable) {

                that.element.before(SEARCH_TEMPLATE({
                    placeholder: filterable.placeholder || "Search..."
                }));

                if (filterable.autoFilter !== false) {
                    events += " keyup";
                }

                that.searchInput = that.wrapper.find("input[type=search]")
                    .closest("form").on("submit" + NS, function(e) {
                        e.preventDefault();
                    })
                    .end()
                    .on("focus" + NS, function() {
                        that._oldFilter = that.searchInput.val();
                    })
                    .on(events.split(" ").join(NS + " ") + NS, proxy(that._filterChange, that));

                that.clearButton = that.wrapper.find(".km-filter-reset")
                    .on(CLICK, proxy(that._clearFilter, that))
                    .hide();
            }
        },

        _search: function(expr) {
            this._filter = true;
            this.clearButton[expr ? "show" : "hide"]();
            this.dataSource.filter(expr);
        },

        _filterChange: function(e) {
            var that = this;
            if (e.type == "paste" && that.options.filterable.autoFilter !== false) {
                setTimeout(function() {
                    that._applyFilter();
                }, 1);
            } else {
                that._applyFilter();
            }
        },

        _applyFilter: function() {
            var that = this,
                filterable = that.options.filterable,
                value = that.searchInput.val(),
                expr = value.length ? {
                    field: filterable.field,
                    operator: filterable.operator || "startsWith",
                    ignoreCase: filterable.ignoreCase,
                    value: value
                } : null;

            if (value === that._oldFilter) {
                return;
            }

            that._oldFilter = value;
            that._search(expr);
        },

        _clearFilter: function(e) {
            this.searchInput.val("");
            this._search(null);

            e.preventDefault();
        }
    });

    ui.plugin(ListView);
})(window.kendo.jQuery);
