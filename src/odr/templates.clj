(ns odr.templates
  (:require  [net.cgrand.enlive-html :refer [deftemplate content]]
             [net.cgrand.reload :refer [auto-reload]]))


(deftemplate index "templates/index.html" [param]
  [:#rowcount] (content (str param)))
