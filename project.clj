(defproject okno-do-radnice "1.0.0-SNAPSHOT"
  :description "Okno do radnice"
  :url "http://okno-do-radnice.herokuapp.com"
  :license {:name "Eclipse Public License v1.0"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [compojure "1.5.1"]
                 [enlive "1.1.6"]
                 [hiccup "1.0.5"]
                 [ring/ring-jetty-adapter "1.5.0"]
                 [ring/ring-defaults "0.2.1"]
                 [ring/ring-json "0.4.0"]
                 [ring-cors "0.1.8"]
                 [environ "1.1.0"]
                 [org.clojure/java.jdbc "0.6.1"]
                 [crypto-random "1.2.0"]
                 [yesql "0.5.3"]
                 [org.postgresql/postgresql "9.4.1211"]
                 [slingshot "0.12.2"]
                 [liberator "0.14.1"]
                 [cheshire "5.6.3"]]
  :min-lein-version "2.0.0"
  :plugins [[environ/environ.lein "0.3.1"]]
  :hooks [environ.leiningen.hooks]
  :uberjar-name "okno-do-radnice-standalone.jar"
  :profiles {:production {:env {:production true}}})
