(ns odr.queries
  (:require [yesql.core :refer [defqueries]]
            [environ.core :refer [env]]))

(defn db-spec
  []
  (env :database-url (str "postgres:///" (env :user))))
