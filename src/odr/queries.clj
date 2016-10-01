(ns odr.queries
  (:require [odr.web :as web]
            [yesql.core :refer [defqueries]]))

(defqueries "odr/queries.sql" {:connection (web/db-spec)})
