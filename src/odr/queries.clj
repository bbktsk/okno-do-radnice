(ns odr.queries
  (:require [yesql.core :refer [defqueries]]
            [environ.core :refer [env]]))

(defn db-spec
  []
  (env :database-url (str "postgres:///" (env :user)))
  ;; {:classname "org.postgresql.Driver"
  ;;  :subprotocol "postgresql"
  ;;  :subname "//ec2-54-75-233-22.eu-west-1.compute.amazonaws.com:5432/deusuk15alttgt"
  ;;  :user "jpmgdunmufbyva"
  ;;  :password "O0BA4MmdlBEekOSyB6Ljxb6vEF"
  ;;  :sslmode "require"}
  )

(defqueries "odr/queries.sql" {:connection (db-spec)})
