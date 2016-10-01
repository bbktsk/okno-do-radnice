(ns odr.templates
  (:require  [net.cgrand.enlive-html :refer [deftemplate content] :as enlive]
             [net.cgrand.reload :refer [auto-reload]]
             [cheshire.core :as json]))



(defn js-data [values]
  (println "XXX" values)
  (let [statements (for [[name value] values]
                     (str name "=" (json/generate-string value {:pretty true}) ";\n"))]
    #(assoc % :content (apply str "\n" statements))))

(deftemplate index "templates/index.html" [param data]
  [:#rowcount] (content (str param))
  [:#data] (js-data data))
