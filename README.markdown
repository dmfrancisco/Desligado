Desligado — _A simple web application supporting disconnection and deferred updates_
====================================================================================

[_Desligado_][intro-0] is a proof-of-concept application made by junior
developers.

It's a simple [CRUD][intro-1] web app that runs both online and offline.
Since it is meant to work when the client is disconnected from the web, and/or
when the server is unavailable, it is heavily javascript based. Despite having
a view for each one of the common actions (show, index, new and edit), it's a
[single-page application][intro-2], since all necessary code (HTML,
Javascript, and CSS) is retrieved with a single page load. Further
communication is made using Ajax and [HTML5 Web Sockets][intro-3] with
[JSON][intro-3.1].

The resources are cached thanks to a [HTML5 Cache Manifest][intro-4] file
and the client keeps a synced local version of the data on a [HTML5 WebSQL
database][intro-5] (or, if not supported by his browser, on his [Local
Storage][intro-6]).

[intro-0]: http://github.com/dmfrancisco/desligado
[intro-1]: http://en.wikipedia.org/wiki/Create,_read,_update_and_delete
[intro-2]: http://en.wikipedia.org/wiki/Single-page_application
[intro-3]: http://dev.w3.org/html5/websockets/
[intro-4]: http://www.w3.org/TR/html5/offline.html
[intro-5]: http://www.w3.org/TR/webdatabase/
[intro-6]: http://dev.w3.org/html5/webstorage/
[intro-3.1]: http://www.json.org/js.html


Specification
------------------------------------------------------------------------------

_Desligado_ is a simple item management application.
Those are the functional requirements:

* Users must be able to create, edit, destroy and list items
* The item list must be updated, every time the server's database changes (without requiring any clicks)
* Users must be able to use the app offline (static contents should be presented, and dynamic contents must function)


Dependencies
------------------------------------------------------------------------------

* Built with Ruby 1.9.2 and Rails 3.0.5
* [Faye][dependency-1] gem (tested with 0.5.5)
* [Jammit!][dependency-2] gem (tested with 0.6.0)
* [jQuery][dependency-3] (included; version 1.4.4)
* [backbone.js][dependency-4] (included; version 0.3.3)
* [persistence.js][dependency-5] (included; version 0.2.4)

[dependency-1]: http://faye.jcoglan.com/
[dependency-2]: http://documentcloud.github.com/jammit/
[dependency-3]: http://jquery.com/
[dependency-4]: http://documentcloud.github.com/backbone/
[dependency-5]: http://persistencejs.org/


Source
------------------------------------------------------------------------------

* [Github Repo][download-0] (_version 1.1.7 stable_)
* [Rails Sync][download-1] for persistence.sync
* [Backbone.sync adapter][download-2] for persistence.js

[download-0]: http://github.com/dmfrancisco/desligado
[download-1]: https://github.com/dmfrancisco/Desligado/blob/master/app/controllers/items_controller.rb
[download-2]: https://github.com/dmfrancisco/Desligado/blob/master/public/javascripts/backbone/sync.js


Supported Browsers and Caveats
------------------------------------------------------------------------------

Should work with, at least:

* Chrome 11+
* Mozilla Firefox 4+

It doesn't seem to work on Safari 5 (not fully tested), and Firefox will use
local storage instead of WebSQL. Beware that, if the HTML layout file contains
the reference to the application manifest, server pushing will not work.
Comment out the reference _<... manifest="application.manifest">_ or just
remove the _public/application.manifest_ file to try it. This is a known
issue.


The Application
------------------------------------------------------------------------------

The goal for this project was to create a multi-client simple web application
with some basic functionalities (the creation, manipulation and deletion of
shared items) that worked both online and offline.


### Core technologies ###

To achieve the behaviour of keeping functionality in offline mode, we used
several techniques introduced in HTML5 - [Cache Manifest][intro-4],
[WebSQL][intro-5], [Local Storage][intro-6] and [Web
Sockets][intro-3].

Starting with the cache manifest, since we used Ruby on Rails for our
back-end, to dynamically generate this manifest file we used the
[rack-offline][intro-7] gem, as suggested by Ryan Bates on his interesting
[railscast][intro-8]. Every time the user opens the website, all files
required by the application are downloaded and saved for offline browsing.
This solves the problem of accessing the static content in offline mode.

[intro-7]: https://github.com/wycats/rack-offline
[intro-8]: http://railscasts.com/episodes/247

Another important aspect is that only one HTML page is fetched from the
server. This page contains the necessary components to generate four views —
index, show, edit and new. We used [backbone.js][dependency-4] and
[underscore][dependency-6] templates to build them. Backbone.js let us
implement a well-structured client-side application, but is not so
<strike>rigid</strike> opinionated as Rails. To organize our client-side code,
we followed the approach designed by [James Yu][intro-9] on his
[article][intro-10] about backbone.js.

[intro-9]: http://www.jamesyu.org/
[intro-10]: http://t.co/hkBlDvo
[dependency-6]: http://documentcloud.github.com/underscore/


### Javascript MVC framework ###

Backbone is composed by several modules. It contains one module called
Backbone.sync which lets us persist data through RESTful JSON requests to the
server. Since we want it to work offline too, we need it to persist the data
locally, using the HTML5 WebSQL technology (if supported by the browser) or
the Local Storage. This would be synced to the server, if possible, when both
client and server are online. This is tougher than it may look, since we are
talking about a multi-client app, with desynchronized clocks, etc..


### Data synchronization ###

In what concerns persistence, we used persistence.js, and specifically the
[persistence.sync.js][intro-11] plugin, to keep the databases synced together.
We created an adapter, a new Backbone.sync module, which maps the CRUD actions
with the persistence.sync.js library's API.

Another problem is that persistence.sync was primarly made to communicate
with node.js servers. Since we are using Rails, we coded the necessary
mechanisms to make it work with RoR.

[intro-11]: http://persistencejs.org/plugin/sync
[intro-12]: https://github.com/dmfrancisco/Desligado/


### Server pushing ###

At last, we wanted the server to broadcast to all connected clients when one
of them modifies the server's database. We integrated [Faye][intro-11] for the
server to client communication, which uses WebSockets, XMLHttpRequest (if
WebSockets not supported) or JSON-P (if no other alternative is supported). We
are still having some crazy issues regarding having both Faye and the
application.manifest) which are listed on the bottom of this document.


Contribute
------------------------------------------------------------------------------

Feel free to use the code for your own projects. Improvements are very
welcome (keep in mind that we are junior developers, with no background on
Javascript, assynchronous programming and all the like). Pull requests to our
[git repository][intro-12] would be greatly appreciated!


Installation
------------------------------------------------------------------------------

To initialize the application, run:

<pre><code>bundle install</code>
<code>rake db:migrate</pre></code>


Usage
------------------------------------------------------------------------------

Run Faye:
<pre><code>rackup script/faye.ru -s thin -E production</pre></code>
Run the Rails sever:
<pre><code>rails server</pre></code>


Issues
------------------------------------------------------------------------------

A list of the current issues will be added soon.


Change log
------------------------------------------------------------------------------

For now, you may check our github page to keep track of all the undergoing
changes.


Authors
------------------------------------------------------------------------------

- David Francisco { [dmfranc@student.dei.uc.pt][m-1]; [@dmfrancisco][t-1] }
- José Dias { [jacdias@student.dei.uc.pt][m-2] }

[m-1]: mailto:dmfranc@student.dei.uc.pt
[t-1]: http://twitter.com/dmfrancisco
[m-2]: mailto:jacdias@student.dei.uc.pt
