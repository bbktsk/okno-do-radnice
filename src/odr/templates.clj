(ns odr.templates
  (:require  [net.cgrand.enlive-html :refer [deftemplate content] :as enlive]
             [net.cgrand.reload :refer [auto-reload]]
             [cheshire.core :as json]))



(defn js-data [values]
  (let [statements (for [[name value] values]
                     (str name "=" (json/generate-string value {:pretty true}) ";\n"))]
    #(assoc % :content (apply str "\n" statements))))

(deftemplate index "templates/index.html" [param data]
  [:#rowcount] (content (str param))
  [:#data] (js-data data))


(defn table->html [table]
  (apply str (for [row table]
               (str "<tr>"
                    (apply str (map #(str "<td>" % "</td>") row))
                    "</tr>\n"))))

(defn presence-table [data]
  (let [bads (take 5 data)
        table (map (fn [x]
                     [(str (:jmeno x) " " (:prijmeni x))
                      (:pohlavi x)
                      (str (:percentage x) "%")])
                   bads)]
    (table->html table)))

(deftemplate presence "templates/presence.html" [data]
  [:#bad] (enlive/html-content (presence-table (reverse data)))
  [:#good] (enlive/html-content (presence-table data))
  )

(deftemplate sheeps-mavericks "templates/sheeps-mavericks.html" [data]
  [:#sheeps] (enlive/html-content (table->html (take 5 (reverse (sort-by last data)))))
  [:#mavericks] (enlive/html-content (table->html (take 5 (sort-by last data))))
  )
