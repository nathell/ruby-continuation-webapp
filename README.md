# Proof-of-concept continuation-based Sinatra webapp

This is just a proof of concept to show off how continuations in Ruby work and to illustrate how they could be used for a simple Web app. This code is NOT suitable for production use. In particular, it only works with WEBrick. You have been warned.

This app was prepared for my talk at [4Developers Festival 2016][1]. Idea for the app and some implementation comes from Christian Queinnec’s paper [“Inverting back the inversion of control or, Continuations versus page-centric programming”][2].

 [1]: http://2016.4developers.org.pl/en/
 [2]: https://pages.lip6.fr/Christian.Queinnec/PDF/www.pdf

# Running it

```
# bundle install
# ruby server.rb
```

Then go to http://localhost:4567.

Enjoy!
